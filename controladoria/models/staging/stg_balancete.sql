

{{ config(materialized='table') }}

with source_data as (

    select
        *
    from {{ source('postgres', 'balancete') }}

)

select 
    id_conta,
    conta,
    saldo
from source_data

