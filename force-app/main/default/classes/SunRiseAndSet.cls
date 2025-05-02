public class SunRiseAndSet {

    public static Map<String, Object> sun(){
       Http http = new Http();
       Httprequest req = new HttpRequest();
       req.setEndPoint('https://data-api.cryptocompare.com/index/cc/v1/latest/tick?market=ccix&instruments=BTC-USD');
       req.setMethod('GET');
        
       httpResponse res=http.send(req);
       system.debug(res.getStatusCode());
        
        if(res.getStatusCode()==200){
            Map<String, Object> result= (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            system.debug(result);
            return result;
            
        }
        else{
            throw new calloutException('Error during API Call: '+ res.getStatusCode());
        }
    }
}