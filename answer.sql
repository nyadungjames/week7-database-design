-- ============================================================
-- Week 7 Assignment: Database Design and Normalization
-- Student Name: JAMES NYADUNG THANKO
-- Course: Software Engineering
-- Date: 23/11/2026
-- Database: MySQL
-- ============================================================

-- ============================================================
-- QUESTION 1: Achieving First Normal Form (1NF)
-- ============================================================
-- Problem: The original ProductDetail table violates 1NF because
-- the Products column contains multiple values in a single cell,
-- e.g. 'Laptop, Mouse'.
-- Solution: Create a new table where each row represents
-- ONLY ONE product per order. Each cell holds one atomic value.

-- Step 1: Drop the table if it already exists, to allow re-running
DROP TABLE IF EXISTS ProductDetail_1NF;

-- Step 2: Create the normalized table in 1NF
-- Primary Key = (OrderID, Product) because one order can have
-- many products, and the combination makes each row unique.
CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

-- Step 3: Insert the normalized records
-- Order 101: 'Laptop, Mouse' is split into 2 rows
-- Order 102: 'Tablet, Keyboard, Mouse' is split into 3 rows
-- Order 103: 'Phone' is already 1 row

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 4: Verify the result (optional, for testing in Workbench)
-- SELECT * FROM ProductDetail_1NF;

-- ============================================================
-- QUESTION 2: Achieving Second Normal Form (2NF)
-- ============================================================
-- Problem: The original OrderDetails table is in 1NF, but violates 2NF.
-- Composite Primary Key = (OrderID, Product)
-- Partial Dependency: CustomerName depends ONLY on OrderID,
-- not on the full composite key (OrderID, Product).
-- Example: Knowing OrderID 101 is enough to know CustomerName is John Doe,
-- you do not need to know the Product.
--
-- Solution: Split into TWO tables to remove the partial dependency:
-- 1. Orders - stores order information (OrderID, CustomerName)
-- 2. OrderItems - stores products and quantities for each order

-- Step 1: Drop tables if they already exist (OrderItems first because of FK)
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;

-- Step 2: Create the Orders table
-- This removes the partial dependency.
-- CustomerName now depends on the FULL primary key (OrderID) of this table.
CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID)
);

-- Step 3: Create the OrderItems table
-- Composite Primary Key = (OrderID, Product)
-- Foreign Key = OrderID references Orders(OrderID)
-- Quantity depends on the FULL composite key (OrderID + Product),
-- so there is no partial dependency here.
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert records into Orders table
-- One row per unique order (no duplicates)
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Step 5: Insert records into OrderItems table
-- One row per product per order
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Step 6: Verify the result (optional, for testing in Workbench)
-- SELECT * FROM Orders;
-- SELECT * FROM OrderItems;
-- This JOIN proves the tables link correctly via the Foreign Key:
-- SELECT o.OrderID, o.CustomerName, i.Product, i.Quantity
-- FROM Orders o
-- JOIN OrderItems i ON o.OrderID = i.OrderID;