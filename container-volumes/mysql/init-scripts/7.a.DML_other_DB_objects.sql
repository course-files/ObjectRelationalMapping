USE `siwaka_dishes`;

-- First view
-- This script creates a view named `view_payment_data` that consolidates payment information
-- Tables involved:
-- payment, paymentmethod, customerorder, orderstatus, customer, branch
CREATE VIEW `view_payment_data` AS
SELECT payment.paymentNumber        AS payment_paymentNumber,
       customerorder.orderNumber    AS customerorder_orderNumber,
       payment.paymentDate          AS payment_paymentDate,
       payment.amount               AS payment_amount,
       paymentMethod.paymentMethod  AS payment_paymentMethod,
       orderstatus.status           AS orderstatus_status,
       customerorder.customerNumber AS customerorder_customerNumber,
       customerorder.branchCode     AS customerorder_branchCode
FROM payment
         INNER JOIN customerorder ON payment.orderNumber = customerorder.orderNumber
         INNER JOIN customer ON customerorder.customerNumber = customer.customerNumber
         INNER JOIN orderstatus ON customerorder.orderStatusID = orderstatus.orderStatusID
         INNER JOIN paymentmethod ON payment.paymentMethodID = paymentmethod.paymentMethodID
         INNER JOIN branch ON customerorder.branchCode = branch.branchCode
ORDER BY payment.paymentDate;


-- Second view
-- This script creates a view named `view_customerfeedback_data` that
-- consolidates customer, order, feedback, product, and branch information
-- Tables involved:
-- customer, customerorder, customerfeedback, orderdetail, product, productcategory, orderstatus, branch
CREATE VIEW `view_customerfeedback_data` AS
SELECT customer.customerNumber             AS customer_customerNumber,
       customer.customerName               AS customer_customerName,
       customer.contactFirstName           AS customer_contactFirstName,
       customer.contactLastName            AS customer_contactLastName,
       customer.phone                      AS customer_phone,
       customer.addressLine1               AS customer_addressLine1,
       customer.addressLine2               AS customer_addressLine2,
       customer.postalCode                 AS customer_postalCode,
       customer.county                     AS customer_county,
       customer.subCounty                  AS customer_subCounty,
       customer.status                     AS customer_status,
       customerorder.orderNumber           AS customerorder_orderNumber,
       customerorder.orderDate             AS customerorder_orderDate,
       customerorder.requiredDate          AS customerorder_requiredDate,
       customerorder.dispatchDate          AS customerorder_dispatchDate,
       customerorder.orderStatusID         AS customerorder_orderStatusID,
       customerorder.customerNumber        AS customerorder_customerNumber,
       customerfeedback.customerfeedbackID AS customerfeedback_customerfeedbackID,
       customerfeedback.foodquality        AS customerfeedback_foodquality,
       customerfeedback.servicequality     AS customerfeedback_servicequality,
       customerfeedback.pricetovalue       AS customerfeedback_pricetovalue,
       customerfeedback.ambiance           AS customerfeedback_ambiance,
       customerfeedback.comment            AS customerfeedback_comment,
       orderdetail.productCode             AS orderdetail_productCode,
       orderdetail.quantityOrdered         AS orderdetail_quantityOrdered,
       orderdetail.priceEach               AS orderdetail_priceEach,
       product.productName                 AS product_productName,
       product.productDescription          AS product_productDescription,
       product.quantityInStock             AS product_quantityInStock,
       product.costOfProduction            AS product_costOfProduction,
       product.sellingPrice                AS product_sellingPrice,
       productcategory.productCategoryID   AS productcategory_productCategoryID,
       productcategory.categoryName        AS productcategory_categoryName,
       productcategory.categoryDescription AS productcategory_categoryDescription,
       orderstatus.orderStatusID           AS orderstatus_orderStatusID,
       orderstatus.status                  AS orderstatus_status,
       branch.branchCode                   AS branch_branchCode,
       branch.phone                        AS branch_phone,
       branch.addressLine1                 AS branch_addressLine1,
       branch.addressLine2                 AS branch_addressLine2,
       branch.postalCode                   AS branch_postalCode,
       branch.county                       AS branch_county,
       branch.subCounty                    AS branch_subCounty
FROM customer
         LEFT OUTER JOIN customerorder ON
    customerorder.customerNumber = customer.customerNumber
         LEFT OUTER JOIN customerfeedback ON
    customerorder.orderNumber = customerfeedback.orderNumber
         INNER JOIN orderdetail ON
    customerorder.orderNumber = orderdetail.orderNumber
         INNER JOIN product ON
    orderdetail.productCode = product.productCode
         INNER JOIN productcategory ON
    product.productCategoryID = productcategory.productCategoryID
         LEFT OUTER JOIN orderstatus ON
    customerorder.orderStatusID = orderstatus.orderStatusID
         INNER JOIN branch ON
    customerorder.branchCode = branch.branchCode;