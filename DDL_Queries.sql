create database dmdd_final_project10
GO
use dmdd_final_project10;
GO


CREATE TABLE ZIPCODE (
  ZipCode int PRIMARY KEY NOT NULL,
  [State] VARCHAR(50) NOT NULL,
  City  VARCHAR(50) NOT NULL,
  Country  VARCHAR(50) NOT NULL
);
CREATE TABLE BRANCH (
  BranchID int PRIMARY KEY NOT NULL,
  Street varchar(255) NOT NULL,
  ZipCode int REFERENCES ZIPCODE(ZipCode) NOT NULL
);
CREATE TABLE EMPLOYEE (
  EmployeeID int PRIMARY KEY IDENTITY (90000,1) NOT NULL,
  [Name] varchar(255) NOT NULL,
  Position varchar(255) NOT NULL,
  BranchID int FOREIGN KEY REFERENCES BRANCH(BRANCHID) NOT NULL
);
CREATE TABLE CUSTOMER (
  CustomerID int PRIMARY KEY IDENTITY (20000,1) NOT NULL,
  [Name] varchar(255) NOT NULL,
  BranchID int FOREIGN KEY REFERENCES BRANCH(BRANCHID) NOT NULL,
  DOB date NOT NULL CHECK (DOB <= GETDATE()),
  RegistrationDate date DEFAULT GETDATE() not NULL,
  MobileNo varchar(20) UNIQUE NOT NULL,
  Email varchar(255) UNIQUE,
  Street varchar(255),
  ZipCode int NOT NULL,
  -- 5. Computed Columns based on a user defined function (UDF) - Age is a computed column
  Age AS DATEDIFF(YEAR, DOB, GETDATE()) - CASE WHEN MONTH(DOB) > MONTH(GETDATE()) OR (MONTH(DOB) = MONTH(GETDATE()) AND DAY(DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END,
  FOREIGN KEY (ZipCode) REFERENCES ZIPCODE(ZipCode),
  CONSTRAINT CHK_RegistrationDate CHECK (RegistrationDate <= GETDATE())
);
CREATE TABLE ALERTS (
  AlertID int PRIMARY KEY NOT NULL IDENTITY (5000,1),
  Message Varchar(500),
  Type Varchar(20) CHECK(TYPE IN('ATM','Customer')),
  [Time] datetime not null CHECK (CAST([Time] AS TIME) <= CAST(GETDATE() AS TIME))
);
CREATE TABLE ONLINE_BANKING (
  OBankingID int PRIMARY KEY NOT NULL,
  CustomerID int FOREIGN KEY REFERENCES CUSTOMER(CustomerID) NOT NULL,
  RegistrationDate date CHECK (RegistrationDate <= GETDATE()),
  LastAccessDate date CHECK (LastAccessDate <= GETDATE()),
  "Password" varbinary(100) NOT NULL
);
CREATE TABLE ACCOUNT (
  AccountNumber int PRIMARY KEY IDENTITY (50000000,1) NOT NULL,
  CustomerID int FOREIGN KEY REFERENCES CUSTOMER(CustomerID) NOT NULL,
  BranchID int FOREIGN KEY REFERENCES BRANCH(BranchID) NOT NULL,
  [Type] varchar(255) CHECK (Type in ('Savings','Current')),
  Balance decimal(10,2) CHECK (Balance >= -100)
  CONSTRAINT ACC_UNK UNIQUE(CustomerID, [Type])
);
CREATE TABLE ATM (
  ATMId int PRIMARY KEY NOT NULL IDENTITY (100,1),
  BranchID int NOT NULL,
  Balance decimal(10,2) NOT NULL CHECK(Balance >= 0),
  Street varchar(255) NOT NULL,
  ZipCode int NOT NULL,
  FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID),
  FOREIGN KEY (ZipCode) REFERENCES ZIPCODE(ZipCode)
);
CREATE TABLE LOAN (
  LoanID int PRIMARY KEY IDENTITY (700000,1),
  CustomerID int FOREIGN KEY REFERENCES CUSTOMER(CustomerID) NOT NULL,
  [Type] varchar(255) CHECK ([Type] IN ('Education', 'Automobile', 'Property')),
  Amount decimal(10,2) NOT NULL CHECK(Amount >= 0),
  InterestRate decimal(10,2) NOT NULL CHECK(InterestRate >= 0 and InterestRate <=100) 
);

/*
CHK_DestinationAccountNumber - Destination Account number must be NULL for 'ATM' type of transaction. For all the other types it must be not null
CHK_SourceAccountNumber - Source Account number may or may not be null for 'Branch' type of transactions and it must be not null for all other types of transaction
Source Account Number will be null for Branch type of transactions when the customer is depositing the amount by visiting the branch. Currently there is no other
ways of depositing the amount. 
*/

CREATE TABLE "TRANSACTION" (
  TransactionID int PRIMARY KEY NOT NULL IDENTITY (60000000,1),
  SourceAccountNumber int FOREIGN KEY REFERENCES ACCOUNT(AccountNumber),
  DestinationAccountNumber int FOREIGN KEY REFERENCES ACCOUNT(AccountNumber),
  [Time] datetime not null DEFAULT CURRENT_TIMESTAMP CHECK (CAST([Time] AS TIME) <= CAST(GETDATE() AS TIME)),
  [Type] varchar(255) CHECK (Type IN ('Online', 'ATM', 'Branch')),
  Amount decimal(10,2),
  CONSTRAINT CHK_DestinationAccountNumber 
        CHECK ( 
            (Type <> 'ATM' AND DestinationAccountNumber IS NOT NULL) OR 
            (Type = 'ATM' AND DestinationAccountNumber IS NULL)
        ),
  CONSTRAINT CHK_SourceAccountNumber
		 CHECK ( 
            (Type <> 'Branch' AND SourceAccountNumber IS NOT NULL) OR 
            (Type = 'Branch')
		 )
);
CREATE TABLE LOAN_PAYMENT (
  PaymentID int PRIMARY KEY NOT NULL IDENTITY (90000000,1),
  LoanID int FOREIGN KEY REFERENCES LOAN(LoanID) NOT NULL,
  Amount decimal(10,2) CHECK(Amount >= 0),
  [Date] date NOT NULL CHECK ([Date] <= GETDATE())
);
CREATE TABLE ACCOUNT_BENEFICIARY (
  BeneficiaryID int PRIMARY KEY NOT NULL IDENTITY (3000,1),
  AccountNumber int FOREIGN KEY REFERENCES ACCOUNT(AccountNumber) NOT NULL,
  [Name] varchar(255) NOT NULL,
  Relationship varchar(255) CHECK (Relationship IN ('Son', 'Mother', 'Father', 'Sister', 'Brother'))
);
CREATE TABLE MANAGER(
MANAGERID int PRIMARY KEY FOREIGN KEY REFERENCES EMPLOYEE(EMPLOYEEID) NOT NULL,
BRANCHID int FOREIGN KEY REFERENCES BRANCH(BRANCHID) NOT NULL,
);
CREATE TABLE CUSTOMER_ALERTS (
  CAlertID int PRIMARY KEY NOT NULL,
  FOREIGN KEY (CAlertID) REFERENCES ALERTS(AlertID),
  CustomerID int FOREIGN KEY REFERENCES CUSTOMER(CustomerID) NOT NULL
);
CREATE TABLE ATM_ALERTS (
  AlertID int PRIMARY KEY NOT NULL,
  FOREIGN KEY (AlertID) REFERENCES ALERTS(AlertID),
  ATMId int FOREIGN KEY REFERENCES ATM(ATMId) NOT NULL
);
CREATE TABLE ONLINE_TRANSACTION (
  OTransactionID int PRIMARY KEY NOT NULL,
  FOREIGN KEY (OTransactionID) REFERENCES "TRANSACTION"(TransactionID),
  OBankingID int FOREIGN KEY REFERENCES ONLINE_BANKING(OBankingID) NOT NULL
);
CREATE TABLE ATM_TRANSACTION (
  ATransactionID int PRIMARY KEY NOT NULL,
  FOREIGN KEY (ATransactionID) REFERENCES "TRANSACTION"(TransactionID),
  ATMID int FOREIGN KEY REFERENCES ATM(ATMID) NOT NULL
);
CREATE TABLE BRANCH_TRANSACTION (
  BTransactionID int PRIMARY KEY NOT NULL,
  FOREIGN KEY (BTransactionID) REFERENCES "TRANSACTION"(TransactionID),
  BRANCHID int FOREIGN KEY REFERENCES BRANCH(BRANCHID) NOT NULL
);
GO



/*Creation of Accounts , Loan, Customer*/
GO
/*
1. stored procedure - This stored procedure, is creating customer, account and account beneficiary in the same transaction. 
This ensures that customer, account and account beneficiary will be created at the same time.
*/
CREATE OR ALTER PROCEDURE CreateCustomerWithAccountAndBeneficiary
    @Name varchar(255),
    @BranchID int,
    @DOB date,
    @MobileNo varchar(20),
    @Email varchar(255),
    @Street varchar(255),
    @ZipCode int,
    @AccountType varchar(255),
    @InitialBalance decimal(10,2),
    @BeneficiaryName varchar(255),
    @BeneficiaryRelationship varchar(255) AS BEGIN SET NOCOUNT ON;
    BEGIN TRANSACTION; -- Start the transaction
    DECLARE @CustomerID int;
    DECLARE @AccountNumber int;
    BEGIN TRY
        -- Insert into CUSTOMER table
        INSERT INTO CUSTOMER ([Name], BranchID, DOB, MobileNo, Email, Street, ZipCode)
        VALUES (@Name, @BranchID, @DOB, @MobileNo, @Email, @Street, @ZipCode);
        SET @CustomerID = SCOPE_IDENTITY(); -- Get the ID of the newly inserted customer
        -- Insert into ACCOUNT table
        INSERT INTO ACCOUNT (CustomerID, BranchID, Type, Balance)
        VALUES (@CustomerID, @BranchID, @AccountType, @InitialBalance);
        SET @AccountNumber = SCOPE_IDENTITY(); -- Get the Account Number of the newly inserted account
        -- Insert into ACCOUNT_BENEFICIARY table
        INSERT INTO ACCOUNT_BENEFICIARY (AccountNumber, [Name], Relationship)
        VALUES (@AccountNumber, @BeneficiaryName, @BeneficiaryRelationship);
        COMMIT TRANSACTION; -- Commit the transaction if all inserts succeed
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- Rollback the transaction if an error occurs
        -- Optionally, handle the error or log it
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

GO
/*
    1. Stored Procedure - This SP ensures that customer will be created along with the loan account in same transaction. This SP is usually used for
    the customers who don't have a prior account with the bank.
*/
CREATE OR ALTER PROCEDURE CreateCustomerWithLoan
    @Name varchar(255),
    @BranchID int,
    @DOB date,
    @MobileNo varchar(20),
    @Email varchar(255),
    @Street varchar(255),
    @ZipCode int,
    @LoanAccountType varchar(255),
    @Amount decimal(10,2),
    @IntrestRate decimal(10,2) AS BEGIN SET NOCOUNT ON;
    BEGIN TRANSACTION; -- Start the transaction
    DECLARE @CustomerID int;
    DECLARE @LoanID int;
    BEGIN TRY
        -- Insert into CUSTOMER table
        INSERT INTO CUSTOMER ([Name], BranchID, DOB, MobileNo, Email, Street, ZipCode)
        VALUES (@Name, @BranchID, @DOB, @MobileNo, @Email, @Street, @ZipCode);
        SET @CustomerID = SCOPE_IDENTITY(); -- Get the ID of the newly inserted customer
        -- Insert into LOAN table
        INSERT INTO LOAN(CustomerID,Type,Amount,InterestRate)
        VALUES (@CustomerID, @LoanAccountType, @Amount, @IntrestRate);
        COMMIT TRANSACTION; -- Commit the transaction if all inserts succeed
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- Rollback the transaction if an error occurs
        -- Optionally, handle the error or log it
        PRINT ERROR_MESSAGE();
    END CATCH;
END;


GO
/*
    1. Stored Procedure - This SP is used to create an account and account beneficiary in single transaction. We will use this SP if customer is already registered
    with our bank and is requesting for a new account.
*/
CREATE OR ALTER PROCEDURE CreateAccountAndBeneficiaryforExistingCustomer
    @CustomerID int,
    @BranchID int,
    @AccountType varchar(255),
    @InitialBalance decimal(10,2),
    @BeneficiaryName varchar(255),
    @Relationship varchar(255) AS BEGIN SET NOCOUNT ON;
    DECLARE @AccountNumber int;
    DECLARE @BeneficiaryID int;
    -- Insert into ACCOUNT table
    INSERT INTO ACCOUNT (CustomerID, BranchID, Type, Balance)
    VALUES (@CustomerID, @BranchID, @AccountType, @InitialBalance);
    -- Get the newly generated AccountNumber
    SET @AccountNumber = SCOPE_IDENTITY();
    -- Insert into ACCOUNT_BENEFICIARY table
    INSERT INTO ACCOUNT_BENEFICIARY (AccountNumber, [Name], Relationship)
    VALUES (@AccountNumber, @BeneficiaryName, @Relationship);
    -- Get the newly generated BeneficiaryID
    SET @BeneficiaryID = SCOPE_IDENTITY();
    -- Return the AccountNumber and BeneficiaryID
    SELECT @AccountNumber AS AccountNumber, @BeneficiaryID AS BeneficiaryID;
END;

GO
/*
    1. Stored Procedure - This SP is used to create loan for a existing customer. We will use this SP if customer is already registered with our bank and is 
    requesting for a loan.
*/
CREATE OR ALTER PROCEDURE CreateLoanAccountforExistingCustomer
    @CustomerID INT,
    @LoanType VARCHAR(255),
    @Amount DECIMAL(10, 2),
    @InterestRate DECIMAL(10, 2) AS BEGIN SET NOCOUNT ON;
    -- Check if the customer exists
    IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CustomerID = @CustomerID)
    BEGIN
        PRINT 'Customer does not exist.';
        RETURN;
    END;
    -- Check if the loan type is valid
    IF @LoanType NOT IN ('Education', 'Automobile', 'Property')
    BEGIN
        PRINT 'Invalid loan type.';
        RETURN;
    END;
    -- Insert new loan into LOAN table
    INSERT INTO LOAN (CustomerID, [Type], Amount, InterestRate)
    VALUES (@CustomerID, @LoanType, @Amount, @InterestRate);
    PRINT 'Loan account created successfully.';
END;


/*END of Creation of Accounts , Loan, Customer*/

GO
/*
1. stored procedures containing input and output parameters : This SP will be used to perform a ATM transaction. First it will deduct the amount from the source
account, add the record to the transaction table then add the record to ATM_TRANSACTION and finally deduct the amount from the ATM.
*/
CREATE PROCEDURE PERFORM_ATM_TRANSACTION @customer_id int, @source_account_number int, @amount decimal(10,2), @atm_id int, @status int OUTPUT  AS
DECLARE @transactionID int
DECLARE @OBankingID int
BEGIN
	SET NOCOUNT ON;
	SET @status = 0
	IF @customer_id not in (select CustomerID from Customer)
	BEGIN
		RAISERROR ('Invalid customer id %d', 16, 1, @customer_id)
		RETURN;
	END
	IF @source_account_number not in (select a.AccountNumber from Account a)
	BEGIN
		RAISERROR ('Invalid source account number. Kindly recheck the account number', 16, 1)
		RETURN;
	END
	
	--check if customer is authroized to perform the transaction
	IF @customer_id <> (select a.CustomerID from Account a where a.AccountNumber = @source_account_number)
	BEGIN
		RAISERROR ('This customer %d is not authorized to perform transaction on account %d', 16, 1, @customer_id, @source_account_number)
		RETURN;
	END

	IF @atm_id not in (select ATMID from ATM)
	BEGIN
		-- This is severe error because atm transactions happen at the atm and atm machine using this stored procedure is incorrectly configured
		RAISERROR ('Invalid ATM ID', 25, 1) WITH LOG;
		RETURN;
	END

	IF @amount <= 0
	BEGIN
		RAISERROR ('Invalid amount entered. Please enter a valid amount', 16, 1)
		RETURN
	END

	DECLARE @source_balance_before_transaction decimal(10,2)
	select @source_balance_before_transaction = a.balance from Account as a where a.AccountNumber = @source_account_number

	if(@source_balance_before_transaction - @amount < -100)
	BEGIN
		RAISERROR ('Insufficient balance, the maximum overdraft balance that we allow is 100 dollars', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION;
			-- deducting amount from the source account
			update Account SET balance = balance - @amount WHERE AccountNumber = @source_account_number;
			-- add records to transaction table
			INSERT into [TRANSACTION](SourceAccountNumber, DestinationAccountNumber, [Time], [Type], Amount)
			VALUES
			(@source_account_number, NULL , GETDATE(), 'ATM', @amount)
			SET @transactionID = SCOPE_IDENTITY();
			
			-- add the record to ATM_TRANSACTION table
			INSERT into ATM_TRANSACTION (ATransactionID, ATMID)
			VALUES
			(@transactionID, @atm_id)
			DECLARE @atm_balance_before_deducting decimal(10,2)
			SET @atm_balance_before_deducting = (select ATM.Balance from ATM where ATM.ATMID = @atm_id)
			if(@atm_balance_before_deducting - @amount < 0)
			BEGIN
				RAISERROR ('Insufficient balance in the ATM, try with a lower amount', 16, 1)
			END
			--deduct the amount from ATM
			update ATM SET Balance = Balance - @amount where ATMID = @atm_id
		COMMIT TRANSACTION;
		PRINT 'Transaction Completed Successfully'
		SET @status = 1
	END TRY
	BEGIN CATCH
		--rollback the transaction
		ROLLBACK TRANSACTION;
		--print error message
		PRINT ERROR_MESSAGE();
		PRINT 'TRANSACTION CANCELLED'
	END CATCH
END
GO

/*
1. stored procedures containing input and output parameters : This SP will be used to perform a Online transactions. First it will deduct the amount from the source
account, add the record to the transaction table then add the record to ONLINE_TRANSACTION and finally add the amount to destination account.
*/
CREATE PROCEDURE PERFORM_ONLINE_TRANSACTION @obanking_id int, @source_account_number int, @destination_account_number int, @amount decimal(10,2), @status int OUTPUT AS
DECLARE @transactionID int
DECLARE @customerId int
BEGIN
	SET NOCOUNT ON;
	SET @status = 0
	IF @obanking_id not in (select OBankingID from ONLINE_BANKING)
	BEGIN
		RAISERROR ('Invalid online banking id. Kindly recheck online banking id', 16, 1)
		RETURN
	END
	
	IF @source_account_number not in (select a.AccountNumber from Account a)
	BEGIN
		RAISERROR ('Invalid source account number. Kindly recheck the account number', 16, 1)
		RETURN
	END

	SET @customerId = (select CustomerID from ONLINE_BANKING where OBankingID = @obanking_id)

	IF @source_account_number not in (select AccountNumber from ACCOUNT where CustomerID = @customerId)
	BEGIN
		RAISERROR ('customer %d is not authorized to perform action on account %d', 16, 1, @customerId, @source_account_number)
		RETURN
	END

	
	IF @destination_account_number not in (select a.AccountNumber from Account a)
	BEGIN
		RAISERROR ('Invalid destination account number. Kindly recheck the account number', 16, 1)
		RETURN
	END

	IF @amount <= 0
	BEGIN
		RAISERROR ('Invalid amount entered. Please enter a valid amount', 16, 1)
		RETURN
	END

	DECLARE @source_balance_before_transaction decimal(10,2)
	select @source_balance_before_transaction = a.balance from Account as a where a.AccountNumber = @source_account_number

	if(@source_balance_before_transaction - @amount < -100)
	BEGIN
		RAISERROR ('Insufficient balance, the maximum overdraft balance that we offer is 100 dollars', 16, 1)
		RETURN;
	END

	
	BEGIN TRY
		BEGIN TRANSACTION
			-- deducting amount from the source account
			update Account SET balance = balance - @amount WHERE AccountNumber = @source_account_number;
			-- add records to transaction table
			INSERT into [TRANSACTION](SourceAccountNumber, DestinationAccountNumber, [Time], [Type], Amount)
			VALUES
			(@source_account_number, @destination_account_number, GETDATE(), 'Online', @amount)
			SET @transactionID = SCOPE_IDENTITY();
			-- add the record to ONLINE_TRANSACTION table
			INSERT into ONLINE_TRANSACTION (OTransactionID, OBankingID)
			VALUES
			(@transactionID, @obanking_id)
			-- crediting in the destination account
			update Account SET balance = balance + @amount WHERE AccountNumber = @destination_account_number;
		COMMIT TRANSACTION;
		PRINT 'Transaction Completed Successfully'
		SET @status = 1
	END TRY
	BEGIN CATCH
		--rollback the transaction
		ROLLBACK TRANSACTION;
		--print error message
		PRINT ERROR_MESSAGE();
		PRINT 'TRANSACTION CANCELLED'
	END CATCH
END
GO

/*
1. stored procedures containing input and output parameters : This SP will be used to perform a Branch transactions. First it will deduct the amount from the source
account, add the record to the transaction table then add the record to BRANCH_TRANSACTION and finally add the amount to destination account.
*/
CREATE PROCEDURE PERFORM_BRANCH_TRANSACTION @branch_id int, @source_account_number int, @destination_account_number int, @amount decimal(10,2), @status int OUTPUT  AS
DECLARE @transactionID int
BEGIN
	SET NOCOUNT ON;
	SET @status = 0
	IF @branch_id not in (select BRANCHID from BRANCH)
	BEGIN
		-- This is severe error because branch transactions happen at the branch and application using this stored procedure is incorrectly configured
		RAISERROR ('Invalid bank branch id', 25, 1) WITH LOG;
		RETURN
	END
	IF (@source_account_number IS NOT NULL) and (@source_account_number not in (select a.AccountNumber from Account a))
	BEGIN
		RAISERROR ('Invalid source account number. Kindly recheck the account number', 16, 1)
		RETURN
	END
	IF @destination_account_number not in (select a.AccountNumber from Account a)
	BEGIN
		RAISERROR ('Invalid destination account number. Kindly recheck the account number', 16, 1)
		RETURN
	END

	IF @amount <= 0
	BEGIN
		RAISERROR ('Invalid amount entered. Please enter a valid amount', 16, 1)
		RETURN
	END

	DECLARE @source_balance_before_transaction decimal(10,2)
	IF (@source_account_number IS NOT NULL)
	BEGIN
		select @source_balance_before_transaction = a.balance from Account as a where a.AccountNumber = @source_account_number

		if(@source_balance_before_transaction - @amount < -100)
		BEGIN
			RAISERROR ('Insufficient balance, the maximum overdraft balance that we offer is 100 dollars', 16, 1)
			RETURN;
		END
	END

	
	BEGIN TRY
		BEGIN TRANSACTION
			-- deducting amount from the source account
			IF (@source_account_number IS NOT NULL)
			BEGIN
				update Account SET balance = balance - @amount WHERE AccountNumber = @source_account_number;
			END
			-- add records to transaction table
			INSERT into [TRANSACTION](SourceAccountNumber, DestinationAccountNumber, [Time], [Type], Amount)
			VALUES
			(@source_account_number, @destination_account_number, GETDATE(), 'Branch', @amount)
			SET @transactionID = SCOPE_IDENTITY();
			-- add the record to BRANCH_TRANSACTION table
			INSERT into BRANCH_TRANSACTION (BTransactionID, BRANCHID)
			VALUES
			(@transactionID, @branch_id)
			-- crediting in the destination account
			update Account SET balance = balance + @amount WHERE AccountNumber = @destination_account_number;
		COMMIT TRANSACTION;
		PRINT 'Transaction Completed Successfully'
		SET @status = 1
	END TRY
	BEGIN CATCH
		--rollback the transaction
		ROLLBACK TRANSACTION;
		--print error message
		PRINT ERROR_MESSAGE();
		PRINT 'TRANSACTION CANCELLED'
	END CATCH
END

GO

-- 2. Views
--Customer,Account,Account beneficiary
CREATE VIEW CustomerAccountView AS
SELECT 
    C.CustomerID,
    C.Name AS CustomerName,
    A.AccountNumber,
    A.Type AS AccountType,
    AB.Name AS BeneficiaryName,
    AB.Relationship AS BeneficiaryRelationship
FROM 
    CUSTOMER C
JOIN 
    ACCOUNT A ON C.CustomerID = A.CustomerID
LEFT JOIN 
    ACCOUNT_BENEFICIARY AB ON A.AccountNumber = AB.AccountNumber;
GO
--3 views for customer who has 3 different types of loan and check on interest rate
CREATE VIEW CustomerLoanView AS
SELECT
    c.CustomerID,
    c.Name,
    c.BranchID,
    c.DOB,
    c.MobileNo,
    c.Email,
    c.Street,
    c.ZipCode,
    c.Age,
    l.LoanID,
    l.Type AS LoanType,
    l.Amount AS LoanAmount,
    l.InterestRate AS LoanInterestRate
FROM
    CUSTOMER c
INNER JOIN
    LOAN l ON c.CustomerID = l.CustomerID;
GO
-- View for Property Loans with Interest Rate > 4%
CREATE VIEW PropertyLoanView AS
SELECT *
FROM CustomerLoanView
WHERE LoanType = 'Property' AND LoanInterestRate > 4;
GO
-- View for Education Loans with Interest Rate > 4%
CREATE VIEW EducationLoanView AS
SELECT *
FROM CustomerLoanView
WHERE LoanType = 'Education' AND LoanInterestRate > 4;
GO
-- View for Automobile Loans with Interest Rate > 4%
CREATE VIEW AutomobileLoanView AS
SELECT *
FROM CustomerLoanView
WHERE LoanType = 'Automobile' AND LoanInterestRate > 4;
GO
--percentage of people using online, atm and branch
CREATE VIEW TransactionUsagePercentage AS
SELECT
    'Online' AS TransactionType,
    CAST(COUNT(OT.OTransactionID) * 100.0 / COUNT(T.TransactionID) AS DECIMAL(5, 2)) AS UsagePercentage
FROM
    "TRANSACTION" T
LEFT JOIN
    ONLINE_TRANSACTION OT ON T.TransactionID = OT.OTransactionID

UNION ALL

SELECT
    'ATM' AS TransactionType,
    CAST(COUNT(AT.ATransactionID) * 100.0 / COUNT(T.TransactionID) AS DECIMAL(5, 2)) AS UsagePercentage
FROM
    "TRANSACTION" T
LEFT JOIN
    ATM_TRANSACTION AT ON T.TransactionID = AT.ATransactionID

UNION ALL

SELECT
    'Branch' AS TransactionType,
    CAST(COUNT(BT.BTransactionID) * 100.0 / COUNT(T.TransactionID) AS DECIMAL(5, 2)) AS UsagePercentage
FROM
    "TRANSACTION" T
LEFT JOIN
    BRANCH_TRANSACTION BT ON T.TransactionID = BT.BTransactionID;
GO

/* The Transaction Summary View categorizes transactions into four periods: morning, afternoon, evening, and night, 
   providing the total number and amount of transactions during each period.
*/
CREATE VIEW TransactionSummaryView AS
SELECT
    CASE
        WHEN DATEPART(HOUR, [Time]) >= 6 AND DATEPART(HOUR, [Time]) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) >= 12 AND DATEPART(HOUR, [Time]) < 18 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) >= 18 AND DATEPART(HOUR, [Time]) < 24 THEN 'Evening'
        ELSE 'Night'
    END AS Period,
    ISNULL(COUNT(*), 0) AS TotalTransactions,
    ISNULL(SUM(Amount), 0) AS TotalAmount
FROM
    [TRANSACTION]
GROUP BY
    CASE
        WHEN DATEPART(HOUR, [Time]) >= 6 AND DATEPART(HOUR, [Time]) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) >= 12 AND DATEPART(HOUR, [Time]) < 18 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) >= 18 AND DATEPART(HOUR, [Time]) < 24 THEN 'Evening'
        ELSE 'Night'
    END

GO
-- 3. DML Trigger: This trigger enforces that the loan payment amounts account exceed the total loan amount
CREATE TRIGGER EnforceLoanPaymentsLimit
ON LOAN_PAYMENT
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @LoanID INT;
    DECLARE @TotalPayments DECIMAL(10, 2);
    DECLARE @LoanAmount DECIMAL(10, 2);

    -- Get the LoanID for the inserted or updated row
    SELECT @LoanID = LoanID FROM inserted;

    -- Get the total payments for the current loan
    SELECT @TotalPayments = SUM(Amount) FROM LOAN_PAYMENT WHERE LoanID = @LoanID;

    -- Get the loan amount for the current loan
    SELECT @LoanAmount = Amount FROM LOAN WHERE LoanID = @LoanID;

    -- Check if the total payments exceed the loan amount
    IF @TotalPayments > @LoanAmount
    BEGIN
        -- Rollback the transaction
        RAISERROR('Total payments for the loan cannot exceed the loan amount', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

GO


/*
3. DML Trigger: This triggers when a new transaction record is created and takes action when amount greater than an alert threshold amount which is 1000 dollars is 
performed. The action that it will perform is insert the record into the ALERTS table and records into the CUSTOMER_ALERTS. This also takes care of the case 
that alert won't be triggered for deposit transaction(cash deposit at the bank).
*/
CREATE TRIGGER CUSTOMER_ALERT
on [transaction]
AFTER INSERT
AS
BEGIN
	declare @alert_threshold_amount int = 1000
	DECLARE @customer_alert_count int
	SET @customer_alert_count = 0
	declare @customer_amounts TABLE (
		customer_id int,
		amount decimal(10,2)
	)

	INSERT into @customer_amounts(customer_id, amount)
	select a.CustomerID ,i.amount from inserted i join ACCOUNT a on i.SourceAccountNumber = a.AccountNumber
	where i.amount > @alert_threshold_amount
	
	BEGIN TRY
		DECLARE @customer_id int
		DECLARE @message varchar(1000)
		DECLARE @type varchar(20)
		DECLARE @current_data_time datetime
		DECLARE @alert_id int
		--declare a cursor for alert data
		DECLARE c_alert_cursor CURSOR LOCAL FOR
		select ca.customer_id, 'High Value Transaction of ' + CONVERT(varchar(20), ca.amount) + ' dollars','Customer', GETDATE() from @customer_amounts ca

		--open cursor
		OPEN c_alert_cursor;

		--Fetch first row from cursor
		FETCH NEXT from c_alert_cursor INTO @customer_id, @message, @type, @current_data_time

		--Loop through records until no more are left
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--INSERT the alert data into the Alerts table
			INSERT into ALERTS([Message], [Type], [Time])
			VALUES (@message, @type, @current_data_time)
			--GET the last generated alert id
			SET @alert_id = SCOPE_IDENTITY();
			--INSERT alert data into the CUSTOMER_ALERTS table
			INSERT into CUSTOMER_ALERTS(CAlertID, CustomerID)
			VALUES (@alert_id, @customer_id)
			FETCH NEXT from c_alert_cursor INTO @customer_id, @message, @type, @current_data_time
			SET @customer_alert_count = @customer_alert_count + 1
		END	
		CLOSE c_alert_cursor;
		IF @customer_alert_count > 0
		BEGIN
			PRINT 'SUCCESSFULLY CREATED ' + CONVERT(varchar(5), @customer_alert_count) + ' CUSTOMER ALERTS'
		END
	END TRY
	BEGIN CATCH
		IF @customer_alert_count > 0
		BEGIN
			PRINT 'SUCCESSFULLY CREATED ' + CONVERT(varchar(5), @customer_alert_count) + ' CUSTOMER ALERTS'
		END
		PRINT ERROR_MESSAGE();
		PRINT 'SOMETHING WENT WRONG WHILE CHECKING FOR ALERTS. HENCE ABORTING THE EVENT WHICH CALLED THIS TRIGGER'
	END CATCH
END

GO
/*
3. DML Trigger: This triggers when a ATM table is updated and takes action when balance of the amount is less than the threshould which is 15000 dollars. The action 
that it will perform is to insert the record into the ALERTS table and records into the ATM_ALERTS table.
*/
CREATE TRIGGER ATM_ALERT
on [ATM]
AFTER INSERT, UPDATE
AS
BEGIN
	declare @alert_threshold_amount int = 15000
	DECLARE @atm_alert_count int
	SET @atm_alert_count = 0
	BEGIN TRY
		DECLARE @atm_id int
		DECLARE @message varchar(1000)
		DECLARE @type varchar(20)
		DECLARE @current_data_time datetime
		DECLARE @alert_id int
		--declare a cursor for alert data
		DECLARE a_alert_cursor CURSOR LOCAL FOR
		select i.ATMID, 'ATM is running low on money, ' + CONVERT(varchar(20), i.Balance) + ' dollars left' , 'ATM', GETDATE() FROM inserted i where i.Balance < @alert_threshold_amount

		--open cursor
		OPEN a_alert_cursor;

		--Fetch first row from cursor
		FETCH NEXT from a_alert_cursor INTO @atm_id, @message, @type, @current_data_time
		--Loop through records until no more are left
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--INSERT the alert data into the Alerts table
			INSERT into ALERTS([Message], [Type], [Time])
			VALUES (@message, @type, @current_data_time)
			--GET the last generated alert id
			SET @alert_id = SCOPE_IDENTITY();
			--INSERT alert data into the ATM_ALERTS table
			INSERT into ATM_ALERTS(AlertID, ATMID)
			VALUES (@alert_id, @atm_id)
			FETCH NEXT from a_alert_cursor INTO @atm_id, @message, @type, @current_data_time
			SET @atm_alert_count = @atm_alert_count + 1
		END	
		IF @atm_alert_count > 0
		BEGIN
			PRINT 'SUCCESSFULLY CREATED ' + CONVERT(varchar(5), @atm_alert_count) + ' ATM ALERTS'
		END
		CLOSE a_alert_cursor;
	END TRY
	BEGIN CATCH
		IF @atm_alert_count > 0
		BEGIN
			PRINT 'SUCCESSFULLY CREATED ' + CONVERT(varchar(5), @atm_alert_count) + ' ATM ALERTS'
		END
		PRINT ERROR_MESSAGE();
		PRINT 'SOMETHING WENT WRONG WHILE CHECKING FOR ALERTS. HENCE ABORTING THE EVENT WHICH CALLED THIS TRIGGER'
	END CATCH
END
GO


/*5. Computed Columns based on a user defined function (UDF): This is a user defined function is calculate credit score */
CREATE FUNCTION dbo.calculate_credit_score
(
	@customer_id int
)
RETURNS int
AS
BEGIN
	DECLARE @total_credit_score int = 0
	DECLARE @no_of_months int
	DECLARE @no_of_accounts int
	DECLARE @total_balance int
	DECLARE @no_of_loans int
	DECLARE @avg_percentage_of_all_loans int

	--For every month the customer is with the bank, add 20 credit score.
	select @no_of_months = DATEDIFF(month, c.RegistrationDate, GETDATE()) from CUSTOMER c where c.CustomerID = @customer_id
	SET @total_credit_score = @total_credit_score + (@no_of_months * 20)

	--For every account the customer has in our bank, add 10 credit score
	select @no_of_accounts = ISNULL(count(a.AccountNumber), 0) from Account a where a.CustomerID = @customer_id
	SET @total_credit_score = @total_credit_score + (@no_of_accounts * 10)

	-- add (Sum of all balances in the all accounts / 40) to credit score
	select @total_balance = ISNULL(sum(a.Balance), 0) from ACCOUNT a where a.CustomerID = @customer_id
	SET @total_credit_score = @total_credit_score + (@total_balance / 40)

	-- For every loan customer has already taken substract 50 credit score
	select @no_of_loans = ISNULL(count(l.LoanID), 0) from LOAN l where l.CustomerID = @customer_id
	SET @total_credit_score = @total_credit_score - (@no_of_loans * 50)
	
	-- add (total of all loan paid back / total of all loan paid amount) * 100 * 2
	select @avg_percentage_of_all_loans = ISNULL((SUM(lp.Amount) / AVG(l.Amount)) * 200, 0) from LOAN l join LOAN_PAYMENT lp on l.LoanID = lp.LoanID where l.CustomerID = @customer_id
	SET @total_credit_score = @total_credit_score + @avg_percentage_of_all_loans

	--return computed credit score
	return @total_credit_score
END

GO

-- 5. Computed Columns based on a user defined function (UDF): add computed column CreditScore as user defined function dbo.calculate_credit_score
ALTER TABLE CUSTOMER
ADD CreditScore AS dbo.calculate_credit_score(CustomerID);


/* 6. Master Key, Certificate and Symmetric Key for Column data encryption */
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'damg6210';
CREATE CERTIFICATE MyCertificate WITH SUBJECT = 'ONLINEBANKINGPASSWORD';
CREATE SYMMETRIC KEY OBPass_SM WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE MyCertificate


/*7. at least 3 non-clustered indexes */
/* creating index for SourceAccountNumber on the Transaction table because it is 
very often used to retrieve transaction history of an account and also for joins and filtering.
This will drastically improve the performance*/
CREATE NONCLUSTERED INDEX IX_SourceAccountNumber  ON [TRANSACTION](SourceAccountNumber);

/* creating index for SourceAccountNumber on the Transaction table because it is 
very often used to retrieve transaction history of an account, joins, filtering.
This will drastically improve the performance*/
CREATE NONCLUSTERED INDEX IX_DestinationAccountNumber ON [TRANSACTION](DestinationAccountNumber);

/* creating index for EmailId on the Customer table because in traditional bank system,
customers are often identified by their email ids because everyone always remembers their email id.
Creating an index on such a column will improve the performance of the application relying on them and also
will improve the user experience*/
CREATE NONCLUSTERED INDEX IX_CustomerEmailId ON [CUSTOMER](Email);

/* creating index for CustomerID on Accounts table because it is always involved in joins, filtering, grouping
and other complex requiries. This will drastically improve the performance*/
CREATE NONCLUSTERED INDEX IX_Acc_CustomerId ON [Account](CustomerID);