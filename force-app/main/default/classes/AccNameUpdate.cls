public class AccNameUpdate {
 
    public static void nameUpdate(List<Account> accList, Map<id, Account> oldMap){
        for(Account acc:accList){
            if(oldMap.get(acc.Id) != null && acc.Name!=oldMap.get(acc.Id).Name){
                acc.Name_Changed__c=True;
            }
    }
}
}