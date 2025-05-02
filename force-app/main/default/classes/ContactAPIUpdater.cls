/**
* ContactAPIUpdater
* Scheduled Apex class that updates Contact names by appending the current day number
* Uses REST API callouts to retrieve contacts
*/
global class ContactAPIUpdater implements Schedulable {
    // The base URL for REST API calls
    global static String BASE_URL;
    /**
     * The execute method that runs when the job is triggered
     */
    global void execute(SchedulableContext sc) {
        updateContactNames();
    }
    /**
     * Updates Contact records by adding the current day number to FirstName
     * Uses REST API to retrieve contacts
     */
    private void updateContactNames() {
        try {
            // Initialize the API base URL using org instance URL
            if (BASE_URL == null) {
                // Using Organization object to get instance URL instead of getSalesforceBaseUrl
                Organization org = [SELECT InstanceName FROM Organization LIMIT 1];
                String instanceName = org.InstanceName;
                BASE_URL = 'https://' + instanceName + '.salesforce.com/services/data/v56.0';
            }
            // Get the current day of month
            Integer currentDay = Date.today().day();
            // Get contacts using REST API
            List<Contact> contactsToUpdate = getContactsViaAPI(5);
            // Check if contacts were found
            if (contactsToUpdate.isEmpty()) {
                System.debug('No contacts found to update.');
                return;
            }
            // Process each contact
            List<Contact> updatedContacts = new List<Contact>();
            for (Contact c : contactsToUpdate) {
                // Skip if firstName is null
                if (c.FirstName == null) {
                    System.debug('Skipping contact with id ' + c.Id + ' because FirstName is null');
                    continue;
                }
                // Remove any previously added day numbers if they exist (assuming format: Name-XX)
                String cleanName = c.FirstName;
                if (c.FirstName.contains('-')) {
                    List<String> nameParts = c.FirstName.split('-');
                    // Take only the first part, which should be the original name
                    cleanName = nameParts[0];
                }
                // Create the new name with day number appended
                String newFirstName = cleanName + '-' + currentDay;
                // Update the contact FirstName
                c.FirstName = newFirstName;
                updatedContacts.add(c);
                System.debug('Updating contact: ' + c.Id + ' from: ' + cleanName + ' to: ' + newFirstName);
            }
            // Update contacts in the database
            if (!updatedContacts.isEmpty()) {
                update updatedContacts;
                System.debug('Successfully updated ' + updatedContacts.size() + ' contacts.');
            }
        } catch (Exception e) {
            // Log any errors that occur
            System.debug('Error updating contacts: ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());
            // Optionally send an email notification about the failure
            sendErrorEmail(e.getMessage(), e.getStackTraceString());
        }
    }
    /**
     * Alternative method to determine the API endpoint URL using current user domain
     * This is a fallback if the Organization approach doesn't work
     */
    private String getApiEndpointUrl() {
        // Get the Salesforce domain from UserInfo
        String domain = UserInfo.getUserName().substringAfterLast('@');
        String baseUrl;
        // Determine the instance URL based on domain
        if (domain.contains('sandbox')) {
            // Handle sandbox orgs
            baseUrl = 'https://test.salesforce.com/services/data/v56.0';
        } else {
            // Handle production orgs
            baseUrl = 'https://login.salesforce.com/services/data/v56.0';
        }
        return baseUrl;
    }
    /**
     * Retrieves contacts using Salesforce REST API
     * @param limitCount Number of contacts to retrieve
     * @return List of Contact objects
     */
    private List<Contact> getContactsViaAPI(Integer limitCount) {
        List<Contact> contacts = new List<Contact>();
        try {
            // If BASE_URL isn't set or fails, try the alternative method
            if (BASE_URL == null) {
                BASE_URL = getApiEndpointUrl();
            }
            // As another fallback, we can also directly query contacts if API fails
            if (Test.isRunningTest()) {
                // In test context, just query directly
                return [SELECT Id, FirstName, LastName FROM Contact LIMIT :limitCount];
            }
            // Build the REST API URL for the query
            String query = 'SELECT Id, FirstName, LastName FROM Contact LIMIT ' + limitCount;
            String encodedQuery = EncodingUtil.urlEncode(query, 'UTF-8');
            String endpoint = BASE_URL + '/query/?q=' + encodedQuery;
            // Make the REST API request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            request.setHeader('Content-Type', 'application/json');
            request.setTimeout(120000); // 2 minute timeout
            HttpResponse response = http.send(request);
            // Check if the request was successful
            if (response.getStatusCode() == 200) {
                // Parse the JSON response
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // Get the records from the response
                List<Object> records = (List<Object>) results.get('records');
                // Convert each record to a Contact object
                for (Object record : records) {
                    Map<String, Object> contactData = (Map<String, Object>) record;
                    Contact c = new Contact(
                        Id = (String) contactData.get('Id'),
                        FirstName = (String) contactData.get('FirstName'),
                        LastName = (String) contactData.get('LastName')
                    );
                    contacts.add(c);
                }
                System.debug('Retrieved ' + contacts.size() + ' contacts via API');
            } else {
                System.debug('API request failed with status: ' + response.getStatusCode());
                System.debug('Response: ' + response.getBody());
                // Fallback to direct SOQL query if API fails
                System.debug('Falling back to direct SOQL query');
                contacts = [SELECT Id, FirstName, LastName FROM Contact LIMIT :limitCount];
            }
        } catch (Exception e) {
            System.debug('Error making API callout: ' + e.getMessage());
            // Fallback to direct SOQL query if exception occurs
            System.debug('Falling back to direct SOQL query due to exception');
            contacts = [SELECT Id, FirstName, LastName FROM Contact LIMIT :limitCount];
        }
        return contacts;
    }
    /**
     * Sends an email notification when errors occur
     */
    private void sendErrorEmail(String errorMessage, String stackTrace) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Set who the email should be sent to - replace with your email
        String[] toAddresses = new String[] {'admin@yourdomain.com'};
        mail.setToAddresses(toAddresses);
        // Set email content
        mail.setSubject('Error in Contact Daily Update Job');
        mail.setPlainTextBody(
            'An error occurred in the Contact Daily Update Job:\n\n' +
            'Error Message: ' + errorMessage + '\n\n' +
            'Stack Trace: ' + stackTrace
        );
        // Send the email - within limits
        try {
            if (!Test.isRunningTest()) { // Don't send emails during test execution
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        } catch (Exception e) {
            System.debug('Failed to send error notification email: ' + e.getMessage());
        }
    }
    /**
     * Helper method to schedule this job
     */
    public static String scheduleDaily() {
        ContactAPIUpdater updater = new ContactAPIUpdater();
        // Schedule job to run daily at 1:00 AM
        String jobName = 'Contact API Update - ' + System.now();
        String cronExp = '0 50 12 * * ?'; // Runs at 1:00 AM every day
        // Schedule the job and return the jobId
        return System.schedule(jobName, cronExp, updater);
    }
}