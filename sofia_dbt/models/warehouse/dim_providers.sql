{{ config(
    materialized='table',
    schema='warehouse'
) }}

with providers as (
    select * from {{ ref('stg_providers') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['provider_id']) }} as provider_sk,
    provider_id as provider_bk,
    provider_name,
    provider_type,
    specialty,
    cedula_profesional,
    tax_id,
    street_address,
    city,
    state,
    zip_code,
    phone,
    email,
    network_tier,
    contract_start_date,
    contract_end_date,
    is_accepting_patients,
    quality_rating
from providers 