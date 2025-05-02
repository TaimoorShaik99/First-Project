public class REStfullServices {
    
	public static void getAccounts() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
 
    //Salesforce base URL
    String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
    request.setEndpoint(baseUrl + '/services/apexrest/AccountRecords/');
    request.setMethod('GET');
 
    // Add Authorization Header (Session ID for testing)
    request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    request.setHeader('Content-Type', 'application/json');
 
    HttpResponse res = http.send(request);
    System.debug(res);
    if (res.getStatusCode() == 200) {
        System.debug('Call has been Successful: ' + res.getBody());
    } else {
        System.debug('Error: ' + res.getStatus() + ' - ' + res.getBody());
    }
}
 
 
    
    public static void createAccount(String name, String industry) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
    	request.setEndpoint(baseUrl + '/services/apexrest/AccountRecords/');
    	request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"name": "' + name + '", "industry": "' + industry + '"}');
        HttpResponse res = http.send(request);
        system.debug(res);
        if (res.getStatusCode() == 201) {
            System.debug('Account created: ' + res.getBody());
        } else {
            System.debug('Error: ' + res.getStatus() + ' - ' + res.getBody());
        }
    }
    
    public static void updateAccount(String accountId, String name, String industry) {
    try {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
 
        // Get Salesforce base URL
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
        request.setEndpoint(baseUrl + '/services/apexrest/AccountRecords/' + accountId);
        request.setMethod('PATCH');
 
        // Add headers
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
 
        // Set request body
        request.setBody('{"name": "' + name + '", "industry": "' + industry + '"}');
 
        // Send HTTP request
        HttpResponse res = http.send(request);
        System.debug(res);
        if (res.getStatusCode() == 200) {
            System.debug('Account updated: ' + res.getBody());
        } else {
            System.debug('Error: ' + res.getStatus() + ' - ' + res.getBody());
        }
    } catch (Exception e) {
        System.debug('Exception: ' + e.getMessage());
    }
}

    public static void deleteAccount(String accountId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
 
        // Set the endpoint for the REST resource, appending the accountId
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();  // Replace with your Salesforce instance URL
        request.setEndpoint(baseUrl + '/services/apexrest/AccountRecords/' + accountId);
        // Set the HTTP method to DELETE
        request.setMethod('DELETE');
        // Set the Authorization header with the Bearer token (using session ID for testing)
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
 
        // Send the HTTP request
        HttpResponse response = http.send(request);
 
        // Log the response
        if (response.getStatusCode() == 200) {
            System.debug('Account deleted successfully: ' + response.getBody());
        } else {
            System.debug('Error deleting account: ' + response.getStatus() + ' - ' + response.getBody());
        }
    }
}