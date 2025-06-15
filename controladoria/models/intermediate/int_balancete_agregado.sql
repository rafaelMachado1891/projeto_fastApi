WITH balancete AS (
  SELECT 
      id_conta,
      conta,
      saldo
  FROM {{ ref('stg_balancete') }}
),
plano_contas AS (
  SELECT
      nivel,
      id_conta,
      conta,
      grupo
  FROM {{ ref('stg_plano_contas') }}
),
balancete_agregado AS (
  SELECT 
    a.id_conta,
    b.conta,
    b.grupo,
    a.saldo
  FROM balancete a
  JOIN plano_contas b
  ON a.id_conta = b.id_conta
)
SELECT
  MAX(CASE WHEN grupo = 'ativo' THEN saldo END) AS ativo,
  MAX(CASE WHEN grupo = 'passivo' THEN saldo END) AS passivo,
  MAX(CASE WHEN conta = 'PATRIMONIO LIQUIDO' THEN saldo END) AS patrimonio_liquido,
  MAX(CASE WHEN conta = 'RECEITAS' THEN saldo END) AS receitas,
  MAX(CASE WHEN conta = 'RECEITA LIQUIDA' THEN saldo END) AS receita_liquida,
  MAX(CASE WHEN conta = 'CUSTOS E DESPESAS' THEN saldo END) AS custos_despesas,
  MAX(CASE WHEN conta = 'RESULTADO LIQ DO EXERCICIO' THEN saldo END) AS lucro_liquido
FROM balancete_agregado