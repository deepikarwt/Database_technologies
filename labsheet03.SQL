-- Create database and tables
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

CREATE TABLE IF NOT EXISTS departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    budget DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    is_active BOOLEAN,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
) ENGINE=InnoDB;


-- Create users used in the assignment
CREATE USER IF NOT EXISTS 'john'@'localhost' IDENTIFIED BY 'JohnPass2026!';
CREATE USER IF NOT EXISTS 'alice'@'localhost' IDENTIFIED BY 'AlicePass2026!';
CREATE USER IF NOT EXISTS 'intern_user'@'localhost' IDENTIFIED BY 'InternPass2026!';
CREATE USER IF NOT EXISTS 'temp_user'@'localhost' IDENTIFIED BY 'TempPass2026!';
CREATE USER IF NOT EXISTS 'sec_user'@'localhost' IDENTIFIED BY 'SecPass2026!';
CREATE USER IF NOT EXISTS 'admin_user'@'%' IDENTIFIED BY 'AdminPass2026!';

CREATE USER IF NOT EXISTS 'auditor'@'localhost' IDENTIFIED BY 'AuditPass2026!';
CREATE USER IF NOT EXISTS 'analyst'@'localhost' IDENTIFIED BY 'AnalystPass2026!';
CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'MgrPass2026!';
CREATE USER IF NOT EXISTS 'dev_user'@'localhost' IDENTIFIED BY 'DevPass2026!';
CREATE USER IF NOT EXISTS 'hr_assistant'@'localhost' IDENTIFIED BY 'HrPass2026!';
CREATE USER IF NOT EXISTS 'finance_user'@'localhost' IDENTIFIED BY 'FinPass2026!';
CREATE USER IF NOT EXISTS 'team_lead'@'localhost' IDENTIFIED BY 'LeadPass2026!';


-- Q1. Grant SELECT to john
GRANT SELECT ON company_db.* TO 'john'@'localhost';

-- Q2. Grant SELECT and INSERT to alice
GRANT SELECT, INSERT ON company_db.employees TO 'alice'@'localhost';

-- Q3. Revoke INSERT from alice
REVOKE INSERT ON company_db.employees FROM 'alice'@'localhost';

-- Q4. Start a transaction
START TRANSACTION;

-- Q5. Commit department insertion
COMMIT;

-- Q6. Roll back uncommitted deletion
ROLLBACK;

-- Q7. Create transaction savepoint
SAVEPOINT sp_before_update;

-- Q8. Grant all privileges to admin_user
GRANT ALL PRIVILEGES ON *.* TO 'admin_user'@'%' WITH GRANT OPTION;

-- Q9. Refresh privilege tables
FLUSH PRIVILEGES;

-- Q10. Revoke all privileges from intern_user
REVOKE ALL PRIVILEGES, GRANT OPTION
ON company_db.* FROM 'intern_user'@'localhost';


-- Q11. Grant DELETE on orders to dev_user
GRANT DELETE ON company_db.orders TO 'dev_user'@'localhost';

-- Q12. Update salaries using savepoint
START TRANSACTION;
UPDATE employees SET salary = 80000 WHERE emp_id = 101;
SAVEPOINT sp_first;
UPDATE employees SET salary = 95000 WHERE emp_id = 102;
ROLLBACK TO sp_first;
COMMIT;

-- Q13. Revoke UPDATE from hr_assistant
REVOKE UPDATE ON company_db.employees
FROM 'hr_assistant'@'localhost';

-- Q14. Set transaction to read-only
SET TRANSACTION READ ONLY;
START TRANSACTION;
SELECT * FROM employees;
COMMIT;

-- Q15. Demonstrate implicit commit by ALTER TABLE
START TRANSACTION;
UPDATE employees SET salary = 85000 WHERE emp_id = 101;
ALTER TABLE employees ADD COLUMN test_col INT;
-- ALTER TABLE causes an implicit commit in MySQL.

-- Q16. Transfer 10000 budget from department 10 to 20
START TRANSACTION;
UPDATE departments SET budget = budget - 10000 WHERE dept_id = 10;
UPDATE departments SET budget = budget + 10000 WHERE dept_id = 20;
COMMIT;

-- Q17. Check team_lead privileges
SHOW GRANTS FOR 'team_lead'@'localhost';

-- Q18. Revoke grant option from team_lead
REVOKE GRANT OPTION ON company_db.*
FROM 'team_lead'@'localhost';

-- Q19. Update order and roll back if amount is below 500
START TRANSACTION;
UPDATE orders SET status = 'Shipped' WHERE order_id = 5002;

SELECT total_amount FROM orders WHERE order_id = 5002;
-- Order 5002 is 450, so execute:
ROLLBACK;

-- Q20. Create and assign reporter role
CREATE ROLE IF NOT EXISTS 'reporter_role';
GRANT SELECT ON company_db.* TO 'reporter_role';
GRANT 'reporter_role' TO 'analyst'@'localhost';


-- Q21. Increase department 10 salaries and conditionally roll back budget
START TRANSACTION;
UPDATE employees SET salary = salary * 1.15 WHERE dept_id = 10;
SAVEPOINT sp_salary_done;
UPDATE departments SET budget = budget + 50000 WHERE dept_id = 10;

-- Budget becomes 550000, which exceeds 520000
ROLLBACK TO sp_salary_done;
COMMIT;

-- Q22. Lock employee 101 before updating salary
START TRANSACTION;
SELECT * FROM employees WHERE emp_id = 101 FOR UPDATE;
UPDATE employees SET salary = 88000 WHERE emp_id = 101;
COMMIT;

-- Q23. Shared lock on department 10
START TRANSACTION;
SELECT * FROM departments WHERE dept_id = 10 FOR SHARE;
SELECT * FROM employees WHERE dept_id = 10;
COMMIT;

-- Q24. Set auditor resource limits
ALTER USER 'auditor'@'localhost'
WITH MAX_QUERIES_PER_HOUR 100
MAX_USER_CONNECTIONS 2;

-- Q25. Cancel order 5002 and refund its amount to department 20
START TRANSACTION;
UPDATE orders
SET status = 'Cancelled'
WHERE order_id = 5002 AND status = 'Pending';

UPDATE departments
SET budget = budget + 450
WHERE dept_id = 20;

COMMIT;

-- Q26. Create role hierarchy
CREATE ROLE IF NOT EXISTS 'read_role';
CREATE ROLE IF NOT EXISTS 'write_role';
CREATE ROLE IF NOT EXISTS 'admin_role';

GRANT SELECT ON company_db.* TO 'read_role';
GRANT INSERT, UPDATE ON company_db.* TO 'write_role';
GRANT 'read_role', 'write_role' TO 'admin_role';

CREATE USER IF NOT EXISTS 'super_dev'@'localhost'
IDENTIFIED BY 'SuperDev2026!';

GRANT 'admin_role' TO 'super_dev'@'localhost';
SET DEFAULT ROLE 'admin_role' TO 'super_dev'@'localhost';

-- Q27. Deadlock simulation (run in two separate sessions)
-- Session 1:
-- START TRANSACTION;
-- UPDATE employees SET salary = salary + 100
-- WHERE emp_id = 101;
-- UPDATE employees SET salary = salary + 100
-- WHERE emp_id = 102;
-- COMMIT;

-- Session 2:
-- START TRANSACTION;
-- UPDATE employees SET salary = salary + 100
-- WHERE emp_id = 102;
-- UPDATE employees SET salary = salary + 100
-- WHERE emp_id = 101;
-- COMMIT;

-- Q28. Create remote SSL-required user
CREATE USER IF NOT EXISTS 'cloud_user'@'%'
IDENTIFIED BY 'CloudPass2026!'
REQUIRE SSL;

GRANT SELECT, INSERT ON company_db.*
TO 'cloud_user'@'%';

-- Q29. Insert two orders using savepoints
START TRANSACTION;

INSERT INTO orders
VALUES (5008, 'Customer Eight', '2024-02-01', 800, 'Pending');

SAVEPOINT sp_5008;

INSERT INTO orders
VALUES (5009, 'Customer Nine', '2024-02-02', 600, 'Pending');

SAVEPOINT sp_5009;

-- If order 5009 fails business rules:
ROLLBACK TO sp_5008;


-- Q30. Create maintenance user, grant, update, audit,
-- revoke permissions and lock account
CREATE USER IF NOT EXISTS 'test_maint'@'localhost'
IDENTIFIED BY 'MaintPass2026!';

GRANT SELECT, INSERT, UPDATE ON company_db.*
TO 'test_maint'@'localhost';

START TRANSACTION;
UPDATE employees SET is_active = TRUE WHERE emp_id = 104;
ROLLBACK;

SHOW GRANTS FOR 'test_maint'@'localhost';

REVOKE SELECT, INSERT, UPDATE ON company_db.*
FROM 'test_maint'@'localhost';

ALTER USER 'test_maint'@'localhost' ACCOUNT LOCK;

