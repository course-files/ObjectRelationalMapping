"""
Role: This is the backend. It implements the business rules and transaction logic.

Responsibilities:
- Orchestrates multiple CRUD operations as one logical unit.
- Validates data from the frontend before persisting it.
- Handles exceptions, savepoints, and rollbacks during transaction processing.

* It should be completely decoupled from the frontend. There should be an API between the frontend and the backend.
* It can run on the application server (which has Python installed) to serve as the backend.

Takeaway: This is your core backend, the part of the system that actually does the work.
"""
from datetime import datetime, timedelta
import sqlalchemy
from sqlalchemy import exc
from sqlalchemy.orm import Session
from models import *

from collections import Counter
from typing import List, Dict
from decimal import Decimal

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

    except sqlalchemy.exc.SQLAlchemyError as e:
        session.rollback()  # Full rollback
        return {"error": str(e)}

def create_customer_order_with_products(
    session: Session,
    customer_number: int,
    branch_code: int,
    order_status_id: int,
    payment_method_id: int,
    items: List[Dict]
) -> Dict:
    """
    Create a customer order for multiple products.

    Strategy:
    1. Aggregate requested quantities by product_code.
    2. Start a single transaction.
    3. Lock the corresponding product rows (SELECT ... FOR UPDATE).
    4. Partition items into accepted and rejected (missing or insufficient stock).
    5. If there are accepted items, insert the order header, order details, update stock,
       insert payment, and commit the transaction.
    6. Return a structured result containing accepted/rejected items and a receipt for accepted items.

    The products are provided as a list of dictionaries
        [
            {
              "product_code": "P001",
              "quantity_ordered": 2
            },
            {
              "product_code": "P018",
              "quantity_ordered": 5
            },
            {
              "product_code": "P072",
              "quantity_ordered": 1
            },
            {
              "product_code": "P038",
              "quantity_ordered": 70
            }
        ]
    """

    # Aggregate Duplicates in the Payload:
    # Analogy: A supermarket teller scans the same packet of milk 5 times
    #          to represent the fact that you have bought 5 packets.

    # This aggregates the total quantity requested for each product code.
    # It adds the current item's quantity (`qty`) to the existing value in the
    # `requested` dictionary for the given product's `code`.
    #
    # It initializes the value to `0` (since `Counter()` returns `0` for missing keys)
    # and then adds the quantity. This ensures that if the same product code appears
    # multiple times in the input, their quantities are summed up.
    requested = Counter()
    original_item_order = []  # We use this to maintain the original item order for reporting purposes (e.g., in a receipt)
    for it in items:
        code = it.get("product_code")
        qty = int(it.get("quantity_ordered", 0)) if it.get("quantity_ordered") is not None else 0
        if not code or qty <= 0:
            # skip invalid items early (avoid over-processing); report them as rejected later
            original_item_order.append((code, qty))
            continue
        requested[code] = int(requested[code]) + int(qty)
        original_item_order.append((code, qty))

    if not requested:
        return {"error": "No valid items requested", "accepted": [], "rejected": list(original_item_order)}

    try:
        # Begin an explicit transaction scope. This will commit on success, rollback on exception.
        with session.begin():

            products = (
                session.query(Product)
                .filter(Product.productCode.in_(list(requested.keys())))
                .with_for_update()  # This locks the corresponding product rows for the duration of the transaction
                .all()
            )

            products_map = {p.productCode: p for p in products}

            accepted: Dict[str, int] = {}   # A dictionary presenting product_code -> qty accepted
            rejected: Dict[str, str] = {}   # A dictionary presenting product_code -> reason

            # Validate stock for each requested product (based on aggregated quantity)
            # This is where the backend implements the business logic based on the business rules.
            # It provides more flexibility to define the procedure to follow (using a procedural language like Python)
            # than if you were to use SQL, which is declarative.

            for product_code, qty_requested in requested.items():
                product = products_map.get(product_code)
                # Document the reasons for rejection.
                if product is None:
                    rejected[product_code] = "Product not found"
                    continue

                if qty_requested <= 0:
                    rejected[product_code] = "Invalid quantity"
                    continue

                if qty_requested > product.quantityInStock:
                    rejected[product_code] = f"Insufficient stock (requested {qty_requested}, available {product.quantityInStock})"
                    continue

                # Accept the aggregated request
                accepted[product_code] = qty_requested

            # If nothing is accepted, then do not create an empty order; return the list of rejected products
            if not accepted:
                # The session will roll back the 'with-block' automatically (no changes made), but we return a friendly structure for other backend/frontend developers.
                return {"message": "No items accepted", "accepted": {}, "rejected": rejected}

            # We create the order header first. This will help us to get the order_number.
            order_date = datetime.now()

            # These can be customized to request the teller to specify when the client expects the order
            # to be delivered and when the business should dispatch it for delivery.
            # For now, the default is set to "required after 30 minutes and dispatched after 20 minutes".
            required_date = order_date + timedelta(minutes=30)
            dispatch_date = order_date + timedelta(minutes=20)

            customer_order = CustomerOrder(
                orderDate=order_date,
                requiredDate=required_date,
                dispatchDate=dispatch_date,
                orderStatusID=order_status_id,
                customerNumber=customer_number,
                branchCode=branch_code
            )
            session.add(customer_order)
            session.flush()  # Obtain customer_order.orderNumber without the need to commit the transaction first

            order_number = customer_order.orderNumber

            # Create order detail rows and update the stock
            overall_total = 0.0
            created_order_details = []

            for product_code, qty in accepted.items():
                product = products_map[product_code]

                price = product.sellingPrice
                line_total = price * qty
                overall_total = Decimal(overall_total) + Decimal(line_total)

                order_detail = OrderDetail(
                    orderNumber=order_number,
                    productCode=product_code,
                    quantityOrdered=qty,
                    priceEach=price
                )
                session.add(order_detail)
                created_order_details.append(order_detail)

                # Update the inventory by reducing the amount of stock remaining based on the quantity purchased
                product.quantityInStock = product.quantityInStock - qty

            # Assumption: The client paid in full.
            # Insert payment record for the accepted items total
            payment = Payment(
                orderNumber=order_number,
                paymentDate=datetime.now(),
                amount=round(overall_total, 2),
                paymentMethodID=payment_method_id
            )
            session.add(payment)
            session.commit()

        # After commit, build a receipt from the created objects (we use what is available in this session instead of reading again)
        receipt = {
            "order_number": order_number,
            "order_date": order_date.strftime("%Y-%m-%d %H:%M:%S"),
            "customer_number": customer_number,
            "branch_code": branch_code,
            "order_status_id": order_status_id,
            "overall_total": round(overall_total, 2),
            "items": []
        }

        # Populate items for the receipt
        for od in created_order_details:
            receipt["items"].append({
                "product_code": od.productCode,
                "quantity": od.quantityOrdered,
                "unit_price": float(od.priceEach),
                "line_total": round(float(od.priceEach) * od.quantityOrdered, 2)
            })

        return {
            "message": "Order created successfully",
            "order_number": order_number,
            "accepted": accepted,
            "rejected": rejected,
            "receipt": receipt
        }

    except Exception as exc:
        # Full rollback already handled by session.begin() context manager.
        # Provide an informative error for the caller and log as needed upstream.
        session.rollback()
        return {"error": "Failed to create order", "details": str(exc)}

def get_selling_price_by_product_code(session: Session, product_code: str):
    """
    Retrieve the selling price for a given product code.

    Returns:
      - {"product_code": "...", "selling_price": 123.45} if found
      - {"error": "..."} if not found / invalid input / unexpected error
    """
    try:
        code = (product_code or "").strip()
        if not code:
            return {"error": "product_code is required"}

        product = (
            session.query(Product.productCode, Product.sellingPrice)
            .filter(Product.productCode == code)
            .first()
        )

        if not product:
            return {"error": f"Product not found for product_code={code}"}

        return {
            "product_code": product.productCode,
            "selling_price": float(product.sellingPrice)
        }

    except sqlalchemy.exc.SQLAlchemyError as e:
        return {"error": str(e)}
