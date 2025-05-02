public class ContactEmailChange {
@future
    public static void sendEmailConfirmation(Set<Id> contactIds) {
        List<Contact> contacts = [
            SELECT Id, Name, Email 
            FROM Contact 
            WHERE Id IN :contactIds
        ];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Contact contact : contacts) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{contact.Email});
            email.setSubject('Email Address Confirmation');
            email.setPlainTextBody(
                'Dear ' + contact.Name + ',\n\n' +
                'This email confirms that your contact email address has been updated in our system.\n\n' +
                'If you did not make this change, please contact our support team.\n\n'+
				'Regards,\n\n'+
                'Salesforce'
            );
            emails.add(email);
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    
    public static void onContactEmailChange(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        Set<Id> contactsWithChangedEmail = new Set<Id>();
        
        for (Contact newContact : newContacts) {
            Contact oldContact = oldContactMap.get(newContact.Id);
            if (newContact.Email != oldContact.Email) {
                contactsWithChangedEmail.add(newContact.Id);
            }
        }
        
        if (!contactsWithChangedEmail.isEmpty()) {
            sendEmailConfirmation(contactsWithChangedEmail);
        }
        
        
    }
}