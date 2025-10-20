/**
* Quick and Dirty utility to test a REST Callout using a Named Credential
**/ 
public class CalloutUtility {
    public static final String MMODATAPOC='callout:MMODataPOC/$metadata';
    public static final String MMODATAGET='callout:MMODataPOC/FinancialTransactions';
    public static final String TESTKEY='00000000000035500598|||ANNWMA';
    /**
* Expects a named credential style url:  'callout:My_Named_Credential/some_path'
**/ 
    public static void simpleGet(final String relativeEndpoint) {
       try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(relativeEndpoint);
            req.setMethod('GET');
            System.debug(req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());            
        } catch (Exception ex) {
            System.debug(ex);
        } finally {
            
        }
    }
    public static void simpleGet() {
        simpleGet(MMODATAPOC); 
    }
    public static void getData() {
        getData(TESTKEY);
    }
    public static void getData(final String key) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(MMODATAGET);
            req.setHeader('top','10');
            req.setHeader('filter','AgreementNumber=\''+key+'\'');
            req.setHeader('count','true');
            req.setHeader('select','AgreementNumber,DueDate,ProcessedDate,TotalPayment,TransactionNumber');
            req.setMethod('GET');
            System.debug(req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());            

        } catch (Exception ex) {
            System.debug(ex);
        } finally {
            
        }
    }
}