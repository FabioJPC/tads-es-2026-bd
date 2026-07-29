CREATE VIEW orders_paid_on_current_month AS
SELECT id, paid_at, total 
FROM orders
WHERE YEAR(paid_at) = YEAR(CURRENT_DATE)
AND MONTH(paid_at) = MONTH(CURRENT_DATE);