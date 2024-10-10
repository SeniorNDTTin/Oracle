--Create Table
CREATE TABLE toppings(
    id VARCHAR(10),
    name NVARCHAR2(50) NOT NULL,
    active NUMBER(1) DEFAULT 1,
    
    PRIMARY KEY (id)
);

CREATE TABLE sizes(
    id VARCHAR(10),
    name NVARCHAR2(50) NOT NULL,
    active NUMBER(1) DEFAULT 1,
    
    PRIMARY KEY (id)
);

CREATE TABLE products(
    id VARCHAR(10),
    name NVARCHAR2(50) NOT NULL,
    slug NVARCHAR2(50) NOT NULL UNIQUE,
    base_price NUMBER CHECK (base_price >= 0),
    active NUMBER(1) DEFAULT 1,
    
    PRIMARY KEY (id)
);

CREATE TABLE product_sizes(
    id VARCHAR(10),
    size_id VARCHAR(10),
    price_increment NUMBER CHECK (price_increment >= 0),
    product_id VARCHAR(10),
    
    PRIMARY KEY (id),
    FOREIGN KEY (size_id) REFERENCES sizes(id)
);

CREATE TABLE product_toppings(
    id VARCHAR(10),
    topping_id VARCHAR(10),
    price_increment NUMBER CHECK (price_increment >= 0),
    product_id VARCHAR(10),
    
    PRIMARY KEY (id),
    FOREIGN KEY (topping_id) REFERENCES toppings(id)
);

DROP TABLE product_sizes;
DROP TABLE product_toppings;
DROP TABLE products;
DROP TABLE sizes;
DROP TABLE toppings;

--End Create Table

--Insert Data
INSERT INTO sizes
VALUES('0000000001', 'very small', 1);
INSERT INTO sizes
VALUES('0000000002', 'small', 1);
INSERT INTO sizes
VALUES('0000000003', 'medium', 1);
INSERT INTO sizes
VALUES('0000000004', 'large', 1);
INSERT INTO sizes
VALUES('0000000005', 'extra large', 1);

INSERT INTO toppings
VALUES('0000000001', 'Vietnam sause', 1);
INSERT INTO toppings
VALUES('0000000002', 'USA sause', 1);
INSERT INTO toppings
VALUES('0000000003', 'Japan sause', 1);
INSERT INTO toppings
VALUES('0000000004', 'India sause', 1);
INSERT INTO toppings
VALUES('0000000005', 'Campuchia sause', 1);

INSERT INTO products
VALUES('0000000001', 'Pizza abc', 'pizza-abc', 10000, 1);
INSERT INTO products
VALUES('0000000002', 'Pizza hihi', 'pizza-hihi', 20000, 1);
INSERT INTO products
VALUES('0000000003', 'Pizza test3', 'pizza-test3', 30000, 1);
INSERT INTO products
VALUES('0000000004', 'Pizza test4', 'pizza-test4', 40000, 1);
INSERT INTO products
VALUES('0000000005', 'Pizza test5', 'pizza-test5', 50000, 1);

INSERT INTO product_sizes
VALUES('0000000001', '0000000001', 2000, '0000000001');
INSERT INTO product_sizes
VALUES('0000000002', '0000000002', 3000, '0000000002');
INSERT INTO product_sizes
VALUES('0000000003', '0000000003', 4000, '0000000003');
INSERT INTO product_sizes
VALUES('0000000004', '0000000004', 5000, '0000000004');
INSERT INTO product_sizes
VALUES('0000000005', '0000000005', 6000, '0000000005');
INSERT INTO product_sizes
VALUES('0000000006', '0000000001', 6000, '0000000005');

INSERT INTO product_toppings
VALUES('0000000001', '0000000001', 2500, '0000000001');
INSERT INTO product_toppings
VALUES('0000000002', '0000000002', 3500, '0000000002');
INSERT INTO product_toppings
VALUES('0000000003', '0000000003', 4500, '0000000003');
INSERT INTO product_toppings
VALUES('0000000004', '0000000004', 5500, '0000000004');
INSERT INTO product_toppings
VALUES('0000000005', '0000000005', 6500, '0000000005');
--End Insert Data

--Procedure
--Update base price field of a product
CREATE PROCEDURE update_product_base_price(v_id VARCHAR2, new_base_price NUMBER)
IS
BEGIN
    UPDATE products SET base_price = new_base_price
    WHERE id = v_id;
    
    COMMIT;
END;

EXECUTE update_product_base_price('0000000001', 10001);

--Delete product by id
CREATE PROCEDURE delete_product_by_id(v_id VARCHAR2)
IS
BEGIN
    DELETE FROM products
    WHERE id = v_id;
    
    COMMIT;
END;

EXECUTE delete_product_by_id('0000000005');

--Create a new product
CREATE PROCEDURE create_product(
    v_id VARCHAR2, 
    v_name NVARCHAR2, 
    v_slug NVARCHAR2, 
    v_base_price NUMBER, 
    v_active NUMBER
)
IS
BEGIN
    IF v_active != 0 AND v_active != 1 THEN
        INSERT INTO products
        VALUES(v_id, v_name, v_slug, v_base_price, 1);
    ELSE
        INSERT INTO products
        VALUES(v_id, v_name, v_slug, v_base_price, v_active);
    END IF;
    
    COMMIT;
END;

EXECUTE create_product('0000000005', 'Pizza test5', 'pizza-test5', 50000, 21);
--End Procedure

--Function
--Get product name by id
CREATE OR REPLACE FUNCTION get_product_name_by_id(v_id VARCHAR2)
    RETURN NVARCHAR2
IS
    v_name NVARCHAR2(50);
BEGIN
    SELECT name INTO v_name
    FROM products
    WHERE id = v_id;
    
    RETURN v_name;
END;

SET SERVEROUTPUT ON;
DECLARE
    v_name NVARCHAR2(50);
BEGIN
    v_name := get_product_name_by_id('0000000001');
    
    DBMS_OUTPUT.PUT_LINE(v_name);
END;

--Get base price total products 
CREATE OR REPLACE FUNCTION get_products_base_price_total
    RETURN NUMBER
IS
    v_price_total NUMBER;
BEGIN
    SELECT SUM(base_price) INTO v_price_total
    FROM products;
    
    RETURN v_price_total;
END;

SET SERVEROUTPUT ON;
DECLARE
    v_price_total NUMBER;
BEGIN
    v_price_total := get_products_base_price_total();
    
    DBMS_OUTPUT.PUT_LINE(v_price_total);
END;

--Get total price of a product
CREATE OR REPLACE FUNCTION get_product_total_price(v_id VARCHAR2)
    RETURN NUMBER
IS
    v_current_price NUMBER;
    v_price_total NUMBER;
BEGIN
    v_price_total := 0;

    SELECT base_price INTO v_current_price
    FROM products
    WHERE id = v_id;
    
    v_price_total := v_price_total + v_current_price;
    
    SELECT SUM(price_increment) INTO v_current_price
    FROM product_sizes
    WHERE product_id = v_id;
    
    v_price_total := v_price_total + v_current_price;
    
    SELECT SUM(price_increment) INTO v_current_price
    FROM product_toppings
    WHERE product_id = v_id;
    
    v_price_total := v_price_total + v_current_price;
    
    RETURN v_price_total;
END;

SET SERVEROUTPUT ON;
DECLARE
    v_price_total NUMBER;
BEGIN
    v_price_total := get_product_total_price('0000000005');
    
    DBMS_OUTPUT.PUT_LINE(v_price_total);
END;
--End Function

--Trigger
--Check product base price
CREATE OR REPLACE TRIGGER check_product_base_price
    AFTER INSERT OR UPDATE OF base_price ON products
    FOR EACH ROW
BEGIN
    IF (:new.base_price = 0) THEN
        RAISE_APPLICATION_ERROR(-20225, 'base price should greater than 0');
    END IF;
END;

UPDATE products SET base_price = 0
WHERE id = '0000000001';

--Check product active
CREATE OR REPLACE TRIGGER check_product_active
    AFTER INSERT OR UPDATE OF active ON products
    FOR EACH ROW
BEGIN
    IF (:new.active != 0 AND :new.active != 1) THEN
        RAISE_APPLICATION_ERROR(-20225, 'active must to 0 or 1');
    END IF;
END;

UPDATE products SET active = 9
WHERE id = '0000000001';

--Check name have pizza keyword
CREATE OR REPLACE TRIGGER check_product_name
    AFTER INSERT OR UPDATE OF name ON products
    FOR EACH ROW
BEGIN
    IF INSTR(LOWER(:new.name), 'pizza') = 0 THEN
        RAISE_APPLICATION_ERROR(-20225, 'active must to have pizza keyword');
    END IF;
END;

UPDATE products SET name = 'abc'
WHERE id = '0000000001';

SELECT * FROM products;
--End Trigger