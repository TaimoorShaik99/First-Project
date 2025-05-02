public with sharing class LeadConversionController {
    @AuraEnabled
    public static String convertLeadToOpportunity(Id leadId) {
        try {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadId);
            lc.setDoNotCreateOpportunity(false); // Ensure Opportunity is created

            // Prevents Account and Contact creation
            lc.setAccountId(null);
            lc.setContactId(null);

            // Get the converted status for Leads
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            if (lcr.isSuccess()) {
                return 'Success';
            } else {
                return 'Failed';
            }
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}