public class OpportunityController {
	@AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccountId(Id accountId) {
        return [
            SELECT Id, Name, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE AccountId = :accountId
            
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getStageNamePicklistValues() {
        // Retrieve the picklist values for StageName
        List<String> stageValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistEntries) {
            stageValues.add(entry.getLabel()); // Add picklist label to the list
        }
        return stageValues;
    }
 
	@AuraEnabled
	public static void updateOpportunityStages(List<Id> opportunityIds, String newStage) {
    	if (opportunityIds.isEmpty()) {
        	throw new AuraHandledException('No opportunities selected for update.');
    	}
    List<Opportunity> opportunitiesToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id IN :opportunityIds];
        if (opportunitiesToUpdate.isEmpty()) {
        throw new AuraHandledException('No matching opportunities found.');
    }
    for (Opportunity opp : opportunitiesToUpdate) {
        opp.StageName = newStage;
    }
    try {
        update opportunitiesToUpdate;
    } catch (Exception ex) {
        throw new AuraHandledException('Failed to update opportunities: ' + ex.getMessage());
    }
}
}