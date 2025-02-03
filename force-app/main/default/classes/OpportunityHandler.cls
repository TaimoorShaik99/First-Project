/*
 ******************************************************************************************
 * @Name of the Apex   :  OpportunityHandler
 * @ Description       :  Sends email whenever opportunity stage is updated
 * @ Author            :  Taimoor Shaik
 * @ Created Date      :  28-01-2024
 ******************************************************************************************
 * @ Last Modified By         :  Taimoor Shaik
 * @ Last Modified On         :  29-01-2024
 * @ Modification Description : Added extra functionality
 ******************************************************************************************
 */

public class OpportunityHandler {
    public static void sendEmailToOpportunityOwner(List<Opportunity> oppList) {
        /*System.debug('Starting email send process for Opportunity: ' + opportunityId);
        
        try {
            // Get Email Template
            EmailTemplate template = [
                SELECT Id 
                FROM EmailTemplate 
                WHERE DeveloperName = 'Opportunity_Stage_Update' 
                AND IsActive = TRUE 
                LIMIT 1
            ];
            
            // Get Opportunity with Owner
            Opportunity opp = [
                SELECT Id, OwnerId, Owner.Email, Name
                FROM Opportunity 
                WHERE Id = :opportunityId
                LIMIT 1
            ];
            
            System.debug('Sending email to owner: ' + opp.Owner.Email);

            // Create and send email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(opp.OwnerId);
            email.setTemplateId(template.Id);
            //email.setWhatId(opp.Id);
            email.setSaveAsActivity(false);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            System.debug('Email sent successfully');
            
        } catch (Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
            throw e;
        }
    }*/



  List<Messaging.SingleEmailMessage> emailObjs = new List<Messaging.SingleEmailMessage>();

		for (Opportunity opp : oppList) {

    		if (opp.ContactId != null) {  // Ensure Opportunity has a Contact

        		Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();

        		emailObj.setTargetObjectId(opp.ContactId); // Send to Contact

        		emailObj.setTemplateId([SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Opportunity_Stage_Update_1738064948892' LIMIT 1].Id);

        		// setWhatId can only be used when sending to a Contact or Lead

        		emailObj.setWhatId(opp.Id);
 
        		// Ensure saveAsActivity is false when sending to a Contact

        		emailObj.setSaveAsActivity(false);
 
        		emailObjs.add(emailObj);

    }

}
 
		if (!emailObjs.isEmpty()) {

    		Messaging.sendEmail(emailObjs);

		}
 
}
}