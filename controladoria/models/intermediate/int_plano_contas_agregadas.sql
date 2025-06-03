WITH balancete AS (
    SELECT 
        *  
    FROM 
        {{ ref("stg_balancete") }}
),
plano_contas AS (
    SELECT 
        *
    FROM 
        {{ ref("stg_plano_contas") }}
),
resultado AS (
    SELECT 
        a.id_conta,
        a.conta,
        SUM(a.saldo) AS saldo
    FROM balancete a
    JOIN plano_contas b 
    ON a.id_conta = b.id_conta
    WHERE b.conta_agregadora = true AND
        b.nivel = 0 OR b.nivel = 1 
    GROUP BY 
        b.conta_pai,
        a.id_conta,
        a.conta,
        b.estrutura
    ORDER BY 
        b.estrutura
)
SELECT * FROM resultado