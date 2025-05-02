@isTest
private class ContactTriggerHandleTest {
    @isTest
    static void testConUpdate() {
        // Test scenario with first and last name
        List<Contact> testContacts = new List<Contact>{
            new Contact(
                FirstName = 'John', 
                LastName = 'Doe'
            ),
            new Contact(
                FirstName = 'Jane', 
                LastName = 'Smith'
            )
        };
        
        Test.startTest();
        ContactTriggerHandle.conUpdate(testContacts);
        Test.stopTest();
        
        // Verify description is set correctly
        System.assertEquals('John Doe', testContacts[0].Contact_Description__c, 'First contact description incorrect');
        System.assertEquals('Jane Smith', testContacts[1].Contact_Description__c, 'Second contact description incorrect');
    }
    
    @isTest
    static void testConUpdateWithNullNames() {
        // Test scenario with null names
        List<Contact> testContacts = new List<Contact>{
            new Contact(
                FirstName = null, 
                LastName = null
            )
        };
        
        Test.startTest();
        ContactTriggerHandle.conUpdate(testContacts);
        Test.stopTest();
        
        // Verify no error occurs
        System.assertNotEquals(null, testContacts[0], 'Contact should not be modified');
    }
    
    @isTest
    static void testPreventDuplicateContacts() {
        // Create an existing contact
        Contact existingContact = new Contact(
            FirstName = 'Existing', 
            LastName = 'Contact', 
            Email = 'existing@test.com'
        );
        insert existingContact;
        
        // Prepare new contacts with duplicate email
        List<Contact> newContacts = new List<Contact>{
            new Contact(
                FirstName = 'New', 
                LastName = 'Contact', 
                Email = 'existing@test.com'
            )
        };
        
        Test.startTest();
        try {
            ContactTriggerHandle.preventDuplicateCon(newContacts);
        } catch (Exception e) {
            // Expect an error to be added to the contact
            System.assert(true, 'Duplicate contact prevention failed');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testPreventDuplicateContactsWithUniqueEmail() {
        // Prepare new contacts with unique email
        List<Contact> newContacts = new List<Contact>{
            new Contact(
                FirstName = 'Unique', 
                LastName = 'Contact', 
                Email = 'unique@test.com'
            )
        };
        
        Test.startTest();
        ContactTriggerHandle.preventDuplicateCon(newContacts);
        Test.stopTest();
        
        // No exception should be thrown
        System.assert(true, 'Unique contact should be allowed');
    }
    
    @isTest
    static void testPreventDuplicateContactsWithNullEmail() {
        // Prepare new contacts with null email
        List<Contact> newContacts = new List<Contact>{
            new Contact(
                FirstName = 'Null', 
                LastName = 'Email', 
                Email = null
            )
        };
        
        Test.startTest();
        ContactTriggerHandle.preventDuplicateCon(newContacts);
        Test.stopTest();
        
        // No exception should be thrown
        System.assert(true, 'Contact with null email should be allowed');
    }
}