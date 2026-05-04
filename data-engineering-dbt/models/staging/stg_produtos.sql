-- Staging de DimProduct + Subcategoria + Categoria
-- Denormaliza o snowflake de produto em uma única view limpa

with produtos as (
    select * from {{ source('contoso', 'DimProduct') }}
),

subcategorias as (
    select * from {{ source('contoso', 'DimProductSubcategory') }}
),

categorias as (
    select * from {{ source('contoso', 'DimProductCategory') }}
),

final as (
    select
        p.ProductKey                            as produto_key,
        p.ProductName                           as nome_produto,
        p.Status                                as status,
        p.UnitCost                              as custo_unitario,
        p.UnitPrice                             as preco_unitario,
        sub.ProductSubcategoryName              as subcategoria,
        cat.ProductCategoryName                 as categoria
    from produtos p
    left join subcategorias sub
        on p.ProductSubcategoryKey = sub.ProductSubcategoryKey
    left join categorias cat
        on sub.ProductCategoryKey = cat.ProductCategoryKey
)

select * from final
