
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "data_engineering",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="mortgage_underwriting_pipeline",
    description="Load mortgage and credit data, then run dbt",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    default_args=default_args,
) as dag:

    load_applications = BashOperator(
        task_id="load_mortgage_applications",
        bash_command=(
            "snowsql -f snowflake/load_applications.sql"
        ),
    )

    load_credit = BashOperator(
        task_id="load_credit_bureau",
        bash_command=(
            "snowsql -f snowflake/load_credit.sql"
        ),
    )

    run_dbt = BashOperator(
        task_id="run_dbt_transformations",
        bash_command=(
            "cd dbt_mortgage && dbt run "
            "--select silver gold"
        ),
    )

    # Both source loads must succeed before dbt starts.
    [load_applications, load_credit] >> run_dbt
