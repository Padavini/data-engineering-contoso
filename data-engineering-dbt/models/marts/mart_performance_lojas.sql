-- Mart: Performance de lojas com segmentação
-- Entrega: ranking e segmento de cada loja

with vendas as (
    select * from {{ ref('stg_vendas') }}
),

lojas as (
    select * from {{ ref('stg_lojas') }}
),

datas as (
    select * from {{ ref('stg_datas') }}
),

base as (
    select
        l.loja_key,
        l.nome_loja,
        l.tipo_loja,
        l.pais,
        l.estado,
        l.cidade,
        l.num_funcionarios,
        d.ano,
        v.valor_venda,
        v.custo_total,
        v.valor_venda - v.custo_total as lucro,
        v.venda_key,
        v.quantidade
    from vendas v
    inner join lojas l on v.loja_key  = l.loja_key
    inner join datas d on v.data_key  = d.data_key
),

agregado as (
    select
        loja_key,
        nome_loja,
        tipo_loja,
        pais,
        estado,
        cidade,
        num_funcionarios,
        count(distinct ano)                 as anos_operando,
        count(distinct venda_key)           as total_pedidos,
        sum(quantidade)                     as total_itens,
        round(sum(valor_venda), 2)          as receita_total,
        round(sum(lucro), 2)                as lucro_total,
        round(avg(valor_venda), 2)          as ticket_medio,
        round(sum(lucro)
              / nullif(sum(valor_venda),0) * 100, 2) as margem_perc
    from base
    group by loja_key, nome_loja, tipo_loja, pais, estado, cidade, num_funcionarios
),

final as (
    select
        *,
        rank() over (order by receita_total desc) as ranking_global,
        rank() over (partition by pais order by receita_total desc) as ranking_no_pais,

        case
            when receita_total >= 1000000 then 'Platinum'
            when receita_total >= 500000  then 'Gold'
            when receita_total >= 100000  then 'Silver'
            else 'Bronze'
        end as segmento
    from agregado
)

select * from final
