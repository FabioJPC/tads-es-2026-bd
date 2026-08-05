CREATE TABLE shopping_cart (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED,
    quantity INT,
    FOREIGN KEY (customer_id)
        REFERENCES customers (id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
);


DELIMITER $

CREATE PROCEDURE finish_sale(
	IN c_customer_id INT
)

BEGIN
	DECLARE v_order_id INT;
	DECLARE v_total DECIMAL(10,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
	END;
    
    START TRANSACTION;
        INSERT INTO orders (customer_id, created_at) 
        VALUES (c_customer_id, NOW());
        
        SET v_order_id = LAST_INSERT_ID();

        INSERT INTO order_items(order_id, product_id, product_name, product_price, quantity)
            SELECT 	v_order_id,
                    shopping_cart.product_id,
                    products.name,
                    products.price,
                    shopping_cart.quantity
            FROM shopping_cart
            INNER JOIN products
            ON shopping_cart.product_id = products.id
            WHERE shopping_cart.customer_id = c_customer_id;
        
        UPDATE products
        JOIN shopping_cart
        ON products.id = shopping_cart.product_id
        SET products.stock = (products.stock - shopping_cart.quantity)
        WHERE shopping_cart.customer_id = c_customer_id;
        
        SELECT SUM(shopping_cart.quantity * products.price)
        INTO v_total
        FROM shopping_cart
        INNER JOIN products
        ON shopping_cart.product_id = products.id 
        WHERE shopping_cart.customer_id = c_customer_id;
        
        UPDATE orders
        set total = v_total
        WHERE id = v_order_id;
        
        DELETE FROM shopping_cart
        WHERE customer_id = c_customer_id;

    COMMIT;
END$

DELIMITER ;
