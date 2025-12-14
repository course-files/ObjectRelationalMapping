"""
Role: Exposes the backend to the outside world through API endpoints.
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from db import SessionLocal, engine, Base
from services import (
    create_order_with_items,
    create_customer_order_with_products,
    get_selling_price_by_product_code,
)
# Create tables on startup
Base.metadata.create_all(bind=engine)

app = Flask(__name__)
CORS(app, supports_credentials=False,
     origins=["https://127.0.0.1", "https://localhost",
              "https://127.0.0.1:443", "https://localhost:443",
              "http://127.0.0.1", "http://localhost",
              "http://127.0.0.1:5000",
              "http://localhost:63342"])  # http://localhost:63342 is for supporting JetBrains IDE's built-in web server

"""
Sample Payload:
{
  "customer": "John Doe",
  "items": [
    {"name": "Mukimo", "qty": 2},
    {"name": "Chapati", "qty": 3}
  ]
}
"""
@app.post("/api/orders")
def create_order():
    data = request.json

    # Basic validation
    if "customer" not in data or "items" not in data:
        return jsonify({"error": "Missing required fields"}), 400

    session = SessionLocal()

    try:
        result = create_order_with_items(
            session,
            customer=data["customer"],
            items=data["items"]
        )
        status = 200 if "error" not in result else 400
        return jsonify(result), status

    finally:
        session.close()

"""
Receives transaction input for:
- customerOrder
- orderDetail line items (with savepoints per item)
- payment (amount computed by ORM from accepted items)

Sample payload:
{
  "customer_number": 621,
  "branch_code": 5,
  "order_status_id": 4,
  "payment_method_id": 1,
  "items": [
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
}
"""
@app.post("/api/meal_order_transaction")
def create_customer_order_transaction():
    data = request.get_json(silent=True) or {}

    required_fields = ["customer_number", "branch_code", "order_status_id", "payment_method_id", "items"]
    missing = [f for f in required_fields if f not in data]
    if missing:
        return jsonify({"error": f"Missing required fields: {', '.join(missing)}"}), 400

    # Type/shape validation (keep it simple and explicit)
    try:
        customer_number = int(data["customer_number"])
        branch_code = int(data["branch_code"])
        order_status_id = int(data["order_status_id"])
        payment_method_id = int(data["payment_method_id"])
    except (TypeError, ValueError):
        return jsonify({"error": "customer_number, branch_code, order_status_id, payment_method_id must be integers"}), 400

    items = data["items"]
    if not isinstance(items, list) or len(items) == 0:
        return jsonify({"error": "items must be a non-empty list"}), 400

    normalized_items = []
    for idx, item in enumerate(items, start=1):
        if not isinstance(item, dict):
            return jsonify({"error": f"items[{idx}] must be an object"}), 400

        if "product_code" not in item or "quantity_ordered" not in item:
            return jsonify({"error": f"items[{idx}] must include product_code and quantity_ordered"}), 400

        product_code = str(item["product_code"]).strip()
        if not product_code:
            return jsonify({"error": f"items[{idx}].product_code cannot be empty"}), 400

        try:
            quantity_ordered = int(item["quantity_ordered"])
        except (TypeError, ValueError):
            return jsonify({"error": f"items[{idx}].quantity_ordered must be an integer"}), 400

        if quantity_ordered <= 0:
            return jsonify({"error": f"items[{idx}].quantity_ordered must be > 0"}), 400

        normalized_items.append(
            {"product_code": product_code, "quantity_ordered": quantity_ordered}
        )

    session = SessionLocal()
    try:
        result = create_customer_order_with_products(
            session=session,
            customer_number=customer_number,
            branch_code=branch_code,
            order_status_id=order_status_id,
            payment_method_id=payment_method_id,
            items=normalized_items
        )

        status = 200 if "error" not in result else 400
        return jsonify(result), status

    finally:
        session.close()

    """
    Retrieves selling price for a given product code.

    Example:
      GET /api/products/P001/selling-price
    """
@app.get("/api/products/<string:product_code>/selling-price")
def api_get_selling_price(product_code: str):
    session = SessionLocal()
    try:
        result = get_selling_price_by_product_code(session, product_code=product_code)
        status = 200 if "error" not in result else 404
        return jsonify(result), status
    finally:
        session.close()

if __name__ == '__main__':
    app.run(debug=True)
# if __name__ == '__main__':
#     app.run(debug=False)
# if __name__ == "__main__":
#     app.run(ssl_context=("cert.pem", "key.pem"), debug=True)
