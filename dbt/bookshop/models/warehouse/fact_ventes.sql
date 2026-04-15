{{ config(schema='WAREHOUSE') }}

SELECT
    id,
    code,
    date_edit,
    YEAR(date_edit)          AS annees,
    {{ get_mois('date_edit') }} AS mois,
    {{ get_jour('date_edit') }} AS jour,
    factures_id,
    books_id,
    pu,
    qte,
    created_at
FROM {{ ref('stg_ventes') }}
