from datetime import datetime
from airflow import DAG
from airflow.decorators import task
from airflow.models.baseoperator import chain
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from extract import extract_from_api
# Caminhos dentro do container, conforme o mapeamento dos volumes no Docker
DBT_PROJECT_DIR = "/dbt_project"  # Diretório mapeado para dentro do container
DBT_PROFILES_DIR = "/root/.dbt"   # Diretório mapeado para dentro do container

with DAG(
        'extract_load_dag',
        default_args={'owner': 'postgres'},
        description='DAG with responsibilities of extracting and loading data in Postgres.',
        schedule_interval=None,
        start_date=datetime(2024, 10, 1, 0, 0),
) as dag:
    
    create_schemas = SQLExecuteQueryOperator(
        task_id = "create_schemas",
        sql = "sql/create_schemas.sql",
        conn_id = "pg_conn"
    )

    @task
    def extract_load_agregados_censo(postgres_conn_id):
        db_conn = PostgresHook(postgres_conn_id).get_sqlalchemy_engine()
        extract_from_api.extract_load_from_zip(db_conn, table="despesas_contratadas", schema="sa_eleicoes")
    
    
    create_dim_tables = SQLExecuteQueryOperator(
        task_id = "create_dim_tables",
        sql = "sql/create_dim_tables.sql",
        conn_id = "pg_conn"
    )

    create_fact_table = SQLExecuteQueryOperator(
        task_id = "create_fact_table",
        sql = "sql/create_fact_table.sql",
        conn_id = "pg_conn"
    )
    insert_dim_data = SQLExecuteQueryOperator(
        task_id = "insert_dim_data",
        sql = "sql/insert_dim_data.sql",
        conn_id = "pg_conn"
    )
    insert_fact_data = SQLExecuteQueryOperator(
        task_id = "insert_fact_data",
        sql = "sql/insert_fact_data.sql",
        conn_id = "pg_conn"
    )

    extract_load = extract_load_agregados_censo("pg_conn")

    
    chain(create_schemas, extract_load, create_dim_tables, create_fact_table, insert_dim_data, insert_fact_data)