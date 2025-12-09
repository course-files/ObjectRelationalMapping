-- \connect postgres

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_roles WHERE rolname = 'student'
   ) THEN
      CREATE ROLE student LOGIN PASSWORD '5trathm0re';
   END IF;
END$$;

-- Grant role capability to create databases (optional, but good for "DBA" status)
ALTER ROLE student CREATEDB;

-- Create database
-- CREATE DATABASE dreamhome
--     WITH OWNER = student
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'en_US.UTF-8'
--     LC_CTYPE   = 'en_US.UTF-8'
--     TEMPLATE   template0;

-- GRANT ALL PRIVILEGES ON DATABASE dreamhome TO student;

-- Connect to the database
-- \c dreamhome;

-- PostgreSQL uses databases → schemas → tables/other objects.
-- By default, if you do not create a custom schema, everything goes into the public schema.
-- The public schema is owned by the role that created the database (or postgres),
-- and everyone usually has privileges to create objects there.
CREATE SCHEMA IF NOT EXISTS dreamhome AUTHORIZATION student;

GRANT ALL PRIVILEGES ON SCHEMA dreamhome TO student;

SET search_path TO dreamhome;

DROP TABLE IF EXISTS viewing CASCADE;
DROP TABLE IF EXISTS registration CASCADE;
DROP TABLE IF EXISTS propertyforrent CASCADE;
DROP TABLE IF EXISTS privateowner CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS branch CASCADE;

-- 1. branch
CREATE TABLE branch (
  branchNo   CHAR(4) PRIMARY KEY,
  street     VARCHAR(25) NOT NULL,
  city       VARCHAR(15) NOT NULL,
  postcode   VARCHAR(8)  NOT NULL
);

-- 2. staff
CREATE TABLE staff (
  staffNo    VARCHAR(5) PRIMARY KEY,
  fName      VARCHAR(15) NOT NULL,
  lName      VARCHAR(15) NOT NULL,
  position   VARCHAR(20) NOT NULL,
  sex        CHAR(1) CHECK (sex IN ('M','F')),
  DOB        DATE,
  salary     NUMERIC(9,2) NOT NULL CHECK (salary > 0),
  branchNo   CHAR(4) NOT NULL REFERENCES branch(branchNo)
);

-- 3. client
CREATE TABLE client (
  clientNo   VARCHAR(7) PRIMARY KEY,
  fName      VARCHAR(15) NOT NULL,
  lName      VARCHAR(15) NOT NULL,
  telNo      VARCHAR(20) NOT NULL,
  prefType   VARCHAR(10) NOT NULL,
  maxRent    NUMERIC(7,2) NOT NULL CHECK (maxRent > 0)
);

-- 4. privateowner
CREATE TABLE privateowner (
  ownerNo    VARCHAR(7) PRIMARY KEY,
  fName      VARCHAR(15) NOT NULL,
  lName      VARCHAR(15) NOT NULL,
  address    VARCHAR(80) NOT NULL,
  telNo      VARCHAR(20) NOT NULL
);

-- 5. propertyforrent
CREATE TABLE propertyforrent (
  propertyNo VARCHAR(8) PRIMARY KEY,
  street     VARCHAR(25) NOT NULL,
  city       VARCHAR(15) NOT NULL,
  postcode   VARCHAR(8)  NOT NULL,
  type       VARCHAR(10) NOT NULL,
  rooms      SMALLINT NOT NULL CHECK (rooms > 0),
  rent       NUMERIC(7,2) NOT NULL CHECK (rent > 0),
  ownerNo    VARCHAR(7) NOT NULL REFERENCES privateowner(ownerNo),
  staffNo    VARCHAR(5) REFERENCES staff(staffNo),
  branchNo   CHAR(4) NOT NULL REFERENCES branch(branchNo)
);

-- 6. registration
CREATE TABLE registration (
  clientNo   VARCHAR(7) NOT NULL REFERENCES client(clientNo),
  branchNo   CHAR(4)    NOT NULL REFERENCES branch(branchNo),
  staffNo    VARCHAR(5) NOT NULL REFERENCES staff(staffNo),
  dateJoined DATE NOT NULL,
  PRIMARY KEY (clientNo, branchNo)
);

-- 7. viewing
CREATE TABLE viewing (
  clientNo   VARCHAR(7) NOT NULL REFERENCES client(clientNo),
  propertyNo VARCHAR(8) NOT NULL REFERENCES propertyforrent(propertyNo),
  viewDate   DATE NOT NULL,
  comment    VARCHAR(50),
  PRIMARY KEY (propertyNo, clientNo)
);

INSERT INTO branch (branchNo, street, city, postcode) VALUES
('B002','56 Clover Dr','London','NW10 6EU'),
('B003','163 Main St','Glasgow','G11 9QX'),
('B004','32 Manse Rd','Bristol','BS99 1NZ'),
('B005','22 Deer Rd','London','SW1 4EH'),
('B007','16 Argyll St','Aberdeen','AB2 3SU');

INSERT INTO staff VALUES
('SA9','Mary','Howe','Assistant','F','1970-02-19',9000.00,'B007'),
('SG14','David','Ford','Supervisor','M','1958-11-24',18000.00,'B003'),
('SG37','Ann','Beech','Assistant','F','1960-10-11',12000.00,'B003'),
('SG5','Susan','Brand','Manager','F','1940-06-03',24000.00,'B003'),
('SL21','John','White','Manager','M','1945-10-01',30000.00,'B005'),
('SL41','Julie','Lee','Assistant','F','1965-06-13',9000.00,'B005');

INSERT INTO client VALUES
('CR56','Aline','Stewart','0141-848-1825','Flat',350.0),
('CR62','Mary','Tregar','01224-196720','Flat',600.0),
('CR74','Mike','Ritchie','01475-392178','House',750.0),
('CR76','John','Kay','0207-774-5632','Flat',425.0);

INSERT INTO privateowner VALUES
('CO40','Tina','Murphy','63 Well St, Glasgow G42','0141-943-1728'),
('CO46','Joe','Keogh','2 Fergus Dr, Aberdeen AB2 7SX','01224-861212'),
('CO87','Carol','Farrel','6 Achray St, Glasgow G32 9DX','0141-357-7419'),
('CO93','Tony','Shaw','12 Park Pl, Glasgow G4 0QR','0141-225-7025');

INSERT INTO propertyforrent VALUES
('PA14','16 Holhead','Aberdeen','AB7 5SU','House',6,650.0,'CO46','SA9','B007'),
('PG16','5 Novar Dr','Glasgow','G12 9AX','Flat',4,450.0,'CO93','SG14','B003'),
('PG21','18 Dale Rd','Glasgow','G12','House',5,600.0,'CO87','SG37','B003'),
('PG36','2 Manor Rd','Glasgow','G32 4QX','Flat',3,375.0,'CO93','SG37','B003'),
('PG4','6 Lawrence St','Glasgow','G11 9QX','Flat',3,350.0,'CO40',NULL,'B003'),
('PL94','6 Argyll St','London','NW2','Flat',4,400.0,'CO87','SL41','B005');

INSERT INTO registration VALUES
('CR56','B003','SG37','2000-04-11'),
('CR62','B007','SA9','2000-03-07'),
('CR74','B003','SG37','1999-11-16'),
('CR76','B005','SL41','2001-01-02');

INSERT INTO viewing VALUES
('CR56','PA14','2001-05-24','too small'),
('CR62','PA14','2001-05-14','no dining room'),
('CR56','PG36','2001-04-28',NULL),
('CR56','PG4','2001-05-26',NULL),
('CR76','PG4','2001-04-20','too remote');
