public class AccountTriggerHandler {
    
    
    public static void phoneCantBeNull(List<Account> accList){
        for(Account acc:accList){
            if(acc.Phone==null || acc.Phone==''){
                acc.addError('Phone cant be null');
                insert acc;
            }
        }
    }

    // Copy Billing Add to Shipping Add
    public static void copyBillToShipAdd(List<Account> accList){
        for(Account acc: accList){
            if(acc.BillingCountry!=null || acc.BillingState!=null || acc.BillingCity!=null){
                acc.ShippingCountry=acc.BillingCountry;
                acc.ShippingState=acc.BillingState;
                acc.ShippingCity=acc.BillingCity;
            }
        }
    }
    
    // If industry is media rating should be Hot
    public static void mediaHot(List<Account> accList){
        for(Account acc: accList){
            if(acc.Industry!=null || acc.Industry=='Media'){
                acc.Rating='Hot';
            }
        }
    }
    
    //Throw an error if Annual Revenue is less than 1000
    public static void annaulRevenue(List<Account> accList){
      for(Account acc : accList){
          if(acc.AnnualRevenue<1000){
              acc.addError('Annual Revenue Cannot be Less Than 1000');
          }
       }
    }
    
    //Create related contact when new account is created
    public static void relatedContact(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            Contact con=new Contact();
            con.AccountId=acc.Id;
            con.LastName=acc.Name;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }
    
    //Throw Error if Account Name is Modified
    public static void accNameUpdateError(List<Account> accList){
        for(Account acc: accList){
            Account accOld=(Account)Trigger.oldMap.get(acc.Id);
            if(acc.Name!=accOld.Name){
                acc.addError('Account Name Cannot be Modified');
            }
        }
    }
    
    //Active account should not be deleted
    public static void activeAccount(List<Account> accList){
        for(Account acc: accList){
            if(acc.Active__c=='Yes'){
                acc.addError('Active Account cannot be deleted');
            }
        }
    }
    
    //Realted Opportunity
    public static void relatedOpp(List<Account> accList){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc : accList){
            Opportunity opp=new Opportunity();
            opp.AccountId=acc.Id;
            opp.Name=acc.Name;
            opp.StageName='Prospecting';
            opp.CloseDate=System.TODAY();
            oppList.add(opp);
        }
        if(!oppList.isEmpty()){
            insert oppList;
        }
    }
    }