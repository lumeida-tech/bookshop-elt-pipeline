"""
bookshop_pipeline.py
─────────────────────────────────────────────────────────
DAG Airflow : Pipeline ELT Bookshop
  1. Ingest   : PostgreSQL → Snowflake RAW
  2. Staging  : RAW → STAGGING  (nettoyage des dates)
  3. Warehouse: STAGGING → WAREHOUSE  (dims + facts)
  4. Marts    : WAREHOUSE → MARTS  (obt_sales)
─────────────────────────────────────────────────────────
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

# ──────────────────────────────────────────────────────
# Configuration par défaut de toutes les tâches
# ──────────────────────────────────────────────────────
default_args = {
    'owner': 'bookshop',
    'depends_on_past': False,       # Ne pas attendre l'exécution précédente
    'retries': 1,                   # Réessayer 1 fois en cas d'échec
    'retry_delay': timedelta(minutes=5),
}

DBT_DIR = '/opt/dbt/bookshop'
DBT_PROFILES_DIR = '/home/airflow/.dbt'

# ──────────────────────────────────────────────────────
# Définition du DAG
# ──────────────────────────────────────────────────────
with DAG(
    dag_id='bookshop_pipeline',
    default_args=default_args,
    description='ELT Pipeline : PostgreSQL → Snowflake → DBT',
    schedule_interval='@daily',     # Se lance tous les jours
    start_date=datetime(2024, 1, 1),
    catchup=False,                  # Ne pas rattraper les jours passés
    tags=['bookshop', 'elt'],
) as dag:

    # ──────────────────────────────────────────────────
    # TACHE 1 : Ingestion PostgreSQL → Snowflake RAW
    # ──────────────────────────────────────────────────
    ingest = BashOperator(
        task_id='ingest_postgres_to_snowflake',
        bash_command='python /opt/airflow/scripts/ingest.py',
    )

    # ──────────────────────────────────────────────────
    # TACHE 2 : DBT Staging (RAW → STAGGING)
    # ──────────────────────────────────────────────────
    dbt_staging = BashOperator(
        task_id='dbt_staging',
        bash_command=f'cd {DBT_DIR} && dbt run --profiles-dir {DBT_PROFILES_DIR} --select staging',
    )

    # ──────────────────────────────────────────────────
    # TACHE 3 : DBT Warehouse (STAGGING → WAREHOUSE)
    # ──────────────────────────────────────────────────
    dbt_warehouse = BashOperator(
        task_id='dbt_warehouse',
        bash_command=f'cd {DBT_DIR} && dbt run --profiles-dir {DBT_PROFILES_DIR} --select warehouse',
    )

    # ──────────────────────────────────────────────────
    # TACHE 4 : DBT Marts (WAREHOUSE → MARTS)
    # ──────────────────────────────────────────────────
    dbt_marts = BashOperator(
        task_id='dbt_marts',
        bash_command=f'cd {DBT_DIR} && dbt run --profiles-dir {DBT_PROFILES_DIR} --select marts',
    )

    # ──────────────────────────────────────────────────
    # ORDRE D'EXECUTION
    # ──────────────────────────────────────────────────
    ingest >> dbt_staging >> dbt_warehouse >> dbt_marts
