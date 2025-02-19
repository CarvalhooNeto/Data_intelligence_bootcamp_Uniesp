{{ config(
    materialized='view'
) }}

WITH cleaned_data AS (
    SELECT
        CAST("DT_PRESTACAO_CONTAS" AS DATE),
        CAST("VR_DESPESA_CONTRATADA" AS NUMERIC),
        *
    FROM {{ ref('sa_eleicoes_despesas_contratadas') }} 
)
SELECT *
FROM cleaned_data;
