-- Staging de DimDate com colunas padronizadas

with fonte as (
    select * from {{ source('contoso', 'DimDate') }}
),

final as (
    select
        DateKey                             as data_key,
        FullDateLabel                       as data_completa,
        CalendarYear                        as ano,
        CalendarMonth                       as numero_mes,
        CalendarMonthLabel                  as nome_mes,
        CalendarQuarter                     as trimestre,
        CalendarHalfYear                    as semestre,
        CalendarDayOfWeek                   as numero_dia_semana,
        CalendarDayOfWeekLabel              as nome_dia_semana
    from fonte
)

select * from final
