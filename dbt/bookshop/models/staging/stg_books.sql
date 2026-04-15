{{ config(schema='STAGGING') }}

SELECT * FROM {{ source('raw', 'books') }}
