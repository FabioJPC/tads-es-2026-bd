SELECT 
	customers.id,
	customers.name,
    COUNT(orders.id)
FROM customers
LEFT JOIN orders
	ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name;

-- EM PROGRESSO