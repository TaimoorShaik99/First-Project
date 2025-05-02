public with sharing class OpportunityControllerr {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Id accountId) {
        return [SELECT Id,Name,StageName FROM Opportunity WHERE AccountId = :accountId];
    }
}