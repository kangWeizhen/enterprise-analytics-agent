INSERT INTO customers (customer_id, name, city, email)
VALUES
    (1, 'Anna', 'Berlin', 'anna@example.com'),
    (2, 'Max', 'Munich', 'max@example.com'),
    (3, 'Lisa', 'Berlin', 'lisa@example.com');


INSERT INTO products (product_id, product_name, price)
VALUES
    (201, 'Badminton Racket', 129.99),
    (202, 'Shuttlecock', 24.50),
    (203, 'Sports Bag', 59.90);


INSERT INTO orders (order_id, customer_id, order_date)
VALUES
    (101, 1, '2026-09-21'),
    (102, 3, '2026-09-21'),
    (103, 1, '2026-09-22');


INSERT INTO order_items (order_id, product_id, quantity)
VALUES
    (101, 201, 1),
    (101, 202, 2),
    (102, 202, 1),
    (102, 203, 1),
    (103, 203, 2);