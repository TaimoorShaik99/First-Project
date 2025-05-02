public with sharing class LeadAccountController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Id accountId) {
        if (accountId == null) {
            return new List<Opportunity>();
        }
        return [
            SELECT Id, Name, StageName, CloseDate 
            FROM Opportunity 
            WHERE AccountId = :accountId
            ORDER BY CloseDate DESC
            LIMIT 10
        ];
    }
}