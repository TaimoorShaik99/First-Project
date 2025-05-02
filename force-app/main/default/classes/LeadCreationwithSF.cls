@RestResource(urlMapping='/LeadCreationwithSF/*')
global class LeadCreationwithSF {
@httpget
    global static List<Lead> getLeadData(){
         List<Lead> leadList = [SELECT Id, FirstName, LastName, Company,Status, Phone FROM Lead];
        return leadList;    }
    
    @HttpPost
   global static Lead createLead(String FirstName, String LastName, String Company, String Status, String Phone, String Email) {
        Lead lead = new Lead(FirstName = FirstName, LastName = LastName, Company = Company, Status = status, Phone = phone, Email = email, API_Email__c = true);
        insert lead;
        return lead; 
    }
    
    
}