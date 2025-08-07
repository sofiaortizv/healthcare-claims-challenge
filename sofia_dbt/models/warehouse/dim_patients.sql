{{ config(
    materialized='table',
    schema='warehouse'
) }}

with patients as (
    select * from {{ ref('stg_patients') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['patient_id']) }} as patient_sk,
    patient_id as patient_bk,
    first_name,
    last_name,
    maternal_surname,
    date_of_birth,
    gender,
    curp,
    street_address,
    city,
    state,
    zip_code,
    email,
    plan_name,
    plan_code,
    policy_number,
    group_id,
    enrollment_date,
    is_active,
    annual_deductible,
    annual_out_of_pocket_max
from patients 