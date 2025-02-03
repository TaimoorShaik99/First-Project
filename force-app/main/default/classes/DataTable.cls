public class DataTable {
   @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        List<Account> accList = [Select id,Name,Phone from Account limit 20];
        return accList;
        }
    
}