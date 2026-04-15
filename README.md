# Bookshop ELT Pipeline

Pipeline ELT complet pour un système de vente de livres.

```
PostgreSQL → Snowflake RAW → STAGGING → WAREHOUSE → MARTS → Metabase
```

---

## Prérequis

Installe ces outils sur ta machine :

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Git

---

## Etape 1 : Créer un compte Snowflake

1. Va sur **snowflake.com** → "Start for free"
2. Choisis :
   - Edition : **Standard**
   - Cloud : **AWS**
   - Région : **Europe (Paris)**
3. Vérifie ton email et connecte-toi
4. Note ton **Account Identifier** depuis l'URL :
   ```
   https://app.snowflake.com/XXXXXXX/YYYYYYY
                              └──────────────┘
                              ton account = XXXXXXX-YYYYYYY
   ```

---

## Etape 2 : Configurer Snowflake

Dans Snowflake, ouvre un **SQL Worksheet** et exécute le fichier `snowflake_setup.sql` :

```sql
-- Remplace LuMeiDa par ton username Snowflake
```

> **Important** : modifie la dernière ligne avec ton username :
> ```sql
> GRANT ROLE SYSADMIN TO USER TonUsername;
> ```

---

## Etape 3 : Cloner le projet

```bash
git clone <url-du-depot>
cd elt-exam
```

---

## Etape 4 : Créer le fichier .env

Copie ce contenu dans un fichier `.env` à la racine du projet :

```env
# Snowflake
SNOWFLAKE_ACCOUNT=ton-account-identifier
SNOWFLAKE_USER=TonUsername
SNOWFLAKE_PASSWORD=TonMotDePasse
SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_DATABASE=BOOKSHOP

# PostgreSQL source
POSTGRES_USER=bookshop
POSTGRES_PASSWORD=UnMotDePasseFort
```

---

## Etape 5 : Lancer le projet

```bash
docker compose up --build
```

> La première fois ca prend 5-10 minutes (téléchargement des images).

---

## Etape 6 : Vérifier que tout tourne

Attends de voir ces messages dans les logs :

```
bookshop_airflow_webserver  | [INFO] Listening at: http://0.0.0.0:8080
bookshop_metabase           | Metabase Initialization COMPLETE
```

---

## Les interfaces disponibles

| Service | URL | Login |
|---------|-----|-------|
| **Airflow** | http://localhost:8080 | admin / admin |
| **Metabase** | http://localhost:3000 | à créer au 1er lancement |

---

## Etape 7 : Lancer le pipeline

1. Va sur **http://localhost:8080**
2. Connecte-toi avec `admin` / `admin`
3. Clique sur le DAG **`bookshop_pipeline`**
4. Clique sur **▶️ Trigger DAG**
5. Suis l'évolution dans l'onglet **Graph**

Le pipeline fait dans l'ordre :
```
1. ingest    → copie PostgreSQL vers Snowflake RAW
2. staging   → nettoie les dates
3. warehouse → crée les dimensions et faits
4. marts     → crée la table finale obt_sales
```

---

## Etape 8 : Connecter Metabase à Snowflake

1. Va sur **http://localhost:3000**
2. Crée ton compte admin
3. Choisis **Snowflake** comme base de données
4. Remplis :
   - **Account name** : `ton-account-identifier`
   - **Username** : `TonUsername`
   - **Password** : `TonMotDePasse`
   - **Warehouse** : `COMPUTE_WH`
   - **Database** : `BOOKSHOP`
5. Clique **Connecter**

---

## Structure du projet

```
elt-exam/
├── docker-compose.yml       → orchestration des services
├── .env                     → credentials (à créer, non versionné)
├── snowflake_setup.sql      → script d'init Snowflake
│
├── postgres/
│   └── init.sql             → tables + données de test
│
├── ingestion/
│   └── ingest.py            → copie PostgreSQL → Snowflake RAW
│
├── airflow/
│   ├── Dockerfile
│   └── dags/
│       └── bookshop_pipeline.py  → pipeline ELT complet
│
└── dbt/
    ├── profiles.yml         → connexion Snowflake
    └── bookshop/
        ├── dbt_project.yml
        ├── macros/
        │   ├── generate_schema_name.sql
        │   └── date_helpers.sql
        └── models/
            ├── staging/     → RAW → STAGGING
            ├── warehouse/   → STAGGING → WAREHOUSE
            └── marts/       → WAREHOUSE → MARTS
```

---

## Schéma des données

```
category ──→ books ──→ ventes ──→ factures ──→ customers
```

### Couches Snowflake

| Schéma | Contenu |
|--------|---------|
| **RAW** | Données brutes copiées depuis PostgreSQL |
| **STAGGING** | Données nettoyées (dates converties) |
| **WAREHOUSE** | 3 dimensions (dim_*) + 5 faits (fact_*) |
| **MARTS** | 1 table finale `obt_sales` |

---

## Commandes utiles

```bash
# Arrêter tous les services
docker compose down

# Arrêter et supprimer les volumes (repart de zéro)
docker compose down -v

# Voir les logs d'un service
docker compose logs -f airflow-webserver

# Rebuild après modification
docker compose up --build
```

---

## Problèmes fréquents

**Login Airflow invalide**
```bash
docker exec -it bookshop_airflow_webserver airflow users create \
  --username admin --password admin \
  --firstname Admin --lastname Bookshop \
  --role Admin --email admin@bookshop.com
```

**DBT - Insufficient privileges**
```
→ Vérifie que tu as bien exécuté snowflake_setup.sql
→ Vérifie que GRANT ROLE SYSADMIN TO USER TonUsername est exécuté
```

**PostgreSQL - database does not exist**
```
→ Attends 30 secondes que PostgreSQL finisse de s'initialiser
→ Relance : docker compose restart
```
