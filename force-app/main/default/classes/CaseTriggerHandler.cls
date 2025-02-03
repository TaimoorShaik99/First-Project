public class CaseTriggerHandler {
    
    //Update case number is account custom fields
    public static void latestCaseNo(List<Case> caseList){
        List<Account> accList=new List<Account>();
        for(Case cs : caseList){
            if(cs.AccountId!=null){
                Account acc=new Account();
                acc.id = cs.AccountId;
                acc.Latest_Case_Number__c = cs.CaseNumber;
                accList.add(acc);
            }
            if(!accList.isEmpty()){
                Update accList;
            }
        }
    }
}