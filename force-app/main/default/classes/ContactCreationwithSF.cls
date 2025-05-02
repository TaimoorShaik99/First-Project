@RestResource(urlMapping='/ContactCreationwithSF/*')
global class ContactCreationwithSF {
 
    @HttpPost
    global static Contact createContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
 
        // Parse JSON request body
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
 
        if (!params.containsKey('FirstName') || !params.containsKey('LastName')) {
            res.statusCode = 400;
            return null;
        }
 
        Contact con = new Contact(    
            FirstName = String.valueOf(params.get('FirstName')), 
            LastName = String.valueOf(params.get('LastName'))
        );
        insert con;
        return con; 
}
 
    @HttpPatch
    global static Contact updateContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        // Extract Contact ID from the URL
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        if (String.isEmpty(contactId)) {
            res.statusCode = 400;
            return null;
        }
 
        // Parse JSON request body
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
 
        try {
            // Fetch existing Contact record
            Contact con = [SELECT Id, FirstName, LastName, Wind__c, Temperature__c FROM Contact WHERE Id = :contactId LIMIT 1];
 
            // Update fields if present in the request body
            if (params.containsKey('FirstName')) {
                con.FirstName = String.valueOf(params.get('FirstName'));
            }
            if (params.containsKey('LastName')) {
                con.LastName = String.valueOf(params.get('LastName'));
            }
            if (params.containsKey('Wind')) {
                con.Wind__c = String.valueOf(params.get('Wind'));
            }
            if (params.containsKey('Temperature')) {
                con.Temperature__c = String.valueOf(params.get('Temperature'));
            }
 
            update con;
            return con;
        } catch (Exception e) {
            System.debug('Exception in updateContact: ' + e.getMessage());
            res.statusCode = 500;
            return null;
        }
    }
}