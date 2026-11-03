CREATE DATABASE college_db;
USE college_db;

/* Q1. Create an empty table named departments
   with dept_id as primary key and dept_name
   up to 50 characters.
*/

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);


/* Q2. Create employees table with emp_id,
   first_name and salary.
*/

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    salary DECIMAL(10,2)
);


/* Q3. Create projects table with project_id,
   project_name and start_date.
*/

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE
);


/* Q4. Create audit_logs table with log_id,
   action and created_at.
*/

CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY,
    action TEXT,
    created_at TIMESTAMP
);


/* Q5. Create products table with product_id,
   product_name and is_available.
*/

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    is_available BOOLEAN
);


/* Q6. Create system_settings table with
   setting_id, setting_key and setting_value.
*/

CREATE TABLE system_settings (
    setting_id SMALLINT PRIMARY KEY,
    setting_key VARCHAR(50),
    setting_value VARCHAR(100)
);


/* Q7. Add email column to employees table.
*/

ALTER TABLE employees
ADD email VARCHAR(100);


/* Q8. Remove is_available column from products.
*/

ALTER TABLE products
DROP COLUMN is_available;


/* Q9. Rename departments table to dept_units.
*/

RENAME TABLE departments TO dept_units;


/* Q10. Empty all records from audit_logs
    without deleting the table.
*/

TRUNCATE TABLE audit_logs;


/* Q11. Create user_profiles table with
    user_id, bio and profile_pic.
*/

CREATE TABLE user_profiles (
    user_id INT PRIMARY KEY,
    bio TEXT,
    profile_pic BLOB
);


/* Q12. Create ticket_orders table with
    priority_level restricted to Low, Medium, High.
*/

CREATE TABLE ticket_orders (
    ticket_id INT PRIMARY KEY,
    priority_level ENUM('Low', 'Medium', 'High')
);


/* Q13. Permanently delete products table.
*/

DROP TABLE products;


/* Q14. Change email data type from VARCHAR(100)
    to VARCHAR(150).
*/

ALTER TABLE employees
MODIFY email VARCHAR(150);


/* Q15. Create sensor_data table with
    read_id and temperature.
*/

CREATE TABLE sensor_data (
    read_id BIGINT PRIMARY KEY,
    temperature FLOAT
);


/* Q16. Add composite primary key to
    existing student_courses table.
*/

ALTER TABLE student_courses
ADD PRIMARY KEY (student_id, course_id);


/* Q17. Rename first_name to given_name
    in employees table.
*/

ALTER TABLE employees
RENAME COLUMN first_name TO given_name;


/* Q18. Drop primary key from system_settings.
*/

ALTER TABLE system_settings
DROP PRIMARY KEY;


/* Q19. Create clients table with client_id
    and registration_time.
*/

CREATE TABLE clients (
    client_id INT,
    registration_time TIME
);


/* Q20. Add primary key to client_id
    using ALTER command.
*/

ALTER TABLE clients
ADD PRIMARY KEY (client_id);


/* Q21. Create order_items table with
    composite primary key order_id and item_id.
*/

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(8,2),
    PRIMARY KEY (order_id, item_id)
);


/* Q22. Create event_schedules table with
    composite primary key event_id and venue_id.
*/

CREATE TABLE event_schedules (
    event_id INT,
    venue_id INT,
    event_date DATE,
    duration_hours TINYINT,
    PRIMARY KEY (event_id, venue_id)
);


/* Q23. Add hire_date and is_active columns
    to employees in one ALTER statement.
*/

ALTER TABLE employees
ADD hire_date DATE,
ADD is_active BOOLEAN;


/* Q24. Drop email and change salary data type
    in one ALTER statement.
*/

ALTER TABLE employees
DROP COLUMN email,
MODIFY salary DECIMAL(12,2);


/* Q25. Add composite primary key to inventory
    using warehouse_id and sku.
*/

ALTER TABLE inventory
ADD PRIMARY KEY (warehouse_id, sku);


/* Q26. Change bio column from TEXT to MEDIUMTEXT.
*/

ALTER TABLE user_profiles
MODIFY bio MEDIUMTEXT;


/* Q27. Add middle_name after given_name.
*/

ALTER TABLE employees
ADD middle_name VARCHAR(30)
AFTER given_name;


/* Q28. Create geolocations table.
*/

CREATE TABLE geolocations (
    location_id INT PRIMARY KEY,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);


/* Q29. Create user_accounts table with
    account_type ENUM and created_timestamp.
*/

CREATE TABLE user_accounts (
    user_id BIGINT PRIMARY KEY,
    account_type ENUM('Standard', 'Premium', 'Admin'),
    created_timestamp TIMESTAMP
);


/* Q30. Create device_logs table.
*/

CREATE TABLE device_logs (
    log_id BIGINT PRIMARY KEY,
    ip_address VARCHAR(45),
    payload LONGBLOB
);


/* Q31. Drop existing primary key of order_items,
    add order_item_id at first position
    and make it the new primary key.
*/

ALTER TABLE order_items
DROP PRIMARY KEY,
ADD order_item_id INT FIRST,
ADD PRIMARY KEY (order_item_id);


/* Q32. Rename start_date to project_year
    and change its type to YEAR.
*/

ALTER TABLE projects
CHANGE start_date project_year YEAR;


/* Q33. Create document_store table.
*/

CREATE TABLE document_store (
    doc_id INT PRIMARY KEY,
    doc_title VARCHAR(255),
    content LONGTEXT
);


/* Q34. Rename content to doc_body
    while maintaining LONGTEXT type.
*/

ALTER TABLE document_store
CHANGE content doc_body LONGTEXT;


/* Q35. Create empty employees_archive table
    identical to employees structure and constraints.
*/

CREATE TABLE employees_archive
LIKE employees;


/* Q36. Drop employees_archive only if it exists.
*/

DROP TABLE IF EXISTS employees_archive;


/* Q37. Create financial_ledger table.
*/

CREATE TABLE financial_ledger (
    entry_id BIGINT PRIMARY KEY,
    debit DECIMAL(15,4),
    credit DECIMAL(15,4)
);


/* Q38. Add transaction_date as first column.
*/

ALTER TABLE financial_ledger
ADD transaction_date DATETIME FIRST;


/* Q39. Create measurements table.
*/

CREATE TABLE measurements (
    sample_id INT PRIMARY KEY,
    value DOUBLE
);


/* Q40. Create app_users table.
*/

CREATE TABLE app_users (
    user_id INT PRIMARY KEY,
    status_code TINYINT
);


/* Q41. Create transactions table with
    transaction details and channel ENUM.
*/

CREATE TABLE transactions (
    xact_id BIGINT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    channel ENUM('Web', 'Mobile', 'ATM'),
    status VARCHAR(20),
    xact_time TIMESTAMP
);


/* Q42. Create system_events table with
    composite primary key event_id and node_id.
*/

CREATE TABLE system_events (
    event_id BIGINT,
    node_id SMALLINT,
    event_payload TEXT,
    logged_time TIMESTAMP,
    PRIMARY KEY (event_id, node_id)
);


/* Q43. Drop current primary key of clients,
    add region_code and create composite key.
*/

ALTER TABLE clients
DROP PRIMARY KEY,
ADD region_code CHAR(3),
ADD PRIMARY KEY (client_id, region_code);


/* Q44. Rename temp_val to converted_val,
    change type to DECIMAL(6,3),
    and add processed_at after it.
*/

ALTER TABLE raw_data
CHANGE temp_val converted_val DECIMAL(6,3),
ADD processed_at TIMESTAMP
AFTER converted_val;


/* Q45. Create student_enrollments table
    with three-column composite primary key.
*/

CREATE TABLE student_enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id, semester)
);


/* Q46. Drop composite key, add enrollment_id
    as first column and set as primary key.
*/

ALTER TABLE student_enrollments
DROP PRIMARY KEY,
ADD enrollment_id BIGINT FIRST,
ADD PRIMARY KEY (enrollment_id);


/* Q47. Create file_metadata table.
*/

CREATE TABLE file_metadata (
    file_id INT PRIMARY KEY,
    file_path VARCHAR(500),
    file_size_bytes BIGINT,
    checksum CHAR(64)
);


/* Q48. Change file_id to BIGINT,
    file_path to TEXT and drop checksum.
*/

ALTER TABLE file_metadata
MODIFY file_id BIGINT,
MODIFY file_path TEXT,
DROP COLUMN checksum;


/* Q49. Create sensor_readings table with
    composite primary key and rename the table.
*/

CREATE TABLE sensor_readings (
    sensor_id INT,
    recorded_at TIMESTAMP,
    reading FLOAT,
    PRIMARY KEY (sensor_id, recorded_at)
);

RENAME TABLE sensor_readings
TO historical_sensor_readings;


/* Q50. Create application_logs table and
    modify level from ENUM to VARCHAR(10).
*/

CREATE TABLE application_logs (
    log_id BIGINT PRIMARY KEY,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR'),
    message TEXT,
    execution_time DOUBLE,
    created_at DATETIME
);

ALTER TABLE application_logs
MODIFY level VARCHAR(10);

