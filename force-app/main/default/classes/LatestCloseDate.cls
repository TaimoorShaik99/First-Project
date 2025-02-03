public class LatestCloseDate {
    public static void closedate(List<Opportunity> oppList){
        List<Account> accList = new List<Account>();
        List<opportunity> oppCloseDate=[SELECT Id, Name,AccountId, Account.Name, CloseDate, Account.Opp_Close_Date__c FROM Opportunity WHERE StageName = 'Closed Won' ORDER BY CloseDate ASC limit 1];
        for(Opportunity opp: oppList){
            Account acc=new Account();
            acc.id=opp.AccountId;
            acc.Opp_Close_Date__c=opp.CloseDate;
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            update accList;
        }
            
        }
    }