@isTest
public class AccNameUpdateTest {
    @isTest
    static void testNameChange() {
        // Test data setup
        Account oldAcc = new Account(Name = 'Old Account Name');
        insert oldAcc;
        // Create a map of old accounts
        Map<Id, Account> oldMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id = :oldAcc.Id]);
        // Update the account name
        Account updatedAcc = [SELECT Id, Name, Name_Changed__c FROM Account WHERE Id = :oldAcc.Id];
        updatedAcc.Name = 'New Account Name';
        // Create list for trigger
        List<Account> accList = new List<Account>{updatedAcc};
        // Call the method
        Test.startTest();
        AccNameUpdate.nameUpdate(accList, oldMap);
        Test.stopTest();
        // Verify the results
        System.assertEquals(true, accList[0].Name_Changed__c, 'Name_Changed__c should be true when name is updated');
    }
    @isTest
    static void testNoNameChange() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        // Create a map of old accounts
        Map<Id, Account> oldMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id = :acc.Id]);
        // Get the same account without changing the name
        Account unchangedAcc = [SELECT Id, Name, Name_Changed__c FROM Account WHERE Id = :acc.Id];
        // Create list for trigger
        List<Account> accList = new List<Account>{unchangedAcc};
        // Call the method
        Test.startTest();
        AccNameUpdate.nameUpdate(accList, oldMap);
        Test.stopTest();
        // Verify the results
        System.assertEquals(false, accList[0].Name_Changed__c, 'Name_Changed__c should remain null when name is not changed');
    }
}