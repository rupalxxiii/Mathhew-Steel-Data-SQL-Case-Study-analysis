create database  challenge5;
use challenge5;

CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);
--------------------
-- Create the 'beverages' table
CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);
--------------------
-- Create the 'sales' table
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
--------------------
-- Create the 'ratings' table 
CREATE TABLE ratings 
( rating_id INT PRIMARY KEY, pub_id INT, 
customer_name VARCHAR(50), rating FLOAT, review TEXT, FOREIGN KEY (pub_id) REFERENCES pubs(pub_id) );
--------------------
-- Insert sample data into the 'pubs' table
INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');
--------------------
-- Insert sample data into the 'beverages' table
INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content, price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);
--------------------
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');
--------------------
-- Insert sample data into the 'ratings' table
INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');
--------------------

-- 1. HOW MANY PUBS ARE LOCATED IN EACH COUNTRY?

select pub_name , country , count(pub_id) as total
from pubs
group by pub_name, country
order by count(pub_id) DESC; 

-- 2. WHAT IS THE TOTAL SALES AMOUNT FOR EACH PUB, INCLUDING THE BEVERAGE PRICE AND QUANTITY SOLD?

select P.pub_name, sum(B.price_per_unit*S.quantity)
as total_sales_amount
from beverages as B
join sales as S using(beverage_id)
join pubs as P using(pub_id)
group by P.pub_name
order by total_sales_amount desc;

-- 3. WHICH PUB HAS THE HIGHEST AVERAGE RATING?

select P.pub_name , ceil(avg(R.rating))
from pubs as P
join ratings as R using(pub_id)
group by P.pub_name
order by avg(R.rating) desc
limit 1;

-- 4. WHAT ARE THE TOP 5 BEVERAGES BY SALES QUANTITY ACROSS ALL PUBS?

select B.beverage_id, B.beverage_name,
sum(S.quantity) as Total
from beverages as B
join sales as S using(beverage_id)
group by B.beverage_id, B.beverage_id
order by sum(S.quantity) desc
limit 1;


-- 5. HOW MANY SALES TRANSACTIONS OCCURRED ON EACH DATE?

select count(sale_id) as total, transaction_date
from sales 
group by transaction_date
order by count(sale_id) desc;

-- 6. FIND THE NAME OF SOMEONE THAT HAD COCKTAILS AND WHICH PUB THEY HAD IT IN.

select R.customer_name , P.pub_name , B.category
from pubs as P
join ratings as R using(pub_id)
join beverages as B
where B.category ="cocktail";

-- 7. WHAT IS THE AVERAGE PRICE PER UNIT FOR EACH CATEGORY OF BEVERAGES, EXCLUDING THE CATEGORY 'SPIRIT'?

select category , avg(price_per_unit) as average
from beverages as B
where category <> "Spirit"
group by category
order by avg(price_per_unit);


-- 8. WHICH PUBS HAVE A RATING HIGHER THAN THE AVERAGE RATING OF ALL PUBS?

select P.pub_name , round(avg(R.rating),1) as rating
from ratings as R
join pubs as P using(pub_id)
where R.rating > (select round(avg(R.rating),1) as avg_rating from ratings )
group by P.pub_name
order by rating desc;
 
 
