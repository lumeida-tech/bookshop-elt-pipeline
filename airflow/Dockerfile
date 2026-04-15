FROM apache/airflow:2.8.1-python3.11

USER root

# Installer les dépendances système
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

USER airflow

# Installer DBT + connecteurs Python
RUN pip install --no-cache-dir \
    dbt-core==1.7.4 \
    dbt-snowflake==1.7.4 \
    snowflake-connector-python \
    pandas \
    psycopg2-binary

# Créer le dossier pour les scripts d'ingestion
RUN mkdir -p /opt/airflow/scripts
