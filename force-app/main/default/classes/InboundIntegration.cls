public class InboundIntegration {

    public static void makeGetCallOut(){
        Http http=new Http();
        httpRequest req = new httpRequest();
        req.setEndPoint('https://goweather.herokuapp.com/weather/Curitiba');
        req.setMethod('GET');
        httpResponse res= http.send(req);
        system.debug(res.getStatusCode());
        
        if(res.getStatusCode() == 200){
            system.debug('Call out has been successfull'+ res.getBody());
        }
    }
    
    
    /*public static void spoonacularGet(){
        Http http=new Http();
        httpRequest req = new httpRequest();
        req.setEndPoint('https://api.spoonacular.com/recipes/complexSearch?apiKey=c39c2fbaf91f4e1faeea95ea7e970f84');
        req.setMethod('GET');
        httpResponse res= http.send(req);
        system.debug(res.getStatusCode());
        
        if(res.getStatusCode() == 200){
            system.debug('Call out has been successfull'+ res.getBody());
        }
    }*/
}