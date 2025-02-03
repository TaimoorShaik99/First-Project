@isTest
private class AccountControllerNavTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test Account
        Account testAccount = new Account(
            Name = 'Test Account',
            Industry = 'Technology',
            Phone = '1234567890'
        );
        insert testAccount;
        
        // Create test Opportunities
        List<Opportunity> testOpps = new List<Opportunity>();
        testOpps.add(new Opportunity(
            Name = 'Test Opp 1',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 10000
        ));
        testOpps.add(new Opportunity(
            Name = 'Test Opp 2',
            AccountId = testAccount.Id,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30),
            Amount = 20000
        ));
        insert testOpps;
    }
    
    @isTest
    static void testGetAccounts() {
        // Test getAccounts method
        Test.startTest();
        List<Account> accounts = AccountControllerNav.getAccounts();
        Test.stopTest();
        
        // Verify results
        Assert.isTrue(!accounts.isEmpty(), 'Should return at least one account');
        Assert.areEqual('Test Account', accounts[0].Name, 'Account name should match');
        Assert.areEqual('Technology', accounts[0].Industry, 'Industry should match');
        Assert.areEqual('1234567890', accounts[0].Phone, 'Phone should match');
    }
    
    @isTest
    static void testGetOpportunities() {
        // Get test account
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // Test getOpportunities method
        Test.startTest();
        List<Opportunity> opportunities = AccountControllerNav.getOpportunities(testAccount.Id);
        Test.stopTest();
        
        // Debug statements to verify data
        System.debug('Opportunities returned: ' + opportunities);
        
        // Verify results
        Assert.areEqual(2, opportunities.size(), 'Should return two opportunities');
        Assert.areEqual('Test Opp 1', opportunities[0].Name, 'First opportunity name should match');
        Assert.areEqual('Test Opp 2', opportunities[1].Name, 'Second opportunity name should match');
    }
    
    @isTest
    static void testGetStageNamePicklistValues() {
        Test.startTest();
        List<String> stageValues = AccountControllerNav.getStageNamePicklistValues();
        Test.stopTest();
        
        // Verify results
        Assert.isTrue(!stageValues.isEmpty(), 'Should return picklist values');
        Assert.isTrue(stageValues.contains('Prospecting'), 'Should contain Prospecting stage');
        Assert.isTrue(stageValues.contains('Qualification'), 'Should contain Qualification stage');
        Assert.isTrue(stageValues.contains('Closed Won'), 'Should contain Closed Won stage');
    }
    
    @isTest
    static void testUpdateOpportunityStages_Success() {
        // Get test opportunities
        List<Opportunity> testOpps = [SELECT Id FROM Opportunity WHERE Name LIKE 'Test Opp%'];
        List<Id> oppIds = new List<Id>();
        for(Opportunity opp : testOpps) {
            oppIds.add(opp.Id);
        }
        
        // Test updateOpportunityStages method
        Test.startTest();
        AccountControllerNav.updateOpportunityStages(oppIds, 'Closed Won');
        Test.stopTest();
        
        // Verify results
        List<Opportunity> updatedOpps = [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppIds];
        for(Opportunity opp : updatedOpps) {
            Assert.areEqual('Closed Won', opp.StageName, 'Opportunity stage should be updated to Closed Won');
        }
    }
    
    @isTest
    static void testUpdateOpportunityStages_NoOpps() {
        // Test with empty list
        Test.startTest();
        try {
            AccountControllerNav.updateOpportunityStages(new List<Id>(), 'Closed Won');
            Assert.fail('Should throw an exception when no opportunities are provided');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('No opportunities selected'), 'Should throw correct error message');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateOpportunityStages_InvalidStage() {
        // Get test opportunities
        List<Opportunity> testOpps = [SELECT Id FROM Opportunity WHERE Name LIKE 'Test Opp%'];
        List<Id> oppIds = new List<Id>();
        for(Opportunity opp : testOpps) {
            oppIds.add(opp.Id);
        }
        
        // Test with invalid stage
        Test.startTest();
        try {
            AccountControllerNav.updateOpportunityStages(oppIds, 'Invalid_Stage');
            Assert.fail('Should throw an exception when invalid stage is provided');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Failed to update opportunities'), 'Should throw correct error message');
        }
        Test.stopTest();
    }
}