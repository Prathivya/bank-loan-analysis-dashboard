-- ==========================================
-- BANK LOAN ANALYSIS PROJECT
-- SQL DATA ANALYSIS USING MYSQL
-- ==========================================

-- 1. DATABASE CREATION AND DATA PREPARATION

CREATE DATABASE bank_loan_db;

USE bank_loan_db;

-- View the dataset
SELECT *
FROM bank_loan_data;

-- Check issue_date format
SELECT issue_date
FROM bank_loan_data
LIMIT 5;

-- Convert issue_date into DATE format
-- Run this conversion only if issue_date is imported as VARCHAR/TEXT.

SET SQL_SAFE_UPDATES = 0;

UPDATE bank_loan_data
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE bank_loan_data
MODIFY COLUMN issue_date DATE;

SET SQL_SAFE_UPDATES = 1;


-- ==========================================
-- 2. BANK LOAN REPORT | SUMMARY
-- ==========================================

-- A. TOTAL LOAN APPLICATIONS

SELECT COUNT(id) AS Total_Loan_Applications
FROM bank_loan_data;


-- B. MTD LOAN APPLICATIONS (DECEMBER 2021)

SELECT COUNT(id) AS MTD_Total_Applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;


-- C. PMTD LOAN APPLICATIONS (NOVEMBER 2021)

SELECT COUNT(id) AS PMTD_Total_Applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;


-- D. TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan_data;


-- E. MTD TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;


-- F. PMTD TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;


-- G. TOTAL AMOUNT RECEIVED

SELECT SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data;


-- H. MTD TOTAL AMOUNT RECEIVED

SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;


-- I. PMTD TOTAL AMOUNT RECEIVED

SELECT SUM(total_payment) AS PMTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;


-- J. AVERAGE INTEREST RATE

SELECT AVG(int_rate) * 100 AS Avg_Interest_Rate
FROM bank_loan_data;


-- K. MTD AVERAGE INTEREST RATE

SELECT AVG(int_rate) * 100 AS MTD_Avg_Interest_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;


-- L. PMTD AVERAGE INTEREST RATE

SELECT AVG(int_rate) * 100 AS PMTD_Avg_Interest_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;


-- M. AVERAGE DTI

SELECT AVG(dti) * 100 AS Avg_DTI
FROM bank_loan_data;


-- N. MTD AVERAGE DTI

SELECT AVG(dti) * 100 AS MTD_Avg_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;


-- O. PMTD AVERAGE DTI

SELECT AVG(dti) * 100 AS PMTD_Avg_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;


-- ==========================================
-- 3. GOOD LOAN ANALYSIS
-- ==========================================

-- A. GOOD LOAN PERCENTAGE

SELECT
    COUNT(CASE
        WHEN loan_status IN ('Fully Paid', 'Current')
        THEN id
    END) * 100.0 / COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;


-- B. GOOD LOAN APPLICATIONS

SELECT COUNT(id) AS Good_Loan_Applications
FROM bank_loan_data
WHERE loan_status IN ('Fully Paid', 'Current');


-- C. GOOD LOAN FUNDED AMOUNT

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status IN ('Fully Paid', 'Current');


-- D. GOOD LOAN AMOUNT RECEIVED

SELECT SUM(total_payment) AS Good_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status IN ('Fully Paid', 'Current');


-- ==========================================
-- 4. BAD LOAN ANALYSIS
-- ==========================================

-- A. BAD LOAN PERCENTAGE

SELECT
    COUNT(CASE
        WHEN loan_status = 'Charged Off'
        THEN id
    END) * 100.0 / COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;


-- B. BAD LOAN APPLICATIONS

SELECT COUNT(id) AS Bad_Loan_Applications
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- C. BAD LOAN FUNDED AMOUNT

SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- D. BAD LOAN AMOUNT RECEIVED

SELECT SUM(total_payment) AS Bad_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- ==========================================
-- 5. LOAN STATUS ANALYSIS
-- ==========================================

-- A. LOAN STATUS WISE ANALYSIS

SELECT
    loan_status,
    COUNT(id) AS Loan_Count,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate) * 100 AS Interest_Rate,
    AVG(dti) * 100 AS DTI
FROM bank_loan_data
GROUP BY loan_status
ORDER BY loan_status;


-- B. MTD LOAN STATUS ANALYSIS

SELECT
    loan_status,
    SUM(total_payment) AS MTD_Total_Amount_Received,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021
GROUP BY loan_status
ORDER BY loan_status;


-- ==========================================
-- 6. BANK LOAN REPORT | OVERVIEW
-- ==========================================

-- A. MONTH-WISE ANALYSIS

SELECT
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);


-- B. STATE-WISE ANALYSIS

SELECT
    address_state AS State,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;


-- C. TERM-WISE ANALYSIS

SELECT
    term AS Loan_Term,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;


-- D. EMPLOYEE LENGTH ANALYSIS

SELECT
    emp_length AS Employee_Length,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;


-- E. LOAN PURPOSE ANALYSIS

SELECT
    purpose AS Loan_Purpose,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;


-- F. HOME OWNERSHIP ANALYSIS

SELECT
    home_ownership AS Home_Ownership,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;


-- ==========================================
-- 7. FILTER-BASED ANALYSIS
-- ==========================================

-- A. LOAN PURPOSE ANALYSIS FOR GRADE A

SELECT
    purpose AS Loan_Purpose,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;




