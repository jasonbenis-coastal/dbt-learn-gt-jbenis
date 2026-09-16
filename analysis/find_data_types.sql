{% set relation = ref('fct_orders') %}
{% set cols = adapter.get_columns_in_relation(relation) %}
{% for col in cols %}
  - name: {{ col.name | lower }}
    data_type: {{ col.dtype | lower }}
{% endfor %}