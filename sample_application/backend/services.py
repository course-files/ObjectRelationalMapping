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
from sqlalchemy import exc
from sqlalchemy.orm import Session
from models import Order, OrderItem

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
