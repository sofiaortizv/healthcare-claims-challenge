{{ config(
    materialized='table',
    schema='staging'
) }}

with source as (
    select * from {{ source('raw', 'claims') }}
),

deduped as (
    select *,
        row_number() over (
            partition by claim_id 
            order by service_date desc, claim_submitted_date desc
        ) as rn
    from source
),

filtered as (
    select * from deduped where rn = 1
),

cleaned as (
    select
        trim(claim_id) as claim_id,
        trim(patient_id) as patient_id,
        service_date,
        claim_submitted_date,
        trim(claim_type) as claim_type,
        trim(place_of_service) as place_of_service,
        diagnosis_codes,
        diagnosis_descriptions,
        procedure_codes,
        procedure_descriptions,
        billed_amount,
        allowed_amount,
        deductible_amount,
        coinsurance_amount,
        copay_amount,
        insurance_paid_amount,
        patient_responsibility,
        trim(claim_status) as claim_status,
        trim(denial_reason) as denial_reason,
        is_in_network,
        trim(network_tier) as network_tier,
        trim(prior_auth_number) as prior_auth_number,
        processed_date
    from filtered
)

select * from cleaned
