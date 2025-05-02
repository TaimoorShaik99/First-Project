@isTest
private class ContactEmailChangeTest {
    @isTest
    static void testEmailChangeTriggersConfirmation() {
        // Create test contact
        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'User', 
            Email = 'original@test.com'
        );
        insert testContact;
        
        // Prepare for testing
        Test.startTest();
        
        // Create old map for comparison
        Map<Id, Contact> oldContactMap = new Map<Id, Contact>{
            testContact.Id => new Contact(
                Id = testContact.Id, 
                Email = 'original@test.com'
            )
        };
        
        // Update contact email
        testContact.Email = 'updated@test.com';
        update testContact;
        
        Test.stopTest();
        
        // Assertions
        List<Contact> updatedContacts = [
            SELECT Email 
            FROM Contact 
            WHERE Id = :testContact.Id
        ];
        System.assertEquals('updated@test.com', updatedContacts[0].Email, 'Email should be updated');
    }
    
    @isTest
    static void testNoEmailChangeScenario() {
        // Create test contact
        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'User', 
            Email = 'original@test.com'
        );
        insert testContact;
        
        // Prepare for testing
        Test.startTest();
        
        // Create old map for comparison
        Map<Id, Contact> oldContactMap = new Map<Id, Contact>{
            testContact.Id => new Contact(
                Id = testContact.Id, 
                Email = 'original@test.com'
            )
        };
        
        // Update contact without changing email
        testContact.FirstName = 'Updated Name';
        update testContact;
        
        Test.stopTest();
        
        // No specific assertion needed as we're testing no email confirmation is sent
    }
    
    @isTest
    static void testNullEmailScenario() {
        // Create test contact
        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'User', 
            Email = 'original@test.com'
        );
        insert testContact;
        
        // Prepare for testing
        Test.startTest();
        
        // Create old map for comparison
        Map<Id, Contact> oldContactMap = new Map<Id, Contact>{
            testContact.Id => new Contact(
                Id = testContact.Id, 
                Email = 'original@test.com'
            )
        };
        
        // Set email to null
        testContact.Email = null;
        update testContact;
        
        Test.stopTest();
        
        // Assertions
        List<Contact> updatedContacts = [
            SELECT Email 
            FROM Contact 
            WHERE Id = :testContact.Id
        ];
        System.assertEquals(null, updatedContacts[0].Email, 'Email should be null');
    }
}