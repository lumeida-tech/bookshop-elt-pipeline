{{ config(schema='WAREHOUSE') }}

SELECT
    id,
    code,
    date_edit,
    YEAR(date_edit)             AS annees,
    {{ get_mois('date_edit') }} AS mois,
    {{ get_jour('date_edit') }} AS jour,
    customers_id,
    qte_totale,
    total_amount,
    total_paid,
    created_at
FROM {{ ref('stg_factures') }}
