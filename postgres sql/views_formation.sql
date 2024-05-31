CREATE VIEW PatientDetails AS
SELECT PatientID, FirstName, LastName, DateOfBirth, Gender
FROM lz_patients;

CREATE VIEW DoctorsByDepartment AS
SELECT d.FirstName, d.LastName, dep.DepartmentName
FROM lz_doctors d
JOIN lz_departments dep ON d.DepartmentID = dep.DepartmentID;

CREATE VIEW NursesByDepartment AS
SELECT n.FirstName, n.LastName, dep.DepartmentName
FROM lz_nurses n
JOIN lz_departments dep ON n.DepartmentID = dep.DepartmentID;


CREATE VIEW RadiologyExamDetails AS
SELECT e.ExamID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, e.ExamType, e.ExamDate, e.ExamStatus
FROM lz_radiology_exams e
JOIN lz_patients p ON e.PatientID = p.PatientID;


CREATE VIEW RadiologyReports AS
SELECT r.ReportID, e.ExamType, r.Radiologist, r.ReportDate, r.ReportText
FROM lz_radiology_reports r
JOIN lz_radiology_exams e ON r.ExamID = e.ExamID;


CREATE VIEW EmployeeDetails AS
SELECT EmployeeID, FirstName, LastName, Department, JobTitle, HireDate, Salary
FROM lz_employees;


CREATE VIEW EmployeeSalarySummary AS
SELECT Department, AVG(Salary) AS AvgSalary, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM lz_employees
GROUP BY Department;


CREATE VIEW EmployeesHiredAfter2020 AS
SELECT EmployeeID, FirstName, LastName, HireDate
FROM lz_employees
WHERE HireDate > '2020-01-01';


CREATE VIEW InvoiceDetails AS
SELECT i.InvoiceID, p.FirstName AS CustomerFirstName, p.LastName AS CustomerLastName, i.InvoiceDate, i.DueDate, i.TotalAmount
FROM lz_invoices i
JOIN lz_customers p ON i.CustomerID = p.CustomerID;

CREATE VIEW OverdueInvoices AS
SELECT InvoiceID, CustomerID, InvoiceDate, DueDate, TotalAmount
FROM lz_invoices
WHERE DueDate < CURRENT_DATE AND TotalAmount > (SELECT SUM(PaymentAmount) FROM lz_receipts WHERE lz_receipts.InvoiceID = lz_invoices.InvoiceID);

CREATE VIEW CustomerContactInformation AS
SELECT CustomerID, FirstName, LastName, Email, PhoneNumber
FROM lz_customers;


CREATE VIEW CustomersWithMultipleInvoices AS
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(i.InvoiceID) AS NumberOfInvoices
FROM lz_customers c
JOIN lz_invoices i ON c.CustomerID = i.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(i.InvoiceID) > 1;


CREATE VIEW CustomerTotalAmountSpent AS
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(i.TotalAmount) AS TotalAmountSpent
FROM lz_customers c
JOIN lz_invoices i ON c.CustomerID = i.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;


CREATE VIEW EmployeeDepartmentInfo AS
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, e.JobTitle
FROM lz_employees e
JOIN lz_departments d ON e.Department = d.DepartmentName;


CREATE VIEW MedicalStaffByDepartment AS
SELECT d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, n.FirstName AS NurseFirstName, n.LastName AS NurseLastName, dep.DepartmentName
FROM lz_doctors d
JOIN lz_nurses n ON d.DepartmentID = n.DepartmentID
JOIN lz_departments dep ON d.DepartmentID = dep.DepartmentID;


CREATE VIEW PatientExamDetails AS
SELECT p.PatientID, p.FirstName, p.LastName, e.ExamID, e.ExamType, e.ExamDate, e.ExamStatus
FROM lz_patients p
JOIN lz_radiology_exams e ON p.PatientID = e.PatientID;



