"""
Role: This is the backend. It implements the business rules and transaction logic.

Responsibilities:
- Orchestrates multiple CRUD operations as one logical unit.
- Validates data from the frontend before persisting it.
- Handles exceptions, savepoints, and rollbacks during transaction processing.

* It should be completely decoupled from the HTTP or UI frameworks.
* It can run on the application server which has Python installed.

Takeaway: This is your core backend, the part of the system that actually does the work.
"""
from datetime import datetime, timedelta
from sqlalchemy import exc
from sqlalchemy.orm import Session
from models import Order, OrderItem, CustomerOrder, OrderDetail, Product, Payment, Customer, Branch, OrderStatus, PaymentMethod


def create_order_with_items(session: Session, customer: str, items: list):
    """
    items is a list of dictionaries:
    [ {"name": "Mukimo", "qty": 2}, {"name": "Chapati", "qty": 3} ]
    """

    try:
        # Start transaction
        order = Order(customer=customer)
        session.add(order)
        session.flush()   # Obtain order.id without committing

        # Create a savepoint in case items fail
        savepoint = session.begin_nested()

        for item in items:
            # Example validation: quantities must be > 0
            if item["qty"] <= 0:
                savepoint.rollback()   # Roll back only the items block
                raise ValueError("Quantity must be a positive integer.")

            order_item = OrderItem(
                order_id=order.id,
                item_name=item["name"],
                quantity=item["qty"]
            )
            session.add(order_item)

        session.commit()  # Commit entire transaction
        return {"message": "Order created successfully", "order_id": order.id}

    except Exception as e:
        session.rollback()  # Full rollback
        return {"error": str(e)}


def create_customer_order_with_products(
        session: Session,
        customer_number: int,
        branch_code: int,
        order_status_id: int,
        payment_method_id: int,
        items: list
):
    """
    Creates a customer order with multiple products, implementing savepoints after each order line item.

    items is a list of dictionaries:
    [ {"product_code": "P001", "quantity_ordered": 2}, {"product_code": "P018", "quantity_ordered": 5} ]

    Business rule: You cannot sell what you do not have (stock validation).
    If a product has insufficient stock, rollback to the previous savepoint and continue with other products.
    """

    try:
        # We start the transaction here
        order_date = datetime.now()
        required_date = order_date + timedelta(minutes=30)
        dispatch_date = order_date + timedelta(minutes=20)

        # Create a new order for the specific customer
        customer_order = CustomerOrder(
            orderDate=order_date,
            requiredDate=required_date,
            dispatchDate=dispatch_date,
            orderStatusID=order_status_id,
            customerNumber=customer_number,
            branchCode=branch_code
        )
        session.add(customer_order)
        session.flush()  # Obtain the new order_number without committing

        order_number = customer_order.orderNumber

        # Initialize the total amount to be paid for the order
        total_amount = 0.0

        # List to store savepoints
        savepoints = []
        processed_products = []

        # Process each product using a unique savepoint
        for idx, item in enumerate(items):
            product_code = item["product_code"]
            quantity_ordered = item["quantity_ordered"]

            # Create a savepoint before processing this product
            savepoint = session.begin_nested()
            savepoint_name = f"sp{idx + 1}"

            try:
                # Query product to get price and stock
                product = session.query(Product).filter_by(productCode=product_code).first()

                if not product:
                    # If the product has not been found, then roll back this item
                    savepoint.rollback()
                    continue

                price = product.sellingPrice
                quantity_in_stock = product.quantityInStock

                # Validate stock availability (according to the business rule or Standard Operating Procedure)
                if quantity_in_stock < quantity_ordered:
                    # There is insufficient stock, therefore, roll back to the previous savepoint
                    savepoint.rollback()
                    continue

                # Insert the order detail iff the product was found and the quantity in stock is enough to meet the demand
                order_detail = OrderDetail(
                    orderNumber=order_number,
                    productCode=product_code,
                    quantityOrdered=quantity_ordered,
                    priceEach=price
                )
                session.add(order_detail)

                # Update the inventory to reflect the quantity that has been sold
                product.quantityInStock = product.quantityInStock - quantity_ordered

                # Calculate the total amount the client has to pay for this order
                line_total = quantity_ordered * price
                total_amount += line_total

                # Store savepoint and product info
                savepoints.append((savepoint_name, savepoint))
                processed_products.append(product_code)

            except Exception as item_error:
                # If any error occurs with this item, rollback to the most recent savepoint
                savepoint.rollback()
                continue

        # Insert payment for the order
        payment = Payment(
            orderNumber=order_number,
            paymentDate=datetime.now(),
            amount=total_amount,
            paymentMethodID=payment_method_id
        )
        session.add(payment)

        # Generate receipt (query order details)
        receipt_query = (
            session.query(
                CustomerOrder.orderNumber,
                CustomerOrder.orderDate,
                Customer.customerName,
                Customer.contactFirstName,
                Customer.contactLastName,
                Branch.addressLine1,
                Branch.addressLine2,
                Branch.subCounty,
                Branch.county,
                Product.productCode,
                Product.productName,
                OrderDetail.priceEach,
                OrderDetail.quantityOrdered,
                OrderStatus.status
            )
            .join(Customer, CustomerOrder.customerNumber == Customer.customerNumber)
            .join(Branch, CustomerOrder.branchCode == Branch.branchCode)
            .join(OrderDetail, CustomerOrder.orderNumber == OrderDetail.orderNumber)
            .join(Product, OrderDetail.productCode == Product.productCode)
            .join(OrderStatus, CustomerOrder.orderStatusID == OrderStatus.orderStatusID)
            .filter(CustomerOrder.orderNumber == order_number)
            .order_by(OrderDetail.productCode)
            .all()
        )

        # Construct the receipt
        receipt = {
            "order_number": order_number,
            "order_date": None,
            "customer_name": None,
            "contact_person": None,
            "branch": None,
            "order_status": None,
            "overall_total": round(total_amount, 2),
            "items": []
        }

        for row in receipt_query:
            if receipt["order_date"] is None:
                receipt["order_date"] = row.orderDate.strftime("%Y-%m-%d %H:%M:%S")
                receipt["customer_name"] = row.customerName
                receipt["contact_person"] = f"{row.contactFirstName} {row.contactLastName}"
                receipt["branch"] = f"{row.addressLine1}, {row.addressLine2}, {row.subCounty}, {row.county}"
                receipt["order_status"] = row.status

            line_total = row.priceEach * row.quantityOrdered
            receipt["items"].append({
                "product_code": row.productCode,
                "product_name": row.productName,
                "unit_price": float(row.priceEach),
                "quantity": row.quantityOrdered,
                "line_total": float(line_total)
            })

        # Commit entire transaction
        session.commit()

        return {
            "message": "Order created successfully",
            "order_number": order_number,
            "receipt": receipt
        }

    except Exception as e:
        session.rollback()  # Full rollback
        return {"error": str(e)}
