public class OAuthTokenService {
    public static String getAccessToken() {
        String tokenEndpoint = 'https://login.salesforce.com/services/oauth2/token'; // Change to 'test.salesforce.com' for sandbox
        String clientId = '3MVG9GCMQoQ6rpzRUNwOxYS.FB1TkSpb6y6PCvNcjRMYkHcEISnJ5eugfMLyxNIABBUGBPBDTPLyF23t2Ioe7'; 
        String clientSecret = 'AE73B3E6D9991F060D9E2DB402FDEC205B52BC07BCD1F1CBEE9DCF1EF73DCE77';
        String username = 'taimoorsk99@gmail.com';
        String password = 'Asdfg@09';
        String securityToken = 'ie6oDI6uZtPv1q2W29TqgvnYM'; // Append security token if required

        // Build request body
        String requestBody = 'grant_type=password' +
                             '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                             '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
                             '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') +
                             '&password=' + EncodingUtil.urlEncode(password + securityToken, 'UTF-8');

        // HTTP request setup
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(requestBody);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            // Parse JSON response
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            system.debug('Accesstoken: '+String.valueOf(responseMap.get('access_token')));
            return (String) responseMap.get('access_token'); // Return access token
            
        } else {
            System.debug('Error: ' + res.getBody());
            return null;
        }
    }
}