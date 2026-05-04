-- Staging de DimChannel
-- Objetivo: limpar e padronizar colunas do canal de venda

with fonte as (
    select * from {{ source('contoso', 'DimChannel') }}
),

final as (
    select
        ChannelKey          as channel_key,
        ChannelLabel        as channel_label,
        ChannelName         as nome_canal,
        ChannelDescription  as descricao_canal
    from fonte
)

select * from final
