from django.contrib import admin

from bank_app.models import * 

# Register your models here.
admin.site.register(ZipCode)
admin.site.register(Branch)
admin.site.register(Employee)
admin.site.register(Customer)
admin.site.register(Alerts)
admin.site.register(OnlineBanking)
admin.site.register(Account)
admin.site.register(ATM)
admin.site.register(Loan)
admin.site.register(Transaction)
admin.site.register(LoanPayment)
admin.site.register(AccountBeneficiary)
admin.site.register(Manager)
admin.site.register(CustomerAlerts)
admin.site.register(AtmAlerts)
admin.site.register(OnlineTransaction)
admin.site.register(ATMTransaction)
admin.site.register(BranchTransaction)