select 
  order_id,
  sum(order_amount) as total_amount
from {{ref('fct_orders')}}
group by order_id
having total_amount < 0