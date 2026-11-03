--  Create database 
CREATE DATABASE CollegeDB;
USE CollegeDB;


-- Create Department table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);

-- Create Student table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Marks DECIMAL(5,2),
    DeptID INT,
    Email VARCHAR(100),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- Create Course table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50) NOT NULL,
    Credits INT
);


-- Insert Department records
INSERT INTO Department VALUES
(101, 'Computer Science', 'Block A'),
(102, 'Pharmacy', 'Block B'),
(103, 'Commerce', 'Block C'),
(104, 'Mathematics', 'Block D');


-- Insert Student records
INSERT INTO Student VALUES
(1, 'Amit', 20, 'Male', 85.50, 101, 'amit@gmail.com'),
(2, 'Priya', 21, 'Female', 92.00, 102, 'priya@gmail.com'),
(3, 'Rahul', 19, 'Male', 76.50, 101, 'rahul@gmail.com'),
(4, 'Neha', 22, 'Female', 88.00, 103, 'neha@gmail.com'),
(5, 'Arjun', 20, 'Male', 69.50, 104, 'arjun@gmail.com'),
(6, 'Sneha', 21, 'Female', 95.00, 102, 'sneha@gmail.com'),
(7, 'Rohit', 23, 'Male', 72.00, 103, 'rohit@gmail.com'),
(8, 'Pooja', 20, 'Female', 81.00, 104, 'pooja@gmail.com');


-- Insert Course records
INSERT INTO Course VALUES
(201, 'Database Management System', 4),
(202, 'Python Programming', 4),
(203, 'Mathematics', 3),
(204, 'Computer Networks', 3),
(205, 'Data Structures', 4);


-- Display tables
SELECT * FROM Department;
SELECT * FROM Student;
SELECT * FROM Course;


-- Change delimiter for procedures and functions
DELIMITER //


-- Q1. Display all students
CREATE PROCEDURE ShowStudents()
BEGIN
    SELECT * FROM Student;
END //


-- Q2. Display all departments
CREATE PROCEDURE ShowDepartments()
BEGIN
    SELECT * FROM Department;
END //


-- Q3. Display all courses
CREATE PROCEDURE ShowCourses()
BEGIN
    SELECT * FROM Course;
END //


-- Q4. Display student by ID
CREATE PROCEDURE GetStudent(IN sid INT)
BEGIN
    SELECT * FROM Student
    WHERE StudentID = sid;
END //


-- Q5. Display students by department
CREATE PROCEDURE GetStudentsByDept(IN did INT)
BEGIN
    SELECT * FROM Student
    WHERE DeptID = did;
END //


-- Q6. Display students above given marks
CREATE PROCEDURE StudentsAboveMarks(IN m DECIMAL(5,2))
BEGIN
    SELECT * FROM Student
    WHERE Marks > m;
END //


-- Q7. Display total number of students
CREATE PROCEDURE TotalStudents()
BEGIN
    SELECT COUNT(*) AS TotalStudents
    FROM Student;
END //


-- Q8. Check student result
CREATE PROCEDURE CheckResult(IN sid INT)
BEGIN
    SELECT StudentName,
    CASE
        WHEN Marks >= 50 THEN 'Pass'
        ELSE 'Fail'
    END AS Result
    FROM Student
    WHERE StudentID = sid;
END //


-- Q9. Display students by gender
CREATE PROCEDURE GetStudentsByGender(IN g VARCHAR(10))
BEGIN
    SELECT * FROM Student
    WHERE Gender = g;
END //


-- Q10. Display students within marks range
CREATE PROCEDURE StudentsBetweenMarks(
    IN m1 DECIMAL(5,2),
    IN m2 DECIMAL(5,2)
)
BEGIN
    SELECT * FROM Student
    WHERE Marks BETWEEN m1 AND m2;
END //


-- Q11. Add two numbers
CREATE FUNCTION AddTwoNumbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN a + b;
END //


-- Q12. Find square of a number
CREATE FUNCTION FindSquare(n INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN n * n;
END //


-- Q13. Check pass or fail
CREATE FUNCTION ResultStatus(m DECIMAL(5,2))
RETURNS VARCHAR(10)
DETERMINISTIC
NO SQL
BEGIN
    IF m >= 50 THEN
        RETURN 'Pass';
    ELSE
        RETURN 'Fail';
    END IF;
END //


-- Q14. Find student grade
CREATE FUNCTION StudentGrade(m DECIMAL(5,2))
RETURNS CHAR(1)
DETERMINISTIC
NO SQL
BEGIN
    IF m >= 90 THEN
        RETURN 'A';
    ELSEIF m >= 75 THEN
        RETURN 'B';
    ELSEIF m >= 60 THEN
        RETURN 'C';
    ELSE
        RETURN 'D';
    END IF;
END //


-- Q15. Find age category
CREATE FUNCTION AgeCategory(a INT)
RETURNS VARCHAR(10)
DETERMINISTIC
NO SQL
BEGIN
    IF a >= 18 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Minor';
    END IF;
END //


-- Q16. Calculate bonus
CREATE FUNCTION CalculateBonus(m DECIMAL(5,2))
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    IF m >= 90 THEN
        RETURN 1000;
    ELSEIF m >= 75 THEN
        RETURN 500;
    ELSE
        RETURN 200;
    END IF;
END //


-- Q17. Find higher number
CREATE FUNCTION HigherNumber(a INT, b INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    IF a > b THEN
        RETURN a;
    ELSE
        RETURN b;
    END IF;
END //


-- Q18. Calculate double marks
CREATE FUNCTION DoubleMarks(m DECIMAL(5,2))
RETURNS DECIMAL(6,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN m * 2;
END //


-- Q19. Calculate age after five years
CREATE FUNCTION AgeAfterFiveYears(a INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN a + 5;
END //


-- End procedure and function definitions
DELIMITER ;


-- Test stored procedures

-- Test Q1
CALL ShowStudents();

-- Test Q2
CALL ShowDepartments();

-- Test Q3
CALL ShowCourses();

-- Test Q4: Student ID 3
CALL GetStudent(3);

-- Test Q5: Department ID 102
CALL GetStudentsByDept(102);

-- Test Q6: Marks above 80
CALL StudentsAboveMarks(80);

-- Test Q7
CALL TotalStudents();

-- Test Q8: Check result of student 3
CALL CheckResult(3);

-- Test Q9: Female students
CALL GetStudentsByGender('Female');

-- Test Q10: Marks between 70 and 90
CALL StudentsBetweenMarks(70, 90);


-- Test functions

-- Test Q11: Add 10 and 20
SELECT AddTwoNumbers(10, 20) AS Sum;

-- Test Q12: Square of 5
SELECT FindSquare(5) AS Square;

-- Test Q13: Check pass or fail
SELECT ResultStatus(65) AS Result;

-- Test Q14: Find grade
SELECT StudentGrade(85) AS Grade;

-- Test Q15: Find age category
SELECT AgeCategory(20) AS Category;

-- Test Q16: Calculate bonus
SELECT CalculateBonus(95) AS Bonus;

-- Test Q17: Find higher number
SELECT HigherNumber(10, 20) AS GreaterNumber;

-- Test Q18: Double marks
SELECT DoubleMarks(85.50) AS DoubleMarks;

-- Test Q19: Age after five years
SELECT AgeAfterFiveYears(20) AS NewAge;


-- Q20. Display student name, marks and grade
SELECT StudentName, Marks,
       StudentGrade(Marks) AS Grade
FROM Student;