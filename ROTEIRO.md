# Roteiro: Engenheiro de Dados
**Banco de prática:** ContosoRetailDW (SQL Server local)  
**Arquivo de exercícios:** `conexao.ipynb`

---

## FASE 1 — SQL Analítico Avançado
**Duração estimada:** 3-4 semanas  
**Arquivo:** `conexao.ipynb`  
**Status:** [ ] Em andamento

### O que estudar:
- Window Functions: `RANK`, `DENSE_RANK`, `ROW_NUMBER`
- Window Functions com `PARTITION BY`
- `LAG` e `LEAD` para análise temporal
- Running Total e Média Móvel
- CTEs simples e encadeadas
- JOINs avançados: `LEFT JOIN`, `CROSS APPLY`, `SELF JOIN`
- Subqueries correlacionadas
- Análise de performance e índices

### Critério para avançar:
Conseguir escrever qualquer query do `conexao.ipynb` do zero, sem consultar o gabarito.

---

## FASE 2 — Python para Engenharia de Dados
**Duração estimada:** 4 semanas  
**Arquivo:** `fase2_pipeline.ipynb` (a criar)  
**Status:** [ ] Não iniciado

### O que estudar:
- Pandas avançado: `merge`, `groupby`, `pivot_table`
- Tratamento de dados sujos: nulos, duplicatas, tipos errados
- Pipeline ETL completo: Extrair → Transformar → Carregar
- Salvar resultados em novas tabelas no banco
- Logging de pipelines com o módulo `logging`
- Leitura de arquivos CSV, JSON, Excel

### Projeto prático:
Criar um pipeline que lê `FactSales`, transforma os dados e salva uma tabela `AggVendasMensal` no banco.

---

## FASE 3 — Modelagem de Data Warehouse
**Duração estimada:** 2-3 semanas  
**Status:** [ ] Não iniciado

### O que estudar:
- Esquema Estrela vs Snowflake (o ContosoRetailDW já é um exemplo real)
- Tabelas Fato vs Dimensão
- Slowly Changing Dimensions (SCD Tipo 1, 2 e 3)
- Granularidade de fatos
- Documentar o schema do ContosoRetailDW do zero

### Projeto prático:
Desenhar o diagrama ER do ContosoRetailDW e recriar uma versão simplificada do zero.

---

## FASE 4 — dbt (Data Build Tool)
**Duração estimada:** 3-4 semanas  
**Status:** [ ] Não iniciado

### O que é:
Ferramenta que transforma SQL em pipelines versionados, testados e documentados automaticamente. A mais pedida para Eng. de Dados hoje.

### O que estudar:
- Instalar dbt com SQL Server: `pip install dbt-sqlserver`
- Criar projeto dbt: `dbt init contoso_project`
- Models, Sources, Seeds
- Testes automáticos de qualidade
- Documentação gerada automaticamente
- Lineage (rastreabilidade dos dados)

### Projeto prático:
Transformar as queries do `conexao.ipynb` em models dbt versionados no GitHub.

---

## FASE 5 — Cloud + Orquestração
**Duração estimada:** 4-6 semanas  
**Status:** [ ] Não iniciado

### Azure (recomendado por já usar SQL Server):
- Azure Data Factory — orquestrar pipelines
- Azure Data Lake Storage — armazenar dados brutos
- Azure Synapse Analytics — Data Warehouse em cloud

### Apache Airflow (orquestração):
- Criar DAGs para agendar pipelines
- Monitorar execuções e tratar falhas
- Integrar com o banco local primeiro, depois cloud

### Projeto prático:
Pipeline agendado no Airflow que roda todo dia, carrega dados do ContosoRetailDW e salva no Azure Data Lake.

---

## FASE 6 — Portfólio no GitHub
**Duração estimada:** Paralelo a tudo  
**Status:** [ ] Não iniciado

### Projetos para publicar:

| Projeto | O que demonstra |
|---|---|
| Pipeline ETL ContosoRetailDW | Python + SQL + pandas |
| Modelos dbt para Contoso | dbt + modelagem |
| Dashboard com Streamlit | Python + visualização |
| Pipeline agendado com Airflow | Orquestração |

### Como montar o GitHub:
- README explicando o projeto, tecnologias usadas e como rodar
- Cada fase vira um repositório separado
- Adicionar screenshots dos resultados

---

## Stack completa ao final do roteiro

```
SQL Avançado → Python → dbt → Airflow → Azure → GitHub
```

---

## Como retomar em nova sessão

Abra uma nova conversa com Claude Code e diga:
> "Estou seguindo o roteiro de Engenheiro de Dados, terminei a Fase X, quero começar a Fase Y. Meu banco é ContosoRetailDW no SQL Server local."

O arquivo `conexao.ipynb` tem todos os exercícios da Fase 1 prontos para rodar.

---

## Timeline resumida

| Período | Fase |
|---|---|
| Mês 1-2 | Fase 1: SQL Avançado |
| Mês 2-3 | Fase 2: Python ETL |
| Mês 3 | Fase 3: Modelagem DW |
| Mês 4 | Fase 4: dbt |
| Mês 5-6 | Fase 5: Cloud + Airflow |
| Paralelo | Fase 6: Portfólio GitHub |
