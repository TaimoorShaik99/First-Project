public class AccountTriggerHandler {
    
    
    public static void accountUpdate(list<Account> acclist, map<ID, Account> oldMap){
        for(Account acc : acclist){
            if(oldMap.get(acc.Id).name != null && acc.name != oldMap.get(acc.Id).name){
                acc.Name_changed__c = true;
            }
        }
    }
}