@RestResource(urlMapping='/AccountRecords/*')
global class RESTServices {
@httpget
    global static List<Account> getAccountData(){
        List<Account> accList = [Select id,Name,industry from Account];
        return accList;
    }
    @HttpPost
    global static Account createAccount(String name, String industry) {
        Account acc = new Account(Name = name, Industry = industry);
        insert acc;
        return acc;
    }
 
    @HttpPatch
	global static Account updateAccount() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
 
    // Extract Account ID from the URL
    String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
    if (String.isEmpty(accountId)) {
        res.statusCode = 400;
        return null;
    }
 
    // Parse JSON request body
    String requestBody = req.requestBody.toString();
    Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
 
    // Fetch existing Account record
    Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId LIMIT 1];
 
    // Update fields if present in the request body
    if (params.containsKey('name')) {
        acc.Name = String.valueOf(params.get('name'));
    }
    if (params.containsKey('industry')) {
        acc.Industry = String.valueOf(params.get('industry'));
    }
 
    update acc;
    return acc;
}
 
 
 
  @HttpDelete
    global static String deleteAccount() {
        // Extract Account ID from the request URL
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
 
        // Check if Account ID is valid
        if (String.isEmpty(accountId)) {
            RestContext.response.statusCode = 400;  // Bad Request
            return '{"error": "Account ID is required"}';
        }
 
        try {
            // Fetch the Account record
            Account acc = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];
 
            // Delete the Account
            delete acc;
 
            // Return success message
            RestContext.response.statusCode = 200;
            return '{"message": "Account deleted successfully"}';
        } catch (Exception e) {
            // Return error message
            RestContext.response.statusCode = 500;  // Internal Server Error
            return '{"error": "' + e.getMessage() + '"}';
        }
    }
 
}