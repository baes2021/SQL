-- 1.1 Select the names of all the products in the store.
SELECT name FROM Day1.Products;

-- 1.2 Select the names and the prices of all the products in the store.
SELECT name, price From Day1.Products;

-- 1.3 Select the name of the products with a price less than or equal to $200.
SELECT name From Day1.Products
where price <= 200;

-- 1.4 Select all the products with a price between $60 and $120.
SELECT * From Day1.Products
where price <= 120 and price >=60;

SELECT * From Day1.Products
where price between 60 and 120 ;

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
SELECT name, price*100 From Day1.Products;


-- 1.6  Compute the average price of all the products.
SELECT avg(price) From Day1.Products;

select sum(price)/count(price) from day1.products;

-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
SELECT avg(price) From Day1.Products
where manufacturer=2;

-- 1.8 Compute the number of products with a price larger than or equal to $180.
select count(*) From DAY1.products
where price >= 180;

-- 1.9 Select the name and price of all products with a price larger than or equal to $180,
-- and sort first by price (in descending order), and then by name (in ascending order).
select name, price From DAY1.products
where price >= 180
order by price desc, name asc;

-- 1.10 Select all the data from the products, including all the data for each 
-- product's manufacturer.
select * from DAY1.products
join Manufacturers
on Products.manufacturer= Manufacturers.code;

-- 1.11 Select the product name, price, and manufacturer name of all the products.
select products.name, price, Manufacturer from DAY1.products
join Manufacturers
on Products.manufacturer = Manufacturers.code;

-- 1.12  Select the average price of each manufacturer's products,
--  showing only the manufacturer's code.
Select avg(Price) ,Manufacturer
From Products
GROUP By Manufacturer;

--  1.13 Select the average price of each manufacturer's products, showing
--  the manufacturer's name.
select avg(products.price) , manufacturers.name
from Products
join manufacturers
on products.manufacturer=manufacturers.code
group by manufacturers.name;

-- 1.14 Select the names of manufacturer whose products 
-- have an average price larger than or equal to $150.
Select avg(products.Price) , Manufacturers.Name  
From Products  
JOIN Manufacturers  
on products.manufacturer = manufacturers.Code
group By manufacturers.Name
HAVING avg(products.Price) >=150;

select avg(price), Manufacturers.name
from Manufacturers, products
where products.manufacturer = Manufacturers.code
group by Manufacturers.name
having avg(price) >= 150;

-- 1.15 Select the name and price of the cheapest product.
select price, name from products
where price=(select min(price) from products);


select price, name
from products
order by price asc
Limit 1;

-- 1.16 Select the name of each manufacturer along with the name
-- and price of its most expensive product.


SELECT Manufacturers.Name , products.Name, max(price)
FROM Products 
JOIN Manufacturers 
ON manufacturers.Code = products.Manufacturer
group by products.Manufacturer;






-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
insert into products(code, name, price,manufacturer) values(30,'Loudspeaker',70,2);


-- 1.18 Update the name of product 8 to "Laser Printer".
update products
set name='Lase printer'
where code=8;



-- 1.19 Apply a 10% discount to all products.
ALTER Table Products add 
 discount INTEGER;
 Update Products 
 set discount = Price *0.9
 where code >0;

-- 1.20 Apply a 10% discount to all products with a price larger
-- than or equal to $120.
ALTER Table Products add 
 discount1 INTEGER;
 Update Products 
 set discount1 = Price *0.9
 where code >0 and price >=120;



