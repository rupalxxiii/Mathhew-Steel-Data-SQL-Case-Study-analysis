create database challenge4;
use challenge4;


-- Create the Customers table
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
--------------------
-- Create the Branches table
CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Branches table
INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');
--------------------
-- Create the Accounts table
CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
--------------------
-- Populate the Accounts table
INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);
--------------------
-- Create the Transactions table
CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--------------------
-- Populate the Transactions table
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);


-- challenge4
-- Finance-Analysis-SQL-Case-Study  


-- 1 . What Are The Names Of All The Customers Who Live In NewYork?

select concat(FirstName," ", LastName) as customer_name
from customers
where City = "New York";

-- 2 . What Is The Total Number Of accounts In The  Accounts Table ?

select count(AccountId) as Total
from Accounts;

-- 3.What is the total balance of all checking Accounts?

select sum(Balance) as Total_Balance
from Accounts
where AccountType = "Checking";


 -- 4 . What is The Total balance of all  acounts associated with customers who live in losangeles? 

select sum(A.Balance) as total_balance from Accounts as A
join Customers as C using(CustomerID) 
where C.City = "Los Angeles"; 


-- 5 . Which branh has the highest average account balance? 

select B.BranchName, avg(A.Balance) as highest_average
from Branches as B
join accounts as A using(BranchId)
group by BranchId
order by avg(A.Balance) desc limit 1; 


-- 6. which customers has the highest cuurrent balance in their account?

select C.FirstName, C.LastName, sum(A.Balance) as highest_current_balance
from Accounts as A 
join Customers as C using(CustomerId)
group by CustomerId
order by sum(A.Balance) desc limit 1;

-- 7. which customer has made most transaction in the transaction table?

select C.FirstNAme, C.LastName , count(T.TransactionID)as most_transactions 
from Transactions as T join 
Accounts as A using(AccountId) join 
customers as C using(CustomerID)
group by C.FirstName, C.LastName
order by count(T.TransactionID) desc limit 2;

-- 8  . Which branches has the highest total balance across all of its accounts? 

select B.BranchName , sum(A.Balance) as total_balance
from Branches as B
join Accounts as A using(BranchId)
group by B.BranchName
order by sum(A.Balance) desc limit 1;


-- 9. Which Customer has the higest total balance across all of theeir accouts , including savings and checking accounts? 

select C.FirstName, C.LastName , sum(A.Balance) as total_balance
from Accounts as A
join Customers as C using(CustomerID)
where A.AccountType in("Savings","Checking")
group by CustomerID
order by sum(A.Balance) desc; 


-- 10 which branches has the highest number of transaction in their transaction table?

select B.BranchName, count(T.TransactionID) as highest_transactions
from  Transactions as T join Accounts as A using(accountID) join
Branches as B using(BranchID)
group by BranchName
order by count(T.TransactionID) desc limit 2



                                                -- T H E  E N D --
----------------------------------------------------------------------------------------------------------------------------------------------