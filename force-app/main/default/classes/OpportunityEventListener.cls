public with sharing class OpportunityEventListener {
    @AuraEnabled
    @future(callout=true)
    public static void sendOpportunityDetails( String name,  Date closeDate) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://eohfl1r47jk41oi.m.pipedream.net'); // Use your mock API URL
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        
        String body = JSON.serialize(new Map<String, Object>{
            
            'name' => name,
           
            'closeDate' => closeDate
        });
        request.setBody(body);
        
        try {
            HttpResponse response = http.send(request);
            System.debug('Response: ' + response.getBody());
        } catch (Exception e) {
            System.debug('Error during API callout: ' + e.getMessage());
        }
    }
}