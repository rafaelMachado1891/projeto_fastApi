WITH int_contas_nao_agregadas AS (
    SELECT 
        * 
    FROM  {{ ref('stg_balancete') }} 

),
int_plano_de_contas AS (
    SELECT 
        *
    FROM {{ ref('plano_de_contas') }}
),
contas_nao_agregadas AS (
    SELECT 
        a.id_conta,
        b.conta,
        b.conta_agregadora,
        b.conta_pai,
        a.saldo
    FROM int_contas_nao_agregadas a
    JOIN int_plano_de_contas b
    ON a.id_conta = b.id_conta
    WHERE b.conta_agregadora = false
)

SELECT * FROM contas_nao_agregadas
