{{ config(schema='WAREHOUSE') }}

SELECT * FROM {{ ref('stg_books') }}
