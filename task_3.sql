CREATE TABLE Warehouses (
   Code INTEGER NOT NULL,
   Location VARCHAR(255) NOT NULL ,
   Capacity INTEGER NOT NULL,
   PRIMARY KEY (Code)
 );
CREATE TABLE Boxes (
    Code CHAR(4) NOT NULL,
    Contents VARCHAR(255) NOT NULL ,
    Value REAL NOT NULL ,
    Warehouse INTEGER NOT NULL,
    PRIMARY KEY (Code)
 );
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(1,'Chicago',3);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(2,'Chicago',4);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(3,'New York',7);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(4,'Los Angeles',2);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(5,'San Francisco',8);
 
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('0MN7','Rocks',180,3);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4H8P','Rocks',250,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4RT3','Scissors',190,4);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('7G3H','Rocks',200,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8JN6','Papers',75,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8Y6U','Papers',50,3);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('9J6F','Papers',175,2);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('LL08','Rocks',140,4);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P0H6','Scissors',125,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P2T6','Scissors',150,2);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('TU55','Papers',90,5);

-- 3.1 Select all warehouses.
SELECT *
FROM Warehouses;

-- 3.2 Select all boxes with a value larger than $150.
select *
from boxes
where value > 150;

-- 3.3 Select all distinct contents in all the boxes.
select distinct(contents)
from boxes;

-- 3.4 Select the average value of all the boxes.
select avg(value) as average_value
from boxes;

-- 3.5 Select the warehouse code and the average value of 
-- the boxes in each warehouse.
select avg(value), warehouse
from boxes
group by warehouse;

-- 3.6 Same as previous exercise, but select only those 
-- warehouses where the average value of the boxes is greater than 150.
select avg(value), warehouse
from boxes
group by warehouse
having avg(value) > 150;

-- or
SELECT Warehouse, ROUND(AVG(Value), 2) AS 'Average value'
FROM Boxes
GROUP BY Warehouse;


-- 3.7 Select the code of each box, along with the name of the city
--  the box is located in.
select box.code, war.location
from boxes box
join warehouses war
on box.warehouse = war.code;

-- or
SELECT Boxes.Code AS 'Box Code', Warehouses.Location AS 'City'
FROM Boxes
JOIN Warehouses
ON Warehouse = Warehouses.Code
ORDER BY City;

-- 3.8 Select the warehouse codes, along with the number of boxes 
-- in each warehouse. 
select count(contents) as count_boxes, warehouse
from boxes
group by warehouse;

-- or
SELECT Warehouses.Code AS 'Warehouse Code', COUNT(Boxes.Warehouse) AS 'Box Count'
FROM Boxes
JOIN Warehouses
ON Warehouse = Warehouses.Code
GROUP BY Warehouses.Code;


-- 3.9 Select the codes of all warehouses that are saturated 
-- (a warehouse is saturated if the number of boxes in it is larger than 
-- the warehouse's capacity).
select con.con_co,war.code
from warehouses war
join(
select count(contents) as con_co , warehouse
from boxes box
group by warehouse) as con
on war.code = con.warehouse
where con_co > war.capacity;



-- 3.10 Select the codes of all the boxes located in Chicago.
select box.code
from boxes box
join warehouses war
on war.code =box.warehouse
where location like 'Chicago';


-- 3.11 Create a new warehouse in New York with a capacity for 3 boxes.
insert into warehouses values (6,'New York', 3);

-- 3.12 Create a new box, with code "H5RT", containing "Papers" with 
-- a value of $200, and located in warehouse 2.
insert into boxes values ('H5RT', 'Papers',200,2);

-- 3.13 Reduce the value of all boxes by 15%.
alter table boxes add
new_value float;

SET SQL_SAFE_UPDATES = 0;
update boxes
set new_value = value-value*.15 ;

-- 3.14 Remove all boxes with a value lower than $100.
delete from boxes
where value < 100;

-- 3.15 Remove all boxes from saturated warehouses.
delete from boxes 
where warehouse in (
select war.code 
from Warehouses war
join (
select count(contents) as con_cont, warehouse
from boxes
group by warehouse) as co
on co.warehouse = war.code
where con_cont < capacity);

-- 3.16 Add Index for column "Warehouse" in table "boxes"
-- !!!NOTE!!!: index should NOT be used on small tables in practice
CREATE INDEX INDEX_WAREHOUSE 
ON Boxes (Warehouse);

-- 3.17 Print all the existing indexes
-- !!!NOTE!!!: index should NOT be used on small tables in practice
SELECT * 
FROM SQLITE_MASTER 
WHERE type = "index";


-- 3.18 Remove (drop) the index you added just
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
drop index INDEX_WAREHOUSE 
