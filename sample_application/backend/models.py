# Used to define the database models for the ORM.
"""
Role: This forms part of the ORM layer. It defines the database schema and maps Python objects to database tables.

- It defines the actual database schemas using ORM classes (Order, OrderItem, SideDish etc.).
- It maps Python objects to database tables (attributes ↔ columns, relationships ↔ foreign keys).
"""
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from db import Base

class Order(Base):
    __tablename__ = "orders"
    id = Column(Integer, primary_key=True)
    customer = Column(String(45), nullable=False)

    items = relationship("OrderItem", back_populates="order")


class OrderItem(Base):
    __tablename__ = "order_items"
    id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey("orders.id"))
    item_name = Column(String(45), nullable=False)
    quantity = Column(Integer, nullable=False)

    order = relationship("Order", back_populates="items")
