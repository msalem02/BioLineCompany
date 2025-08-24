--  Mohammed Salem - Sabtia Assad

CREATE DATABASE IF NOT EXISTS BioLineCompany;
USE BioLineCompany;

CREATE TABLE PaymentMethod (
  MethodId        TINYINT UNSIGNED PRIMARY KEY,
  MethodName      VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE CustomerType (
  CustomerTypeId  TINYINT UNSIGNED PRIMARY KEY,
  TypeName        VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE ProductStatus (
  StatusId        TINYINT UNSIGNED PRIMARY KEY,
  StatusName      VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE SupplierType (
  SupplierTypeId  TINYINT UNSIGNED PRIMARY KEY,
  TypeName        VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE Company (
  CompanyId           INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  CompanyName         VARCHAR(64) NOT NULL,
  CEO                 VARCHAR(64) NOT NULL,
  FoundedYear         YEAR NOT NULL,
  City                VARCHAR(64) NOT NULL,
  Address             VARCHAR(100) NOT NULL,
  Website             VARCHAR(255),
  NumberOfEmployees   INT UNSIGNED NOT NULL DEFAULT 0,
  CreatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  IsActive            TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE Department (
  DepartmentId        INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  DepartmentName      VARCHAR(64) NOT NULL,
  EmployeeCount       INT UNSIGNED NOT NULL DEFAULT 0,
  CompanyId           INT UNSIGNED NOT NULL,
  CreatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  IsActive            TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY (CompanyId, DepartmentName),
  FOREIGN KEY (CompanyId) REFERENCES Company(CompanyId)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE Employee (
  EmployeeId          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  FirstName           VARCHAR(32) NOT NULL,
  LastName            VARCHAR(32) NOT NULL,
  Position            VARCHAR(64),
  PhoneNumber         VARCHAR(20),
  Email               VARCHAR(255) NOT NULL UNIQUE,
  Address             VARCHAR(100),
  Gender              ENUM('Male','Female') NOT NULL,
  DateOfHire          DATE NOT NULL,
  DateOfBirth         DATE NOT NULL,
  Salary              DECIMAL(12,2) NOT NULL,
  WorkHours           INT UNSIGNED NOT NULL DEFAULT 8,
  DepartmentId        INT UNSIGNED NOT NULL,
  CreatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  IsActive            TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE Product (
  ProductId           INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  ProductName         VARCHAR(100) NOT NULL,
  Category            VARCHAR(64)  NOT NULL,
  CostPrice           DECIMAL NOT NULL,
  SellingPrice        DECIMAL NOT NULL,
  DiscountRate        DECIMAL NOT NULL DEFAULT 0.00,
  QuantityInStock     INT UNSIGNED NOT NULL DEFAULT 0,
  ExpirationDate      DATE,
  StatusId            TINYINT UNSIGNED NOT NULL,
  DateAdded           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ReturnPolicy        VARCHAR(64),
  CompanyId           INT UNSIGNED NOT NULL,
  CreatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  IsActive            TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT CHK_Product_DiscountRate CHECK (DiscountRate BETWEEN 0 AND 100),
  INDEX (ProductName),
  FOREIGN KEY (StatusId) REFERENCES ProductStatus(StatusId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (CompanyId) REFERENCES Company(CompanyId)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE Customer (
  CustomerId          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  FirstName           VARCHAR(32) NOT NULL,
  LastName            VARCHAR(32) NOT NULL,
  ContactNumber       VARCHAR(20),
  Email               VARCHAR(255),
  ShippingAddress     VARCHAR(200),
  CustomerTypeId      TINYINT UNSIGNED NOT NULL,
  PaymentMethodId     TINYINT UNSIGNED NOT NULL,
  CreatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  IsActive            TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (CustomerTypeId) REFERENCES CustomerType(CustomerTypeId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethod(MethodId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE Supplier (
  SupplierId          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  SupplierCompany     VARCHAR(100) NOT NULL,
  ContactName         VARCHAR(100),
  PhoneNumber         VARCHAR(20),
  Email               VARCHAR(255),
  Address             VARCHAR(100),
  Website             VARCHAR(255),
  SupplierTypeId      TINYINT UNSIGNED NOT NULL,
  CreatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  IsActive            TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (SupplierTypeId) REFERENCES SupplierType(SupplierTypeId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE Purchase (
  PurchaseId          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  PurchaseDate        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  SupplierId          INT UNSIGNED NOT NULL,
  CompanyId           INT UNSIGNED NOT NULL,
  TotalCost           DECIMAL(14,2) NOT NULL,
  FOREIGN KEY (SupplierId) REFERENCES Supplier(SupplierId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (CompanyId) REFERENCES Company(CompanyId)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE PurchaseDetail (
  PurchaseDetailId    INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  PurchaseId          INT UNSIGNED NOT NULL,
  ProductId           INT UNSIGNED NOT NULL,
  Quantity            INT UNSIGNED NOT NULL,
  CostPerUnit         DECIMAL NOT NULL,
  FOREIGN KEY (PurchaseId) REFERENCES Purchase(PurchaseId)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE Sale (
  SaleId              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  SaleDate            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CustomerId          INT UNSIGNED NOT NULL,
  CompanyId           INT UNSIGNED NOT NULL,
  TotalRevenue        DECIMAL NOT NULL,
  INDEX (SaleDate),
  FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (CompanyId) REFERENCES Company(CompanyId)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE SaleDetail (
  SaleDetailId        INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  SaleId              INT UNSIGNED NOT NULL,
  ProductId           INT UNSIGNED NOT NULL,
  Quantity            INT UNSIGNED NOT NULL,
  SellingPrice        DECIMAL NOT NULL,
  FOREIGN KEY (SaleId) REFERENCES Sale(SaleId)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE SupplierProduct (
  SupplierProductId   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  SupplierId          INT UNSIGNED NOT NULL,
  ProductId           INT UNSIGNED NOT NULL,
  FOREIGN KEY (SupplierId) REFERENCES Supplier(SupplierId)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- =============================================================================
-- AUTOMATIC COUNTS

DELIMITER $$

-- 2.2 Increment Department.EmployeeCount when an employee is added
DROP TRIGGER IF EXISTS trg_IncDeptCount$$
CREATE TRIGGER trg_IncDeptCount
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
  UPDATE Department
  SET EmployeeCount = EmployeeCount + 1
  WHERE DepartmentId = NEW.DepartmentId;
END$$

-- 2.3 Decrement Department.EmployeeCount when an employee is removed
DROP TRIGGER IF EXISTS trg_DecDeptCount$$
CREATE TRIGGER trg_DecDeptCount
AFTER DELETE ON Employee
FOR EACH ROW
BEGIN
  UPDATE Department
  SET EmployeeCount = EmployeeCount - 1
  WHERE DepartmentId = OLD.DepartmentId;
END$$

-- 2.4 Update Company.NumberOfEmployees after an employee is added
DROP TRIGGER IF EXISTS trg_UpdateCompanyEmployeeCount_AfterInsert$$
CREATE TRIGGER trg_UpdateCompanyEmployeeCount_AfterInsert
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
  UPDATE Company
  SET NumberOfEmployees = (
    SELECT SUM(EmployeeCount)
    FROM Department
    WHERE CompanyId = (
      SELECT CompanyId FROM Department WHERE DepartmentId = NEW.DepartmentId
    )
  )
  WHERE CompanyId = (
    SELECT CompanyId FROM Department WHERE DepartmentId = NEW.DepartmentId
  );
END$$

-- 2.5 Update Company.NumberOfEmployees after an employee is removed
DROP TRIGGER IF EXISTS trg_UpdateCompanyEmployeeCount_AfterDelete$$
CREATE TRIGGER trg_UpdateCompanyEmployeeCount_AfterDelete
AFTER DELETE ON Employee
FOR EACH ROW
BEGIN
  UPDATE Company
  SET NumberOfEmployees = (
    SELECT SUM(EmployeeCount)
    FROM Department
    WHERE CompanyId = (
      SELECT CompanyId FROM Department WHERE DepartmentId = OLD.DepartmentId
    )
  )
  WHERE CompanyId = (
    SELECT CompanyId FROM Department WHERE DepartmentId = OLD.DepartmentId
  );
END$$

DELIMITER ;



-- =============================================================================
-- DATA

INSERT INTO PaymentMethod VALUES (1,'Cash'),(2,'Credit Card'),(3,'Bank Transfer');
INSERT INTO CustomerType VALUES (1,'Retail'),(2,'Wholesale');
INSERT INTO ProductStatus VALUES (1,'Available');
INSERT INTO SupplierType VALUES (1,'Local'),(2,'International');

INSERT INTO Company (CompanyId, CompanyName, CEO, FoundedYear, City, Address, Website)
VALUES 
  (1, 'BioLine Ramallah', 'Abd AlSalam Sarary', 2005, 'Ramallah', 'Al kolliya Al Ahliyya Street Al Assad Building', 'https://www.bioline.ps'),
  (2, 'BioLine Bethlehem', 'Mohammad Salem', 2017, 'Bethlehem', 'Jerusalem Hebron St.', 'https://www.bioline.ps'),
  (3, 'BioLine Hebron', 'Sabtia Asad', 2022, 'Hebron', 'Ein Sara st.', 'https://www.bioline.ps');


-- Ramallah
INSERT INTO Department (DepartmentId, DepartmentName, EmployeeCount, CompanyId) VALUES
(1, 'SalesR', 2, 1),
(2, 'ResearchR', 1, 1),
(3, 'LogisticsR', 1, 1);

-- Bethlehem
INSERT INTO Department (DepartmentId, DepartmentName, EmployeeCount, CompanyId) VALUES
(4, 'SalesB', 1, 2),
(5, 'SupportB', 2, 2),
(6, 'LogisticsB', 1, 2);

-- Hebron
INSERT INTO Department (DepartmentId, DepartmentName, EmployeeCount, CompanyId) VALUES
(7, 'SalesH', 1, 3),
(8, 'ResearchH', 1, 3),
(9, 'LogisticsH', 1, 3);



-- For Ramallah
INSERT INTO Employee (FirstName, LastName, Position, PhoneNumber, Email, Address, Gender, DateOfHire, DateOfBirth, Salary, DepartmentId)
VALUES
('Alaa', 'Yousef', 'Sales Manager', '0599000001', 'alaa.ramallah@bioline.ps', 'Ramallah', 'Male', '2022-05-10', '1990-04-23', 3500.00, 1),
('Sara', 'Salameh', 'Sales Rep', '0599000002', 'sara.ramallah@bioline.ps', 'Ramallah', 'Female', '2023-03-15', '1995-02-15', 2300.00, 1),
('Hani', 'Shaban', 'Researcher', '0599000003', 'hani.ramallah@bioline.ps', 'Ramallah', 'Male', '2021-09-01', '1988-11-09', 3100.00, 2),
('Dina', 'Mansour', 'Logistics Lead', '0599000004', 'dina.ramallah@bioline.ps', 'Ramallah', 'Female', '2024-01-11', '1997-10-20', 1900.00, 3);

-- For Bethlehem
INSERT INTO Employee (FirstName, LastName, Position, PhoneNumber, Email, Address, Gender, DateOfHire, DateOfBirth, Salary, DepartmentId)
VALUES
('Omar', 'Awad', 'Sales Rep', '0599001001', 'omar.bethlehem@bioline.ps', 'Bethlehem', 'Male', '2023-08-12', '1998-06-30', 2200.00, 4),
('Nawal', 'Fares', 'Support Engineer', '0599001002', 'nawal.bethlehem@bioline.ps', 'Bethlehem', 'Female', '2022-12-05', '1993-09-18', 2450.00, 5),
('Ziad', 'Nimer', 'Support Rep', '0599001003', 'ziad.bethlehem@bioline.ps', 'Bethlehem', 'Male', '2022-03-18', '1989-02-10', 1800.00, 5),
('Reem', 'Araj', 'Logistics Coordinator', '0599001004', 'reem.bethlehem@bioline.ps', 'Bethlehem', 'Female', '2023-07-22', '1995-08-02', 1700.00, 6);

-- For Hebron
INSERT INTO Employee (FirstName, LastName, Position, PhoneNumber, Email, Address, Gender, DateOfHire, DateOfBirth, Salary, DepartmentId)
VALUES
('Nabil', 'Barghouthi', 'Sales Rep', '0599002001', 'nabil.hebron@bioline.ps', 'Hebron', 'Male', '2022-04-01', '1992-05-19', 2100.00, 7),
('Waseem', 'Salem', 'Researcher', '0599002002', 'waseem.hebron@bioline.ps', 'Hebron', 'Male', '2023-02-14', '1997-03-25', 2050.00, 8),
('Majd', 'Hamed', 'Logistics', '0599002003', 'majd.hebron@bioline.ps', 'Hebron', 'Male', '2022-09-10', '1990-12-05', 1800.00, 9);



INSERT INTO Product (ProductId, ProductName, Category, CostPrice, SellingPrice, DiscountRate, QuantityInStock, ExpirationDate, StatusId, ReturnPolicy, CompanyId)
VALUES
(10001, 'Sterile Gloves',         'Lab Supplies',  2.50,  5.00, 0,  10, '2025-12-31', 1, '7 Days', 1),
(10002, 'Microscope',             'Equipment',   500.00, 630.00, 5,   2, '2027-05-15', 1, '1 Year', 1),
(10003, 'Test Tubes',             'Lab Supplies',  0.30,  0.60, 0,  3,  '2025-06-15', 1, 'No Returns', 1),
(10004, 'Blood Analyzer',         'Equipment',  800.00, 900.00, 2,   1, '2029-11-20', 1, '1 Year', 1),
(10005, 'Buffer Solution',        'Chemicals',     8.00, 21.35, 10, 0,  '2024-07-02', 1, 'No Returns', 1), -- Expiring soon, out of stock

(10006, 'Pipette Tips',           'Lab Supplies',  1.20,  2.80, 0,  4, '2025-07-15', 1, '30 Days', 2),
(10007, 'Centrifuge',             'Equipment',   400.00, 615.00, 3,  6, '2028-02-12', 1, '6 Months', 2),
(10008, 'Beakers',                'Lab Supplies',  0.80,  2.00, 0,  5, '2025-09-20', 1, 'No Returns', 2),
(10009, 'pH Meter',               'Equipment',    75.00, 120.00, 0,  0, '2026-01-25', 1, '6 Months', 2), -- Out of stock
(10010, 'Glucose Strips',         'Medical',       0.15,  0.50, 0,  3, '2024-07-05', 1, 'No Returns', 2), -- Expiring soon

(10011, 'Thermometer',            'Medical',       2.00,  8.00, 0,  8, '2026-03-10', 1, '14 Days', 3),
(10012, 'PCR Machine',            'Equipment', 1000.00,1200.00, 2,   5, '2027-10-28', 1, '1 Year', 3),
(10013, 'Culture Media',          'Chemicals',    20.00, 50.00, 5,   2, '2024-07-01', 1, 'No Returns', 3), -- Expiring soon, low stock
(10014, 'Microtome Blades',       'Lab Supplies',  5.00, 10.00, 0,  5, '2025-11-11', 1, '7 Days', 3),
(10015, 'Cryovials',              'Lab Supplies',  0.70,  1.50, 0,  4, '2025-08-18', 1, 'No Returns', 3);



INSERT INTO Supplier (SupplierCompany, ContactName, PhoneNumber, Email, Address, Website, SupplierTypeId)
VALUES
('LabSupplies Ltd.',        'Majed Hasan',    '022224000', 'majed@labsupplies.com',    'Ramallah',   'http://labsupplies.com', 1),
('RamBio Co.',              'Ali Nimer',      '022226000', 'ali@rambio.com',           'Ramallah',   'http://rambio.com',      1),
('Nablus Equipments',       'Nader Arafat',   '092228000', 'nader@nabluseq.com',       'Nablus',     'http://nabluseq.com',    1),
('AlQuds Scientific',       'Samah Deeb',     '022223000', 'samah@alqudsci.com',       'Jerusalem',  'http://alqudsci.com',    1),
('Bethlehem Chem',          'Rami Zaki',      '022229000', 'rami@bethchem.com',        'Bethlehem',  'http://bethchem.com',    1),

('Global Labs Inc.',        'John Carter',    '+44-1222-4500', 'john@globallabs.com',  'London, UK',  'http://globallabs.com',    2),
('MediSource GmbH',         'Sven Mueller',   '+49-89-335500', 'sven@medisource.de',   'Munich, DE',  'http://medisource.de',     2),
('BioImport SA',            'Marie Fournier', '+33-1-892212',  'marie@bioimport.fr',   'Paris, FR',   'http://bioimport.fr',      2),
('EastAsia Bio',            'Wei Zhang',      '+86-10-5500',   'wei@eabio.cn',         'Beijing, CN', 'http://eabio.cn',          2),
('US Diagnostics',          'Linda Brooks',   '+1-800-900-9900','linda@usdiagnostics.com','New York, USA', 'http://usdiagnostics.com', 2),
('ScandiLab',               'Emma Olsson',    '+46-8-224400',  'emma@scandilab.se',    'Stockholm, SE','http://scandilab.se',      2),
('Arabia Scientific',       'Fadi Salem',     '00962-6-220011','fadi@arabiasci.com',   'Amman, JO',   'http://arabiasci.com',     2);



-- Each supplier supplies all products
INSERT INTO SupplierProduct (SupplierId, ProductId)
VALUES
(1,10001),(1,10002),(1,10003),(1,10004),(1,10005),(1,10006),(1,10007),(1,10008),(1,10009),(1,10010),(1,10011),(1,10012),(1,10013),(1,10014),(1,10015),
(2,10001),(2,10002),(2,10003),(2,10004),(2,10005),(2,10006),(2,10007),(2,10008),(2,10009),(2,10010),(2,10011),(2,10012),(2,10013),(2,10014),(2,10015),
(3,10001),(3,10002),(3,10003),(3,10004),(3,10005),(3,10006),(3,10007),(3,10008),(3,10009),(3,10010),(3,10011),(3,10012),(3,10013),(3,10014),(3,10015),
(4,10001),(4,10002),(4,10003),(4,10004),(4,10005),(4,10006),(4,10007),(4,10008),(4,10009),(4,10010),(4,10011),(4,10012),(4,10013),(4,10014),(4,10015),
(5,10001),(5,10002),(5,10003),(5,10004),(5,10005),(5,10006),(5,10007),(5,10008),(5,10009),(5,10010),(5,10011),(5,10012),(5,10013),(5,10014),(5,10015),
(6,10001),(6,10002),(6,10003),(6,10004),(6,10005),(6,10006),(6,10007),(6,10008),(6,10009),(6,10010),(6,10011),(6,10012),(6,10013),(6,10014),(6,10015),
(7,10001),(7,10002),(7,10003),(7,10004),(7,10005),(7,10006),(7,10007),(7,10008),(7,10009),(7,10010),(7,10011),(7,10012),(7,10013),(7,10014),(7,10015),
(8,10001),(8,10002),(8,10003),(8,10004),(8,10005),(8,10006),(8,10007),(8,10008),(8,10009),(8,10010),(8,10011),(8,10012),(8,10013),(8,10014),(8,10015),
(9,10001),(9,10002),(9,10003),(9,10004),(9,10005),(9,10006),(9,10007),(9,10008),(9,10009),(9,10010),(9,10011),(9,10012),(9,10013),(9,10014),(9,10015),
(10,10001),(10,10002),(10,10003),(10,10004),(10,10005),(10,10006),(10,10007),(10,10008),(10,10009),(10,10010),(10,10011),(10,10012),(10,10013),(10,10014),(10,10015),
(11,10001),(11,10002),(11,10003),(11,10004),(11,10005),(11,10006),(11,10007),(11,10008),(11,10009),(11,10010),(11,10011),(11,10012),(11,10013),(11,10014),(11,10015),
(12,10001),(12,10002),(12,10003),(12,10004),(12,10005),(12,10006),(12,10007),(12,10008),(12,10009),(12,10010),(12,10011),(12,10012),(12,10013),(12,10014),(12,10015);



INSERT INTO Customer (FirstName, LastName, ContactNumber, Email, ShippingAddress, CustomerTypeId, PaymentMethodId)
VALUES
('Yara', 'Hassan', '0591111111', 'yara.hassan@mail.com', 'Ramallah, Main St.', 1, 1),
('Khaled', 'Tawfiq', '0592222222', 'khaled.tawfiq@mail.com', 'Bethlehem, King David St.', 2, 2),
('Leen', 'Majali', '0593333333', 'leen.majali@mail.com', 'Hebron, Market Rd.', 1, 3);



-- Purchases
INSERT INTO Purchase (PurchaseId, SupplierId, CompanyId, TotalCost)
VALUES
(1, 1, 1, 500.00),
(2, 2, 2, 900.00),
(3, 6, 3, 1200.00);

-- Purchase details (a few products per purchase)
INSERT INTO PurchaseDetail (PurchaseId, ProductId, Quantity, CostPerUnit)
VALUES
(1, 10001, 10, 2.50),
(1, 10002, 1, 500.00),
(1, 10003, 20, 0.30),

(2, 10006, 10, 1.20),
(2, 10007, 1, 400.00),
(2, 10008, 10, 0.80),

(3, 10012, 1, 1000.00),
(3, 10014, 10, 5.00),
(3, 10015, 20, 0.70);




-- Sales
INSERT INTO Sale (SaleId, CustomerId, CompanyId, TotalRevenue)
VALUES
(1, 1, 1, 23.26 + 61.19*5 + 21.35*4),
(2, 2, 2, 61.19 + 63.57*2 + 41.72*2),
(3, 3, 3, 22.78*4 + 21.47*5 + 36.48*2);

-- Sale details
INSERT INTO SaleDetail (SaleId, ProductId, Quantity, SellingPrice)
VALUES
(1, 10004, 3, 23.26),
(1, 10007, 5, 61.19),
(1, 10005, 4, 21.35),

(2, 10007, 1, 61.19),
(2, 10002, 2, 63.57),
(2, 10006, 2, 41.72),

(3, 10013, 4, 22.78),
(3, 10015, 5, 21.47),
(3, 10014, 2, 36.48);





