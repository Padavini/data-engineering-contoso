"""
Pipeline ContosoRetailDW
Orquestra: extração → dbt run → dbt test
Agenda: todo dia às 6h
"""

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from datetime import datetime, timedelta
import logging

log = logging.getLogger(__name__)

# ── Configuração do DAG ───────────────────────────────────────
default_args = {
    'owner':            'data-engineering',
    'retries':          1,
    'retry_delay':      timedelta(minutes=5),
    'email_on_failure': False,
}

dag = DAG(
    dag_id='pipeline_contoso',
    description='Pipeline diário do ContosoRetailDW — dbt run + test',
    default_args=default_args,
    schedule_interval='0 6 * * *',   # todo dia às 6h
    start_date=days_ago(1),
    catchup=False,
    tags=['contoso', 'dbt', 'data-engineering'],
)

# ── Tarefas ───────────────────────────────────────────────────

def verificar_conexao():
    """Verifica se o SQL Server está acessível via TCP antes de rodar"""
    import socket
    host = 'host.docker.internal'
    port = 1433
    try:
        sock = socket.create_connection((host, port), timeout=5)
        sock.close()
        log.info(f"Banco acessível em {host}:{port} — prosseguindo com o pipeline")
    except Exception as e:
        raise Exception(f"Banco inacessível em {host}:{port} — {e}")


def notificar_inicio():
    log.info("=" * 50)
    log.info(f"PIPELINE INICIADO: {datetime.now()}")
    log.info("=" * 50)


def notificar_fim():
    log.info("=" * 50)
    log.info(f"PIPELINE CONCLUÍDO COM SUCESSO: {datetime.now()}")
    log.info("=" * 50)


# Tarefa 1 — notificar início
t1_inicio = PythonOperator(
    task_id='notificar_inicio',
    python_callable=notificar_inicio,
    dag=dag,
)

# Tarefa 2 — verificar conexão com o banco
t2_verificar_banco = PythonOperator(
    task_id='verificar_banco',
    python_callable=verificar_conexao,
    dag=dag,
)

# Tarefa 3 — rodar staging (dbt run)
t3_dbt_staging = BashOperator(
    task_id='dbt_run_staging',
    bash_command='cd /opt/airflow/dags/../data-engineering-dbt && dbt run --select staging',
    dag=dag,
)

# Tarefa 4 — rodar marts (dbt run)
t4_dbt_marts = BashOperator(
    task_id='dbt_run_marts',
    bash_command='cd /opt/airflow/dags/../data-engineering-dbt && dbt run --select marts',
    dag=dag,
)

# Tarefa 5 — rodar testes (dbt test)
t5_dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command='cd /opt/airflow/dags/../data-engineering-dbt && dbt test',
    dag=dag,
)

# Tarefa 6 — notificar fim
t6_fim = PythonOperator(
    task_id='notificar_fim',
    python_callable=notificar_fim,
    dag=dag,
)

# ── Ordem de execução ─────────────────────────────────────────
#
# inicio → verifica_banco → dbt_staging → dbt_marts → dbt_test → fim
#
t1_inicio >> t2_verificar_banco >> t3_dbt_staging >> t4_dbt_marts >> t5_dbt_test >> t6_fim
