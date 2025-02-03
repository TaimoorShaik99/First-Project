@isTest
public class AccountControllerTes {
    @isTest
    static void testCreateAccount() {
        Account acc = new Account(
            Name = 'TestAccount',
            AccountNumber = '12345',
            BillingStreet = '123 Test Street',
            Description = 'Test Description'
        );

        Test.startTest();
        Account result = AccountController.createOrUpdateAccount(acc);
        Test.stopTest();

       
        System.assertNotEquals(result.Id, null, 'Account ID should not be null');
        System.assertEquals(result.Name, 'TestAccount', 'Account name should match');
    }

    @isTest
    static void testUpdateAccount() {
        Account acc = new Account(
            Name = 'TestAccount',
            AccountNumber = '12345',
            BillingStreet = '123 Test Street',
            Description = 'Test Description'
        );
        insert acc;

        
        acc.Name = 'UpdatedTestAccount';

        Test.startTest();
        Account result = AccountController.createOrUpdateAccount(acc);
        Test.stopTest();

       
        System.assertEquals(result.Name, 'UpdatedTestAccount', 'Account name should be updated');
    }

}