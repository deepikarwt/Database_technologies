
-- Create and select database
CREATE DATABASE Hospital_Functions_Lab;
USE Hospital_Functions_Lab;


-- Create Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    WeightKg DECIMAL(5,2),
    ConsultationFee DECIMAL(10,2)
);


-- Create Medicines table
CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Stock INT
);


-- Insert patient records
INSERT INTO Patients VALUES
(201, 'Asha', 24, 'F', 55.5, 600),
(202, 'Rohan', 35, 'M', 72.0, 800),
(203, 'Meera', 29, 'F', 61.5, 700),
(204, 'Vivek', 46, 'M', 85.0, 1000),
(205, 'Nitin', 17, 'M', 58.0, 500),
(206, 'Kavya', 52, 'F', 68.0, 900);


-- Insert medicine records
INSERT INTO Medicines VALUES
(301, 'Paracetamol', 25, 100),
(302, 'Amoxicillin', 80, 50),
(303, 'Cetirizine', 35, 75),
(304, 'Omeprazole', 60, 40),
(305, 'Azithromycin', 120, 25);


-- Display tables
SELECT * FROM Patients;
SELECT * FROM Medicines;


DELIMITER //


-- Q1. Calculate BMI
CREATE FUNCTION calculate_bmi(
    weight_kg DECIMAL(5,2),
    height_m DECIMAL(5,2)
)
RETURNS DECIMAL(6,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN weight_kg / (height_m * height_m);
END //


-- Q2. Find age category
CREATE FUNCTION age_category(age INT)
RETURNS VARCHAR(10)
DETERMINISTIC
NO SQL
BEGIN
    IF age < 18 THEN
        RETURN 'Child';
    ELSEIF age < 60 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Senior';
    END IF;
END //


-- Q3. Calculate consultation fee with tax
CREATE FUNCTION consultation_with_tax(
    fee DECIMAL(10,2),
    tax_percent DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN fee + (fee * tax_percent / 100);
END //


-- Q4. Calculate medicine stock value
CREATE FUNCTION medicine_stock_value(
    unit_price DECIMAL(10,2),
    stock INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN unit_price * stock;
END //


-- Q5. Display patients by gender
CREATE PROCEDURE patient_by_gender(IN p_gender VARCHAR(10))
BEGIN
    SELECT * FROM Patients
    WHERE Gender = p_gender;
END //


-- Q6. Display patients above given age
CREATE PROCEDURE patients_above_age(IN p_age INT)
BEGIN
    SELECT * FROM Patients
    WHERE Age > p_age;
END //


-- Q7. Increase medicine stock
CREATE PROCEDURE update_medicine_stock(
    IN p_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE Medicines
    SET Stock = Stock + p_quantity
    WHERE MedicineID = p_id;
END //


-- Q8. Count total medicines
CREATE PROCEDURE medicine_count(OUT p_count INT)
BEGIN
    SELECT COUNT(*) INTO p_count
    FROM Medicines;
END //


-- Q9. Display patient report
CREATE PROCEDURE patient_report()
BEGIN
    SELECT
        PatientID,
        PatientName,
        Age,
        calculate_bmi(WeightKg, 1.65) AS BMI,
        age_category(Age) AS AgeCategory
    FROM Patients;
END //


-- Q10. Display medicine report
CREATE PROCEDURE medicine_report()
BEGIN
    SELECT
        MedicineID,
        MedicineName,
        UnitPrice,
        Stock,
        medicine_stock_value(UnitPrice, Stock) AS StockValue,
        CASE
            WHEN Stock < 30 THEN 'Low Stock'
            WHEN Stock <= 70 THEN 'Medium Stock'
            ELSE 'High Stock'
        END AS StockStatus
    FROM Medicines;
END //


DELIMITER ;



-- Q1. Test BMI with weight 60 kg and height 1.65 m
SELECT calculate_bmi(60, 1.65) AS BMI;


-- Q2. Apply age category to every patient
SELECT PatientName, Age,
       age_category(Age) AS AgeCategory
FROM Patients;


-- Q3. Display original fee and fee with 10% tax
SELECT PatientName,
       ConsultationFee AS OriginalFee,
       consultation_with_tax(ConsultationFee, 10) AS FeeWithTax
FROM Patients;


-- Q4. Display stock value of every medicine
SELECT MedicineName,
       UnitPrice,
       Stock,
       medicine_stock_value(UnitPrice, Stock) AS StockValue
FROM Medicines;


-- =========================================
-- TEST STORED PROCEDURES
-- =========================================


-- Q5. Display female patients
CALL patient_by_gender('F');

-- Q5. Display male patients
CALL patient_by_gender('M');


-- Q6. Display patients above age 20
CALL patients_above_age(20);

-- Q6. Display patients above age 30
CALL patients_above_age(30);


-- Q7. Increase stock of medicine ID 301 by 20
CALL update_medicine_stock(301, 20);

-- Verify updated stock
SELECT * FROM Medicines
WHERE MedicineID = 301;


-- Q8. Count total medicines
CALL medicine_count(@total);
SELECT @total AS TotalMedicines;


-- Q9. Display complete patient report
CALL patient_report();


-- Q10. Display complete medicine report
CALL medicine_report();


-- Final verification
SELECT * FROM Patients;
SELECT * FROM Medicines;