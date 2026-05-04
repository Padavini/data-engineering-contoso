-- Sobrescreve o comportamento padrão do dbt de concatenar schemas
-- Resultado: usa exatamente o nome definido em +schema, sem prefixo

{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
