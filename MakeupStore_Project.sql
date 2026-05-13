CREATE DATABASE IF NOT EXISTS OnlineStoreDB;
show databases;
use OnlineStoreDB;

-- CUSTOMER TABLE --
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    CHECK (CHAR_LENGTH(Phone) >= 10)
);
INSERT INTO CUSTOMER (FirstName, LastName, Phone)
VALUES
('Ahmed', 'Alqahtani', '0501234567'),
('Sara', 'Alharbi', '0552345678'),
('Nora', 'Alshehri', '0533456789'),
('Fahad', 'Alotaibi', '0544567890'),
('Reem', 'Alzahrani', '0565678901');

-- Select customers with ID greater than 2
SELECT FirstName, LastName
FROM CUSTOMER
WHERE CustomerID > 2;

-- Count total number of customers
SELECT COUNT(*) AS TotalCustomers
FROM CUSTOMER;

-- Count number of orders for each customer
SELECT CustomerID, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY CustomerID;


-- Get customers who have placed orders
SELECT FirstName
FROM CUSTOMER
WHERE CustomerID IN (
    SELECT CustomerID FROM Orders
);

-- Join customers with their orders
SELECT CUSTOMER.FirstName, Orders.OrderID
FROM CUSTOMER
JOIN Orders
ON CUSTOMER.CustomerID = Orders.CustomerID;

-- Create a view to show customer orders
CREATE VIEW CustomerReport AS
SELECT CUSTOMER.FirstName, Orders.OrderID
FROM CUSTOMER
JOIN Orders
ON CUSTOMER.CustomerID = Orders.CustomerID;

-- Display the view
SELECT * FROM CustomerReport;

DESC CUSTOMER;
SELECT * FROM CUSTOMER;


-- PRODUCT TABLE --
CREATE TABLE PRODUCT (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    Price DECIMAL(8,2) NOT NULL,
    Stock INT NOT NULL,
    CHECK (Price > 0),
    CHECK (Stock >= 0)
);
INSERT INTO PRODUCT (ProductName, Price, Stock)
VALUES
('Lipstick', 45.00, 20),
('Foundation', 80.00, 15),
('Mascara', 35.50, 30),
('Eyeshadow Palette', 150.00, 10),
('Blush', 95.00, 12);

-- Select products with price greater than 50
SELECT ProductName, Price
FROM PRODUCT
WHERE Price > 50;

-- Calculate average product price
SELECT AVG(Price) AS AvgPrice
FROM PRODUCT;

-- Count number of products for each price
SELECT Price, COUNT(*) AS NumProducts
FROM PRODUCT
GROUP BY Price;


-- Get products above average price
SELECT ProductName
FROM PRODUCT
WHERE Price > (
    SELECT AVG(Price) FROM PRODUCT
);

-- Join products with order quantities
SELECT PRODUCT.ProductName, ORDER_DETAILS.Quantity
FROM PRODUCT
JOIN ORDER_DETAILS
ON PRODUCT.ProductID = ORDER_DETAILS.ProductID;

-- Create a view for product report
CREATE VIEW ProductReport AS
SELECT ProductName, Price
FROM PRODUCT;

-- Display the view
SELECT * FROM ProductReport;

DESC PRODUCT;
SELECT * FROM PRODUCT;


-- ORDERS TABLE --
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);
INSERT INTO Orders (OrderDate, CustomerID)
VALUES
('2026-04-01', 1),
('2026-04-02', 2),
('2026-04-03', 3),
('2026-04-04', 1),
('2026-04-05', 4);

-- Select orders after a specific date
SELECT *
FROM Orders
WHERE OrderDate > '2026-04-02';


-- Get the earliest order date
SELECT MIN(OrderDate) AS FirstOrder
FROM Orders;

-- Count orders per date
SELECT OrderDate, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY OrderDate;

-- Get orders for existing customers
SELECT *
FROM Orders
WHERE CustomerID IN (
    SELECT CustomerID FROM CUSTOMER
);

-- Join orders with customer names
SELECT Orders.OrderID, Orders.OrderDate, CUSTOMER.FirstName
FROM Orders
JOIN CUSTOMER
ON Orders.CustomerID = CUSTOMER.CustomerID;


-- Create a view for orders
CREATE VIEW OrdersView AS
SELECT OrderID, OrderDate
FROM Orders;

-- Display the view
SELECT * FROM OrdersView;

DESC Orders;
SELECT * FROM Orders;

CREATE TABLE ORDER_DETAILS (
OrderID INT NOT NULL,
ProductID INT NOT NULL,
Quantity INT NOT NULL,
primary key (OrderID,ProductID),
foreign key (OrderID) references Orders(OrderID),
foreign key (ProductID) references Product(ProductID),
check (Quantity > 0) 
);

INSERT INTO ORDER_DETAILS (OrderID, ProductID, Quantity)
VALUES 
(1,2,4),
(2,1,7),
(3,3,2),
(4,5,1),
(5,4,1);

-- Select order details with quantity greater than 1
SELECT OrderID, Quantity
FROM ORDER_DETAILS
WHERE Quantity > 1;


-- Get minimum and maximum quantity
SELECT 
MIN(Quantity) AS MinQuantity,
MAX(Quantity) AS MaxQuantity
FROM ORDER_DETAILS;

-- Calculate average quantity per product
SELECT AVG(Quantity) AS AvgQuantity
FROM ORDER_DETAILS
GROUP BY ProductID;


-- Get the order with the highest quantity
SELECT *
FROM ORDER_DETAILS
WHERE Quantity = (
    SELECT MAX(Quantity) FROM ORDER_DETAILS
);

-- Join order details with product names
SELECT OD.OrderID, P.ProductName, OD.Quantity
FROM ORDER_DETAILS OD
JOIN PRODUCT P 
ON OD.ProductID = P.ProductID;

-- Create a view for order details report
CREATE VIEW OrderReport AS
SELECT OD.OrderID, P.ProductName, OD.Quantity
FROM ORDER_DETAILS OD
JOIN PRODUCT P 
ON OD.ProductID = P.ProductID;

-- Display the view
SELECT * FROM OrderReport;

DESC ORDER_DETAILS;
SELECT * FROM ORDER_DETAILS;




