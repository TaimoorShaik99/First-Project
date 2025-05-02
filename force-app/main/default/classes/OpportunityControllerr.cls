public with sharing class OpportunityControllerr {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Id accountId) {
        return [SELECT Id, StageName FROM Opportunity WHERE AccountId = :accountId];
    }
}