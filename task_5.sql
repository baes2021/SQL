CREATE TABLE Pieces (
 Code INTEGER NOT NULL,
 Name TEXT NOT NULL,
 PRIMARY KEY (Code)
 );
CREATE TABLE Providers (
 Code VARCHAR(40) NOT NULL,  
 Name TEXT NOT NULL,
PRIMARY KEY (Code) 
 );
CREATE TABLE Provides (
 Piece INTEGER, 
 Provider VARCHAR(40), 
 Price INTEGER NOT NULL,
 PRIMARY KEY(Piece, Provider) 
 );

INSERT INTO Providers(Code, Name) VALUES('HAL','Clarke Enterprises');
INSERT INTO Providers(Code, Name) VALUES('RBT','Susan Calvin Corp.');
INSERT INTO Providers(Code, Name) VALUES('TNBC','Skellington Supplies');

INSERT INTO Pieces(Code, Name) VALUES(1,'Sprocket');
INSERT INTO Pieces(Code, Name) VALUES(2,'Screw');
INSERT INTO Pieces(Code, Name) VALUES(3,'Nut');
INSERT INTO Pieces(Code, Name) VALUES(4,'Bolt');

INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'HAL',10);
INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'RBT',15);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'HAL',20);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'RBT',15);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'TNBC',14);
INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'RBT',50);
INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'TNBC',45);
INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'HAL',5);
INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'RBT',7);


-- 5.1 Select the name of all the pieces. 
select name
from pieces;

-- 5.2  Select all the providers' data. 
select *
from providers;

-- -- 5.3 Obtain the average price of each piece (show only 
-- the piece code and the average price).
select avg(price), piece
from provides
group by  piece;

-- 5.4  Obtain the names of all providers who supply piece 1.
select provider
from provides
where piece like 1;

-- 5.5 Select the name of pieces provided by provider with code "HAL".
select pc.name
from pieces pc
join provides pv
on pc.code= pv.piece
where provider like 'HAL'

-- or 
WITH HAL_Stock AS
(SELECT Piece
FROM Provides
WHERE Provider = 'HAL')

SELECT Pieces.Name
FROM Pieces
JOIN HAL_Stock
ON Pieces.Code = HAL_Stock.Piece;


-- 5.6 For each piece, find the most expensive offering of 
-- that piece and include the piece name, provider name, 
-- and price (note that there could be two providers who supply the same 
-- piece at the most expensive price).
select pc.name as piece_name, pv.Provider,
max(price) over (partition by piece) AS max_price
from Provides pv
join Pieces pc
on pv.piece = pc.code



-- 5.7 Add an entry to the database to indicate that "Skellington 
-- Supplies" (code "TNBC") will provide sprockets 
-- (code "1") for 7 cents each.
insert into provides values (1, 'TNBC', 7);

-- 5.8 Increase all prices by one cent.
alter table provides add
new_price float;

update provides
set new_price=price +1;

-- 5.9 Update the database to reflect that "Susan 
-- Calvin Corp." (code "RBT") will not supply bolts (code 4).
delete from Provides
where provider = 'RBT' and piece =4;

-- 5.10 Update the database to reflect that 
-- "Susan Calvin Corp." (code "RBT") will not supply any 
-- pieces (the provider should still remain in the database).
delete from Provides
where provider = 'RBT';