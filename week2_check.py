import os

import psycopg
from dotenv import load_dotenv
from psycopg.rows import dict_row


load_dotenv()

connection = psycopg.connect(
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT", "5432")),
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    row_factory=dict_row,
)


cursor = connection.cursor()


# 1. 订单总数
cursor.execute("""
    SELECT COUNT(*) AS total_orders
    FROM orders;
""")

print("Total orders:")
print(cursor.fetchone())


# 2. 总营收
cursor.execute("""
    SELECT
        SUM(order_items.quantity * products.price) AS total_revenue
    FROM order_items
    JOIN products
        ON order_items.product_id = products.product_id;
""")

print("Total revenue:")
print(cursor.fetchone())


# 3. 每个订单金额
cursor.execute("""
    SELECT
        order_items.order_id,
        SUM(order_items.quantity * products.price) AS order_total
    FROM order_items
    JOIN products
        ON order_items.product_id = products.product_id
    GROUP BY order_items.order_id
    ORDER BY order_items.order_id;
""")

print("Order totals:")
for row in cursor.fetchall():
    print(row)


cursor.close()
connection.close()