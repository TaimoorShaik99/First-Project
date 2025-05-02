public class ContactWeatherService {
    // Wrapper Class for Contact API Response
    public class ContactResponseWrapper {
        public String Id; // Ensure this matches the actual response field
    }
 
    // Method to create a contact and update it with weather data
    public static void createContact(String FirstName, String LastName) {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SF_Integration/services/apexrest/ContactWeatherCreationwithSF');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody('{"FirstName": "' + FirstName + '", "LastName": "' + LastName + '"}');
 
            HttpResponse response = http.send(request);
 
            if (response.getStatusCode() == 200) {
                System.debug('Contact created successfully: ' + response.getBody());
 
                // Deserialize response to get Contact ID
                ContactResponseWrapper contactResponse = 
                    (ContactResponseWrapper) JSON.deserialize(response.getBody(), ContactResponseWrapper.class);
 
                if (contactResponse.Id != null) {
                    String contactRecordId = String.valueOf(contactResponse.Id); // Ensure proper format
                    fetchAndUpdateWeatherAsync(contactRecordId); // Call Future Method
                } else {
                    System.debug('Error: Contact ID not found in API response.');
                }
            } else {
                System.debug('Error Creating Contact: ' + response.getStatus() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception in createContact: ' + e.getMessage());
        }
    }
 
    // Future method to fetch and update weather data asynchronously
    @future(callout=true)
    public static void fetchAndUpdateWeatherAsync(String contactId) {
        try {
            String endpoint = 'https://goweather.herokuapp.com/weather/Curitiba';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
 
            HttpResponse response = http.send(request);
 
            if (response.getStatusCode() == 200) {
                // Parse JSON response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
 
                // Extract Wind and Temperature
                String wind = (String) jsonResponse.get('wind');
                String temperature = (String) jsonResponse.get('temperature');
 
                if (wind != null && temperature != null) {
                    updateContactUsingRestAPI(contactId, wind, temperature); // Call REST API
                } else {
                    System.debug('Error: Weather data is null');
                }
            } else {
                System.debug('Error: Unable to fetch weather data.');
            }
        } catch (Exception e) {
            System.debug('Exception in fetchAndUpdateWeatherAsync: ' + e.getMessage());
        }
    }
 
    // Method to update Contact record with weather data via REST API
    private static void updateContactUsingRestAPI(String contactId, String wind, String temperature) {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SF_Integration/services/apexrest/ContactWeatherCreationwithSF/' + contactId);
            request.setMethod('PATCH');
            request.setHeader('Content-Type', 'application/json');
            // JSON body with wind and temperature fields
            String requestBody = '{"Wind": "' + wind + '", "Temperature": "' + temperature + '"}';
            request.setBody(requestBody);
 
            HttpResponse response = http.send(request);
 
            if (response.getStatusCode() == 200) {
                System.debug('Contact updated successfully with weather data.');
            } else {
                System.debug('Error updating contact: ' + response.getStatus() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception in updateContactUsingRestAPI: ' + e.getMessage());
        }
    }
}