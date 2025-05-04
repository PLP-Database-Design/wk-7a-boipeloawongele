-- Create the raw ProductDetail table (violates 1NF)
CREATE TABLE hr;
Use hr;
Create Table
ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);
SELECT * FROM hr.productdetail;

-- Insert original data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');
-- Step 1NF: Decompose the Products column
SELECT OrderID, CustomerName, TRIM(value) AS Product
FROM ProductDetail,
     STRING_SPLIT(Products, ',');
     
     
-- Create the 1NF-compliant table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);
SELECT * FROM hr.productdetail;

-- Insert normalized data using STRING_SPLIT (SQL Server syntax)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(value) AS Product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

-- Create OrderDetails table (already in 1NF, but not in 2NF)
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);
SELECT * FROM hr.orderdetails;
-- Insert 1NF sample data
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);
SELECT DISTINCT OrderID, CustomerName
INTO Orders
FROM OrderDetails;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
SELECT * FROM hr.orders;

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
SELECT * FROM hr.orderitems;

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
