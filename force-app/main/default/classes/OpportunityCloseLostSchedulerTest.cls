@isTest
private class OpportunityCloseLostSchedulerTest {
    
    @isTest
    static void testOpportunitiesOlderThan30Days() {
        // Create test opportunities older than 30 days (should be closed)
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Old Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(-40)
            );
            oldOpportunities.add(opp);
        }
        insert oldOpportunities;
        
        Test.startTest();
        OpportunityCloseLostScheduler scheduler = new OpportunityCloseLostScheduler();
        scheduler.execute(null);
        Test.stopTest();
        
        // Verify that the opportunities have been updated to "Closed Lost"
        List<Opportunity> updatedOpps = [
            SELECT StageName FROM Opportunity WHERE Id IN :oldOpportunities
        ];
        
        for (Opportunity opp : updatedOpps) {
            System.assertEquals('Closed Lost', opp.StageName, 'Older opportunities should be Closed Lost');
        }
    }
    
    @isTest
    static void testOpportunitiesWithin30Days() {
        // Create test opportunities within 30 days (should not be closed)
        List<Opportunity> recentOpportunities = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Recent Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(-20)
            );
            recentOpportunities.add(opp);
        }
        insert recentOpportunities;
        
        Test.startTest();
        OpportunityCloseLostScheduler scheduler = new OpportunityCloseLostScheduler();
        scheduler.execute(null);
        Test.stopTest();
        
        // Verify that recent opportunities are unchanged
        List<Opportunity> unchangedOpps = [
            SELECT StageName FROM Opportunity WHERE Id IN :recentOpportunities
        ];
        
        for (Opportunity opp : unchangedOpps) {
            System.assertEquals('Prospecting', opp.StageName, 'Recent opportunities should not be closed');
        }
    }
    
    @isTest
    static void testNoOpportunities() {
        // No opportunities in the system
        Test.startTest();
        OpportunityCloseLostScheduler scheduler = new OpportunityCloseLostScheduler();
        scheduler.execute(null);
        Test.stopTest();
        
        // No specific assertion is needed, just ensuring no exceptions are thrown
        System.assert(true, 'No opportunities to close scenario should execute successfully');
    }
}