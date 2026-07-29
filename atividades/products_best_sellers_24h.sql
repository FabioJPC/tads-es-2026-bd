CREATE VIEW products_best_sellers_24h AS
SELECT
	product_id AS id, 
	product_name AS name, 
	SUM(quantity) AS quantity
FROM order_items
INNER JOIN orders 
	ON orders.id = order_items.order_id
WHERE orders.paid_at BETWEEN DATE_SUB(NOW(), INTERVAL 1 DAY) AND NOW()
GROUP BY
	order_items.product_id,
	order_items.product_name
HAVING SUM(quantity) > 25
ORDER BY quantity DESC;