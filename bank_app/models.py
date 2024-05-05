from django.db import models

# Create your models here.
from django.db import models
from datetime import date
from datetime import datetime
from django.core.exceptions import ValidationError
from django.core.validators import MinValueValidator
from django.core.validators import MaxValueValidator
from django.utils import timezone

# Create your models here.

class ZipCode(models.Model):
    zipcode = models.IntegerField(primary_key=True)
    state = models.CharField(max_length=50)
    city = models.CharField(max_length=50)
    country = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'ZIPCODE'

    def __str__(self):
        return f"{self.zipcode}, {self.city}, {self.state}, {self.country}"
    

class Branch(models.Model):
    BranchID = models.IntegerField(primary_key=True)
    street = models.CharField(max_length=255)
    ZipCode = models.ForeignKey(ZipCode, on_delete=models.DO_NOTHING, related_name='branch_zipcode', db_column='zipcode')

    class Meta:
        managed = False
        db_table = 'BRANCH'

    def __str__(self):
        return f"Branch ID: {self.BranchID}, Street: {self.street}, Zip Code: {self.ZipCode}"
    
class Employee(models.Model):
    EmployeeID = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    position = models.CharField(max_length=255)
    BranchID = models.ForeignKey(Branch, on_delete=models.DO_NOTHING, related_name='employee_branch', to_field='BranchID', db_column='BranchID')

    class Meta:
        managed = False
        db_table = 'EMPLOYEE'

    def __str__(self):
        return f"Employee ID: {self.EmployeeID}, Name: {self.name}, Position: {self.position}, Branch: {self.BranchID}"
    
class Customer(models.Model):
    CustomerID = models.AutoField(primary_key=True)
    Name = models.CharField(max_length=255)
    BranchID = models.ForeignKey(Branch, on_delete=models.DO_NOTHING, related_name='customer_branch', db_column='BranchID')
    DOB = models.DateField()
    RegistrationDate = models.DateField(auto_now_add=True)
    MobileNo = models.CharField(max_length=20, unique=True)
    Email = models.EmailField(max_length=255, unique=True, null=True, blank=True)
    Street = models.CharField(max_length=255, null=True, blank=True)
    ZipCode = models.ForeignKey(ZipCode, on_delete=models.DO_NOTHING, related_name='customer_zipcode',  db_column='ZipCode')
    # Age = models.IntegerField()

    

    def clean(self):
        if self.RegistrationDate is not None and self.RegistrationDate > date.today():
            raise ValidationError("Registration date cannot be in the future.")

        if self.DOB > date.today():
            raise ValidationError("Date of birth cannot be in the future.")

    class Meta:
        managed = False
        db_table = 'CUSTOMER'

class Alerts(models.Model):
    AlertID = models.AutoField(primary_key=True)
    Message = models.CharField(max_length=500)
    ATM = 'ATM'
    CUSTOMER = 'Customer'
    TYPE_CHOICES = [
        (ATM, 'ATM'),
        (CUSTOMER, 'Customer'),
    ]
    Type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    Time = models.DateTimeField()

    def clean(self):
        if self.Time.time() > timezone.now().time():
            raise ValidationError("Time must be less than or equal to the current time.")

    class Meta:
        managed = False
        db_table = 'ALERTS'

    def __str__(self):
        return f"Alert ID: {self.AlertID}, Type: {self.Type}, Time: {self.Time}"
    

class OnlineBanking(models.Model):
    OBankingID = models.IntegerField(primary_key=True)
    CustomerID = models.ForeignKey(Customer, on_delete=models.DO_NOTHING, related_name = "online_customer",  db_column='CustomerID')
    RegistrationDate = models.DateField()
    LastAccessDate = models.DateField()
    Password = models.BinaryField()

    class Meta:
        managed = False
        db_table = 'ONLINE_BANKING'
    

    def __str__(self):
        return f"Online Banking ID: {self.OBankingID}, Customer ID: {self.CustomerID}, Registration Date: {self.RegistrationDate}, Last Access Date: {self.LastAccessDate}"

    def clean(self):
        if self.RegistrationDate > datetime.now().date():
            raise ValidationError("Registration Date cannot be in the future")

        if self.LastAccessDate > datetime.now().date():
            raise ValidationError("Last Access Date cannot be in the future")
        

class Account(models.Model):
    AccountNumber = models.AutoField(primary_key=True)
    CustomerID = models.ForeignKey(Customer, on_delete=models.DO_NOTHING, related_name="customer_account",  db_column='CustomerID')
    BranchID = models.ForeignKey(Branch, on_delete=models.DO_NOTHING, related_name="account_branch",  db_column='BranchID')
    Type = models.CharField(max_length=255, choices=[('Savings', 'Savings'), ('Current', 'Current')])
    Balance = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'ACCOUNT'

    def __str__(self):
        return f"Account {self.AccountNumber}"

    def clean(self):
        if self.Type not in ['Savings', 'Current']:
            raise ValidationError("Account type must be either 'Savings' or 'Current'.")

        if self.Balance < -100:
            raise ValidationError("Balance cannot be less than -100.")
        
class ATM(models.Model):
    ATMId = models.AutoField(primary_key=True)
    BranchID = models.ForeignKey(Branch, on_delete=models.DO_NOTHING, related_name="atm_branch",  db_column='BranchID')
    Balance = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    Street = models.CharField(max_length=255)
    ZipCode = models.ForeignKey(ZipCode, on_delete=models.DO_NOTHING, related_name="zipcode_atm",  db_column='ZipCode')

    class Meta:
        managed = False
        db_table = 'ATM'
    def __str__(self):
        return f"ATM ID: {self.ATMId}, Branch ID: {self.BranchID}, Balance: {self.Balance}, Location: {self.Street}, Zip Code: {self.ZipCode}"

    def clean(self):
        if self.Balance < 0:
            raise ValidationError("Balance must be greater than or equal to 0")
        
class Loan(models.Model):
    LoanID = models.AutoField(primary_key=True)
    CustomerID = models.ForeignKey(Customer, on_delete=models.DO_NOTHING, related_name="customer_loan",  db_column='CustomerID')
    Type = models.CharField(max_length=255, choices=[('Education', 'Education'), ('Automobile', 'Automobile'), ('Property', 'Property')])
    Amount = models.DecimalField(max_digits=10, decimal_places=2)
    InterestRate = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0), MaxValueValidator(100)])

    class Meta:
        managed = False
        db_table = 'LOAN'

    def __str__(self):
        return f"Loan ID: {self.LoanID}, Customer ID: {self.CustomerID}, Type: {self.Type}, Amount: {self.Amount}, Interest Rate: {self.InterestRate}"

class Transaction(models.Model):
    TransactionID = models.AutoField(primary_key=True)
    SourceAccountNumber = models.ForeignKey(Account, null=True, blank=True, on_delete=models.DO_NOTHING, related_name='source_transaction_accounts',  db_column='SourceAccountNumber')  # Allow null for 'Branch' type
    DestinationAccountNumber = models.ForeignKey(Account,null=True, blank=True, on_delete=models.DO_NOTHING, related_name='destination_transaction_accounts', db_column='DestinationAccountNumber')  # Allow null for 'ATM' type
    Time = models.DateTimeField(auto_now_add=True)
    Type = models.CharField(max_length=255, choices=[('Online', 'Online'), ('ATM', 'ATM'), ('Branch', 'Branch')])
    Amount = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])

    class Meta:
        managed = False
        db_table = 'TRANSACTION'

    def clean(self):
        if self.Time.time() > datetime.now().time():
            raise ValidationError("Transaction time cannot be in the future.")
        if self.Type == 'ATM' and self.DestinationAccountNumber is not None:
            raise ValidationError("Destination account number should be null for ATM transactions.")
        if self.Type != 'Branch' and self.SourceAccountNumber is None:
            raise ValidationError("Source account number cannot be null for non-branch transactions.")

    def __str__(self):
        return f"Transaction ID: {self.TransactionID}, Type: {self.Type}, Amount: {self.Amount}, Time: {self.Time}"


class LoanPayment(models.Model):
    PaymentID = models.AutoField(primary_key=True)
    LoanID = models.ForeignKey(Loan, on_delete=models.DO_NOTHING, related_name="loanpayment_loan", db_column='LoanID')
    Amount = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    Date = models.DateField()

    class Meta:
        managed = False
        db_table = 'LOAN_PAYMENT'

    def clean(self):
        if self.Amount < 0:
            raise ValidationError("Amount cannot be negative")
        
        if self.Date > datetime.now().date():
            raise ValidationError("Date cannot be in the future")
        
    def __str__(self):
        return f"Payment ID: {self.PaymentID}, Loan ID: {self.LoanID}, Amount: {self.Amount}, Date: {self.Date}"
    
class AccountBeneficiary(models.Model):
    BeneficiaryID = models.AutoField(primary_key=True)
    AccountNumber = models.ForeignKey(Account, on_delete=models.DO_NOTHING, related_name="accountbeneficiary_account", db_column='AccountNumber')
    Name = models.CharField(max_length=255)
    Relationship = models.CharField(max_length=255, choices=[
        ('Son', 'Son'),
        ('Mother', 'Mother'),
        ('Father', 'Father'),
        ('Sister', 'Sister'),
        ('Brother', 'Brother')
    ])

    class Meta:
        managed = False
        db_table = 'ACCOUNT_BENEFICIARY'

    def __str__(self):
        return f"{self.Name} - {self.Relationship}"

class Manager(models.Model):
    ManagerId = models.ForeignKey(Employee, primary_key=True, on_delete=models.DO_NOTHING, related_name="manager_employee", db_column='ManagerId')
    BranchId = models.ForeignKey(Branch, on_delete=models.DO_NOTHING, related_name="branch_manager", db_column='BranchId')

    class Meta:
        managed = False
        db_table = 'MANAGER'

    def __str__(self):
        return f"Manager ID: {self.ManagerId}, Branch ID: {self.BranchId}"
    
class CustomerAlerts(models.Model):
    CAlertID = models.ForeignKey(Alerts,primary_key=True, on_delete=models.DO_NOTHING, related_name="customeralert_alert", db_column='CAlertID')
    CustomerID = models.ForeignKey(Customer, on_delete=models.DO_NOTHING, related_name="customeralert_alert", db_column='CustomerID')

    class Meta:
        managed = False
        db_table = 'CUSTOMER_ALERTS'

    def __str__(self):
        return f"Customer Alert ID: {self.CAlertID}"

class AtmAlerts(models.Model):
    AlertID = models.ForeignKey(Alerts,primary_key=True, on_delete=models.DO_NOTHING, related_name="atmalert_alert", db_column='AlertID')
    ATMId = models.ForeignKey(ATM, on_delete=models.DO_NOTHING, related_name="atm_atmalerts", db_column='ATMId')

    class Meta:
        managed = False
        db_table = 'ATM_ALERTS'        

    def __str__(self):
        return f"ATM Alert ID: {self.AlertID}"
    
class OnlineTransaction(models.Model):
    OTransactionID = models.ForeignKey(Transaction,primary_key=True, on_delete=models.DO_NOTHING, related_name="onlinetransaction_transaction", db_column='OTransactionID')
    OBankingID = models.ForeignKey(OnlineBanking, on_delete=models.DO_NOTHING, related_name="onlinetransaction_transaction", db_column='OBankingID')

    class Meta:
        managed = False
        db_table = 'ONLINE_TRANSACTION'        

    def __str__(self):
        return f"Online Transaction ID: {self.OTransactionID}"
    
class ATMTransaction(models.Model):
    ATransactionID = models.ForeignKey(Transaction,primary_key=True, on_delete=models.DO_NOTHING, related_name="atmtransaction_transaction", db_column='ATransactionID')
    ATMID = models.ForeignKey(ATM, on_delete=models.DO_NOTHING, related_name="atmtransaction_atm", db_column='ATMID')

    class Meta:
        managed = False
        db_table = 'ATM_TRANSACTION'        

    def __str__(self):
        return f"ATM Transaction ID: {self.ATransactionID}"
    
class BranchTransaction(models.Model):
    BTransactionID = models.ForeignKey(Transaction,primary_key=True, on_delete=models.DO_NOTHING, related_name="branchtransaction_transaction", db_column='BTransactionID')
    BRANCHID = models.ForeignKey(Branch, on_delete=models.DO_NOTHING, related_name="branchtransaction_branch", db_column='BRANCHID')

    class Meta:
        managed = False
        db_table = 'BRANCH_TRANSACTION'        

    def __str__(self):
        return f"Branch Transaction ID: {self.BTransactionID}"
    
class test(models.Model):
    num = models.IntegerField()
