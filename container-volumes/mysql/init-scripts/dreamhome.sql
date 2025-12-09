-- Create the database
-- Replace `dreamhome` with the name of your database
-- Replace student with your desired username and password

CREATE DATABASE IF NOT EXISTS `dreamhome` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER IF NOT EXISTS `student`@`%` IDENTIFIED WITH caching_sha2_password BY '5trathm0re' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
GRANT USAGE ON * . * TO `student`@`%`;
GRANT ALL PRIVILEGES ON `dreamhome`.* TO `student`@`%` WITH GRANT OPTION ;
FLUSH PRIVILEGES;

USE `dreamhome`;

/* ******************

-- If you need to change the password later
-- If you need to drop the database and delete the user later

ALTER USER `student`@`%` IDENTIFIED WITH caching_sha2_password BY 'new_password';

DROP DATABASE IF EXISTS `dreamhome`;
REVOKE ALL PRIVILEGES, GRANT OPTION FROM `student`@`%`;
DROP USER IF EXISTS `student`@`%`;

*/

/* ******************

-- If you need to change the password later
-- If you need to drop the database and delete the user later

ALTER USER `student`@`%` IDENTIFIED WITH caching_sha2_password BY 'new_password';

DROP DATABASE IF EXISTS `dreamhome`;
REVOKE ALL PRIVILEGES, GRANT OPTION FROM `student`@`%`;
DROP USER IF EXISTS `student`@`%`;

*/

-- List of tables to create (in the specified order):
-- 1. branch
-- 2. staff
-- 3. client
-- 4. privateowner
-- 5. propertyforrent
-- 6. registration
-- 7. viewing

-- 1. The "lock" ensures that no other session can read/write to the table until it is unlocked
-- 2. The "disable keys" disables non-unique indexes on the table because this speeds up the bulk insertion
-- 3. The "!40000" ensures the code is executed in MySQL (>=4.00.00)
-- 4. To disable foreign key checks before inserting: SET foreign_key_checks = 0;
-- 5. To enable foreign key checks after inserting: SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS branch; 
DROP TABLE IF EXISTS client; 
DROP TABLE IF EXISTS privateowner;
DROP TABLE IF EXISTS propertyforrent;
DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS viewing;
SET foreign_key_checks = 1;

-- Create branch table
CREATE TABLE branch (
  branchNo char(4) NOT NULL,
  street varchar(25) NOT NULL,
  city varchar(15) NOT NULL,
  postcode varchar(8) NOT NULL,
  PRIMARY KEY (branchNo)
) ENGINE=InnoDB;

-- Insert branch data
LOCK TABLES branch WRITE;
/*!40000 ALTER TABLE branch DISABLE KEYS */;
INSERT INTO branch VALUES ('B002','56 Clover Dr','London','NW10 6EU'),('B003','163 Main St','Glasgow','G11 9QX'),('B004','32 Manse Rd','Bristol','BS99 1NZ'),('B005','22 Deer Rd','London','SW1 4EH'),('B007','16 Argyll St','Aberdeen','AB2 3SU');
/*!40000 ALTER TABLE branch ENABLE KEYS */;
UNLOCK TABLES;

-- Create staff table
CREATE TABLE staff (
  staffNo varchar(5) NOT NULL,
  fName varchar(15) NOT NULL,
  lName varchar(15) NOT NULL,
  position varchar(10) NOT NULL,
  sex char(4) DEFAULT NULL,
  DOB date DEFAULT NULL,
  salary decimal(9,2) NOT NULL,
  branchNo char(4) NOT NULL,
  PRIMARY KEY (staffNo),
  KEY Staff_Branch_FK (branchNo),
  CONSTRAINT Staff_Branch_FK FOREIGN KEY (branchNo) REFERENCES branch (branchNo)
) ENGINE=InnoDB;

-- Insert staff data
LOCK TABLES staff WRITE;
/*!40000 ALTER TABLE staff DISABLE KEYS */;
INSERT INTO staff VALUES ('SA9','Mary','Howe','Assistant','F','1970-02-19',9000.00,'B007'),('SG14','David','Ford','Supervisor','M','1958-11-24',18000.00,'B003'),('SG37','Ann','Beech','Assistant','F','1960-10-11',12000.00,'B003'),('SG5','Susan','Brand','Manager','F','1940-06-03',24000.00,'B003'),('SL21','John','White','Manager','M','1945-10-01',30000.00,'B005'),('SL41','Julie','Lee','Assistant','F','1965-06-13',9000.00,'B005');
/*!40000 ALTER TABLE staff ENABLE KEYS */;
UNLOCK TABLES;


-- Create table client
CREATE TABLE client (
  clientNo varchar(7) NOT NULL,
  fName varchar(15) NOT NULL,
  lName varchar(15) NOT NULL,
  telNo varchar(13) NOT NULL,
  prefType varchar(10) NOT NULL,
  maxRent decimal(5,1) NOT NULL,
  PRIMARY KEY (clientNo)
) ENGINE=InnoDB;

-- Insert client data
LOCK TABLES client WRITE;
/*!40000 ALTER TABLE client DISABLE KEYS */;
INSERT INTO client VALUES ('CR56','Aline','Stewart','0141-848-1825','Flat',350.0),('CR62','Mary','Tregar','01224-196720','Flat',600.0),('CR74','Mike','Ritchie','01475-392178','House',750.0),('CR76','John','Kay','0207-774-5632','Flat',425.0);
/*!40000 ALTER TABLE client ENABLE KEYS */;
UNLOCK TABLES;

-- Create privateowner table
CREATE TABLE privateowner (
  ownerNo varchar(7) NOT NULL,
  fName varchar(15) NOT NULL,
  lName varchar(15) NOT NULL,
  address varchar(50) NOT NULL,
  telNo varchar(13) NOT NULL,
  PRIMARY KEY (ownerNo)
) ENGINE=InnoDB;

-- Insert privateowner data
LOCK TABLES privateowner WRITE;
/*!40000 ALTER TABLE privateowner DISABLE KEYS */;
INSERT INTO privateowner VALUES ('CO40','Tina','Murphy','63 Well St, Glasgow G42','0141-943-1728'),('CO46','Joe','Keogh','2 Fergus Dr, Aberdeen AB2 7SX','01224-861212'),('CO87','Carol','Farrel','6 Achray St, Glasgow G32 9DX','0141-357-7419'),('CO93','Tony','Shaw','12 Park Pl, Glasgow G4 0QR','0141-225-7025');
/*!40000 ALTER TABLE privateowner ENABLE KEYS */;
UNLOCK TABLES;

-- Create propertyforrent table
CREATE TABLE propertyforrent (
  propertyNo varchar(8) NOT NULL,
  street varchar(25) NOT NULL,
  city varchar(15) NOT NULL,
  postcode varchar(8) NOT NULL,
  type varchar(10) NOT NULL,
  rooms smallint NOT NULL,
  rent decimal(5,1) NOT NULL,
  ownerNo varchar(7) NOT NULL,
  staffNo varchar(5) DEFAULT NULL,
  branchNo char(4) NOT NULL,
  PRIMARY KEY (propertyNo),
  KEY Property_Owner_FK (ownerNo),
  KEY Property_Staff_FK (staffNo),
  KEY Property_Branch_FK (branchNo),
  CONSTRAINT Property_Branch_FK FOREIGN KEY (branchNo) REFERENCES branch (branchNo),
  CONSTRAINT Property_Owner_FK FOREIGN KEY (ownerNo) REFERENCES privateowner (ownerNo),
  CONSTRAINT Property_Staff_FK FOREIGN KEY (staffNo) REFERENCES staff (staffNo)
) ENGINE=InnoDB;

-- Insert propertyforrent data
LOCK TABLES propertyforrent WRITE;
/*!40000 ALTER TABLE propertyforrent DISABLE KEYS */;
INSERT INTO propertyforrent VALUES ('PA14','16 Holhead','Aberdeen','AB7 5SU','House',6,650.0,'CO46','SA9','B007'),('PG16','5 Novar Dr','Glasgow','G12 9AX','Flat',4,450.0,'CO93','SG14','B003'),('PG21','18 Dale Rd','Glasgow','G12','House',5,600.0,'CO87','SG37','B003'),('PG36','2 Manor Rd','Glasgow','G32 4QX','Flat',3,375.0,'CO93','SG37','B003'),('PG4','6 Lawrence St','Glasgow','G11 9QX','Flat',3,350.0,'CO40',NULL,'B003'),('PL94','6 Argyll St','London','NW2','Flat',4,400.0,'CO87','SL41','B005');
/*!40000 ALTER TABLE propertyforrent ENABLE KEYS */;
UNLOCK TABLES;

-- Create registration table
CREATE TABLE registration (
  clientNo varchar(7) NOT NULL,
  branchNo char(4) NOT NULL,
  staffNo varchar(5) NOT NULL,
  dateJoined date NOT NULL,
  PRIMARY KEY (clientNo,branchNo),
  KEY Regist_Branch_FK (branchNo),
  KEY Regist_Staff_FK (staffNo),
  CONSTRAINT Regist_Branch_FK FOREIGN KEY (branchNo) REFERENCES branch (branchNo),
  CONSTRAINT Regist_Client_FK FOREIGN KEY (clientNo) REFERENCES client (clientNo),
  CONSTRAINT Regist_Staff_FK FOREIGN KEY (staffNo) REFERENCES staff (staffNo)
) ENGINE=InnoDB;

-- Insert registration data
LOCK TABLES registration WRITE;
/*!40000 ALTER TABLE registration DISABLE KEYS */;
INSERT INTO registration VALUES ('CR56','B003','SG37','2000-04-11'),('CR62','B007','SA9','2000-03-07'),('CR74','B003','SG37','1999-11-16'),('CR76','B005','SL41','2001-01-02');
/*!40000 ALTER TABLE registration ENABLE KEYS */;
UNLOCK TABLES;

-- Create viewing table
CREATE TABLE viewing (
  clientNo varchar(7) NOT NULL,
  propertyNo varchar(8) NOT NULL,
  viewDate date NOT NULL,
  comment varchar(50) DEFAULT NULL,
  PRIMARY KEY (propertyNo,clientNo),
  KEY Viewing_Client_FK (clientNo),
  CONSTRAINT Viewing_Client_FK FOREIGN KEY (clientNo) REFERENCES client (clientNo),
  CONSTRAINT Viewing_Propty_FK FOREIGN KEY (propertyNo) REFERENCES propertyforrent (propertyNo)
) ENGINE=InnoDB;

-- Insert viewing data
LOCK TABLES viewing WRITE;
/*!40000 ALTER TABLE viewing DISABLE KEYS */;
INSERT INTO viewing VALUES ('CR56','PA14','2001-05-24','too small'),('CR62','PA14','2001-05-14','no dining room'),('CR56','PG36','2001-04-28',NULL),('CR56','PG4','2001-05-26',NULL),('CR76','PG4','2001-04-20','too --ote');
/*!40000 ALTER TABLE viewing ENABLE KEYS */;

UNLOCK TABLES;
