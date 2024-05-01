INSERT INTO ZIPCODE (ZipCode, State, City, Country) VALUES
(10001, 'New York', 'New York City', 'USA'),
(20001, 'DC', 'Washington', 'USA'),
(94101, 'California', 'San Francisco', 'USA'),
(33101, 'Florida', 'Miami', 'USA'),
(90001, 'California', 'Los Angeles', 'USA'),
(60601, 'Illinois', 'Chicago', 'USA'),
(77001, 'Texas', 'Houston', 'USA'),
(85001, 'Arizona', 'Phoenix', 'USA'),
(19101, 'Pennsylvania', 'Philadelphia', 'USA'),
(98101, 'Washington', 'Seattle', 'USA');

INSERT INTO BRANCH (BranchID, Street, ZipCode) VALUES
(1, '123 Main St', 10001),
(2, '456 Maple St', 20001),
(3, '789 Oak St', 94101),
(4, '101 Pine St', 33101),
(5, '102 Elm St', 90001),
(6, '103 Cedar St', 60601),
(7, '104 Birch St', 77001),
(8, '105 Walnut St', 85001),
(9, '106 Cherry St', 19101),
(10, '107 Aspen St', 98101);

INSERT INTO EMPLOYEE (Name, Position, BranchID) VALUES
('John Doe', 'Manager', 1),
('Jane Smith', 'Assistant Manager', 2),
('Michael Brown', 'Teller', 3),
('Emily Johnson', 'Loan Officer', 4),
('Daniel Garcia', 'Branch Manager', 5),
('Sophia Martinez', 'Customer Service Rep', 6),
('David Wilson', 'Financial Advisor', 7),
('Olivia Anderson', 'IT Support Specialist', 8),
('James Thomas', 'HR Coordinator', 9),
('Isabella Jackson', 'Senior Accountant', 10);

EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Alice Brown',
    @BranchID = 2,
    @DOB = '2000-01-01',
    @MobileNo = '1234567890',
    @Email = 'alice@example.com',
    @Street = '111 River St',
    @ZipCode = 10001,
    @AccountType = 'Savings',
    @InitialBalance = 2000.00,
    @BeneficiaryName = 'Sarah Brown',
    @BeneficiaryRelationship = 'Son';

EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Charlie Davis',
    @BranchID = 7,
    @DOB = '1990-03-01',
    @MobileNo = '2345678901',
    @Email = 'charlie@example.com',
    @Street = '222 Creek Rd',
    @ZipCode = 20001,
    @AccountType = 'Current',
    @InitialBalance = 1000.00,
    @BeneficiaryName = 'Mike Davis',
    @BeneficiaryRelationship = 'Brother';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Beatrix Potter',
    @BranchID = 9,
    @DOB = '2010-04-01',
    @MobileNo = '3456789012',
    @Email = 'beatrix@example.com',
    @Street = '333 Lake Ln',
    @ZipCode = 94101,
    @AccountType = 'Current',
    @InitialBalance = 9000.00,
    @BeneficiaryName = 'Lily Potter',
    @BeneficiaryRelationship = 'Mother';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Dexter Morgan',
    @BranchID = 2,
    @DOB = '2000-05-01',
    @MobileNo = '4567890123',
    @Email = 'dexter@example.com',
    @Street = '444 Hill Dr',
    @ZipCode = 33101,
    @AccountType = 'Savings',
    @InitialBalance = 4000.00,
    @BeneficiaryName = 'Rita Morgan',
    @BeneficiaryRelationship = 'Sister';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Eva Green',
    @BranchID = 5,
    @DOB = '1999-01-01',
    @MobileNo = '5678901234',
    @Email = 'eva@example.com',
    @Street = '555 Mountain Pass',
    @ZipCode = 90001,
    @AccountType = 'Current',
    @InitialBalance = 5000.00,
    @BeneficiaryName = 'Rita Morgan',
    @BeneficiaryRelationship = 'Sister';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Frank Herbert',
    @BranchID = 7,
    @DOB = '1994-01-01',
    @MobileNo = '6789012345',
    @Email = 'frank@example.com',
    @Street = '666 Valley View',
    @ZipCode = 60601,
    @AccountType = 'Current',
    @InitialBalance = 7000.00,
    @BeneficiaryName = 'Santy Cau',
    @BeneficiaryRelationship = 'Sister';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Gina Linetti',
    @BranchID = 1,
    @DOB = '1998-01-01',
    @MobileNo = '7890123456',
    @Email = 'gina@example.com',
    @Street = '777 Beach Blvd',
    @ZipCode = 77001,
    @AccountType = 'Savings',
    @InitialBalance = 8000.00,
    @BeneficiaryName = 'Rohan Si',
    @BeneficiaryRelationship = 'Son';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Hank Schrader',
    @BranchID = 3,
    @DOB = '1992-01-01',
    @MobileNo = '8901234567',
    @Email = 'hank@example.com',
    @Street = '888 Desert Sands',
    @ZipCode = 85001,
    @AccountType = 'Current',
    @InitialBalance = 3000.00,
    @BeneficiaryName = 'Pam Lable',
    @BeneficiaryRelationship = 'Mother';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Ivy Sullivan',
    @BranchID = 4,
    @DOB = '1956-01-01',
    @MobileNo = '9012345678',
    @Email = 'ivy@example.com',
    @Street = '999 Forest Glade',
    @ZipCode = 19101,
    @AccountType = 'Savings',
    @InitialBalance = 6000.00,
    @BeneficiaryName = 'Gua Lims',
    @BeneficiaryRelationship = 'Mother';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Jake Peralta',
    @BranchID = 1,
    @DOB = '1958-01-01',
    @MobileNo = '0123456789',
    @Email = 'jake@example.com',
    @Street = '1010 Meadow Lane',
    @ZipCode = 98101,
    @AccountType = 'Current',
    @InitialBalance = 10000.00,
    @BeneficiaryName = 'Sentre guar',
    @BeneficiaryRelationship = 'Father';
EXEC CreateCustomerWithAccountAndBeneficiary 
    @Name = 'Alice Smith',
    @BranchID = 2,
    @DOB = '1990-07-14',
    @MobileNo = '9876543210',
    @Email = 'alice123@example.com',
    @Street = '123 Main Street',
    @ZipCode = 20001,
    @AccountType = 'Savings',
    @InitialBalance = 2000.00,
    @BeneficiaryName = 'John Smith',
    @BeneficiaryRelationship = 'Son';
EXEC CreateCustomerWithLoan 
    @Name = 'Kennedy Flan',
    @BranchID = 3,
    @DOB = '1982-01-01',
    @MobileNo = '9383292010',
    @Email = 'kennedy@example.com',
    @Street = '125 JVue St',
    @ZipCode = 90001,
    @LoanAccountType = 'Automobile',
    @Amount = 10000.00,
    @IntrestRate = 8.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Param Sue',
    @BranchID = 4,
    @DOB = '1972-01-01',
    @MobileNo = '9383292011',
    @Email = 'params@example.com',
    @Street = '124 Smith St',
    @ZipCode = 94101,
    @LoanAccountType = 'Education',
    @Amount = 100000.00,
    @IntrestRate = 8.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Stany Flan',
    @BranchID = 5,
    @DOB = '1989-06-01',
    @MobileNo = '9385222412',
    @Email = 'stanyflany@example.com',
    @Street = '123 Fran St',
    @ZipCode = 85001,
    @LoanAccountType = 'Property',
    @Amount = 10000.00,
    @IntrestRate = 8.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Pawan Fus',
    @BranchID = 1,
    @DOB = '1992-11-05',
    @MobileNo = '9383292410',
    @Email = 'Pawan Fus@example.com',
    @Street = '122 Prong St',
    @ZipCode = 60601,
    @LoanAccountType = 'Property',
    @Amount = 100000.00,
    @IntrestRate = 2.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Yath Yan',
    @BranchID = 3,
    @DOB = '1989-06-01',
    @MobileNo = '9283592010',
    @Email = 'yathy@example.com',
    @Street = '120 JVue St',
    @ZipCode = 90001,
    @LoanAccountType = 'Education',
    @Amount = 10030.00,
    @IntrestRate = 9.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Peter Pan',
    @BranchID = 3,
    @DOB = '1990-01-11',
    @MobileNo = '9383492010',
    @Email = 'peterpan@example.com',
    @Street = '125 JVue St',
    @ZipCode = 90001,
    @LoanAccountType = 'Automobile',
    @Amount = 90000.00,
    @IntrestRate = 8.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Stanley yan',
    @BranchID = 3,
    @DOB = '2000-01-01',
    @MobileNo = '9483292010',
    @Email = 'stanley@example.com',
    @Street = '125 Path St',
    @ZipCode = 90001,
    @LoanAccountType = 'Education',
    @Amount = 100500.00,
    @IntrestRate = 4.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Trant Pes',
    @BranchID = 3,
    @DOB = '2000-01-01',
    @MobileNo = '9983292010',
    @Email = 'TrantPes@example.com',
    @Street = '128 JVue St',
    @ZipCode = 90001,
    @LoanAccountType = 'Education',
    @Amount = 10000.00,
    @IntrestRate = 5.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Stontis Unn',
    @BranchID = 3,
    @DOB = '1988-11-11',
    @MobileNo = '9183292010',
    @Email = 'StontisUnn@example.com',
    @Street = '125 JVue St',
    @ZipCode = 77001,
    @LoanAccountType = 'Automobile',
    @Amount = 10000.00,
    @IntrestRate = 5.15;
EXEC CreateCustomerWithLoan 
    @Name = 'Rasputin Flan',
    @BranchID = 1,
    @DOB = '1982-01-01',
    @MobileNo = '9383692010',
    @Email = 'RasputinFlan@example.com',
    @Street = '125 Stran St',
    @ZipCode = 90001,
    @LoanAccountType = 'Automobile',
    @Amount = 10000.00,
    @IntrestRate = 4.15;

/* 6. Column data encryption for encrypting password of ONLINE_BANKING table*/
OPEN SYMMETRIC KEY OBPass_SM
DECRYPTION BY CERTIFICATE MyCertificate
INSERT INTO ONLINE_BANKING (OBankingID, CustomerID, RegistrationDate, LastAccessDate, [Password]) VALUES
(801, 20001, '2020-01-01', '2023-01-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'Pass1234!') )),
(802, 20002, '2020-02-01', '2023-02-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'Secure9876@') )),
(803, 20003, '2020-03-01', '2023-03-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'HelloWorld$') )),
(804, 20004, '2020-04-01', '2023-04-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'Password123$') )),
(805, 20005, '2020-05-01', '2023-05-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'ChangeMe102!') )),
(806, 20006, '2020-06-01', '2023-06-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'MySecret888@') )),
(807, 20007, '2020-07-01', '2023-07-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'LetMeIn777$') )),
(808, 20008, '2020-08-01', '2023-08-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'AccessGranted9!') )),
(809, 20009, '2020-09-01', '2023-09-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'TrustNo1$$$') )),
(810, 20010, '2020-10-01', '2023-10-01', 
EncryptByKey(Key_GUID('OBPass_SM'), convert(varbinary,'SecureKey222@') ));

INSERT INTO ATM (BranchID, Balance, Street, ZipCode) VALUES
(1, 20000.00, '124 Main St', 10001),
(2, 15000.00, '457 Maple St', 20001),
(3, 18000.00, '790 Oak St', 94101),
(4, 16000.00, '102 Pine St', 33101),
(5, 22000.00, '103 Elm St', 90001),
(6, 14000.00, '104 Cedar St', 60601),
(7, 17000.00, '105 Birch St', 77001),
(8, 19000.00, '106 Walnut St', 85001),
(9, 21000.00, '107 Cherry St', 19101),
(10, 23000.00, '108 Aspen St', 98101);

INSERT INTO LOAN_PAYMENT (LoanID, Amount, Date)
VALUES
(700000, 500.00, '2023-04-07'),
(700001, 700.00, '2023-04-08'),
(700002, 1000.00, '2023-04-09'),
(700000, 500.00, '2023-04-07'),
(700005, 700.00, '2023-04-08'),
(700003, 1000.00, '2023-04-09'),
(700004, 500.00, '2023-04-07'),
(700008, 700.00, '2023-04-08'),
(700009, 1000.00, '2023-04-09');

INSERT INTO MANAGER (MANAGERID, BRANCHID) VALUES
(90000, 1), 
(90001, 2), 
(90002, 3), 
(90003, 4), 
(90004, 5), 
(90005, 6), 
(90006, 7), 
(90007, 8), 
(90008, 9), 
(90009, 10);

DECLARE @transaction_status VARCHAR(100)

-- Transaction 1
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20000, @source_account_number = 50000000, @atm_id = 101, @amount = 200, @status = @transaction_status OUTPUT;

-- Transaction 2
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20001, @source_account_number = 50000001, @atm_id = 102, @amount = 300, @status = @transaction_status OUTPUT;

-- Transaction 3
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20002, @source_account_number = 50000002, @atm_id = 103, @amount = 400, @status = @transaction_status OUTPUT;

-- Transaction 4
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20003, @source_account_number = 50000003, @atm_id = 104, @amount = 500, @status = @transaction_status OUTPUT;

-- Transaction 5
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20004, @source_account_number = 50000004, @atm_id = 105, @amount = 600, @status = @transaction_status OUTPUT;

-- Transaction 6
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20005, @source_account_number = 50000005, @atm_id = 106, @amount = 700, @status = @transaction_status OUTPUT;

-- Transaction 7
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20006, @source_account_number = 50000006, @atm_id = 107, @amount = 800, @status = @transaction_status OUTPUT;

-- Transaction 8
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20007, @source_account_number = 50000007, @atm_id = 108, @amount = 900, @status = @transaction_status OUTPUT;

-- Transaction 9
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20008, @source_account_number = 50000008, @atm_id = 109, @amount = 1000, @status = @transaction_status OUTPUT;

-- Transaction 10
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20009, @source_account_number = 50000009, @atm_id = 100, @amount = 1100, @status = @transaction_status OUTPUT;


-- Transaction 1
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 2, 
    @source_account_number = 50000001, 
    @destination_account_number = 50000002, 
    @amount = 200, 
    @status = @transaction_status OUTPUT;

-- Transaction 2
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 3, 
    @source_account_number = 50000002, 
    @destination_account_number = 50000003, 
    @amount = 300, 
    @status = @transaction_status OUTPUT;

-- Transaction 3
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 4, 
    @source_account_number = 50000003, 
    @destination_account_number = 50000004, 
    @amount = 400, 
    @status = @transaction_status OUTPUT;

-- Transaction 4
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 5, 
    @source_account_number = 50000004, 
    @destination_account_number = 50000005, 
    @amount = 500, 
    @status = @transaction_status OUTPUT;

-- Transaction 5
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 6, 
    @source_account_number = 50000005, 
    @destination_account_number = 50000006, 
    @amount = 600, 
    @status = @transaction_status OUTPUT;

-- Transaction 6
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 7, 
    @source_account_number = 50000006, 
    @destination_account_number = 50000007, 
    @amount = 700, 
    @status = @transaction_status OUTPUT;

-- Transaction 7
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 8, 
    @source_account_number = 50000007, 
    @destination_account_number = 50000008, 
    @amount = 800, 
    @status = @transaction_status OUTPUT;

-- Transaction 8
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 9, 
    @source_account_number = 50000008, 
    @destination_account_number = 50000009, 
    @amount = 900, 
    @status = @transaction_status OUTPUT;

-- Transaction 9
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 10, 
    @source_account_number = 50000009, 
    @destination_account_number = 50000010, 
    @amount = 1000, 
    @status = @transaction_status OUTPUT;

-- Transaction 10
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 1, 
    @source_account_number = 50000010, 
    @destination_account_number = 50000001, 
    @amount = 1100, 
    @status = @transaction_status OUTPUT;

-- Transaction 1
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 801, 
    @source_account_number = 50000001, 
    @destination_account_number = 50000002, 
    @amount = 100, 
    @status = @transaction_status OUTPUT;

-- Transaction 2
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 802, 
    @source_account_number = 50000002, 
    @destination_account_number = 50000003, 
    @amount = 200, 
    @status = @transaction_status OUTPUT;

-- Transaction 3
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 803, 
    @source_account_number = 50000003, 
    @destination_account_number = 50000004, 
    @amount = 300, 
    @status = @transaction_status OUTPUT;

-- Transaction 4
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 804, 
    @source_account_number = 50000004, 
    @destination_account_number = 50000005, 
    @amount = 400, 
    @status = @transaction_status OUTPUT;

-- Transaction 5
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 805, 
    @source_account_number = 50000005, 
    @destination_account_number = 50000006, 
    @amount = 500, 
    @status = @transaction_status OUTPUT;

-- Transaction 6
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 806, 
    @source_account_number = 50000006, 
    @destination_account_number = 50000007, 
    @amount = 600, 
    @status = @transaction_status OUTPUT;

-- Transaction 7
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 807, 
    @source_account_number = 50000007, 
    @destination_account_number = 50000008, 
    @amount = 700, 
    @status = @transaction_status OUTPUT;

-- Transaction 8
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 808, 
    @source_account_number = 50000008, 
    @destination_account_number = 50000009, 
    @amount = 800, 
    @status = @transaction_status OUTPUT;

-- Transaction 9
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 809, 
    @source_account_number = 50000009, 
    @destination_account_number = 50000010, 
    @amount = 900, 
    @status = @transaction_status OUTPUT;

-- Transaction 10
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 810, 
    @source_account_number = 50000010, 
    @destination_account_number = 50000009, 
    @amount = 1000, 
    @status = @transaction_status OUTPUT;

-- This is a deposit transaction
EXEC PERFORM_BRANCH_TRANSACTION 
    @branch_id = 4, 
    @source_account_number = NULL, 
    @destination_account_number = 50000004, 
    @amount = 400, 
    @status = @transaction_status OUTPUT;

-- High value transactions to generate customer alerts
EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 802, 
    @source_account_number = 50000002, 
    @destination_account_number = 50000001, 
    @amount = 1500, 
    @status = @transaction_status OUTPUT;

EXEC PERFORM_ONLINE_TRANSACTION 
    @obanking_id = 804, 
    @source_account_number = 50000004, 
    @destination_account_number = 50000003, 
    @amount = 1300, 
    @status = @transaction_status OUTPUT;

-- High value transaction to generate atm alert
EXEC PERFORM_ATM_TRANSACTION @customer_id = 20002, @source_account_number = 50000002, @atm_id = 103, @amount = 1500, @status = @transaction_status OUTPUT;

-- updating Registration dates of customers to demonstrate the values of computed column CreditScore
-- CustomerID 20000
UPDATE CUSTOMER
SET RegistrationDate = '2023-01-01'
WHERE CustomerID = 20000;

-- CustomerID 20001
UPDATE CUSTOMER
SET RegistrationDate = '2023-02-01'
WHERE CustomerID = 20001;

-- CustomerID 20002
UPDATE CUSTOMER
SET RegistrationDate = '2023-03-01'
WHERE CustomerID = 20002;

-- CustomerID 20003
UPDATE CUSTOMER
SET RegistrationDate = '2023-04-01'
WHERE CustomerID = 20003;

-- CustomerID 20004
UPDATE CUSTOMER
SET RegistrationDate = '2023-05-01'
WHERE CustomerID = 20004;

-- CustomerID 20005
UPDATE CUSTOMER
SET RegistrationDate = '2023-06-01'
WHERE CustomerID = 20005;

-- CustomerID 20006
UPDATE CUSTOMER
SET RegistrationDate = '2023-07-01'
WHERE CustomerID = 20006;

-- CustomerID 20007
UPDATE CUSTOMER
SET RegistrationDate = '2023-08-01'
WHERE CustomerID = 20007;

-- CustomerID 20008
UPDATE CUSTOMER
SET RegistrationDate = '2023-09-01'
WHERE CustomerID = 20008;

-- CustomerID 20009
UPDATE CUSTOMER
SET RegistrationDate = '2023-10-01'
WHERE CustomerID = 20009;

-- CustomerID 20010
UPDATE CUSTOMER
SET RegistrationDate = '2023-11-01'
WHERE CustomerID = 20010;

-- Age and CreditScore are computed columns on CUSTOMER Table
-- To view the computed columns
select * from CUSTOMER;

-- demonstrating creating an account for an existing customer
EXEC CreateAccountAndBeneficiaryforExistingCustomer 
    @CustomerID = '20000',
    @BranchID = 2, 
    @AccountType = 'Current',
    @InitialBalance = 1000.00,
    @BeneficiaryName = 'Maya Doe',
    @Relationship = 'Mother';

-- demonstratong creating a loan for existing customer
EXEC CreateLoanAccountforExistingCustomer
   @CustomerID = 20000,
   @LoanType ='Automobile',
   @Amount =12000,
   @InterestRate=6.75;

-- Querying views
SELECT * from CustomerAccountView
SELECT * from CustomerLoanView
SELECT * from PropertyLoanView
SELECT * from EducationLoanView
SELECT * from AutomobileLoanView
SELECT * from TransactionUsagePercentage
SELECT * from TransactionSummaryView
-- SELECT * from TransactionAlerts

select * from alerts
select * from ATM_ALERTS
select * from CUSTOMER_ALERTS


