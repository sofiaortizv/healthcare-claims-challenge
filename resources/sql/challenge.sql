
------

select count(*) from raw.claim_providers;

select count(*) from raw.claims;

select count(*) from raw.patients;

select count(*) from raw.providers;

------

select 
  claim_id
from raw.claims
group by 1 
having count(*) > 1
limit 10;


select 
*
from raw.claims
order by claim_id
limit 10; 


select 
  *
from raw.claim_providers
order by 1
limit 10; 


select *
from raw.patients
limit 10;

select 
*
from raw.providers
limit 10; 


select 
 distinct insurance_coverage_percentage
from dbt_warehouse.fact_claims dp  
;


select 
  * 
from dbt_staging.stg_claim_providers scp 
order by claim_id 
limit 10; 


1 - Primary
2 - Consulting
3 -Referring
-----

with 
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
        ) as rn
    from dbt_staging.stg_claim_providers
)
select 
*
from primary_providers; 



SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;


----

select 
 *
from dbt_warehouse.fact_claims dp  
limit 10
;


SELECT EXTRACT(YEAR FROM service_date) AS year, COUNT(*) AS total_claims 
FROM dbt_warehouse.fact_claims 
GROUP BY year 
ORDER BY year desc



select 
*
from dbt_warehouse.fact_claims 
limit 10; 

select 
* 
from dbt_warehouse.dim_patients 
limit 10; 

select 
* 
from dbt_warehouse.dim_providers  



SELECT DATE_TRUNC('month', service_date) AS month, COUNT(*) AS visits 
FROM dbt_warehouse.fact_claims WHERE place_of_service = 'Emergency Room' GROUP BY month ORDER BY month DESC LIMIT 10
