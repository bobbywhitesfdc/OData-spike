/**
* Quick and Dirty utility to test a REST Callout using a Named Credential
**/ 
public class CalloutUtility {
    public static final String MMODATAPOC='callout:MMODataPOC/$metadata';
    /**
* Expects a named credential style url:  'callout:My_Named_Credential/some_path'
**/ 
    public static void simpleGet(final String relativeEndpoint) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(relativeEndpoint);
            req.setMethod('GET');
            System.debug(req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());            
        try {

        } catch (Exception ex) {
            System.debug(ex);
        } finally {
            
        }
    }
    public static void simpleGet() {
        simpleGet(MMODATAPOC); 
    }
}