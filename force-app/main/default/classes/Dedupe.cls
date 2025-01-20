global with sharing class Dedupe{

    public HttpResponse ApiCallout(string strURL, string strMethod, string strBody){
        system.debug('@@@strURL@@@ ' + strURL);
        system.debug('@@@strMethod@@@ ' + strMethod);
        system.debug('@@@strBody@@@ ' + strBody);
        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(strURL);
        request.setMethod(strMethod);
        request.setTimeout(120000);
        //req.setCompressed(true);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody(strBody);
        HttpResponse response = http.send(request);
        system.debug('response ===== ' + response);
        return response;
    }
    
    public String fnLeadQuery(){
        string soql = 'SELECT Id, FirstName, LastName, Title, Street, City, State, PostalCode, ';
        soql += 'Country, Phone, Company, Email, Status, IsConverted,SmartDD__DedupeId__c FROM Lead where IsConverted=false WITH USER_MODE limit 3 ';
        return soql;
    }
    
    public void fnDedupePOST(){
        List<Lead> lst = new List<Lead>();
        lst = Database.query(fnLeadQuery());
        wrpDedupe objwrp = new wrpDedupe();
        
        for(Lead obj : lst){
            System.JSONParser parser = System.JSON.createParser('{}'); 
            DedupeJSONRequest.Recorddata objRecorddata = new DedupeJSONRequest.Recorddata(parser);
            
            //if(!string.isBlank(obj.DedupeId__c)){
                //objRecorddata.recordid =  Integer.valueof(obj.DedupeId__c);
            //}
            objRecorddata.zip = obj.PostalCode;
            objRecorddata.country = obj.Country;
            objRecorddata.firstname = obj.FirstName;
            objRecorddata.address = obj.Street;
            objRecorddata.city = obj.City;
            objRecorddata.phone = obj.Phone;
            objRecorddata.company = obj.Company;
            objRecorddata.state = obj.State;
            objRecorddata.title = obj.Title;
            objRecorddata.email = obj.Email;
            objRecorddata.lastname = obj.LastName;
            
            System.JSONParser parser1 = System.JSON.createParser('{}'); 
            DedupeJSONRequest.Leaddata objLD = new DedupeJSONRequest.Leaddata(parser1);
            objLD.recorddata = objRecorddata;
            objwrp.leaddata.add(objLD);
        }
        
        string strURL = 'https://115.118.243.116:8084/SFImport/Dedupe/Insert';
        
        system.debug('@@@strURL@@@ ' + strURL);
        system.debug('@@@strBody@@@ ' + stripJsonNulls(JSON.serialize(objwrp)));
        
        ApiCallout(strURL,'POST',stripJsonNulls(JSON.serialize(objwrp)));
        
    }
    
    public class wrpDedupe {
        public List<DedupeJSONRequest.Leaddata> leaddata {get;set;} 
        //public List<DedupeJSONRequest.Recorddata> leaddata {get;set;} 
        public wrpDedupe(){
            leaddata = new List<DedupeJSONRequest.Leaddata>();
        }
    }
    
    public string stripJsonNulls(string JsonString)
    {
        if(JsonString != null)      
        {
            JsonString = JsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }
    
        return JsonString;
    }
}