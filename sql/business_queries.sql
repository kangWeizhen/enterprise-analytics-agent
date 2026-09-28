-- 1. 客户总数
SELECT COUNT(*) AS total_customers
FROM customers;


-- 2. 订单总数
SELECT COUNT(*) AS total_orders
FROM orders;


-- 3. 实际下过订单的客户数
SELECT COUNT(DISTINCT customer_id) AS ordering_customers
FROM orders;


-- 4. 总营收
SELECT
    SUM(order_items.quantity * products.price) AS total_revenue
FROM order_items
JOIN products
    ON order_items.product_id = products.product_id;


-- 5. 平均订单金额 AOV
SELECT
    SUM(order_items.quantity * products.price)
    / COUNT(DISTINCT orders.order_id) AS average_order_value
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
JOIN products
    ON order_items.product_id = products.product_id;


-- 6. 每个订单的金额
SELECT
    order_items.order_id,
    SUM(order_items.quantity * products.price) AS order_total
FROM order_items
JOIN products
    ON order_items.product_id = products.product_id
GROUP BY order_items.order_id
ORDER BY order_items.order_id;


-- 7. 每个客户的订单数量
-- LEFT JOIN 保留没有下单的客户
SELECT
    customers.customer_id,
    customers.name,
    COUNT(orders.order_id) AS order_count
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
ORDER BY customers.customer_id;


-- 8. 每个客户的总消费额
SELECT
    customers.customer_id,
    customers.name,
    COALESCE(
        SUM(order_items.quantity * products.price),
        0
    ) AS total_spent
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
LEFT JOIN products
    ON order_items.product_id = products.product_id
GROUP BY customers.customer_id, customers.name
ORDER BY customers.customer_id;


-- 9. 产品营收排名
WITH product_totals AS (
    SELECT
        products.product_id,
        products.product_name,
        SUM(order_items.quantity * products.price) AS product_revenue
    FROM order_items
    JOIN products
        ON order_items.product_id = products.product_id
    GROUP BY products.product_id, products.product_name
)
SELECT
    product_id,
    product_name,
    product_revenue,
    RANK() OVER (
        ORDER BY product_revenue DESC
    ) AS revenue_rank
FROM product_totals
ORDER BY revenue_rank;


-- 10. 每个客户金额最高的订单
WITH order_totals AS (
    SELECT
        orders.customer_id,
        orders.order_id,
        SUM(order_items.quantity * products.price) AS order_total
    FROM orders
    JOIN order_items
        ON orders.order_id = order_items.order_id
    JOIN products
        ON order_items.product_id = products.product_id
    GROUP BY orders.customer_id, orders.order_id
),
ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_total,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY order_total DESC
        ) AS customer_order_rank
    FROM order_totals
)
SELECT
    customer_id,
    order_id,
    order_total
FROM ranked_orders
WHERE customer_order_rank = 1
ORDER BY customer_id;