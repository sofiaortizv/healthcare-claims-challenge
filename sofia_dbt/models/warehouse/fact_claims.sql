{{ config(
    materialized='table',
    schema='warehouse'
) }}

with claims as (
    select * from {{ ref('stg_claims') }}
),

patients as (
    select * from {{ ref('dim_patients') }}
),

providers as (
    select * from {{ ref('dim_providers') }}
),

claim_providers as (
    select * from {{ ref('stg_claim_providers') }}
),

-- Get primary provider for each claim based on role priority
primary_providers as (
    select 
        claim_id,
        provider_id,
        row_number() over (
            partition by claim_id 
            order by case 
                when provider_role = 'Primary' then 1
                when provider_role = 'Consulting' then 2
                when provider_role = 'Referring' then 3
                else 4
            end,
            provider_role
        ) as rn,
        provider_role
    from claim_providers
),

primary_provider_filtered as (
    select 
        claim_id,
        provider_id,
        provider_role
    from primary_providers 
    where rn = 1
),

fact_claims as (
    select
        -- Fact table keys
        {{ dbt_utils.generate_surrogate_key(['c.claim_id', 'c.patient_id']) }} as claim_sk,
        c.claim_id as claim_bk,
        
        -- Foreign keys to dimensions
        p.patient_sk as patient_fk,
        pr.provider_sk as provider_fk,
        
        -- Business keys for reference
        c.patient_id as patient_bk,
        pp.provider_id as provider_bk,
        pp.provider_role,
        
        -- Dates
        c.service_date,
        c.claim_submitted_date,
        c.processed_date,
        
        -- Claim details (excluding list fields)
        c.claim_type,
        c.place_of_service,
        -- Excluded: diagnosis_codes, diagnosis_descriptions, procedure_codes, procedure_descriptions
        
        -- Financial amounts
        c.billed_amount,
        c.allowed_amount,
        c.deductible_amount,
        c.coinsurance_amount,
        c.copay_amount,
        c.insurance_paid_amount,
        c.patient_responsibility,
        
        -- Status and network
        c.claim_status,
        c.denial_reason,
        c.is_in_network,
        c.network_tier,
        c.prior_auth_number,
        
        -- Calculated fields
        case 
            when c.billed_amount > 0 then 
                round((c.insurance_paid_amount / c.billed_amount) * 100, 2)
            else 0 
        end as insurance_coverage_percentage,
        
        case 
            when c.allowed_amount > 0 then 
                round((c.patient_responsibility / c.allowed_amount) * 100, 2)
            else 0 
        end as patient_responsibility_percentage
        
    from claims c
    left join primary_provider_filtered pp on c.claim_id = pp.claim_id
    left join patients p on c.patient_id = p.patient_bk
    left join providers pr on pp.provider_id = pr.provider_bk
)

select * from fact_claims 