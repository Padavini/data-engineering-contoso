-- Staging de FactSales
-- Objetivo: limpar e renomear colunas para padrão do DW
-- Regra: sem lógica de negócio aqui, só limpeza e padronização

with fonte as (
    select * from {{ source('contoso', 'FactSales') }}
),

limpo as (
    select
        SalesKey                            as venda_key,
        DateKey                             as data_key,
        StoreKey                            as loja_key,
        ProductKey                          as produto_key,
        ChannelKey                          as channel_key,
        SalesQuantity                       as quantidade,
        UnitPrice                           as preco_unitario,
        SalesAmount                         as valor_venda,
        TotalCost                           as custo_total,
        ReturnAmount                        as valor_devolucao,

        -- colunas derivadas simples (limpeza, não regra de negócio)
        case when SalesAmount > 0 and SalesQuantity > 0
             then 1 else 0
        end                                 as is_venda_valida

    from fonte
)

select * from limpo
where is_venda_valida = 1
