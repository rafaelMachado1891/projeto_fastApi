{{ config(materialized='table') }}

SELECT
  *,
  -- Exemplo: Índice de Liquidez Corrente
  ativo / NULLIF(passivo, 0) AS indice_liquidez,

  -- Margem Líquida
  lucro_liquido / NULLIF(receita_liquida, 0) AS margem_liquida,

  -- ROE: Retorno sobre o patrimônio líquido
  lucro_liquido / NULLIF(patrimonio_liquido, 0) AS roe,

  -- Giro do ativo
  receita_liquida / NULLIF(ativo, 0) AS giro_ativo
FROM {{ ref('int_balancete_agregado') }}