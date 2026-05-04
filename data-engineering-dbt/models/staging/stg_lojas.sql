-- Staging de DimStore + DimGeography

with lojas as (
    select * from {{ source('contoso', 'DimStore') }}
),

geo as (
    select * from {{ source('contoso', 'DimGeography') }}
),

final as (
    select
        s.StoreKey                          as loja_key,
        s.StoreName                         as nome_loja,
        s.StoreType                         as tipo_loja,
        s.Status                            as status,
        s.EmployeeCount                     as num_funcionarios,
        s.SellingAreaSize                   as area_vendas_m2,
        g.CityName                          as cidade,
        g.StateProvinceName                 as estado,
        g.RegionCountryName                 as pais
    from lojas s
    left join geo g on s.GeographyKey = g.GeographyKey
)

select * from final
