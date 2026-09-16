{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='order_id',
        on_schema_change='fail'
    )
}}

with orders as (

    select * from {{ ref('stg_jaffle_shop__orders')}}

),

payments as (

    select * from {{ ref('stg_stripe__payments')}}

),

order_payments as (

    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as order_amount

    from orders
    join order_payments using (order_id)
)

select * from final
{% if is_incremental() %}
    -- this will only be applised to incremental runs, and will filter out any rows that have already been processed
    where order_date >= (select max(order_date) from {{ this }})
{% endif %}
order by order_date desc