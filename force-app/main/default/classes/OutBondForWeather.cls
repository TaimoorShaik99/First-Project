@RestResource(urlMapping='/WeatherApi/')
global class OutBondForWeather {

     @httpget
    global static List<Weather_Report__c> getWeatherData(){
        List<Weather_Report__c> weatherList = [Select id,Temperature__c, Wind__c, Condition__c, Date__c from Weather_Report__c];
        return weatherList;
    }
}