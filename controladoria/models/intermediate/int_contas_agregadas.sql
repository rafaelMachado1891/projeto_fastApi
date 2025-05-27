WITH RECURSIVE

balancete AS (
    SELECT 
        *
    FROM {{ ref('stg_balancete') }}
),

plano_contas AS (
    SELECT 
        *
    FROM {{ ref('plano_de_contas') }}
),

balancete_agrupado AS (
    SELECT 
        a.id_conta,
        b.conta,
        a.saldo,
        b.conta_pai,
        b.conta_agregadora
    FROM balancete a 
    JOIN plano_contas b 
        ON a.id_conta = b.id_conta
),

-- CTE recursiva: mapeia cada conta folha até o topo da hierarquia
hierarquia AS (
    SELECT
        id_conta AS id_folha,
        id_conta AS id_agregado,
        conta_pai
    FROM balancete_agrupado
    WHERE conta_agregadora = false

    UNION ALL

    SELECT
        h.id_folha,
        p.id_conta AS id_agregado,
        p.conta_pai
    FROM hierarquia h
    JOIN plano_contas p 
        ON h.conta_pai = p.id_conta
),

-- Soma os saldos das folhas por cada conta agregadora da hierarquia
saldos_recalculados AS (
    SELECT
        id_agregado AS id_conta,
        SUM(b.saldo) AS saldo_calculado
    FROM hierarquia h
    JOIN balancete b 
        ON h.id_folha = b.id_conta
    GROUP BY id_agregado
),

-- Junta os saldos calculados com os nomes das contas
resultado_final AS (
    SELECT 
        p.id_conta,
        p.conta,
        COALESCE(s.saldo_calculado, b.saldo) AS saldo_final
    FROM plano_contas p
    LEFT JOIN saldos_recalculados s 
        ON p.id_conta = s.id_conta
    LEFT JOIN balancete b 
        ON p.id_conta = b.id_conta
)

SELECT * FROM resultado_final
ORDER BY id_conta