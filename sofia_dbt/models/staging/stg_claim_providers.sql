{{ config(
    materialized='table',
    schema='staging'
) }}

with source as (
    select * from {{ source('raw', 'claim_providers') }}
),

deduped as (
    select *,
        row_number() over (
            partition by claim_id, provider_id 
            order by provider_role
        ) as rn
    from source
),

filtered as (
    select * from deduped where rn = 1
),

cleaned as (
    select
        trim(claim_id) as claim_id,
        trim(provider_id) as provider_id,
        trim(provider_role) as provider_role
    from filtered
)

select * from cleaned
