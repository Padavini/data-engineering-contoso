-- Mart: Vendas por canal de venda
-- Entrega: performance de cada canal (Online, Store, Reseller...)

with vendas as (
    select * from {{ ref('stg_vendas') }}
),

canais as (
    select * from {{ ref('stg_channel') }}
),

datas as (
    select * from {{ ref('stg_datas') }}
),

base as (
    select
        c.channel_key,
        c.nome_canal,
        c.channel_label,
        d.ano,
        d.trimestre,
        v.venda_key,
        v.quantidade,
        v.valor_venda,
        v.custo_total,
        v.valor_venda - v.custo_total   as lucro
    from vendas v
    inner join canais c on v.channel_key = c.channel_key
    inner join datas  d on v.data_key    = d.data_key
),

final as (
    select
        channel_key,
        nome_canal,
        channel_label,
        ano,
        trimestre,
        count(distinct venda_key)           as total_pedidos,
        sum(quantidade)                     as total_itens,
        round(sum(valor_venda), 2)          as receita_total,
        round(sum(custo_total), 2)          as custo_total,
        round(sum(lucro), 2)                as lucro_total,
        round(avg(valor_venda), 2)          as ticket_medio,
        round(sum(lucro)
              / nullif(sum(valor_venda), 0) * 100, 2) as margem_perc,

        -- participação percentual no total de vendas do ano
        round(
            sum(valor_venda) * 100.0
            / sum(sum(valor_venda)) over (partition by ano)
        , 2)                                as perc_receita_ano
    from base
    group by channel_key, nome_canal, channel_label, ano, trimestre
)

select * from final
