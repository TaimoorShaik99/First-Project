public class ContactTriggerHandle {
	
    //First and Last Name in contact Description field
    public static void conUpdate(List<Contact> conList){
        for(Contact con:conList){
            if(con.FirstName!=null && con.LastName!=null){
                con.Contact_Description__c=con.FirstName+' '+con.LastName;
            }
        }
    }
    
   
    public static void preventDuplicateCon(List<Contact> conList) {
        Set<String> newEmails = new Set<String>();

        // Collect all unique emails from new records
        for (Contact con : conList) {
            if (con.Email != null) {
                newEmails.add(con.Email);
            }
        }

        // Query existing contacts with the same emails
        Map<String, Contact> existingContacts = new Map<String, Contact>();
        for (Contact existingCon : [SELECT Id, Email FROM Contact WHERE Email IN :newEmails]) {
            existingContacts.put(existingCon.Email, existingCon);
        }

        // Prevent duplicates by checking if the email already exists
        for (Contact con : conList) {
            if (con.Email != null && existingContacts.containsKey(con.Email)) {
                con.addError('Duplicate Contacts Cannot be Created');
            }
        }
    }
    

    
}