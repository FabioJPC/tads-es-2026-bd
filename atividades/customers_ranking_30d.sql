CREATE VIEW customers_ranking_30d AS
SELECT 
	customers.id AS id,
    customers.name AS name,
    SUM(orders.total) as total
FROM customers
INNER JOIN orders
	ON orders.customer_id = customers.id
WHERE orders.paid_at BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
GROUP BY
	customers.id, 
    customers.name
ORDER BY total DESC;