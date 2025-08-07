{{ config(
    materialized='table',
    schema='staging'
) }}

with source as (
    select * from {{ source('raw', 'providers') }}
),

deduped as (
    select *,
        row_number() over (
            partition by provider_id 
            order by contract_start_date desc
        ) as rn
    from source
),

filtered as (
    select * from deduped where rn = 1
),

cleaned as (
    select
        trim(provider_id) as provider_id,
        trim(provider_name) as provider_name,
        trim(provider_type) as provider_type,
        trim(specialty) as specialty,
        trim(cedula_profesional) as cedula_profesional,
        trim(tax_id) as tax_id,
        trim(street_address) as street_address,
        trim(city) as city,
        trim(state) as state,
        trim(zip_code) as zip_code,
        trim(phone) as phone,
        trim(email) as email,
        trim(network_tier) as network_tier,
        contract_start_date,
        contract_end_date,
        is_accepting_patients,
        quality_rating
    from filtered
)

select * from cleaned
