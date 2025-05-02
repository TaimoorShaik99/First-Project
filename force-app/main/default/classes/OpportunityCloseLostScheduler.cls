public class OpportunityCloseLostScheduler implements Schedulable {
    public void execute(SchedulableContext SC) {
        // Query Opportunities not updated in last 30 days
        List<Opportunity> opportunitiesToClose = [
            SELECT Id 
            FROM Opportunity 
            WHERE IsClosed = false 
            AND LastModifiedDate < LAST_N_DAYS:30
        ];
        
        // Bulk update opportunities
        for (Opportunity opp : opportunitiesToClose) {
            opp.StageName = 'Closed Lost';
        }
        
        if (!opportunitiesToClose.isEmpty()) {
            update opportunitiesToClose;
        }
    }
}