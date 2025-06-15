

{{ config(materialized='view') }}

with source_data as (

    select
        cast(id_conta as text) as id_conta,
        cast(conta as text) as conta,
        abs(cast(saldo as numeric)) as saldo
    from {{ source('postgres', 'balancete') }}

)

select 
    id_conta,
    conta,
    saldo
from source_data

