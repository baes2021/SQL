
CREATE TABLE IF NOT EXISTS Departments (
  Code INTEGER,
  Name TEXT NOT NULL,
  Budget decimal NOT NULL,
  PRIMARY KEY (Code)   
);

CREATE TABLE IF NOT EXISTS Employees (
  SSN INTEGER,
  Name varchar(255) NOT NULL ,
  LastName varchar(255) NOT NULL ,
  Department INTEGER NOT NULL , 
  PRIMARY KEY (SSN)   
);
INSERT INTO Departments(Code,Name,Budget) VALUES(14,'IT',65000);
INSERT INTO Departments(Code,Name,Budget) VALUES(37,'Accounting',15000);
INSERT INTO Departments(Code,Name,Budget) VALUES(59,'Human Resources',240000);
INSERT INTO Departments(Code,Name,Budget) VALUES(77,'Research',55000);

INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('123234877','Michael','Rogers',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('152934485','Anand','Manikutty',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('222364883','Carol','Smith',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('326587417','Joe','Stevens',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332154719','Mary-Anne','Foster',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332569843','George','ODonnell',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('546523478','John','Doe',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('631231482','David','Smith',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('654873219','Zacary','Efron',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('745685214','Eric','Goldsmith',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657245','Elizabeth','Doe',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657246','Kumar','Swamy',14);

-- 2.1 Select the last name of all employees.
select lastname
from employees; 

-- 2.2 Select the last name of all employees, without duplicates.
select distinct(lastname)
from employees;

-- 2.3 Select all the data of employees whose last name is "Smith".
select lastname
from employees
where lastname like 'smith';

-- or
select lastname
from employees
where lastname regexp '^smith$';

-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
select lastname
from employees 
where lastname like 'smith' or lastname like 'doe';

-- or
select lastname
from employees 
where lastname regexp '^smith$|^doe$';

-- 2.5 Select all the data of employees that work in department 14.
select ssn, emp.name, lastname, department, dep.name as 'department name', budget
from employees emp
join departments dep
on emp.department=dep.code
where dep.code like 14;

-- 2.6 Select all the data of employees that work in department 37 or department 77.
select ssn, emp.name, lastname, department, dep.name as 'department name', budget
from employees emp
join departments dep
on emp.department=dep.code
where dep.code like 37 or dep.code like 77;


-- 2.7 Select all the data of employees whose last name begins with an "S".
select ssn, emp.name, lastname, department, dep.name as 'department name', budget
from employees emp
join departments dep
on emp.department=dep.code
where emp.lastname like 's%';




-- 2.8 Select the sum of all the departments' budgets.
SELECT 'Total Budget' AS Name, SUM(Budget) as sum_bud
FROM Departments 
UNION
SELECT Name,SUM(Budget) as sum_bud
from Departments
group by code
order by sum_bud


-- 2.9 Select the number of employees in each department (you only 
-- need to show the department code and the number of employees).
select count(distinct(lastname)) as employee_number, dep.code as department_code
from employees emp
join departments dep
on emp.department=dep.code
group by Dep.code;
  -- or
  SELECT Department, COUNT(Name) AS '# of employees'
FROM Employees
GROUP BY Department;

-- 2.10 Select all the data of employees, including each employee's department's
--  data.
select ssn, emp.name, lastname, department, dep.name as 'department name', budget
from employees emp
join departments dep
on emp.department=dep.code;
-- or
SELECT Employees.Name, LastName AS Surname, Departments.Name AS 'Department', Budget
FROM Departments, Employees;

-- or unique info of employees
select  distinct(lastname), ssn, emp.name, department, dep.name as 'department name', budget
from employees emp
join departments dep
on emp.department=dep.code;

-- 2.11 Select the name and last name of each employee, along with the
-- name and budget of the employee's department.
select  emp.name, lastname, department, dep.name as 'department name', budget
from employees emp
join departments Dep
on emp.department=dep.code;

-- 2.12 Select the name and last name of employees working for
-- departments with a budget greater than $60,000.
select emp.name, lastname
from employees emp
join departments dep
on emp.department=dep.code
where budget > 60000;

-- with subquery
select name, lastname
from employees
where department in (select code 
from departments
where budget > 60000);

-- or

SELECT Employees.Name, LastName AS Surname
FROM Departments, Employees
WHERE Budget > 60000;

-- with cte
WITH filtered_deps AS (
SELECT *
FROM Departments
WHERE Budget > 60000
)

SELECT E.Name, E.LastName
FROM Employees E
JOIN filtered_deps F
ON E.Department=F.Code;



-- 2.13 Select the departments with a budget larger than the 
-- average budget of all the departments.
select code,name
from departments
where budget >
 (select avg(budget) 
from departments);

-- or
SELECT Departments.Name, Budget
FROM Departments
WHERE Budget > (SELECT AVG(Budget) FROM Departments);


-- 2.14 Select the names of departments with more than two employees.
select dep.name, dep.code
from departments dep
where dep.code in (select  department 
from employees
group by department
having count(distinct(name)) > 2);

-- or
SELECT Departments.Name
FROM Employees 
JOIN Departments
ON Department = Code
GROUP BY Departments.Name
HAVING COUNT() > 2;


-- 2.15 Select the name and last name of employees working for the 
-- two departments with lowest budget.
select emp.name, emp.lastname
from employees as emp
join (select code
from departments
order by budget
limit 2) as bud
on emp.department = bud.code;
;


select emp.'name', emp.lastname
from employees as emp
where department in (select code
from departments
order by budget
limit 2) 

-- or
WITH low_budget AS 
(SELECT * 
FROM Departments 
ORDER BY Budget 
LIMIT 2)

SELECT Employees.Name, Employees.LastName
FROM Employees
JOIN low_budget
ON Employees.Department = Code

-- 2.16  Add a new department called "Quality Assurance",
-- with a budget of $40,000 and departmental code 11.
insert into departments values (11, 'Quality Assurance', 40000);

-- And Add an employee called "Mary Moore" in that department, 
-- with SSN 847-21-9811.
insert into Employees values (847-21-9811, 'Mary','Moore',11);

-- 2.17 Reduce the budget of all departments by 10%.
alter table departments add 
new_budget float; 
update Departments
set new_budget = budget *0.10 ;

-- 2.18 Reassign all employees from the Research department
--  (code 77) to the IT department (code 14).
update employees
set Department= 14
where Department = 77;

-- 2.19 Delete from the table all employees in the IT department (code 14).
delete from employees 
where department = 14;

-- 2.20 Delete from the table all employees who work in departments 
-- with a budget greater than or equal to $60,000.
delete from employees 
where department in 
(select code
from departments
where budget >= 60000);


-- 2.21 Delete from the table all employees.
alter table employees 
drop name;
alter table employees 
drop lastname;
