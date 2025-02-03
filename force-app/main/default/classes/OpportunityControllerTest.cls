@isTest
public class OpportunityControllerTest {
    @isTest
    static void testGetOpportunitiesByAccountId() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        // Create test opportunities
        Opportunity opp1 = new Opportunity(
            Name = 'Opportunity 1', 
            StageName = 'Prospecting', 
            CloseDate = Date.today().addDays(10), 
            Amount = 5000, 
            AccountId = testAccount.Id
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Opportunity 2', 
            StageName = 'Negotiation', 
            CloseDate = Date.today().addDays(5), 
            Amount = 10000, 
            AccountId = testAccount.Id
        );
        insert new List<Opportunity>{opp1, opp2};
        // Test the getOpportunitiesByAccountId method
        Test.startTest();
        List<Opportunity> result = OpportunityController.getOpportunitiesByAccountId(testAccount.Id);
        Test.stopTest();
        // Assert the result
        System.assertEquals(2, result.size(), 'There should be two opportunities retrieved.');
        System.assertEquals('Opportunity 2', result[0].Name, 'The first opportunity should be sorted by CloseDate DESC.');
        System.assertEquals('Opportunity 1', result[1].Name, 'The second opportunity should be sorted by CloseDate DESC.');
    }
 
    @isTest
    static void testGetStageNamePicklistValues() {
        // Start test execution
        Test.startTest();
        // Call the method to retrieve picklist values
        List<String> stageNames = OpportunityController.getStageNamePicklistValues();
        Test.stopTest();
        // Assert that the picklist values are returned
        System.assertNotEquals(null, stageNames, 'StageName picklist values should not be null.');
        System.assert(stageNames.size() > 0, 'StageName picklist values should not be empty.');
        // Example: Check that specific picklist values are present (adjust based on org configuration)
        System.assert(stageNames.contains('Prospecting'), 'Picklist values should contain "Prospecting".');
        System.assert(stageNames.contains('Closed Won'), 'Picklist values should contain "Closed Won".');
        System.assert(stageNames.contains('Closed Lost'), 'Picklist values should contain "Closed Lost".');
    }
    @isTest
    static void testUpdateOpportunityStages() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        // Create test opportunities
        Opportunity opp1 = new Opportunity(
            Name = 'Opportunity 1', 
            StageName = 'Prospecting', 
            CloseDate = Date.today().addDays(10), 
            Amount = 5000, 
            AccountId = testAccount.Id
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Opportunity 2', 
            StageName = 'Negotiation', 
            CloseDate = Date.today().addDays(5), 
            Amount = 10000, 
            AccountId = testAccount.Id
        );
        insert new List<Opportunity>{opp1, opp2};
        // Test the updateOpportunityStages method
        Test.startTest();
        OpportunityController.updateOpportunityStages(
            new List<Id>{opp1.Id, opp2.Id}, 
            'Closed Won'
        );
        Test.stopTest();
        // Retrieve updated opportunities and assert the new stage
        Opportunity updatedOpp1 = [SELECT StageName FROM Opportunity WHERE Id = :opp1.Id];
        Opportunity updatedOpp2 = [SELECT StageName FROM Opportunity WHERE Id = :opp2.Id];
        System.assertEquals('Closed Won', updatedOpp1.StageName, 'Opportunity 1 stage should be updated to Closed Won.');
        System.assertEquals('Closed Won', updatedOpp2.StageName, 'Opportunity 2 stage should be updated to Closed Won.');
    }
 
    @isTest
    static void testUpdateOpportunityStages_NoOpportunities() {
        // Test with an empty list of opportunity IDs
        Test.startTest();
        try {
            OpportunityController.updateOpportunityStages(new List<Id>(), 'Closed Lost');
            System.assert(false, 'Exception should have been thrown for empty opportunity list.');
        } catch (AuraHandledException e) {
            System.assertEquals('No opportunities selected for update.', e.getMessage());
        }
        Test.stopTest();
    }
 
    @isTest
    static void testUpdateOpportunityStages_NoMatchingOpportunities() {
        // Test with non-existent opportunity IDs
        Test.startTest();
        try {
            OpportunityController.updateOpportunityStages(new List<Id>{'001000000000000AAA'}, 'Closed Lost');
            System.assert(false, 'Exception should have been thrown for no matching opportunities.');
        } catch (AuraHandledException e) {
            System.assertEquals('No matching opportunities found.', e.getMessage());
        }
        Test.stopTest();
    }
}