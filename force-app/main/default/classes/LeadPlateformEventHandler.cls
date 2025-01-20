global class LeadPlateformEventHandler implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([            
            SELECT Id,Name, SmartDD__Record_Id__c, 
            SmartDD__Object_Type__c,SmartDD__Status__c 
            FROM SmartDD__Sync_Tracking__c  
            WHERE SmartDD__Object_Type__c= 'Lead' AND SmartDD__Status__c = 'Pending'
        ]);
    }

 
  /*  global List<Lead> start(Database.BatchableContext BC){
       return lstNewLeadTrigger;
    }
    
    */
    global void execute(Database.BatchableContext BC, List<Sync_Tracking__c> lstNewLeadTrigger) {
        system.debug(' 12 lstSyncTrackPending --> lstSyncTrackPending'+lstNewLeadTrigger);
        String apexError = ''; 
        String errMsg = ''; 
        string strResponseBody='';
        string strResponseStatus='';
        String strJsonConcat='';
        string endPoint=System.Label.SFImportAPI+'/object/updateData';
		 //HttpResponse response;        
        List<Lead> lstNewLead = new List<Lead>();
        
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
        // Organization Id
        String orgId = lstDedupeConfig[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstDedupeConfig[0].SmartDD__UserId__c;
        // Object Name
        String objectName = 'Lead'; 
        
        system.debug(' 76 lstDedupeConfig --> '+lstDedupeConfig);
        List<SmartDD__Search_Column__c> lstDedupeColumns = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Object_Fields__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :objectName WITH USER_MODE]);
        system.debug(' 78 lstDedupeColumns --> '+lstDedupeColumns);
        String  fieldnames = lstDedupeColumns[0].SmartDD__Search_Object_Fields__c;
        List<String> lstDedupeFieldAPIName = fieldnames.split(',');
        
        
        
        for (Sync_Tracking__c tracking : lstNewLeadTrigger) {
            strJsonConcat +=tracking.SmartDD__Record_Id__c + ', ';                   
                       
        }
        if(!String.isBlank(strJsonConcat)){
            strJsonConcat = strJsonConcat.removeEnd(', ');
            system.debug('55==> '+strJsonConcat);
            String strJsonStruct =  syncLeadWithExternalServer(orgId,userId,objectName, lstDedupeFieldAPIName,strJsonConcat);
            system.debug('58 ==> '+strJsonStruct);
             try{
                HttpResponse response = httpJSONRequest(endPoint, strJsonStruct);
            
                if (response.getStatusCode() == 200) {
                    // Update the tracking record status to 'Synced'
                    for(Sync_Tracking__c tracking : lstNewLeadTrigger){
                        tracking.SmartDD__Status__c = 'Synced';
                    }
                    // strResponseBody = response.getBody();
                    ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'PASS', strJsonStruct, strResponseBody, apexError);
                } else {
                    // Handle API error
                    for(Sync_Tracking__c tracking : lstNewLeadTrigger){
                        tracking.SmartDD__Status__c = 'Error';
                    }
                }
                update lstNewLeadTrigger;
                 system.debug(' 76 lstNewLeadTrigger --> '+lstNewLeadTrigger);
                system.debug(' 77 response.getBody() --> '+response.getBody());
            }
            catch(Exception e){
                errMsg = 'Something went wrong';
                apexError = e.getMessage() + ',' + '  Line No: ' + e.getLineNumber() + ',' + e.getStackTraceString();
            }

            if(!String.isBlank(errMsg)){        
                system.debug('FAIL : 46 @@ strResponseBody ' + strResponseBody);
                ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'FAIL', strJsonStruct, strResponseBody, apexError);
            }
            
            
            ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'Payload', strJsonStruct, strResponseBody, apexError);
            strJsonConcat ='';
        }
      
       
    }
    
   
    

    
    /*
    global void execute(Database.BatchableContext BC, List<Sync_Tracking__c> lstSyncTrackPending) {
        system.debug(' 12 lstSyncTrackPending --> lstSyncTrackPending'+lstSyncTrackPending);
        String apexError = ''; 
        String errMsg = ''; 
        string strResponseBody='';
        string strResponseStatus='';
        String strJsonConcat='';
        string endPoint=System.Label.SFImportAPI+'/object/updateData';
		 //HttpResponse response;        
        List<Lead> lstNewLead = new List<Lead>();
        
        for (Sync_Tracking__c tracking : lstSyncTrackPending) {
            strJsonConcat +=tracking.SmartDD__Record_Id__c + ', ';
            lstNewLead = [SELECT Id, FirstName, LastName, Email FROM Lead WHERE Id = :tracking.SmartDD__Record_Id__c];
            system.debug(' 24 lstNewLead --> '+lstNewLead);
            String JsonString =  syncLeadWithExternalServer(lstNewLead[0].id);
            system.debug(' 26 JsonString --> '+JsonString);
            try{
                HttpResponse response = httpJSONRequest(endPoint, JsonString);
               // Timeout
                if (response.getStatusCode() == 200) {
                    // Update the tracking record status to 'Synced'
                    tracking.SmartDD__Status__c = 'Synced';
                    strResponseBody = response.getBody();
                    ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'PASS', JsonString, strResponseBody, apexError);
                } else {
                    // Handle API error
                    tracking.SmartDD__Status__c = 'Error';
                    tracking.SmartDD__Error_Details__c = response.getBody();
                }
                 system.debug(' 38 response.getBody() --> '+response.getBody());
            }
            catch(Exception e){
                errMsg = 'Something went wrong';
                apexError = e.getMessage() + ',' + '  Line No: ' + e.getLineNumber() + ',' + e.getStackTraceString();
            }

            if(!String.isBlank(errMsg)){        
                system.debug('FAIL : 46 @@ strResponseBody ' + strResponseBody);
                ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'FAIL', JsonString, strResponseBody, apexError);
            }
            
        }
        if(!String.isBlank(strJsonConcat)){
            strJsonConcat = strJsonConcat.removeEnd(', ');
            system.debug('55==> '+strJsonConcat);
            String strJsonStruct =  syncLeadWithExternalServer(strJsonConcat);
            ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'Payload', strJsonStruct, strResponseBody, apexError);
            strJsonConcat ='';
        }
      
        update lstSyncTrackPending;
    }*/  
    global void finish(Database.BatchableContext BC){}
    
    
    public static String syncLeadWithExternalServer(String orgId,String userId,String objectName,List<String> lstDedupeFieldAPIName,String lstNewLead) {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
        
        String strDedupeFields = '';
        for (String dedupeFieldAPIName: lstDedupeFieldAPIName) {  
            String dedupeFieldlabel = '';
            String dedupeFieldName = '';
            if(dedupeFieldAPIName != 'Owner.Name' && dedupeFieldAPIName != 'Account.Name'){
                dedupeFieldlabel = fieldMap.get(dedupeFieldAPIName).getDescribe().getLabel();
                dedupeFieldName = fieldMap.get(dedupeFieldAPIName).getDescribe().getname();
            } else if(dedupeFieldAPIName == 'Account.Name') {
                dedupeFieldlabel = 'Account Name';
                dedupeFieldName = 'Account.Name';
            } else {
                dedupeFieldlabel = 'Owner Name';
                dedupeFieldName = 'Owner.Name';
            }
            strDedupeFields +=  dedupeFieldName + '::' + dedupeFieldlabel + ',';
        }
        strDedupeFields = strDedupeFields.removeEnd(',');
        
        String JsonString = postSyncDedupeRecords(orgId, userId, objectName, strDedupeFields, lstNewLead);	
        
     //   HttpResponse response = httpJSONRequest(System.Label.SFImportAPI+'/object/updateData', JsonString);
        
        // Implement the logic to make the API callout to sync the lead record
        // Return the HTTP response
        return JsonString;
    }
    
    
    /******************************************************/
    //Http Request Body
    /******************************************************/
   public static HttpResponse httpJSONRequest(String strAWSEndpointLead, string strBody) {
      
           HttpRequest objHTTPRequest = new HttpRequest();
           objHTTPRequest.setTimeout(120000);
           objHTTPRequest.setMethod('POST');
           objHTTPRequest.setHeader('Content-Type', 'application/json');
           objHTTPRequest.setBody(strBody);
           objHTTPRequest.setEndpoint(strAWSEndpointLead);
           
           Http http = new Http();
           HTTPResponse statusRes = http.send(objHTTPRequest);
           //strResponseBody =  statusRes.getBody();
           System.debug('129 --> '+statusRes.getBody());
           return statusRes;   
    }
    
      /******************************************************/
    //POST DedupeSync JSON DATA
    /******************************************************/
      public static String postSyncDedupeRecords(String orgId, String userId, String objectName, String strDedupeFields, String leadRecordId) { //NOPMD
        
        String JSONSyncRecString = ''; //NOPMD
        JSONSyncRecString  += '{';
        
        JSONSyncRecString  += '"organisationId":"' + orgId + '",';
        JSONSyncRecString  += '"userId":"' + userId + '",';
        JSONSyncRecString  += '"objectName":"' + objectName + '",';
        JSONSyncRecString  += '"dedupeFields":"' + strDedupeFields + '",';
        JSONSyncRecString  += '"recordIds":"' + leadRecordId + '"';
        
        JSONSyncRecString  += '}';
        system.debug('@#$JSONSyncRecString: '+JSONSyncRecString);
        return JSONSyncRecString;
      //  httpJSONRequest(System.Label.SFImportAPI+'/object/updateData', JSONSyncRecString);
    }

    
    
    
  /*  public static void syncNewLeadRecord(List<Lead> lstNewLeadRec) {       
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
        // Organization Id
        String orgId = lstDedupeConfig[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstDedupeConfig[0].SmartDD__UserId__c;
        // Object Name
        String objectName = 'Lead'; 
        Set<String> strLeadRecordIds = new Set<String>();    
        for(Lead objLeadRec : lstNewLeadRec) {
            strLeadRecordIds.add(objLeadRec.Id);
        }
        // To Set record Ids
        String leadRecordIds = '';
        for(String objLeadRec : strLeadRecordIds) {
            leadRecordIds +=  objLeadRec + ', ';
        }
        leadRecordIds = leadRecordIds.removeEnd(', ');
        List<SmartDD__Search_Column__c> lstDedupeColumns = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Object_Fields__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :objectName WITH USER_MODE]);
        
        String  fieldnames = lstDedupeColumns[0].SmartDD__Search_Object_Fields__c;
        List<String> lstDedupeFieldAPIName = fieldnames.split(',');
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
        
        String strDedupeFields = '';
        for (String dedupeFieldAPIName: lstDedupeFieldAPIName) {  
            String dedupeFieldlabel = '';
            String dedupeFieldName = '';
            if(dedupeFieldAPIName != 'Owner.Name' && dedupeFieldAPIName != 'Account.Name'){
                dedupeFieldlabel = fieldMap.get(dedupeFieldAPIName).getDescribe().getLabel();
                dedupeFieldName = fieldMap.get(dedupeFieldAPIName).getDescribe().getname();
            } else if(dedupeFieldAPIName == 'Account.Name') {
                dedupeFieldlabel = 'Account Name';
                dedupeFieldName = 'Account.Name';
            } else {
                dedupeFieldlabel = 'Owner Name';
                dedupeFieldName = 'Owner.Name';
            }
            strDedupeFields +=  dedupeFieldName + '::' + dedupeFieldlabel + ',';
        }
        strDedupeFields = strDedupeFields.removeEnd(',');
        
       // postSyncDedupeRecords(orgId, userId, objectName, strDedupeFields, leadRecordIds);	
    } 

*/
    /******************************************************/
    //POST DedupeSync JSON DATA
    /******************************************************/
    // @Future(callout=true)
  /*  public static String postSyncDedupeRecords(String orgId, String userId, String objectName, String strDedupeFields, String leadRecordIds) { //NOPMD
        
        String JSONSyncRecString = ''; //NOPMD
        JSONSyncRecString  += '{';
        
        JSONSyncRecString  += '"organisationId":"' + orgId + '",';
        JSONSyncRecString  += '"userId":"' + userId + '",';
        JSONSyncRecString  += '"objectName":"' + objectName + '",';
        JSONSyncRecString  += '"dedupeFields":"' + strDedupeFields + '",';
        JSONSyncRecString  += '"recordIds":"' + leadRecordIds + '"';
        
        JSONSyncRecString  += '}';
        system.debug('@#$JSONSyncRecString: '+JSONSyncRecString);
      //  httpJSONRequest(System.Label.SFImportAPI+'/object/updateData', JSONSyncRecString);
    }
*/
    

}