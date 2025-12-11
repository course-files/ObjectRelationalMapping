# Used to define the database models for the ORM.
"""
Role: This forms part of the ORM layer. It defines the database schema and maps Python objects to database tables.

- It defines the actual database schemas using ORM classes (Order, OrderItem, SideDish etc.).
- It maps Python objects to database tables (attributes ↔ columns, relationships ↔ foreign keys).
"""
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Numeric, Text
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


class Branch(Base):
    __tablename__ = "branch"
    branchCode = Column(Integer, primary_key=True, autoincrement=True)
    phone = Column(String(20), nullable=False)
    addressLine1 = Column(String(100), nullable=False)
    addressLine2 = Column(String(100))
    postalCode = Column(String(20), nullable=False)
    county = Column(String(50), nullable=False)
    subCounty = Column(String(50), nullable=False)

    employees = relationship("Employee", back_populates="branch")
    customer_orders = relationship("CustomerOrder", back_populates="branch")


class Employee(Base):
    __tablename__ = "employee"
    employeeNumber = Column(Integer, primary_key=True, autoincrement=True)
    firstName = Column(String(50), nullable=False)
    lastName = Column(String(50), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    branchCode = Column(Integer, ForeignKey("branch.branchCode", ondelete="CASCADE", onupdate="CASCADE"),
                        nullable=False)
    jobTitle = Column(String(50), nullable=False)
    reportsTo = Column(Integer, ForeignKey("employee.employeeNumber", ondelete="SET NULL", onupdate="CASCADE"))

    branch = relationship("Branch", back_populates="employees")
    manager = relationship("Employee", remote_side=[employeeNumber], back_populates="subordinates")
    subordinates = relationship("Employee", back_populates="manager")


class Customer(Base):
    __tablename__ = "customer"
    customerNumber = Column(Integer, primary_key=True, autoincrement=True)
    customerName = Column(String(100), nullable=False)
    contactFirstName = Column(String(50), nullable=False)
    contactLastName = Column(String(50), nullable=False)
    phone = Column(String(20), nullable=False)
    addressLine1 = Column(String(100), nullable=False)
    addressLine2 = Column(String(100))
    postalCode = Column(String(20), nullable=False)
    county = Column(String(50), nullable=False)
    subCounty = Column(String(50), nullable=False)
    status = Column(Integer, nullable=False)

    customer_orders = relationship("CustomerOrder", back_populates="customer")


class OrderStatus(Base):
    __tablename__ = "orderStatus"
    orderStatusID = Column(Integer, primary_key=True, autoincrement=True)
    status = Column(String(50), nullable=False, unique=True)

    customer_orders = relationship("CustomerOrder", back_populates="order_status")


class CustomerOrder(Base):
    __tablename__ = "customerOrder"
    orderNumber = Column(Integer, primary_key=True, autoincrement=True)
    orderDate = Column(DateTime, nullable=False)
    requiredDate = Column(DateTime, nullable=False)
    dispatchDate = Column(DateTime)
    orderStatusID = Column(Integer, ForeignKey("orderStatus.orderStatusID", ondelete="RESTRICT", onupdate="CASCADE"),
                           nullable=False)
    customerNumber = Column(Integer, ForeignKey("customer.customerNumber", ondelete="CASCADE", onupdate="CASCADE"),
                            nullable=False)
    branchCode = Column(Integer, ForeignKey("branch.branchCode", onupdate="CASCADE"), nullable=False)

    customer = relationship("Customer", back_populates="customer_orders")
    order_status = relationship("OrderStatus", back_populates="customer_orders")
    branch = relationship("Branch", back_populates="customer_orders")
    payments = relationship("Payment", back_populates="customer_order")
    order_details = relationship("OrderDetail", back_populates="customer_order")
    customer_feedback = relationship("CustomerFeedback", back_populates="customer_order")


class ProductCategory(Base):
    __tablename__ = "productCategory"
    productCategoryID = Column(Integer, primary_key=True, autoincrement=True)
    categoryName = Column(String(50), nullable=False, unique=True)
    categoryDescription = Column(Text)

    products = relationship("Product", back_populates="product_category")


class Product(Base):
    __tablename__ = "product"
    productCode = Column(String(20), primary_key=True)
    productName = Column(String(100), nullable=False)
    productDescription = Column(Text, nullable=False)
    quantityInStock = Column(Integer, nullable=False)
    costOfProduction = Column(Numeric(10, 2), nullable=False)
    sellingPrice = Column(Numeric(10, 2), nullable=False)
    productCategoryID = Column(Integer,
                               ForeignKey("productCategory.productCategoryID", ondelete="SET NULL", onupdate="CASCADE"))

    product_category = relationship("ProductCategory", back_populates="products")
    order_details = relationship("OrderDetail", back_populates="product")


class PaymentMethod(Base):
    __tablename__ = "paymentMethod"
    paymentMethodID = Column(Integer, primary_key=True, autoincrement=True)
    paymentMethod = Column(String(50), nullable=False, unique=True)

    payments = relationship("Payment", back_populates="payment_method")


class Payment(Base):
    __tablename__ = "payment"
    paymentNumber = Column(Integer, primary_key=True, autoincrement=True)
    orderNumber = Column(Integer, ForeignKey("customerOrder.orderNumber", ondelete="CASCADE", onupdate="CASCADE"),
                         nullable=False)
    paymentDate = Column(DateTime, nullable=False)
    amount = Column(Numeric(10, 2), nullable=False)
    paymentMethodID = Column(Integer,
                             ForeignKey("paymentMethod.paymentMethodID", ondelete="RESTRICT", onupdate="CASCADE"),
                             nullable=False)

    customer_order = relationship("CustomerOrder", back_populates="payments")
    payment_method = relationship("PaymentMethod", back_populates="payments")


class OrderDetail(Base):
    __tablename__ = "orderDetail"
    orderDetailNumber = Column(Integer, primary_key=True, autoincrement=True)
    orderNumber = Column(Integer, ForeignKey("customerOrder.orderNumber", ondelete="CASCADE", onupdate="CASCADE"),
                         nullable=False)
    productCode = Column(String(20), ForeignKey("product.productCode", ondelete="RESTRICT", onupdate="CASCADE"),
                         nullable=False)
    quantityOrdered = Column(Integer, nullable=False)
    priceEach = Column(Numeric(10, 2), nullable=False)

    customer_order = relationship("CustomerOrder", back_populates="order_details")
    product = relationship("Product", back_populates="order_details")


class CustomerFeedback(Base):
    __tablename__ = "customerfeedback"
    customerfeedbackID = Column(Integer, primary_key=True, autoincrement=True)
    foodquality = Column(Integer)
    servicequality = Column(Integer)
    pricetovalue = Column(Integer)
    ambiance = Column(Integer)
    orderNumber = Column(Integer, ForeignKey("customerOrder.orderNumber", onupdate="CASCADE"))
    comment = Column(Text)

    customer_order = relationship("CustomerOrder", back_populates="customer_feedback")
