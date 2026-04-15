{{ config(schema='MARTS') }}

SELECT
    -- Identifiant unique de la vente
    fv.id,

    -- Informations temporelles (depuis fact_ventes)
    fv.annees,
    fv.mois,
    fv.jour,

    -- Informations de vente (depuis fact_ventes)
    fv.pu,
    fv.qte,

    -- Informations de la facture (depuis fact_factures)
    ff.id            AS facture_id,
    ff.code          AS facture_code,
    ff.qte_totale,
    ff.total_amount,
    ff.total_paid,

    -- Informations de la catégorie (depuis dim_category)
    dc.intitule      AS category_intitule,

    -- Informations du livre (depuis dim_books)
    db.code          AS book_code,
    db.intitule      AS book_intitule,
    db.isbn_10,
    db.isbn_13,

    -- Informations du client (depuis dim_customers)
    dcu.code         AS customer_code,
    dcu.nom          AS customer_nom

FROM {{ ref('fact_ventes') }} fv
LEFT JOIN {{ ref('fact_factures') }} ff  ON fv.factures_id = ff.id
LEFT JOIN {{ ref('dim_books') }}     db  ON fv.books_id    = db.id
LEFT JOIN {{ ref('dim_category') }}  dc  ON db.category_id = dc.id
LEFT JOIN {{ ref('dim_customers') }} dcu ON ff.customers_id = dcu.id
