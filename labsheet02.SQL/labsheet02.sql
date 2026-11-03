-- Select the database
USE college_db;

-- Q1. Insert Fiona Gallagher into employees
INSERT INTO employees
VALUES (106, 'Fiona', 'Gallagher', 10, 65000.00, '2024-02-01', TRUE);

-- Q2. Insert Quality Assurance department
INSERT INTO departments
VALUES (60, 'Quality Assurance', 'Building B', 250000.00);

-- Q3. Insert Delta Retail order
INSERT INTO orders
VALUES (5006, 'Delta Retail', '2024-01-28', 2100.00, 'Pending');

-- Q4. Display all employees
SELECT * FROM employees;

-- Q5. Display employee names and salaries
SELECT first_name, last_name, salary FROM employees;

-- Q6. Find employees in department 10
SELECT * FROM employees WHERE dept_id = 10;

-- Q7. Display completed orders
SELECT * FROM orders WHERE status = 'Completed';

-- Q8. Update salary of employee 102
UPDATE employees SET salary = 55000.00 WHERE emp_id = 102;

-- Q9. Change order 5002 status to Shipped
UPDATE orders SET status = 'Shipped' WHERE order_id = 5002;

-- Q10. Increase department 20 budget by 20000
UPDATE departments SET budget = budget + 20000 WHERE dept_id = 20;

-- Q11. Delete order 5004
DELETE FROM orders WHERE order_id = 5004;

-- Q12. Delete employee Diana Prince
DELETE FROM employees WHERE emp_id = 104;

-- Q13. Find employees earning above 60000
SELECT * FROM employees WHERE salary > 60000;

-- Q14. Find orders between two dates
SELECT * FROM orders
WHERE order_date BETWEEN '2024-01-15' AND '2024-01-20';

-- Q15. Find departments in Building A or B
SELECT * FROM departments
WHERE location IN ('Building A', 'Building B');

-- Q16. Find employees whose last name starts with S
SELECT * FROM employees WHERE last_name LIKE 'S%';

-- Q17. Sort employees by salary descending
SELECT * FROM employees ORDER BY salary DESC;

-- Q18. Sort departments alphabetically
SELECT * FROM departments ORDER BY dept_name ASC;

-- Q19. Count total employees
SELECT COUNT(*) AS total_employees FROM employees;

-- Q20. Calculate average order amount
SELECT AVG(total_amount) AS average_amount FROM orders;


-- Q21. Insert two employees in one query
INSERT INTO employees VALUES
(107, 'George', 'Clark', 30, 50000.00, '2024-02-05', TRUE),
(108, 'Hannah', 'Abbott', 10, 71000.00, '2024-02-10', TRUE);

-- Q22. Increase department 10 salaries by 10%
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 10;

-- Q23. Deactivate employees hired before 2021
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2021-01-01';

-- Q24. Find active employees earning above 60000
SELECT * FROM employees
WHERE is_active = TRUE AND salary > 60000;

-- Q25. Find cancelled or high-value orders
SELECT * FROM orders
WHERE status = 'Cancelled' OR total_amount > 2000;

-- Q26. Find employees outside departments 10 and 30
SELECT * FROM employees
WHERE dept_id NOT IN (10, 30);

-- Q27. Find first names containing letter a
SELECT * FROM employees
WHERE LOWER(first_name) LIKE '%a%';

-- Q28. Calculate salary expenditure per department
SELECT dept_id, SUM(salary) AS total_salary
FROM employees
GROUP BY dept_id;

-- Q29. Count employees in each department
SELECT dept_id, COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id;

-- Q30. Departments with salary expense above 100000
SELECT dept_id, SUM(salary) AS total_salary
FROM employees
GROUP BY dept_id
HAVING SUM(salary) > 100000;

-- Q31. Maximum and minimum order amount per status
SELECT status, MAX(total_amount) AS maximum,
       MIN(total_amount) AS minimum
FROM orders
GROUP BY status;

-- Q32. Employees earning above average salary
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q33. Employees working in Building A
SELECT * FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments
    WHERE location = 'Building A'
);

-- Q34. Delete orders from customers having a cancelled order
DELETE FROM orders
WHERE customer_name IN (
    SELECT customer_name FROM (
        SELECT customer_name FROM orders
        WHERE status = 'Cancelled'
    ) AS cancelled_customers
);

-- Q35. Find employees with NULL last name
SELECT * FROM employees WHERE last_name IS NULL;

-- Q36. Display employee full names
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

-- Q37. Display top 3 highest-paid employees
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 3;

-- Q38. Sort by department and salary
SELECT * FROM employees
ORDER BY dept_id ASC, salary DESC;

-- Q39. Delete departments with budget below 200000
DELETE FROM departments WHERE budget < 200000;

-- Q40. Cancel orders below 200
UPDATE orders
SET status = 'Cancelled'
WHERE total_amount < 200;


-- Q41. Increase salary by 15% in highest-budget department
UPDATE employees
SET salary = salary * 1.15
WHERE dept_id = (
    SELECT dept_id FROM (
        SELECT dept_id FROM departments
        ORDER BY budget DESC
        LIMIT 1
    ) AS highest_budget
);

-- Q42. Departments with average salary above global average
SELECT dept_id, AVG(salary) AS average_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > (
    SELECT AVG(salary) FROM employees
);

-- Q43. Employees in departments with budget above 300000
SELECT * FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments
    WHERE budget > 300000
);

-- Q44. Find the third highest distinct salary
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

-- Q45. Increase salary using CASE
UPDATE employees
SET salary = CASE
    WHEN salary < 60000 THEN salary * 1.10
    ELSE salary * 1.05
END;

-- Q46. Delete inactive employees earning below department average
DELETE FROM employees
WHERE is_active = FALSE
AND salary < (
    SELECT avg_salary FROM (
        SELECT dept_id, AVG(salary) AS avg_salary
        FROM employees
        GROUP BY dept_id
    ) AS dept_average
    WHERE dept_average.dept_id = employees.dept_id
);

-- Q47. Display department name and employee count
SELECT dept_name,
       (SELECT COUNT(*)
        FROM employees
        WHERE employees.dept_id = departments.dept_id)
       AS employee_count
FROM departments;

-- Q48. Customers with more than one order or spending above 1000
SELECT customer_name
FROM orders
GROUP BY customer_name
HAVING COUNT(*) > 1 OR SUM(total_amount) > 1000;

-- Q49. Copy department 10 employees into department 50 with IDs +500
INSERT INTO employees
SELECT emp_id + 500, first_name, last_name, 50,
       salary, hire_date, is_active
FROM employees
WHERE dept_id = 10;

-- Q50. Update order status using CASE
UPDATE orders
SET status = CASE
    WHEN total_amount > 1000 THEN 'Completed'
    WHEN total_amount BETWEEN 500 AND 1000 THEN 'Shipped'
    ELSE 'Pending'
END;