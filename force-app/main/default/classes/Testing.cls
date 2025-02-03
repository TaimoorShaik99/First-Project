@isTest
private class Testing {

    @isTest
    static void phoneCantBeNull(){
        Account acc=new Account();
        acc.Name='Testing 1';
        
        insert acc;
    }
    
    
}