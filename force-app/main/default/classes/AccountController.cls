public  class AccountController {
 @AuraEnabled
    public static Account createOrUpdateAccount(Account accountData) {
        try {
            List<Account> accList =[Select id, Name from Account where Name =: accountData.Name];
            if (!accList.isEmpty()) {
                accountData.Id = accList[0].Id;
                update accountData;
            } else {
                insert accountData;
            }
            return accountData;
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
}