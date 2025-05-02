// AccountDataTableController.cls
public with sharing class AccountDataTableController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Phone, Industry, Rating 
                FROM Account 
                LIMIT 10];
    }
    
    @AuraEnabled
    public static void updateAccounts(List<Account> accountsToUpdate) {
        try {
            // Add field validation here if needed
            update accountsToUpdate;
        } catch(Exception e) {
            throw new AuraHandledException('Error updating accounts: ' + e.getMessage());
        }
    }
}