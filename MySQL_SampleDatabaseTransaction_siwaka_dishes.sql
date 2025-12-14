START TRANSACTION;

-- Insert new order for customer 621
INSERT INTO customerOrder
(orderDate, requiredDate, dispatchDate, orderStatusID, customerNumber, branchCode)
VALUES (NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE), DATE_ADD(NOW(), INTERVAL 20 MINUTE), 4, 621, 5);

-- Get the generated order number
SET @orderNumber = LAST_INSERT_ID();

-- Initialize total amount
SET @totalAmount = 0.00;

-- ######################## PRODUCT 1 ########################
-- Process Product P001 (2 quantities)
SET @productCode = 'P001';
SET @quantityOrdered = 2;
SET @price = (SELECT sellingPrice
              FROM product
              WHERE productCode = @productCode);
SET @quantityInStock = (SELECT quantityInStock
                        FROM product
                        WHERE productCode = @productCode);

INSERT INTO orderDetail (orderNumber, productCode, quantityOrdered, priceEach)
SELECT @orderNumber, @productCode, @quantityOrdered, @price
WHERE @quantityInStock >= @quantityOrdered;

UPDATE product
SET quantityInStock = quantityInStock - @quantityOrdered
WHERE productCode = @productCode
  AND quantityInStock >= @quantityOrdered;

SET @totalAmount =
        @totalAmount + (CASE WHEN @quantityInStock >= @quantityOrdered THEN @quantityOrdered * @price ELSE 0 END);

SAVEPOINT sp1;

-- ######################## PRODUCT 2 ########################
-- Process Product P018 (5 quantities)
SET @productCode = 'P018';
SET @quantityOrdered = 5;
SET @price = (SELECT sellingPrice
              FROM product
              WHERE productCode = @productCode);
SET @quantityInStock = (SELECT quantityInStock
                        FROM product
                        WHERE productCode = @productCode);

INSERT INTO orderDetail (orderNumber, productCode, quantityOrdered, priceEach)
SELECT @orderNumber, @productCode, @quantityOrdered, @price
WHERE @quantityInStock >= @quantityOrdered;

UPDATE product
SET quantityInStock = quantityInStock - @quantityOrdered
WHERE productCode = @productCode
  AND quantityInStock >= @quantityOrdered;

SET @totalAmount =
        @totalAmount + (CASE WHEN @quantityInStock >= @quantityOrdered THEN @quantityOrdered * @price ELSE 0 END);

SAVEPOINT sp2;

-- ######################## PRODUCT 3 ########################
-- Process Product P072 (1 quantity)
SET @productCode = 'P072';
SET @quantityOrdered = 1;
SET @price = (SELECT sellingPrice
              FROM product
              WHERE productCode = @productCode);
SET @quantityInStock = (SELECT quantityInStock
                        FROM product
                        WHERE productCode = @productCode);

INSERT INTO orderDetail (orderNumber, productCode, quantityOrdered, priceEach)
SELECT @orderNumber, @productCode, @quantityOrdered, @price
WHERE @quantityInStock >= @quantityOrdered;

UPDATE product
SET quantityInStock = quantityInStock - @quantityOrdered
WHERE productCode = @productCode
  AND quantityInStock >= @quantityOrdered;

SET @totalAmount =
        @totalAmount + (CASE WHEN @quantityInStock >= @quantityOrdered THEN @quantityOrdered * @price ELSE 0 END);

SAVEPOINT sp3;

-- ######################## PRODUCT 4 ########################
-- Process Product P038 (70 quantities)
SET @productCode = 'P038';
SET @quantityOrdered = 70;
SET @price = (SELECT sellingPrice
              FROM product
              WHERE productCode = @productCode);
SET @quantityInStock = (SELECT quantityInStock
                        FROM product
                        WHERE productCode = @productCode);

INSERT INTO orderDetail (orderNumber, productCode, quantityOrdered, priceEach)
SELECT @orderNumber, @productCode, @quantityOrdered, @price
WHERE @quantityInStock >= @quantityOrdered;

UPDATE product
SET quantityInStock = quantityInStock - @quantityOrdered
WHERE productCode = @productCode
  AND quantityInStock >= @quantityOrdered;

SET @totalAmount =
        @totalAmount + (CASE WHEN @quantityInStock >= @quantityOrdered THEN @quantityOrdered * @price ELSE 0 END);

SAVEPOINT sp4;

-- Assumption is that ordering 70 quantities of P038 fails due to insufficient stock
-- This business logic (you cannot sell what you do not have) should be implemented in the backend.
ROLLBACK TO SAVEPOINT sp3;

-- Insert payment for the order
INSERT INTO payment
    (orderNumber, paymentDate, amount, paymentMethodID)
VALUES (@orderNumber, NOW(), @totalAmount, 1);

SAVEPOINT sp5;

-- Display receipt
SELECT co.orderNumber                                                                  AS 'Order Number',
       co.orderDate                                                                    AS 'Order Date',
       c.customerName                                                                  AS 'Customer Name',
       CONCAT(c.contactFirstName, ' ', c.contactLastName)                              AS 'Contact Person\'s Name',
       CONCAT(b.addressLine1, ', ', b.addressLine2, ', ', b.subCounty, ', ', b.county) AS 'Branch',
       p.productCode                                                                   AS 'Product Code',
       p.productName                                                                   AS 'Product Name',
       od.priceEach                                                                    AS 'Unit Price',
       od.quantityOrdered                                                              AS 'Quantity',
       (od.priceEach * od.quantityOrdered)                                             AS 'Line Total',
       os.status                                                                       AS 'Overall Order Status',
       ROUND(@totalAmount, 2)                                                          AS 'Overall Order Total'
FROM customerOrder co
         JOIN customer c ON co.customerNumber = c.customerNumber
         JOIN branch b ON co.branchCode = b.branchCode
         JOIN orderDetail od ON co.orderNumber = od.orderNumber
         JOIN product p ON od.productCode = p.productCode
         JOIN orderStatus os ON co.orderStatusID = os.orderStatusID
WHERE co.orderNumber = @orderNumber
ORDER BY od.productCode;


-- Display remaining stock quantities for ordered products
# SELECT p.productCode     AS 'Product Code',
#        p.productName     AS 'Product Name',
#        p.quantityInStock AS 'Remaining Stock'
# FROM product p
#          JOIN orderDetail od ON p.productCode = od.productCode
# WHERE od.orderNumber = @orderNumber
# ORDER BY p.productCode;

-- COMMIT;