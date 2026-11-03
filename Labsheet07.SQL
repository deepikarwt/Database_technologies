
-- Q0. Create database
CREATE DATABASE Hospital_Cursor_Trigger_Lab;
USE Hospital_Cursor_Trigger_Lab;


-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50),
    Department VARCHAR(40),
    ConsultationFee DECIMAL(10,2),
    Status VARCHAR(20)
);


-- Insert doctor records
INSERT INTO Doctors VALUES
(201, 'Dr. Anil', 'Cardiology', 1200, 'Active'),
(202, 'Dr. Beena', 'Pediatrics', 900, 'Active'),
(203, 'Dr. Chirag', 'Neurology', 1500, 'Active'),
(204, 'Dr. Divya', 'Dermatology', 1000, 'Active'),
(205, 'Dr. Eshan', 'Cardiology', 1300, 'Active'),
(206, 'Dr. Farah', 'Pediatrics', 850, 'Active');


-- Create Doctor_Audit table
CREATE TABLE Doctor_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    ActionType VARCHAR(30),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    OldDepartment VARCHAR(40),
    NewDepartment VARCHAR(40)
);


-- Create Fee_Log table
CREATE TABLE Fee_Log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    DoctorName VARCHAR(50),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Display tables
SELECT * FROM Doctors;
SELECT * FROM Doctor_Audit;
SELECT * FROM Fee_Log;


DELIMITER //


-- Q1. Display all doctors using cursor
CREATE PROCEDURE ShowDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id, v_name;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_id AS DoctorID, v_name AS DoctorName;
    END LOOP;

    CLOSE cur;
END //


-- Q2. Display doctors with fee greater than 1000
CREATE PROCEDURE DoctorsAboveFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);
    DECLARE v_fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName, ConsultationFee
        FROM Doctors
        WHERE ConsultationFee > 1000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id, v_name, v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_id AS DoctorID, v_name AS DoctorName,
               v_fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //


-- Q3. Calculate total consultation fee
CREATE PROCEDURE TotalConsultationFee(OUT total DECIMAL(10,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_fee DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_total = v_total + v_fee;
    END LOOP;

    CLOSE cur;

    SET total = v_total;
END //


-- Q4. Count Cardiology doctors
CREATE PROCEDURE CountCardiology(OUT total INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE Department = 'Cardiology';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_count = v_count + 1;
    END LOOP;

    CLOSE cur;

    SET total = v_count;
END //


-- Q5. Calculate average consultation fee
CREATE PROCEDURE AverageConsultationFee(OUT avg_fee DECIMAL(10,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_fee DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_total = v_total + v_fee;
        SET v_count = v_count + 1;
    END LOOP;

    CLOSE cur;

    IF v_count = 0 THEN
        SET avg_fee = NULL;
    ELSE
        SET avg_fee = v_total / v_count;
    END IF;
END //


-- Q6. Increase Pediatrics fee by 10%
CREATE PROCEDURE IncreasePediatricsFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE Department = 'Pediatrics';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET ConsultationFee = ConsultationFee * 1.10
        WHERE DoctorID = v_id;
    END LOOP;

    CLOSE cur;
END //


-- Q7. Change status of doctors with fee below 1000
CREATE PROCEDURE ReviewLowFeeDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE ConsultationFee < 1000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET Status = 'Review'
        WHERE DoctorID = v_id;
    END LOOP;

    CLOSE cur;
END //


-- Q8. Display doctor report in sorted order
CREATE PROCEDURE DoctorReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(50);
    DECLARE v_dept VARCHAR(40);
    DECLARE v_fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorName, Department, ConsultationFee
        FROM Doctors
        ORDER BY Department, DoctorName;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_name, v_dept, v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_name AS DoctorName,
               v_dept AS Department,
               v_fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //


-- Q9. Count active doctors
CREATE PROCEDURE CountActiveDoctors(OUT total INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE Status = 'Active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_count = v_count + 1;
    END LOOP;

    CLOSE cur;

    SET total = v_count;
END //


-- Q10. Increase fee by 5% for fees >= 1200
CREATE PROCEDURE IncreaseHighFees()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE ConsultationFee >= 1200;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET ConsultationFee = ConsultationFee * 1.05
        WHERE DoctorID = v_id;
    END LOOP;

    CLOSE cur;
END //


DELIMITER ;


-- =========================================
-- TEST CURSOR PROCEDURES
-- =========================================

-- Test Q1
CALL ShowDoctors();

-- Test Q2
CALL DoctorsAboveFee();

-- Test Q3
CALL TotalConsultationFee(@total);
SELECT @total AS TotalConsultationFee;

-- Test Q4
CALL CountCardiology(@count);
SELECT @count AS CardiologyDoctors;

-- Test Q5
CALL AverageConsultationFee(@avg);
SELECT @avg AS AverageFee;

-- Test Q6
CALL IncreasePediatricsFee();
SELECT * FROM Doctors;

-- Test Q7
CALL ReviewLowFeeDoctors();
SELECT * FROM Doctors;

-- Test Q8
CALL DoctorReport();

-- Test Q9
CALL CountActiveDoctors(@active);
SELECT @active AS ActiveDoctors;

-- Test Q10
CALL IncreaseHighFees();
SELECT * FROM Doctors;



DELIMITER //


-- Q1. AFTER INSERT trigger: record new doctor
CREATE TRIGGER AfterDoctorInsert
AFTER INSERT ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
    (DoctorID, ActionType, NewFee)
    VALUES
    (NEW.DoctorID, 'INSERT', NEW.ConsultationFee);
END //


-- Q2. AFTER UPDATE trigger: record fee changes
CREATE TRIGGER AfterFeeUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldFee, NewFee)
        VALUES
        (NEW.DoctorID, 'FEE_UPDATED',
         OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //


-- Q3. BEFORE INSERT trigger: uppercase doctor name
CREATE TRIGGER BeforeDoctorInsert
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    SET NEW.DoctorName = UPPER(NEW.DoctorName);
END //


-- Q4. BEFORE INSERT trigger: prevent negative fee
CREATE TRIGGER CheckInsertFee
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Consultation fee cannot be negative';
    END IF;
END //


-- Q5. AFTER DELETE trigger: record deleted doctor
CREATE TRIGGER AfterDoctorDelete
AFTER DELETE ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
    (DoctorID, ActionType, OldFee)
    VALUES
    (OLD.DoctorID, 'DELETE', OLD.ConsultationFee);
END //


-- Q6. AFTER UPDATE trigger: store fee in Fee_Log
CREATE TRIGGER LogFeeUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Fee_Log
        (DoctorID, DoctorName, OldFee, NewFee)
        VALUES
        (NEW.DoctorID, NEW.DoctorName,
         OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //


-- Q7. BEFORE UPDATE trigger: prevent negative fee
CREATE TRIGGER CheckUpdateFee
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Updated fee cannot be negative';
    END IF;
END //


-- Q8. BEFORE UPDATE trigger: normalize status
CREATE TRIGGER NormalizeDoctorStatus
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.Status = 'active' THEN
        SET NEW.Status = 'Active';
    END IF;
END //


-- Q9. AFTER UPDATE trigger: record department changes
CREATE TRIGGER DepartmentChangeAudit
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.Department <> NEW.Department THEN
        INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldDepartment, NewDepartment)
        VALUES
        (NEW.DoctorID, 'DEPARTMENT_CHANGED',
         OLD.Department, NEW.Department);
    END IF;
END //


-- Q10. BEFORE INSERT trigger: validate doctor status
CREATE TRIGGER ValidateDoctorStatus
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.Status NOT IN ('Active', 'Inactive', 'Review') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid doctor status';
    END IF;
END //


DELIMITER ;


-- =========================================
-- TEST TRIGGERS
-- =========================================

-- Test Q1 and Q3: insert doctor with lowercase name
INSERT INTO Doctors VALUES
(299, 'dr. test', 'General Medicine', 800, 'Active');

-- Verify uppercase name and insert audit
SELECT * FROM Doctors WHERE DoctorID = 299;
SELECT * FROM Doctor_Audit;


-- Test Q2 and Q6: update consultation fee
UPDATE Doctors
SET ConsultationFee = 1400
WHERE DoctorID = 201;

-- Verify fee audit and fee log
SELECT * FROM Doctor_Audit;
SELECT * FROM Fee_Log;


-- Test Q5: delete test doctor
DELETE FROM Doctors
WHERE DoctorID = 299;

-- Verify delete audit
SELECT * FROM Doctor_Audit;


-- Test Q8: change status to lowercase active
UPDATE Doctors
SET Status = 'active'
WHERE DoctorID = 201;

-- Verify normalized status
SELECT * FROM Doctors WHERE DoctorID = 201;


-- Test Q9: change department
UPDATE Doctors
SET Department = 'Neurology'
WHERE DoctorID = 201;

-- Verify department audit
SELECT * FROM Doctor_Audit;


-- Test Q4: try inserting a negative fee
-- Uncomment to test the error
-- INSERT INTO Doctors VALUES
-- (300, 'Dr. Invalid', 'Cardiology', -500, 'Active');


-- Test Q7: try updating fee to a negative value
-- Uncomment to test the error
-- UPDATE Doctors SET ConsultationFee = -100
-- WHERE DoctorID = 202;


-- Test Q10: try inserting an invalid status
-- Uncomment to test the error
-- INSERT INTO Doctors VALUES
-- (301, 'Dr. Invalid', 'General Medicine', 700, 'Unknown');


-- Final verification
SELECT * FROM Doctors;
SELECT * FROM Doctor_Audit;
SELECT * FROM Fee_Log;

-- Display all triggers
SHOW TRIGGERS;