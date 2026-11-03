-- DATABASE TECHNOLOGIES LAB SHEET 5
-- Topic: INNER JOIN, EQUI JOIN, THETA JOIN, NATURAL JOIN

-- Create and select database
CREATE DATABASE CollegeJoinDB;
USE CollegeJoinDB;


-- Create Departments table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

-- Create Employees table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50)
);

-- Create SalaryGrades table
CREATE TABLE SalaryGrades (
    Grade CHAR(2) PRIMARY KEY,
    MinSalary DECIMAL(10,2),
    MaxSalary DECIMAL(10,2)
);


-- Insert department records
INSERT INTO Departments VALUES
(10, 'Computer Science', 'Block A'),
(20, 'Pharmacy', 'Block B'),
(30, 'Management', 'Block C'),
(40, 'Civil Engineering', 'Block D');

-- Insert employee records
INSERT INTO Employees VALUES
(101, 'Aarav', 10, 65000, 'Delhi'),
(102, 'Priya', 20, 72000, 'Mumbai'),
(103, 'Rahul', 10, 48000, 'Delhi'),
(104, 'Sneha', 30, 91000, 'Pune'),
(105, 'Vikram', 20, 55000, 'Jaipur'),
(106, 'Neha', 50, 80000, 'Bengaluru'),
(107, 'Kabir', 30, 43000, 'Pune');

-- Insert salary grades
INSERT INTO SalaryGrades VALUES
('G1', 0, 49999),
('G2', 50000, 69999),
('G3', 70000, 89999),
('G4', 90000, 120000);


-- Verify database tables
SHOW TABLES;
SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM SalaryGrades;


-- Q1. Display employee and department details
SELECT Employees.EmpName, Departments.DeptName, Departments.Location
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;


-- Q2. Display employee and department IDs
SELECT Employees.EmpID, Employees.EmpName,
       Employees.DeptID, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;


-- Q3. Display Pharmacy employees
SELECT Employees.EmpName, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
WHERE Departments.DeptName = 'Pharmacy';


-- Q4. Display employees earning more than 60000
SELECT Employees.EmpName, Employees.Salary, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
WHERE Employees.Salary > 60000;


-- Q5. Perform Equi Join using DeptID
SELECT *
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;


-- Q6. Display employee city and department location
SELECT Employees.EmpName, Employees.City,
       Departments.DeptName, Departments.Location
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;


-- Q7. Display Computer Science employees
SELECT Employees.EmpName, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
WHERE Departments.DeptName = 'Computer Science';


-- Q8. Theta Join using greater than
SELECT Employees.EmpName, Employees.Salary,
       SalaryGrades.Grade, SalaryGrades.MinSalary
FROM Employees
JOIN SalaryGrades
ON Employees.Salary > SalaryGrades.MinSalary;


-- Q9. Assign employees to correct salary grades
SELECT Employees.EmpName, Employees.Salary, SalaryGrades.Grade
FROM Employees
JOIN SalaryGrades
ON Employees.Salary >= SalaryGrades.MinSalary
AND Employees.Salary <= SalaryGrades.MaxSalary;


-- Q10. Display employees earning less than grade maximum
SELECT Employees.EmpName, Employees.Salary,
       SalaryGrades.Grade, SalaryGrades.MaxSalary
FROM Employees
JOIN SalaryGrades
ON Employees.Salary < SalaryGrades.MaxSalary;


-- Q11. Display employees with salary greater than or equal to grade minimum
SELECT Employees.EmpName, Employees.Salary, SalaryGrades.Grade
FROM Employees
JOIN SalaryGrades
ON Employees.Salary >= SalaryGrades.MinSalary;


-- Q12. Perform Natural Join
SELECT Employees.EmpName, DeptID, Departments.DeptName
FROM Employees
NATURAL JOIN Departments;


-- Q13. Display employees in Block B department
SELECT Employees.EmpName, Departments.DeptName, Departments.Location
FROM Employees
NATURAL JOIN Departments
WHERE Departments.Location = 'Block B';


-- Q14. Display employees earning at least 70000
SELECT Employees.EmpName, Departments.DeptName, Employees.Salary
FROM Employees
NATURAL JOIN Departments
WHERE Employees.Salary >= 70000;


-- Q15. Sort employees by highest salary
SELECT Employees.EmpName, Departments.DeptName, Employees.Salary
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
ORDER BY Employees.Salary DESC;


-- Q16. Display distinct department names
SELECT DISTINCT Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;


-- Q17. Count employees in each department
SELECT Departments.DeptName, COUNT(Employees.EmpID) AS TotalEmployees
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
GROUP BY Departments.DeptName;


-- Q18. Calculate average salary department-wise
SELECT Departments.DeptName, AVG(Employees.Salary) AS AverageSalary
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
GROUP BY Departments.DeptName;


-- Q19. Display departments with average salary above 60000
SELECT Departments.DeptName, AVG(Employees.Salary) AS AverageSalary
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
GROUP BY Departments.DeptName
HAVING AVG(Employees.Salary) > 60000;


-- Q20. Find highest-paid employee
SELECT Employees.EmpName, Departments.DeptName, Employees.Salary
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
ORDER BY Employees.Salary DESC
LIMIT 1;


-- Q21. Display Computer Science and Pharmacy employees
SELECT Employees.EmpName, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
WHERE Departments.DeptName IN ('Computer Science', 'Pharmacy');


-- Q22. Display employees from Delhi or Pune earning at least 50000
SELECT Employees.EmpName, Employees.City,
       Employees.Salary, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
WHERE Employees.City IN ('Delhi', 'Pune')
AND Employees.Salary >= 50000;


-- Q23. Display all employees having matching departments
SELECT Employees.EmpID, Employees.EmpName,
       Employees.DeptID, Departments.DeptName
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;

-- Note: Neha is excluded because DeptID 50 does not exist
-- in the Departments table.


-- Q24. Count employees in each department using Natural Join
SELECT DeptName, COUNT(EmpID) AS TotalEmployees
FROM Employees
NATURAL JOIN Departments
GROUP BY DeptName;


-- Q25. Display departments with total salary above 100000
SELECT Departments.DeptName,
       SUM(Employees.Salary) AS TotalSalary
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID
GROUP BY Departments.DeptName
HAVING SUM(Employees.Salary) > 100000;