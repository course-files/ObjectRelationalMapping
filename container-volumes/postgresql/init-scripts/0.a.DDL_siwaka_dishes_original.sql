DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_roles WHERE rolname = 'student'
   ) THEN
      CREATE ROLE student LOGIN PASSWORD '5trathm0re';
   END IF;
END$$;

ALTER ROLE student CREATEDB;

CREATE SCHEMA IF NOT EXISTS siwaka_dishes AUTHORIZATION student;

GRANT ALL PRIVILEGES ON SCHEMA siwaka_dishes TO student;

SET search_path TO siwaka_dishes;

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

BEGIN;

-- Drop tables if they exist (in correct order for FK constraints)
DROP TABLE IF EXISTS customerfeedback;
DROP TABLE IF EXISTS orderDetail;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS productCategory;
DROP TABLE IF EXISTS customerOrder;
DROP TABLE IF EXISTS orderStatus;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS paymentMethod;

-- Create branch Table
CREATE TABLE branch (
    branchCode SERIAL PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    subCounty VARCHAR(50) NOT NULL
);

-- Create employee Table
CREATE TABLE employee (
    employeeNumber SERIAL PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    branchCode INT NOT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    reportsTo INT,
    CONSTRAINT FK_1_branch_to_M_employee FOREIGN KEY (branchCode) REFERENCES branch (branchCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_employee_to_M_employee FOREIGN KEY (reportsTo) REFERENCES employee (employeeNumber)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create customer Table
CREATE TABLE customer (
    customerNumber SERIAL PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    subCounty VARCHAR(50) NOT NULL,
    status SMALLINT NOT NULL
);

-- Create Order Status Lookup Table
CREATE TABLE orderStatus (
    orderStatusID SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL UNIQUE
);

-- Create customerOrder Table
CREATE TABLE customerOrder (
    orderNumber SERIAL PRIMARY KEY,
    orderDate TIMESTAMP NOT NULL,
    requiredDate TIMESTAMP NOT NULL,
    dispatchDate TIMESTAMP,
    orderStatusID INT NOT NULL,
    customerNumber INT NOT NULL,
    branchCode INT NOT NULL,
    CONSTRAINT FK_1_customer_to_M_customerOrder FOREIGN KEY (customerNumber) REFERENCES customer(customerNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_orderStatus_to_M_customerOrder FOREIGN KEY (orderStatusID) REFERENCES orderStatus(orderStatusID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_branch_to_M_customerorder FOREIGN KEY (branchCode) REFERENCES branch(branchCode)
        ON UPDATE CASCADE
);

-- Create productCategory Table
CREATE TABLE productCategory (
    productCategoryID SERIAL PRIMARY KEY,
    categoryName VARCHAR(50) NOT NULL UNIQUE,
    categoryDescription TEXT
);

-- Create product Table
CREATE TABLE product (
    productCode VARCHAR(20) PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productDescription TEXT NOT NULL,
    quantityInStock INT NOT NULL CHECK (quantityInStock >= 0),
    costOfProduction DECIMAL(10, 2) NOT NULL,
    sellingPrice DECIMAL(10, 2) NOT NULL,
    productCategoryID INT,
    CONSTRAINT FK_1_productCategory_to_M_product FOREIGN KEY (productCategoryID) REFERENCES productCategory(productCategoryID)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Create Payment Methods Lookup Table
CREATE TABLE paymentMethod (
    paymentMethodID SERIAL PRIMARY KEY,
    paymentMethod VARCHAR(50) NOT NULL UNIQUE
);

-- Create payment Table
CREATE TABLE payment (
    paymentNumber SERIAL PRIMARY KEY,
    orderNumber INT NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentMethodID INT NOT NULL,
    CONSTRAINT FK_1_customerOrder_to_M_payment FOREIGN KEY (orderNumber) REFERENCES customerOrder(orderNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_paymentMethod_to_M_payment FOREIGN KEY (paymentMethodID) REFERENCES paymentMethod(paymentMethodID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Create Order Details Table
CREATE TABLE orderDetail (
    orderDetailNumber SERIAL PRIMARY KEY,
    orderNumber INT NOT NULL,
    productCode VARCHAR(20) NOT NULL,
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_1_customerOrder_to_M_orderDetails FOREIGN KEY (orderNumber) REFERENCES customerOrder(orderNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_product_to_M_orderDetails FOREIGN KEY (productCode) REFERENCES product(productCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Create Customer Feedback Table
CREATE TABLE customerfeedback (
    customerfeedbackID SERIAL PRIMARY KEY,
    foodquality INT,
    servicequality INT,
    pricetovalue INT,
    ambiance INT,
    orderNumber INT,
    comment TEXT,
    CONSTRAINT FK_1_customerorder_TO_M_customerfeedback FOREIGN KEY (orderNumber)
        REFERENCES customerOrder(orderNumber)
        ON UPDATE CASCADE
);

COMMIT;