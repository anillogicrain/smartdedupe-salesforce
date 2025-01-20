global with sharing class batchFetchReDedupeRecord implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    public String strQuery = '';
    public Set<String> recordIds;
    List<String> lstRecordIds;
    public String JSONFieldFilterStr = '';
    public String strobjname = '';
    public String struserid = '';
    public String strorganizationid = ''; 
    public String strsfdcTabName= ''; 
    public String isSuccess = '';  
    public String strRecordIds = '';

    public batchFetchReDedupeRecord (string strquerystring, string objectName, string userid, string organizationid,string sfdcTabName){
        strQuery = strquerystring;
        strobjname = objectName;
        struserid = userid;
        strorganizationid = organizationid; 
        strsfdcTabName = sfdcTabName; 
        recordIds = new set<String>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator(strQuery);
    }    
    
    global void execute(Database.BatchableContext bc, List<sObject> lstdata){       
       
        string strRecIds = '';
        for(sObject objChildRecs : lstdata){
            recordIds.add(String.valueof(objChildRecs.get('SmartDD__Cluster_Object_Id__c')));
        }
       
        lstRecordIds = new List<String>(recordIds);strRecordIds = String.join(lstRecordIds, '","');
    }
    
    global void finish(Database.BatchableContext bc){
                      
        JSONFieldFilterStr += '{';        
            JSONFieldFilterStr += '"organisationId":"' + strorganizationid + '",';
            JSONFieldFilterStr += '"userId":"' + struserid + '",';
            JSONFieldFilterStr += '"objectName":"' + strobjname + '",';
            JSONFieldFilterStr += '"sfdcTabName":"' + strsfdcTabName + '",';
            JSONFieldFilterStr += '"type":"rededupe",';
            JSONFieldFilterStr += '"recordIds":["';
            JSONFieldFilterStr += strRecordIds.replace('00 Q', '00Q');
            JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
            JSONFieldFilterStr += '"]';
        JSONFieldFilterStr += '}';        
        JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
       
        String isSuccess = httpDedupeJSONRequest(System.Label.SFImportAPI+'/dedupe/start', JSONFieldFilterStr);
       
    }
    
   public static string httpDedupeJSONRequest(String strAWSEndpoint, string strBody){       
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(60000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpoint);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
           
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
           
            return objSyncDataStatus.isSuccess;
        }
        catch(Exception e) {
           
            return e.getMessage();
        }
    }
}