CREATE TABLE IF NOT EXISTS lz_employees (
  EmployeeID SERIAL PRIMARY KEY,
  FULLNAME VARCHAR(50) NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE,
  Department VARCHAR(50),
  JobTitle VARCHAR(50),
  HireDate DATE,
  Salary DECIMAL(10,2) NOT NULL
);

ALTER TABLE IF EXISTS lz_employees
    OWNER TO lzadmin;

INSERT INTO lz_employees (EmployeeID, FULLNAME, FirstName, LastName, Email, Department, JobTitle, HireDate, Salary) VALUES
(1001, 'John L1', 'John', 'L1', 'John.L1@example.com', 'Engineering', 'Senior Engineer', '2023-01-01', 800000.00),
(1002, 'Jane L2', 'Jane', 'L2', 'Jane.L2@example.com', 'Production', 'Engineer', '2024-01-01', 900000.00),
(1003, 'Michael L3', 'Michael', 'L3', 'Michael.L3@example.com', 'Operations', 'Operation Manager', '2022-01-01', 600000.00),
(1004, 'Pitt L4', 'Russel', 'L4', 'Pitt.L4@example.com', 'Finance', 'Senior Manager', '2024-02-01', 700000.00),
(1005, 'Words L5', 'William', 'L5', 'Words.L5@example.com', 'HR', 'HR Recruiter', '2023-03-01', 500000.00);


CREATE TABLE IF NOT EXISTS lz_customers (
  CustomerID SERIAL PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE,
  PhoneNumber VARCHAR(20)
);

ALTER TABLE IF EXISTS lz_customers
    OWNER TO lzadmin;

INSERT INTO lz_customers (CustomerID, FirstName, LastName, Email, PhoneNumber) VALUES
(1, 'Maira', 'S', 'Maira.S@example.com', '(555) 555-1234'),
(2, 'Jan', 'Low', 'Jan.low@example.com', '(123) 456-7890'),
(3, 'Lowy', 'Dove', 'Lowy.Dove@example.com', '(789) 012-3456'),
(4, 'Max', 'Miller', 'max.miller@example.com', '(234) 567-8901'),
(5, 'Sarah', 'Jones', 'sarah.jones@example.com', '(987) 654-3210');

CREATE TABLE IF NOT EXISTS lz_invoices (
  InvoiceID SERIAL PRIMARY KEY,
  CustomerID INT NOT NULL,
  InvoiceDate DATE NOT NULL,
  DueDate DATE NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (CustomerID) REFERENCES lz_customers(CustomerID)
);

ALTER TABLE IF EXISTS lz_invoices
    OWNER TO lzadmin;

INSERT INTO lz_invoices (InvoiceID, CustomerID, InvoiceDate, DueDate, TotalAmount) VALUES
(1, 1, '2024-05-17', '2024-06-17', 1250.75),
(2, 2, '2024-05-15', '2024-06-15', 890.00),
(3, 3, '2024-05-10', '2024-06-10', 2100.50),
(4, 4, '2024-05-12', '2024-06-12', 987.25),
(5, 5, '2024-05-08', '2024-05-28', 560.99);


CREATE TABLE IF NOT EXISTS lz_departments (
  DepartmentID SERIAL PRIMARY KEY,
  DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

ALTER TABLE IF EXISTS lz_departments
    OWNER TO lzadmin;


CREATE TABLE IF NOT EXISTS lz_doctors (
  DoctorID SERIAL PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  DepartmentID INT NOT NULL,
  Specialty VARCHAR(100),
  LicenseNumber VARCHAR(50),
  FOREIGN KEY (DepartmentID) REFERENCES lz_departments(DepartmentID)
);

ALTER TABLE IF EXISTS lz_doctors
    OWNER TO lzadmin;

CREATE TABLE IF NOT EXISTS lz_patients (
  PatientID SERIAL PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender VARCHAR(20) NOT NULL CHECK (Gender IN ('Male', 'Female', 'Non-binary'))
);

ALTER TABLE IF EXISTS lz_patients
    OWNER TO lzadmin;

CREATE TABLE IF NOT EXISTS lz_nurses (
  NurseID SERIAL PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  DepartmentID INT NOT NULL,
  FOREIGN KEY (DepartmentID) REFERENCES lz_departments(DepartmentID)
);

ALTER TABLE IF EXISTS lz_nurses
    OWNER TO lzadmin;

CREATE TABLE IF NOT EXISTS lz_radiology_exams (
  ExamID SERIAL PRIMARY KEY,
  PatientID INT NOT NULL,
  ExamType VARCHAR(100) NOT NULL,
  ExamDate DATE NOT NULL,
  ReferringPhysician VARCHAR(100) NOT NULL,
  ExamStatus VARCHAR(30) NOT NULL CHECK (ExamStatus IN ('Scheduled', 'Completed', 'Pending Interpretation')),
  FOREIGN KEY (PatientID) REFERENCES lz_patients(PatientID)
);

ALTER TABLE IF EXISTS lz_radiology_exams
    OWNER TO lzadmin;


CREATE TABLE IF NOT EXISTS lz_radiology_reports (
  ReportID SERIAL PRIMARY KEY,
  ExamID INT NOT NULL,
  Radiologist VARCHAR(100),
  ReportDate DATE,
  ReportText TEXT,
  FOREIGN KEY (ExamID) REFERENCES lz_radiology_exams(ExamID)
);

ALTER TABLE IF EXISTS lz_radiology_reports
    OWNER TO lzadmin;


INSERT INTO lz_departments (DepartmentID, DepartmentName)
VALUES (1, 'Radiology'),
       (2, 'Cardiology'),
       (3, 'Emergency Medicine'),
       (4, 'Orthopedics'),
       (5, 'Pediatrics'),
       (6, 'Dermatology'),
       (7, 'Neurology'),
       (8, 'Gastroenterology'),
       (9, 'Oncology'),
       (10, 'Pulmonology');


INSERT INTO lz_patients (PatientID, FirstName, LastName, DateOfBirth, Gender)
VALUES (12345, 'John', 'Smith', '1980-01-01', 'Male'),
       (67890, 'Jane', 'Doe', '1975-12-31', 'Female'),
       (23456, 'Michael', 'Williams', '1990-05-10', 'Male'),
       (78901, 'Sarah', 'Jones', '1985-07-14', 'Female'),
       (34567, 'David', 'Miller', '1968-02-29', 'Male'),
       (89012, 'Lisa', 'Garcia', '1992-11-03', 'Female'),
       (45678, 'Daniel', 'Brown', '2000-08-21', 'Male'),
       (90123, 'Amanda', 'Clark', '1972-09-12', 'Female'),
       (56789, 'Matthew', 'Lewis', '1987-06-05', 'Male'),
       (1234, 'Jennifer', 'Robinson', '1995-03-18', 'Female');


INSERT INTO lz_nurses (NurseID, FirstName, LastName, DepartmentID)
VALUES (101, 'Ashley', 'Diaz', 1),
       (102, 'David', 'Lee', 2),
       (103, 'Maria', 'Garcia', 3),
       (104, 'Elizabeth', 'Johnson', 4),
       (105, 'William', 'Davis', 5),
       (106, 'Katherine', 'Thomas', 6),
       (107, 'Robert', 'Jackson', 7),
       (108, 'Barbara', 'Miller', 8),
       (109, 'Joseph', 'Garcia', 9),
       (110, 'Susan', 'Hernandez', 10);


INSERT INTO lz_radiology_exams (ExamID, PatientID, ExamType, ExamDate, ReferringPhysician, ExamStatus)
VALUES (1000, 12345, 'X-ray', '2024-05-23', 'Dr. Jones', 'Completed'),
       (2000, 67890, 'CT Scan (Head)', '2024-05-20', 'Dr. Lee', 'Completed'),
       (3000, 23456, 'MRI (Knee)', '2024-05-22', 'Dr. Garcia', 'Completed'),
       (4000, 78901, 'Ultrasound (Abdomen)', '2024-05-24', 'Dr. Brown', 'Pending Interpretation'),
       (5000, 34567, 'Bone Density Scan', '2024-05-21', 'Dr. Miller', 'Scheduled'),
       (6000, 89012, 'X-ray (Chest)', '2024-05-22', 'Dr. Thomas', 'Completed'),
       (7000, 45678, 'Fluoroscopy (Chest)', '2024-05-24', 'Dr. Hernandez', 'Pending Interpretation'),
       (8000, 90123, 'Barium Swallow', '2024-05-21', 'Dr. Jackson', 'Completed'),
       (9000, 56789, 'Angiography (Lower Limb)', '2024-05-23', 'Dr. Robinson', 'Scheduled'),
       (10000, 1234, 'Nuclear Medicine Scan (Bone)', '2024-05-20', 'Dr. Garcia', 'Completed');


INSERT INTO lz_radiology_reports (ReportID, ExamID, Radiologist, ReportDate, ReportText)
VALUES (4000, 4000, 'Dr. Smith', '2024-05-24', 'Ultrasound (Abdomen) shows normal findings. No abnormalities detected.'),
       (5000, 5000, NULL, NULL, NULL),
       (6000, 6000, 'Dr. Williams', '2024-05-23', 'Chest X-ray reveals mild infiltrate in the right lower lobe. Further investigation recommended.'),
       (7000, 7000, NULL, NULL, NULL),
       (8000, 8000, 'Dr. Clark', '2024-05-22', 'Barium Swallow demonstrates normal esophageal function. No signs of obstruction.'),
       (9000, 9000, NULL, NULL, NULL),
       (10000, 10000, 'Dr. Brown', '2024-05-21', 'Nuclear Medicine Bone Scan shows increased uptake in the left hip joint, suggestive of arthritis. Correlation with x-ray recommended.');



CREATE TABLE IF NOT EXISTS lz_receipts (
  ReceiptID SERIAL PRIMARY KEY,
  InvoiceID INT NOT NULL,
  ReceiptDate DATE NOT NULL,
  PaymentAmount DECIMAL(10,2) NOT NULL,
  PaymentMethod VARCHAR(50) NOT NULL,
  PaymentReference VARCHAR(50) DEFAULT NULL,
  PaymentStatus VARCHAR(20) DEFAULT NULL CHECK (PaymentStatus IN ('Completed', 'Pending', 'Failed')),
  FOREIGN KEY (InvoiceID) REFERENCES lz_invoices(InvoiceID),
  CONSTRAINT chk_payment_amount CHECK (PaymentAmount > 0)
);

ALTER TABLE IF EXISTS lz_receipts
    OWNER TO lzadmin;


INSERT INTO lz_receipts (InvoiceID, ReceiptDate, PaymentAmount, PaymentMethod) VALUES
(1, '2024-05-20', 500.00, 'Cash'),  -- Partial payment for Invoice 1
(2, '2024-05-22', 890.00, 'Credit Card'),  -- Full payment for Invoice 2
(3, '2024-05-18', 1000.00, 'Check'),    -- Partial payment for Invoice 3
(4, '2024-05-24', 987.25, 'Cash'),     -- Full payment for Invoice 4
(1, '2024-05-27', 750.75, 'Cash'),     -- Completing payment for Invoice 1
(3, '2024-05-25', 500.00, 'Credit Card'),  -- Additional payment for Invoice 3
(5, '2024-05-28', 560.99, 'Cash');     -- Full payment for Invoice 5


