import os
import pandas as pd
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

cursor.execute(
    """
    SELECT
        order_id,
        customer_id,
        order_date
    FROM orders
    ORDER BY order_id;
    """
)

rows = cursor.fetchall()

df = pd.DataFrame(rows)
print(df)

cursor.close()
connection.close()