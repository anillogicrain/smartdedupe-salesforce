global with sharing class batchFetchDedupeRecord implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
        
    public String strQuery = '';
    public set<id> setRecordId;
    public String JSONFieldFilterStr = '';
    public String strobjname = '';
    public String struserid = '';
    public String strorganizationid = '';   
    public String isSuccess = '';  

    public batchFetchDedupeRecord (string strquerystring, string objectName, string userid, string organizationid){
        strQuery = strquerystring;
        strobjname = objectName;
        struserid = userid;
        strorganizationid = organizationid; 
        setRecordId = new set<id>();               
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){      	
        return Database.getQueryLocator(strQuery);
    }    
    
    global void execute(Database.BatchableContext bc, List<sObject> lstdata){       
       setRecordId.addAll(new Map<Id,SObject>(lstdata).keySet());
                
    }
    
    global void finish(Database.BatchableContext bc){  
        SmartDD__Manage_Cluster_Org_Tab_Id__c objOrgTabNameId = SmartDD__Manage_Cluster_Org_Tab_Id__c.getValues('Org Tab Name');
        
        JSONFieldFilterStr += '{';        
            JSONFieldFilterStr += '"organisationId":"' + strorganizationid + '",';
            JSONFieldFilterStr += '"userId":"' + struserid + '",';
            JSONFieldFilterStr += '"objectName":"' + strobjname + '",';           
            JSONFieldFilterStr += '"sfdcTabName":"DedupeManageClusterPage",';
            JSONFieldFilterStr += '"recordIds":[';
              
                for(Id recId : setRecordId){
                    JSONFieldFilterStr += '"' + recId + '",';
                    system.debug('recId >>'+recId);
                }
        
        JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
        JSONFieldFilterStr += '],';
        JSONFieldFilterStr += '"type":"dedupe"';
        JSONFieldFilterStr += '}';        
        JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
        system.debug('JSONFieldFilterStr****'+ JSONFieldFilterStr);
        String isSuccess = httpDedupeJSONRequest(System.Label.SFImportAPI+'/dedupe/start', JSONFieldFilterStr);        
        system.debug('## isSuccess ' + isSuccess);
            
        SmartDD__StartDedupeStatus__c startdedupedata = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');
        if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__API_Call_Time__c.isCreateable()){
        	startdedupedata.SmartDD__API_Call_Time__c = datetime.now();
        }    
        if(isSuccess == '1'){ 
            if (Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__IsSuccess__c.isCreateable() ){ 
                startdedupedata.SmartDD__IsSuccess__c = '1';                
            }
                
        } else if(isSuccess == '0'){
             if (Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__IsSuccess__c.isCreateable()){ 
                 startdedupedata.SmartDD__IsSuccess__c = '0';                
             }
        } else {
             if (Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__IsSuccess__c.isCreateable()){ 
                 startdedupedata.SmartDD__IsSuccess__c = null;                  
             }
        } 
       
        if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__IsSuccess__c.isCreateable() 
           && Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__IsSuccess__c.isUpdateable()
           || Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__API_Call_Time__c.isCreateable()
           && Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__API_Call_Time__c.isUpdateable()){
            upsert startdedupedata;
        }
          
        
    }
    
   public static string httpDedupeJSONRequest(String strAWSEndpointLead, string strBody){       
        string strResponseBody='';
        string strResponseStatus='';   
        string strResponsefromJava='';
        string isSuccess = '0';
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(60000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead); 
		List<SmartDD__Dedupe_Log__c> lstObjDebugLog = new List<SmartDD__Dedupe_Log__c>();
       try {
           HTTPResponse statusRes = http.send(objHTTPRequest);
           String jsonString =  statusRes.getBody();
           strResponsefromJava = jsonString;
           if (statusRes.getStatusCode() == 200){  
               system.debug('res: '+jsonString);
               isSuccess = '1';
               JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);            
               SmartDD__Dedupe_Log__c objDebugLog1 = new SmartDD__Dedupe_Log__c();
               if (Schema.sObjectType.SmartDD__Dedupe_Log__c.fields.SmartDD__Json_Response_Body__c.isCreateable()){ 
               	objDebugLog1.SmartDD__Json_Response_Body__c = jsonString;  
                lstObjDebugLog.add(objDebugLog1);  
               }    
               SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstObjDebugLog); 
               insert decision.getRecords();
               
               return objSyncDataStatus.isSuccess;
           }else {
            SmartDD__Dedupe_Log__c objDebugLog2 = new SmartDD__Dedupe_Log__c();   
            if (Schema.sObjectType.SmartDD__Dedupe_Log__c.fields.SmartDD__Json_Response_Body__c.isCreateable()){ 
               	objDebugLog2.SmartDD__Json_Response_Body__c = strResponsefromJava;  
                lstObjDebugLog.add(objDebugLog2); 
               }   
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstObjDebugLog);         
            insert decision.getRecords();
            return isSuccess;
           }     
       }
        catch(Exception e) {     
            String errMsg = 'Error Message: ' + e.getMessage() + ',' + '  Line No: ' + e.getLineNumber() + ',' + e.getStackTraceString();
            SmartDD__Dedupe_Log__c objDebugLog2 = new SmartDD__Dedupe_Log__c();        	
            objDebugLog2.SmartDD__Json_Response_Body__c = errMsg + ',' + strResponsefromJava; 
            lstObjDebugLog.add(objDebugLog2); 
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstObjDebugLog);     
            insert decision.getRecords();
            return e.getMessage();
        }
    }
}