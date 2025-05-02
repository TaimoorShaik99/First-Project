public class BitcoinPriceService {
private static final String API_URL = 'https://data-api.cryptocompare.com/index/cc/v1/latest/tick?market=ccix&instruments=BTC-USD';

    // Method to Fetch and Store Bitcoin Price
    public static void fetchAndStoreBitcoinPrice() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_URL);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                // Parse JSON Response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> data = (Map<String, Object>) jsonResponse.get('Data');
                Map<String, Object> btcUsd = (Map<String, Object>) data.get('BTC-USD');

                // Map JSON to Custom Object Fields
                Bitcoin_Price__c priceRecord = new Bitcoin_Price__c();
                priceRecord.Value__c = (Decimal) btcUsd.get('VALUE');
                priceRecord.Market__c = (String) btcUsd.get('MARKET');
                priceRecord.Instrument__c = (String) btcUsd.get('INSTRUMENT');
                Long timestamp = (Long) btcUsd.get('VALUE_LAST_UPDATE_TS');
                priceRecord.Last_Update_Timestamp__c = 
                    DateTime.newInstance(timestamp * 1000);

                // Store in Salesforce
                insert priceRecord;
            } else {
                System.debug('Failed to fetch Bitcoin price: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
    }
}