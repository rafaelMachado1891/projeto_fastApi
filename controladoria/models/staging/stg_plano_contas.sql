{{ config(materialized='view') }}

WITH plano_contas AS (
    SELECT 
        cast(nivel as integer) as nivel,
        cast(id_conta as text) as id_conta,
        trim(conta) as conta,
        cast(conta_agregadora as boolean) as conta_agregadora,
        cast(conta_pai as text) as conta_pai,
        lower(trim(grupo)) as grupo,
        trim(estrutura) as estrutura
    FROM {{ source('postgres', 'plano_de_contas') }}
)
SELECT * FROM plano_contas
