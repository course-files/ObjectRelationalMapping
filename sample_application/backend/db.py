"""
Role: This forms part of the ORM layer. It specifies how to connect to the database.

- It creates the engine and session factory (SessionLocal), which are your connection handles to the database.
- It defines the Base declarative class for mapping tables.
"""
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL_SQLITE = "sqlite+pysqlite:///./mydatabase.db"
DATABASE_URL_MYSQL = "mysql+pymysql://root:5trathm0re@127.0.0.1:3307/siwaka_dishes"
DATABASE_URL_POSTGRES = "postgresql+psycopg2://postgres:5trathm0re@127.0.0.1:5433/postgres?options=-csearch_path%3dsiwaka_dishes"

engine = create_engine(DATABASE_URL_MYSQL, echo=True, future=True)

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False, future=True)

Base = declarative_base()
