-- Create the database
-- Replace `siwaka_dishes` with the name of your database
-- Replace student with your desired username and password

CREATE DATABASE IF NOT EXISTS `siwaka_dishes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER IF NOT EXISTS `student`@`%` IDENTIFIED WITH caching_sha2_password BY '5trathm0re' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
-- CREATE USER IF NOT EXISTS `student`@`%` IDENTIFIED WITH mysql_native_password BY '5trathm0re' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
GRANT USAGE ON * . * TO `student`@`%`;
GRANT ALL PRIVILEGES ON `siwaka_dishes`.* TO `student`@`%` WITH GRANT OPTION ;
FLUSH PRIVILEGES;

USE `siwaka_dishes`;

START TRANSACTION;

/* ******************

-- If you need to change the password later
-- If you need to drop the database and delete the user later

-- ALTER USER `student`@`%` IDENTIFIED WITH caching_sha2_password BY 'new_password';
-- or
-- ALTER USER `student`@`%` IDENTIFIED WITH mysql_native_password BY 'new_password';

-- DROP DATABASE IF EXISTS `siwaka_dishes`;
-- REVOKE ALL PRIVILEGES, GRANT OPTION FROM `student`@`%`;
-- DROP USER IF EXISTS `student`@`%`;

*/

-- List of tables to create (in the specified order):
-- 1. branch
-- 2. employee
-- 3. customer
-- 4. orderStatus
-- 5. customerOrder
-- 6. productCategory
-- 7. product
-- 8. paymentMethod
-- 9. payment
-- 10. orderDetail
-- 11. customerfeedback

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS orderStatus;
DROP TABLE IF EXISTS customerOrder;
DROP TABLE IF EXISTS productcategory;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS paymentMethod;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS orderDetail;
DROP TABLE IF EXISTS customerfeedback;
SET foreign_key_checks = 1;

-- Create branch Table
CREATE TABLE siwaka_dishes.branch (
    branchCode INT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    subCounty VARCHAR(50) NOT NULL
);

-- Create employee Table
CREATE TABLE siwaka_dishes.employee (
    employeeNumber INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    branchCode INT NOT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    reportsTo INT,
    CONSTRAINT FK_1_branch_to_M_employee FOREIGN KEY (branchCode) REFERENCES siwaka_dishes.branch (branchCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_employee_to_M_employee FOREIGN KEY (reportsTo) REFERENCES siwaka_dishes.employee (employeeNumber)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create customer Table
CREATE TABLE siwaka_dishes.customer (
    customerNumber INT AUTO_INCREMENT PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    subCounty VARCHAR(50) NOT NULL,
    status TINYINT NOT NULL
);

-- Create Order Status Lookup Table
CREATE TABLE siwaka_dishes.orderStatus (
    orderStatusID INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(50) NOT NULL UNIQUE
);

-- Create customerOrder Table
CREATE TABLE siwaka_dishes.customerOrder (
    orderNumber INT AUTO_INCREMENT PRIMARY KEY,
    orderDate DATETIME NOT NULL,
    requiredDate DATETIME NOT NULL,
    dispatchDate DATETIME,
    orderStatusID INT NOT NULL,
    customerNumber INT NOT NULL,
    branchCode INT NOT NULL,
    CONSTRAINT FK_1_customer_to_M_customerOrder FOREIGN KEY (customerNumber) REFERENCES siwaka_dishes.customer(customerNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_orderStatus_to_M_customerOrder FOREIGN KEY (orderStatusID) REFERENCES siwaka_dishes.orderStatus(orderStatusID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_branch_to_M_customerorder FOREIGN KEY (branchCode) REFERENCES siwaka_dishes.branch(branchCode)
        ON UPDATE CASCADE
);

-- Create productCategory Table
CREATE TABLE siwaka_dishes.productCategory (
    productCategoryID INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(50) NOT NULL UNIQUE,
    categoryDescription TEXT
);

-- Create product Table
CREATE TABLE siwaka_dishes.product (
    productCode VARCHAR(20) PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productDescription TEXT NOT NULL,
    quantityInStock INT NOT NULL CHECK (quantityInStock >= 0),
    costOfProduction DECIMAL(10, 2) NOT NULL,
    sellingPrice DECIMAL(10, 2) NOT NULL,
    productCategoryID INT,
    CONSTRAINT FK_1_productCategory_to_M_product FOREIGN KEY (productCategoryID) REFERENCES siwaka_dishes.productCategory(productCategoryID)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Create Payment Methods Lookup Table
CREATE TABLE siwaka_dishes.paymentMethod (
    paymentMethodID INT AUTO_INCREMENT PRIMARY KEY,
    paymentMethod VARCHAR(50) NOT NULL UNIQUE
);

-- Create payment Table
CREATE TABLE siwaka_dishes.payment (
    paymentNumber INT AUTO_INCREMENT PRIMARY KEY,
    orderNumber INT NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentMethodID INT NOT NULL,
    CONSTRAINT FK_1_customerOrder_to_M_payment FOREIGN KEY (orderNumber) REFERENCES siwaka_dishes.customerOrder(orderNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_paymentMethod_to_M_payment FOREIGN KEY (paymentMethodID) REFERENCES siwaka_dishes.paymentMethod(paymentMethodID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Create Order Details Table
CREATE TABLE siwaka_dishes.orderDetail (
    orderDetailNumber INT AUTO_INCREMENT PRIMARY KEY,
    orderNumber INT NOT NULL,
    productCode VARCHAR(20) NOT NULL,
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_1_customerOrder_to_M_orderDetails FOREIGN KEY (orderNumber) REFERENCES siwaka_dishes.customerOrder(orderNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_product_to_M_orderDetails FOREIGN KEY (productCode) REFERENCES siwaka_dishes.product(productCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Create Customer Feedback Table
CREATE TABLE siwaka_dishes.customerfeedback (
	customerfeedbackID INT auto_increment NOT NULL PRIMARY KEY,
	foodquality INT NULL,
	servicequality INT NULL,
	pricetovalue INT NULL,
	ambiance INT NULL,
	orderNumber INT NULL,
	comment TEXT NULL,
	CONSTRAINT FK_1_customerorder_TO_M_customerfeedback FOREIGN KEY (orderNumber)
	    REFERENCES siwaka_dishes.customerorder(orderNumber)
	    ON UPDATE CASCADE
);

COMMIT;