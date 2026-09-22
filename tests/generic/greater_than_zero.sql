{% test greater_than_zero(model, group_column, amount_column) %}

select 
  {{group_column}},
  sum({{amount_column}}) as total_amount
from {{model}}
group by {{group_column}}
having total_amount < 0

{% endtest %}