-- Mart: Vendas agregadas por mês
-- Entrega: relatório mensal de performance

with vendas as (
    select * from {{ ref('stg_vendas') }}
),

datas as (
    select * from {{ ref('stg_datas') }}
),

vendas_com_data as (
    select
        v.*,
        d.ano,
        d.numero_mes,
        d.nome_mes,
        d.trimestre,
        d.semestre
    from vendas v
    inner join datas d on v.data_key = d.data_key
),

final as (
    select
        ano,
        numero_mes,
        nome_mes,
        trimestre,
        semestre,
        count(distinct venda_key)           as total_pedidos,
        count(distinct loja_key)            as total_lojas_ativas,
        sum(quantidade)                     as total_itens,
        round(sum(valor_venda), 2)          as receita_total,
        round(sum(custo_total), 2)          as custo_total,
        round(sum(valor_venda)
              - sum(custo_total), 2)        as lucro_total,
        round(avg(valor_venda), 2)          as ticket_medio,
        round(
            (sum(valor_venda) - sum(custo_total))
            / nullif(sum(valor_venda), 0) * 100
        , 2)                                as margem_perc
    from vendas_com_data
    group by ano, numero_mes, nome_mes, trimestre, semestre
)

select * from final
