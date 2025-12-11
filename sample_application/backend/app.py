"""
Role: Exposes the backend to the outside world through API endpoints.
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from db import SessionLocal, engine, Base
from services import create_order_with_items

# Create tables on startup
Base.metadata.create_all(bind=engine)

app = Flask(__name__)
CORS(app, supports_credentials=False,
     origins=["https://127.0.0.1", "https://localhost",
              "https://127.0.0.1:443", "https://localhost:443",
              "http://127.0.0.1", "http://localhost",
              "http://127.0.0.1:5000",
              "http://localhost:63342"])  # For JetBrains IDEs

"""
Sample Data:
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

if __name__ == '__main__':
    app.run(debug=True)
# if __name__ == '__main__':
#     app.run(debug=False)
# if __name__ == "__main__":
#     app.run(ssl_context=("cert.pem", "key.pem"), debug=True)
