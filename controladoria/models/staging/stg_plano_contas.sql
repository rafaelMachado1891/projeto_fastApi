WITH plano_contas AS (
    SELECT 
        *
    FROM {{ source('postgres', 'plano_de_contas') }}
)
SELECT * FROM plano_contas
