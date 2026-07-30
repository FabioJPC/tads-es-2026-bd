CREATE VIEW customers_orders_summary AS
SELECT
    customers.id,
    customers.name,
    COUNT(orders.id) AS orders,
    SUM(orders.total) AS total_spent,
    AVG(orders.total) AS average_ticket
FROM customers
JOIN orders
    ON customers.id = orders.customer_id
WHERE orders.status = 'paid'
GROUP BY customers.id, customers.name;