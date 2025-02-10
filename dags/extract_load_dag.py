from datetime import datetime
from airflow import DAG
from airflow.decorators import task
from extract import extract_from_api
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.models.baseoperator import chain

with DAG(
        'extract_load_dag',
        default_args={'owner': 'postgres'},
        description='DAG with responsibilities of extracting and loading data in Postgres.',
        schedule_interval=None,
        start_date=datetime(2024, 10, 1, 0, 0),
) as dag:
    
    @task
    def extract_load_agregados_censo(postgres_conn_id):
        db_conn = PostgresHook(postgres_conn_id).get_sqlalchemy_engine()
        extract_from_api.extract_load_from_zip(db_conn, table="despesas_contratadas", schema="sa_eleicoes")

    extract_load = extract_load_agregados_censo("pg_conn")

    chain(extract_load)