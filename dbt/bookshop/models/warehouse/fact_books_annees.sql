{{ config(schema='WAREHOUSE') }}

SELECT
    b.id          AS book_id,
    b.code        AS book_code,
    b.intitule    AS book_intitule,
    fv.annees,
    COUNT(fv.id)       AS nb_ventes,
    SUM(fv.qte)        AS qte_vendue,
    SUM(fv.pu * fv.qte) AS montant_total
FROM {{ ref('fact_ventes') }} fv
JOIN {{ ref('dim_books') }} b ON fv.books_id = b.id
GROUP BY b.id, b.code, b.intitule, fv.annees
