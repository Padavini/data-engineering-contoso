# Data Engineering — ContosoRetailDW

Pipeline de dados completo construído sobre o banco **ContosoRetailDW** (SQL Server), cobrindo as etapas de análise, transformação, modelagem, orquestração e documentação.

## Stack

| Tecnologia | Uso |
|---|---|
| SQL Server | Banco de dados fonte |
| Python / Pandas | ETL e transformação de dados |
| dbt | Modelagem e testes de qualidade |
| Apache Airflow | Orquestração do pipeline |
| Docker | Ambiente do Airflow |

## Arquitetura do Pipeline

```
SQL Server (ContosoRetailDW)
        ↓
   Python ETL
   (extração e limpeza)
        ↓
   dbt Staging
   (padronização e renomeação)
        ↓
   dbt Marts
   (agregações para análise)
        ↓
   Airflow DAG
   (agendamento diário às 6h)
```

## Estrutura do Projeto

```
├── data-engineering-dbt/
│   ├── models/
│   │   ├── staging/        ← views com dados padronizados
│   │   └── marts/          ← tabelas agregadas para análise
│   ├── macros/             ← funções reutilizáveis dbt
│   ├── notebooks/          ← exercícios práticos fases 1 a 4
│   └── dbt_project.yml
├── airflow/
│   ├── dags/
│   │   └── pipeline_contoso.py   ← DAG principal
│   └── docker-compose.yml
└── fase5_airflow.ipynb
```

## Modelos dbt

### Staging
| Modelo | Fonte | Descrição |
|---|---|---|
| `stg_vendas` | FactSales | Vendas válidas com colunas padronizadas |
| `stg_datas` | DimDate | Calendário com ano, mês, trimestre e semestre |
| `stg_produtos` | DimProduct + DimProductSubcategory + DimProductCategory | Produtos com hierarquia completa |
| `stg_lojas` | DimStore + DimGeography | Lojas com localização |
| `stg_channel` | DimChannel | Canal de venda |

### Marts
| Modelo | Descrição |
|---|---|
| `mart_vendas_mensais` | Receita, custo, lucro e margem por mês |
| `mart_vendas_por_categoria` | Performance por categoria de produto |
| `mart_performance_lojas` | Ranking de lojas por receita |
| `mart_vendas_por_canal` | Receita e ticket médio por canal de venda |

## Pipeline Airflow

DAG `pipeline_contoso` — executa todo dia às 6h:

```
notificar_inicio
      ↓
verificar_banco       (testa conexão TCP com SQL Server)
      ↓
dbt_run_staging       (dbt run --select staging)
      ↓
dbt_run_marts         (dbt run --select marts)
      ↓
dbt_test              (dbt test)
      ↓
notificar_fim
```

## Como rodar localmente

### Pré-requisitos
- SQL Server com banco ContosoRetailDW
- Python 3.10+
- dbt-sqlserver
- Docker Desktop

### dbt
```bash
cd data-engineering-dbt
dbt run
dbt test
```

### Airflow
```bash
cd airflow
docker compose up airflow-init
docker compose up -d
```
Acesse `http://localhost:8080` — login: `admin` / senha: `admin`

## Notebooks

| Arquivo | Conteúdo |
|---|---|
| `conexao.ipynb` | Window Functions, CTEs, JOINs analíticos |
| `fase2_pipeline.ipynb` | ETL com Python e Pandas |
| `fase3_modelagem.ipynb` | Star Schema, SCD, integridade referencial |
| `fase4_dbt.ipynb` | dbt: sources, refs, materializations, testes |
| `fase5_airflow.ipynb` | Airflow: DAGs, operadores, agendamento |
