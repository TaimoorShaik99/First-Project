@isTest

public class ContactAPIUpdaterTest {
 
    // Helper method to create mock contacts

    private static void createMockContacts(Integer count, Boolean withFirstName) {

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < count; i++) {

            Contact c = new Contact(

                FirstName = withFirstName ? 'TestName' + i : null,

                LastName = 'Last' + i

            );

            contacts.add(c);

        }

        insert contacts;

    }
 
    // Test successful execution with valid FirstNames

    @isTest

    static void testExecuteWithValidContacts() {

        createMockContacts(3, true); // Insert contacts with FirstName
 
        Test.startTest();

        ContactAPIUpdater updater = new ContactAPIUpdater();

        updater.execute(null); // Trigger scheduled job logic

        Test.stopTest();
 
        // Verify that FirstNames are updated with day number

        List<Contact> updated = [SELECT FirstName FROM Contact];

        Integer day = Date.today().day();

        for (Contact c : updated) {

            System.assert(c.FirstName.endsWith('-' + day), 'Contact name not updated properly');

        }

    }
 
    // Test when contacts have null FirstName

    @isTest

    static void testExecuteWithNullFirstName() {

        createMockContacts(2, false); // Insert contacts with null FirstName
 
        Test.startTest();

        ContactAPIUpdater updater = new ContactAPIUpdater();

        updater.execute(null);

        Test.stopTest();
 
        // Verify no updates happened

        List<Contact> results = [SELECT FirstName FROM Contact];

        for (Contact c : results) {

            System.assertEquals(null, c.FirstName, 'Contact should be skipped if FirstName is null');

        }

    }
 
    // Test execute with no contacts in system

    @isTest

    static void testExecuteWithNoContacts() {

        Test.startTest();

        ContactAPIUpdater updater = new ContactAPIUpdater();

        updater.execute(null);

        Test.stopTest();
 
        System.assertEquals(0, [SELECT COUNT() FROM Contact], 'No contacts should exist');

    }
 
    // Test scheduling method

    @isTest

    static void testScheduleDailyJob() {

        Test.startTest();

        String jobId = ContactAPIUpdater.scheduleDaily();

        Test.stopTest();
 
        System.assertNotEquals(null, jobId, 'Scheduled job ID should not be null');

    }
 
    // Test send error email (indirectly by calling private method via exception)

    @isTest

    static void testErrorHandling() {

        // Simulate error by injecting faulty contact (invalid update)

        Contact c = new Contact(FirstName = 'Error', LastName = 'Test');

        insert c;
 
        // Create a test subclass to throw error during update

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponse());

        ContactAPIUpdater updater = new ContactAPIUpdater();

        updater.execute(null); // Should fall back and possibly trigger error handling

        Test.stopTest();

    }
 
    // Mock HTTP class for simulating REST API error (if callout ever hits)

    public class MockHttpErrorResponse implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();

            res.setStatusCode(500);

            res.setBody('{"message":"Server Error"}');

            return res;

        }

    }

}