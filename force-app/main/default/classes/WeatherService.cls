public with sharing class WeatherService {
    private static final String API_URL = 'https://goweather.herokuapp.com/weather/Curitiba';

    @future(callout=true)
    public static void fetchWeatherData() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_URL);
        req.setMethod('GET');

        try {
            HttpResponse res = http.send(req);
            System.debug('API Response: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                // Deserialize the response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                
                // Extract weather details
                String temperature = (String) jsonResponse.get('temperature');
                String wind = (String) jsonResponse.get('wind');
                String condition = (String) jsonResponse.get('description');
                
                // Check if the weather data already exists for today
                Date today = Date.today();
                List<Weather_Report__c> existingRecords = [SELECT Id FROM Weather_Report__c WHERE CreatedDate = TODAY LIMIT 1];
                
                if (!existingRecords.isEmpty()) {
                    // Update the existing record
                    Weather_Report__c report = existingRecords[0];
                    report.Temperature__c = temperature;
                    report.Wind__c = wind;
                    report.Condition__c = condition;
                    update report;
                } else {
                    // Insert a new record
                    Weather_Report__c report = new Weather_Report__c(
                        Temperature__c = temperature,
                        Wind__c = wind,
                        Condition__c = condition
                    );
                    insert report;
                }
                System.debug('Weather data updated successfully.');
            } else {
                System.debug('Weather API call failed with status code: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error in Weather API Callout: ' + e.getMessage());
        }
    }
}