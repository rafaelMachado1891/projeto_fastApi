WITH int_balancete AS (
    SELECT 
        * 
    FROM  {{ ref('stg_balancete') }} 

),
int_plano_de_conas AS (
    SELECT 
        *
    FROM {{ ref('plano_de_contas') }}
),
relatorio_agrupado AS (
    SELECT 
        a.id_conta,
        b.conta,
        b.conta_agregadora,
        b.conta_pai,
        a.saldo
    FROM int_balancete a
    JOIN int_plano_de_contas b
    WHERE b.conta_agregadora = "TRUE"
)

SELECT * FROM relatorio_agrupado
