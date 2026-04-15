"""
ingest.py
─────────────────────────────────────────────────────────
Pipeline d'ingestion : PostgreSQL → Snowflake RAW
Copie les 5 tables brutes dans le schéma BOOKSHOP.RAW
─────────────────────────────────────────────────────────
"""

import os
import pandas as pd
import psycopg2
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas

# ──────────────────────────────────────────────────────
# CONNEXION POSTGRESQL
# ──────────────────────────────────────────────────────
def get_postgres_connection():
    return psycopg2.connect(
        host=os.environ.get("POSTGRES_HOST", "postgres-source"),
        port=os.environ.get("POSTGRES_PORT", 5432),
        database=os.environ.get("POSTGRES_DB", "bookshop_source"),
        user=os.environ.get("POSTGRES_USER", "bookshop"),
        password=os.environ.get("POSTGRES_PASSWORD"),
    )

# ──────────────────────────────────────────────────────
# CONNEXION SNOWFLAKE
# ──────────────────────────────────────────────────────
def get_snowflake_connection():
    return snowflake.connector.connect(
        account=os.environ.get("SNOWFLAKE_ACCOUNT"),
        user=os.environ.get("SNOWFLAKE_USER"),
        password=os.environ.get("SNOWFLAKE_PASSWORD"),
        database="BOOKSHOP",
        schema="RAW",
        warehouse=os.environ.get("SNOWFLAKE_WAREHOUSE", "COMPUTE_WH"),
    )

# ──────────────────────────────────────────────────────
# INGESTION D'UNE TABLE
# ──────────────────────────────────────────────────────
def ingest_table(table_name, pg_conn, sf_conn):
    print(f"  → Ingestion de la table : {table_name}")

    # 1. Lire depuis PostgreSQL
    df = pd.read_sql(f"SELECT * FROM {table_name}", pg_conn)
    print(f"     {len(df)} lignes lues depuis PostgreSQL")

    # 2. Snowflake attend des noms de colonnes en MAJUSCULES
    df.columns = [col.upper() for col in df.columns]

    # 3. Ecrire dans Snowflake RAW (recrée la table si elle existe)
    success, _, nrows, _ = write_pandas(
        conn=sf_conn,
        df=df,
        table_name=table_name.upper(),
        database="BOOKSHOP",
        schema="RAW",
        auto_create_table=True,
        overwrite=True,
    )

    if success:
        print(f"     {nrows} lignes chargées dans BOOKSHOP.RAW.{table_name.upper()} ✅")
    else:
        print(f"     Erreur lors du chargement de {table_name} ❌")


# ──────────────────────────────────────────────────────
# MAIN
# ──────────────────────────────────────────────────────
def main():
    # Les 5 tables à copier
    tables = ["category", "books", "customers", "factures", "ventes"]

    print("=" * 50)
    print("INGESTION : PostgreSQL → Snowflake RAW")
    print("=" * 50)

    pg_conn = get_postgres_connection()
    sf_conn = get_snowflake_connection()

    for table in tables:
        ingest_table(table, pg_conn, sf_conn)

    pg_conn.close()
    sf_conn.close()

    print("=" * 50)
    print("Ingestion terminée avec succès ✅")
    print("=" * 50)


if __name__ == "__main__":
    main()
