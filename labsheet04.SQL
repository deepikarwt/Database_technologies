-- Create database
CREATE DATABASE IF NOT EXISTS sql_lab;
USE sql_lab;


-- =========================================
-- Q1. Identify primary key of Department
-- Answer: DeptID uniquely identifies each department.


-- Q2. Create Department table and insert records
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

INSERT INTO Department VALUES
(10, 'Computer Science'),
(20, 'Information Technology'),
(30, 'Pharmacy'),
(40, 'Management');


-- Q3. Create Student table and insert records
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Age INT,
    DeptID INT,
    JoiningDate DATE
);

INSERT INTO Student VALUES
(101, 'Amit Sharma', 'amit@example.com', 20, 10, '2026-07-01'),
(102, 'Priya Singh', 'priya@example.com', 21, 20, '2026-07-03'),
(103, 'Rahul Verma', 'rahul@example.com', 22, 30, '2026-07-05'),
(104, 'Neha Gupta', 'neha@example.com', 20, 10, '2026-07-08'),
(105, 'Arjun Mehta', 'arjun@example.com', 23, 40, '2026-07-10');


-- Q4. Try duplicate StudentID
-- Expected error: Duplicate primary key
-- INSERT INTO Student VALUES
-- (101, 'Karan Shah', 'karan@example.com', 21, 20, '2026-08-01');


-- Q5. Create Enrollment table and insert records
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseName VARCHAR(100)
);

INSERT INTO Enrollment VALUES
(1, 101, 'DBMS'),
(2, 102, 'Operating Systems'),
(3, 103, 'Pharmacology'),
(4, 104, 'Python');


-- Q6. Try duplicate EnrollmentID
-- Expected error: Duplicate primary key
-- INSERT INTO Enrollment VALUES (1, 105, 'Data Mining');


-- Q7. Add foreign key to Student
ALTER TABLE Student
ADD CONSTRAINT fk_student_department
FOREIGN KEY (DeptID) REFERENCES Department(DeptID);


-- Q8. Add foreign key to Enrollment
ALTER TABLE Enrollment
ADD CONSTRAINT fk_enrollment_student
FOREIGN KEY (StudentID) REFERENCES Student(StudentID);


-- Q9. Try invalid department ID
-- Expected error: Foreign key constraint fails
-- INSERT INTO Student VALUES
-- (106, 'Riya Das', 'riya@example.com', 21, 99, '2026-08-01');


-- Q10. Try invalid student ID in Enrollment
-- Expected error: Foreign key constraint fails
-- INSERT INTO Enrollment VALUES (5, 999, 'DBMS');


-- Q11. Display students with department names
SELECT s.StudentID, s.Name, d.DeptName
FROM Student s
INNER JOIN Department d ON s.DeptID = d.DeptID;


-- Q12. Display enrollment with student names
SELECT e.EnrollmentID, s.Name, e.CourseName
FROM Enrollment e
INNER JOIN Student s ON e.StudentID = s.StudentID;


-- Q13. Create Department2 with NOT NULL
CREATE TABLE Department2 (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- Expected error: DeptName cannot be NULL
-- INSERT INTO Department2 VALUES (50, NULL);


-- Q14. Try inserting student without Name
-- Expected error: Name cannot be NULL
-- INSERT INTO Student (StudentID, Email, Age, DeptID)
-- VALUES (106, 'riya@example.com', 21, 20);


-- Q15. Make Student Email unique
ALTER TABLE Student
ADD CONSTRAINT uq_student_email UNIQUE (Email);

-- Expected error: Duplicate email
-- INSERT INTO Student VALUES
-- (106, 'Riya Das', 'amit@example.com', 21, 20, '2026-08-01');


-- Q16. Create Library table and insert books
CREATE TABLE Library (
    BookID INT UNIQUE,
    Title VARCHAR(150) NOT NULL
);

INSERT INTO Library VALUES
(1, 'Database Systems'),
(2, 'Operating Systems'),
(3, 'Computer Networks'),
(4, 'Python Programming'),
(5, 'Data Mining');


-- Q17. Add CHECK constraint for Age
ALTER TABLE Student
ADD CONSTRAINT chk_student_age CHECK (Age > 18);

-- Expected error: Age must be greater than 18
-- INSERT INTO Student VALUES
-- (106, 'Riya Das', 'riya2@example.com', 17, 20, '2026-08-01');


-- Q18. Create Course with Credits between 1 and 6
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INT CHECK (Credits BETWEEN 1 AND 6)
);

-- Expected error: Credits cannot be 8
-- INSERT INTO Course VALUES (1, 'DBMS', 8);


-- Q19. Add JoiningDate2 with current date as default
ALTER TABLE Student
ADD COLUMN JoiningDate2 DATE DEFAULT (CURRENT_DATE);

INSERT INTO Student (StudentID, Name, Email, Age, DeptID)
VALUES (106, 'Riya Das', 'riya@example.com', 21, 20);

SELECT * FROM Student;


-- Q20. Create Faculty with default Designation
CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL,
    Designation VARCHAR(50) DEFAULT 'Lecturer'
);

INSERT INTO Faculty (FacultyID, FacultyName)
VALUES (1, 'Dr. Meera Sharma');

SELECT * FROM Faculty;


-- =========================================
-- EMPLOYEE TABLE
-- =========================================

-- Q21. Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(80),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);


-- Q22. Insert one employee
INSERT INTO employees VALUES
(101, 'John Smith', 'IT', 55000, '2024-01-15');


-- Q23. Insert multiple employees
INSERT INTO employees VALUES
(102, 'Sarah Johnson', 'HR', 48000, '2024-02-10'),
(103, 'Mike Davis', 'Finance', 52000, '2024-01-20'),
(104, 'Lisa Wilson', 'Marketing', 45000, '2024-03-01');


-- Q24. Insert employee with selected columns
INSERT INTO employees (emp_id, name, department)
VALUES (107, 'David Clark', 'Sales');


-- Q25. Display all employees
SELECT * FROM employees;


-- Q26. Display all employees
SELECT * FROM employees;


-- Q27. Display employee names and salaries
SELECT name, salary FROM employees;


-- Q28. Display IT employees
SELECT * FROM employees WHERE department = 'IT';


-- Q29. Find employees earning above 50000
SELECT * FROM employees WHERE salary > 50000;


-- Q30. Find employees hired in January 2024
SELECT * FROM employees
WHERE hire_date BETWEEN '2024-01-01' AND '2024-01-31';


-- Q31. Display unique departments
SELECT DISTINCT department FROM employees;


-- Q32. Count total employees
SELECT COUNT(*) AS total_employees FROM employees;


-- Q33. Find maximum, minimum and average salary
SELECT
MAX(salary) AS maximum_salary,
MIN(salary) AS minimum_salary,
AVG(salary) AS average_salary
FROM employees;


-- Q34. Update John Smith salary
UPDATE employees
SET salary = 58000
WHERE name = 'John Smith';


-- Q35. Increase HR salary by 5%
UPDATE employees
SET salary = salary * 1.05
WHERE department = 'HR';


-- Q36. Update Lisa Wilson salary and hire date
UPDATE employees
SET salary = 47000,
    hire_date = '2024-03-05'
WHERE name = 'Lisa Wilson';


-- Q37. Change department for salary below 50000
UPDATE employees
SET department = 'Operations'
WHERE salary < 50000;


-- Q38. Add 2000 to Finance employees
UPDATE employees
SET salary = salary + 2000
WHERE department = 'Finance';


-- Q39. Change department for employees hired before February 2024
UPDATE employees
SET department = 'Senior Staff'
WHERE hire_date < '2024-02-01';


-- =========================================
-- PRODUCT TABLE
-- =========================================

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 999.99, 5),
(2, 'Mouse', 'Electronics', 25.50, 0),
(3, 'Desk Chair', 'Furniture', 150.00, 3),
(4, 'Monitor', 'Electronics', 1200.00, 2),
(5, 'Keyboard', 'Electronics', 75.00, 0),
(6, 'Coffee Mug', 'Office', 12.99, 10),
(7, 'Notebook', 'Office', 5.99, 8),
(8, 'Smartphone', 'Electronics', 1500.00, 1);


-- Q40. Delete products with zero stock
DELETE FROM products WHERE stock_quantity = 0;


-- Q41. Delete Electronics above 1000
DELETE FROM products
WHERE category = 'Electronics' AND price > 1000;


-- Q42. Delete Desk Chair
DELETE FROM products WHERE product_name = 'Desk Chair';


-- Q43. Delete products below 100
DELETE FROM products WHERE price < 100;


-- =========================================
-- STUDENTS TABLE
-- =========================================

-- Q44. Create students table and insert records
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course VARCHAR(100),
    marks INT,
    city VARCHAR(50)
);

INSERT INTO students VALUES
(1, 'Alice Brown', 'Computer Science', 85, 'Mumbai'),
(2, 'Bob Wilson', 'Mathematics', 92, 'Delhi'),
(3, 'Carol Davis', 'Computer Science', 78, 'Mumbai'),
(4, 'David Miller', 'Physics', 88, 'Chennai'),
(5, 'Eva Garcia', 'Mathematics', 95, 'Delhi'),
(6, 'Frank Johnson', 'Computer Science', 82, 'Bangalore'),
(7, 'Grace Lee', 'Physics', 90, 'Mumbai'),
(8, 'Henry Smith', 'Mathematics', 76, 'Chennai'),
(9, 'Ivy Chen', 'Computer Science', 89, 'Delhi'),
(10, 'Jack Taylor', 'Physics', 84, 'Bangalore');


-- Q45. Sort students by marks descending
SELECT * FROM students ORDER BY marks DESC;


-- Q46. Display top 5 scorers
SELECT * FROM students ORDER BY marks DESC LIMIT 5;


-- Q47. Computer Science students alphabetically
SELECT * FROM students
WHERE course = 'Computer Science'
ORDER BY student_name ASC;


-- Q48. Display bottom 3 scorers
SELECT * FROM students ORDER BY marks ASC LIMIT 3;


-- Q49. Find students with marks between 80 and 90
SELECT * FROM students WHERE marks BETWEEN 80 AND 90;


-- Q50. Find students whose names start with A
SELECT * FROM students WHERE student_name LIKE 'A%';


-- Q51. Display students from Mumbai or Delhi
SELECT * FROM students
WHERE city IN ('Mumbai', 'Delhi');


-- Q52. Create Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    isbn VARCHAR(13) UNIQUE,
    genre VARCHAR(50)
);


-- Q53. Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);


-- Q54. Create Loans table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE,
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


-- Q55. Insert books, members and loans
INSERT INTO Books VALUES
(1, 'Database System Concepts', 'Korth', '9780073523323', 'Database'),
(2, 'Operating System Concepts', 'Silberschatz', '9781119456339', 'OS'),
(3, 'Python Crash Course', 'Eric Matthes', '9781718502703', 'Programming');

INSERT INTO Members VALUES
(101, 'Amit Sharma', 'amit.lib@example.com', '9876500001'),
(102, 'Priya Singh', 'priya.lib@example.com', '9876500002'),
(103, 'Rahul Verma', 'rahul.lib@example.com', '9876500003');

INSERT INTO Loans VALUES
(1, 1, 101, '2026-09-01', NULL),
(2, 2, 102, '2026-09-02', '2026-09-06'),
(3, 3, 103, '2026-09-04', NULL);


-- Q56. Display loan details with book and member names
SELECT
    l.loan_id,
    b.title,
    m.name,
    l.loan_date,
    l.return_date
FROM Loans l
INNER JOIN Books b ON l.book_id = b.book_id
INNER JOIN Members m ON l.member_id = m.member_id;
