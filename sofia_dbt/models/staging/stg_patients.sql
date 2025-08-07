{{ config(
    materialized='table',
    schema='staging'
) }}

with source as (
    select * from {{ source('raw', 'patients') }}
),

deduped as (
    select *,
        row_number() over (
            partition by patient_id 
            order by enrollment_date desc
        ) as rn
    from source
),

filtered as (
    select * from deduped where rn = 1
),

cleaned as (
    select
        trim(patient_id) as patient_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        trim(maternal_surname) as maternal_surname,
        date_of_birth,
        trim(gender) as gender,
        trim(curp) as curp,
        trim(street_address) as street_address,
        trim(city) as city,
        trim(state) as state,
        trim(zip_code) as zip_code,
        trim(email) as email,
        trim(plan_name) as plan_name,
        trim(plan_code) as plan_code,
        trim(policy_number) as policy_number,
        trim(group_id) as group_id,
        enrollment_date,
        is_active,
        annual_deductible,
        annual_out_of_pocket_max
    from filtered
)

select * from cleaned
