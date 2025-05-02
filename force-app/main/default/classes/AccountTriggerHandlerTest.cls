@IsTest
public class AccountTriggerHandlerTest {
    @isTest
    static void testNameChange() {
        // Create test account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        // Verify initial state
        System.assertEquals(false, acc.Name_Changed__c, 'Name_Changed__c should be false initially');
        // Update account name
        Test.startTest();
        acc.Name = 'Updated Test Account';
        update acc;
        Test.stopTest();
        // Query and verify the result
        Account updatedAcc = [SELECT Id, Name, Name_Changed__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(true, updatedAcc.Name_Changed__c, 'Name_Changed__c should be true after name update');
    }
    @isTest
    static void testBulkNameChange() {
        // Create multiple test accounts
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            accList.add(new Account(Name = 'Test Account ' + i));
        }
        insert accList;
        // Update names
        for(Account acc : accList) {
            acc.Name = 'Updated ' + acc.Name;
        }
        Test.startTest();
        update accList;
        Test.stopTest();
        // Query and verify results
        List<Account> updatedAccs = [SELECT Id, Name_Changed__c FROM Account WHERE Id IN :accList];
        for(Account acc : updatedAccs) {
            System.assertEquals(true, acc.Name_Changed__c, 'Name_Changed__c should be true after bulk update');
        }
    }
    @isTest
    static void testNoNameChange() {
        // Create test account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        // Update different field
        Test.startTest();
        acc.Industry = 'Technology';
        update acc;
        Test.stopTest();
        // Query and verify result
        Account updatedAcc = [SELECT Id, Name_Changed__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(false, updatedAcc.Name_Changed__c, 'Name_Changed__c should remain false when name is not changed');
    }
}