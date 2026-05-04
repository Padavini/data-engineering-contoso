-- Mart: Vendas por categoria e ano
-- Entrega: análise de mix de produtos por período

with vendas as (
    select * from {{ ref('stg_vendas') }}
),

produtos as (
    select * from {{ ref('stg_produtos') }}
),

datas as (
    select * from {{ ref('stg_datas') }}
),

base as (
    select
        d.ano,
        d.trimestre,
        p.categoria,
        p.subcategoria,
        v.quantidade,
        v.valor_venda,
        v.custo_total,
        v.valor_venda - v.custo_total   as lucro
    from vendas v
    inner join produtos p on v.produto_key = p.produto_key
    inner join datas   d on v.data_key     = d.data_key
),

final as (
    select
        ano,
        trimestre,
        categoria,
        subcategoria,
        sum(quantidade)                     as total_itens,
        round(sum(valor_venda), 2)          as receita_total,
        round(sum(lucro), 2)                as lucro_total,
        round(avg(valor_venda), 2)          as ticket_medio,
        round(sum(lucro)
              / nullif(sum(valor_venda),0) * 100, 2) as margem_perc,

        -- participação no total de vendas do ano
        round(
            sum(valor_venda) * 100.0
            / sum(sum(valor_venda)) over (partition by ano)
        , 2)                                as perc_receita_ano
    from base
    group by ano, trimestre, categoria, subcategoria
)

select * from final
