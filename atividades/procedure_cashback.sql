ALTER TABLE customers 
ADD COLUMN cashback DECIMAL(10,2) NOT NULL DEFAULT 0.00
AFTER phone;

CREATE TABLE cashback_history(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    order_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at DATETIME NOT NULL,
    UNIQUE(order_id),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


DELIMITER $

CREATE PROCEDURE process_cashback(
	IN c_order_id BIGINT UNSIGNED
)

BEGIN	
	DECLARE v_customer_id BIGINT;
	DECLARE v_total DECIMAL(10,2);
	DECLARE v_cashback DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
        END;

	START TRANSACTION;
		SELECT customer_id, total
		INTO v_customer_id, v_total
		FROM orders
		WHERE id = c_order_id;
		
		IF v_total <= 100 THEN
			SET v_cashback = v_total * 0.02;
		ELSEIF v_total <= 500 THEN
			SET v_cashback = v_total * 0.05;
		ELSE
			SET v_cashback = v_total * 0.10;
		END IF;
		
		INSERT INTO cashback_history(customer_id, order_id, amount, created_at)
			VALUES(v_customer_id, c_order_id, v_cashback, NOW());
		
		UPDATE customers SET cashback = COALESCE(cashback, 0) + v_cashback
			WHERE id = v_customer_id;
	COMMIT;
END$
DELIMITER ;
