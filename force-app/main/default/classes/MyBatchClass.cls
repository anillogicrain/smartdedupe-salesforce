global class MyBatchClass implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private List<SmartDD__Sync_Tracking__c> queueEntries;

    public MyBatchClass(List<SmartDD__Sync_Tracking__c> queueEntries) {
        this.queueEntries = queueEntries;
    }
    /*public List<Id> queueEntries;

    public MyBatchClass(List<Id> queueEntries) {
        this.queueEntries = queueEntries;
    }*/


    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, SmartDD__Record_Id__c
            FROM SmartDD__Sync_Tracking__c
            WHERE Id IN :queueEntries
        ]);
    }

    global void execute(Database.BatchableContext BC, List<SmartDD__Sync_Tracking__c> scope) {
        List<Lead> lstNewLeadTrigger = new List<Lead>();
        List<SmartDD__Sync_Tracking__c> syncTrackingListToUpdate = new List<SmartDD__Sync_Tracking__c>();
        for (SmartDD__Sync_Tracking__c entry : (List<SmartDD__Sync_Tracking__c>) scope) {
            lstNewLeadTrigger.add(new Lead(Id = entry.SmartDD__Record_Id__c));
        }
        
        // Implement your batch processing logic here

        system.debug(' 30 lstSyncTrackPending --> lstSyncTrackPending'+lstNewLeadTrigger);
        String apexError = ''; 
        String errMsg = ''; 
        string strResponseBody='';
        string strResponseStatus='';
        String strJsonConcat='';
        string endPoint=System.Label.SFImportAPI+'/object/updateData';
		 //HttpResponse response;        
        List<Lead> lstNewLead = new List<Lead>();
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c  limit 1];
        // Organization Id
        String orgId = lstDedupeConfig[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstDedupeConfig[0].SmartDD__UserId__c;
        // Object Name
        String objectName = 'Lead'; 
        
        system.debug(' 49 lstDedupeConfig --> '+lstDedupeConfig);
        List<SmartDD__Search_Column__c> lstDedupeColumns = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Object_Fields__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :objectName]);
        system.debug(' 51 lstDedupeColumns --> '+lstDedupeColumns);
        String  fieldnames = lstDedupeColumns[0].SmartDD__Search_Object_Fields__c;
        List<String> lstDedupeFieldAPIName = fieldnames.split(',');
        
        
        
        for (SmartDD__Sync_Tracking__c tracking : scope) {
            strJsonConcat +=tracking.SmartDD__Record_Id__c + ', ';                   
                       
        }
        if(!String.isBlank(strJsonConcat)){
            strJsonConcat = strJsonConcat.removeEnd(', ');
            system.debug('63==> '+strJsonConcat);
            String strJsonStruct =  syncLeadWithExternalServer(orgId,userId,objectName, lstDedupeFieldAPIName,strJsonConcat);
            system.debug('65 ==> '+strJsonStruct);
             try{
                HttpResponse response = httpJSONRequest(endPoint, strJsonStruct);
            
                if (response.getStatusCode() == 200) {
                    // Update the tracking record status to 'Synced'
                    for(SmartDD__Sync_Tracking__c tracking : scope){
                        SmartDD__Sync_Tracking__c objSync = new SmartDD__Sync_Tracking__c();
                        objSync.Id = tracking.Id;
                        objSync.SmartDD__Status__c = 'Synced';
                        syncTrackingListToUpdate.add(objSync);
                        //tracking.SmartDD__Status__c = 'Synced';
                        //tracking.
                    }
                    // strResponseBody = response.getBody();
                    ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'PASS', strJsonStruct, strResponseBody, apexError);
                } else {
                    // Handle API error
                    for(SmartDD__Sync_Tracking__c tracking : scope){
                        tracking.SmartDD__Status__c = 'Error';
                    }
                }
                 if(syncTrackingListToUpdate!= null && syncTrackingListToUpdate.size()>0){
                     update syncTrackingListToUpdate;
                 }
                 if(lstNewLeadTrigger!= null && lstNewLeadTrigger.size()>0){
                     update lstNewLeadTrigger;
                 }
                
                 system.debug(' 83 lstNewLeadTrigger --> '+lstNewLeadTrigger);
                system.debug(' 84 response.getBody() --> '+response.getBody());
            }
            catch(Exception e){
                errMsg = 'Something went wrong';
                apexError = e.getMessage() + ',' + '  Line No: ' + e.getLineNumber() + ',' + e.getStackTraceString();
            }

            if(!String.isBlank(errMsg)){        
                system.debug('FAIL : 91 @@ strResponseBody ' + strResponseBody);
                ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'FAIL', strJsonStruct, strResponseBody, apexError);
            }
            
            
            ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'Payload', strJsonStruct, strResponseBody, apexError);
            strJsonConcat ='';
        }
        
        
        
        
        // Update queue status to 'Processed'
        for (SmartDD__Sync_Tracking__c entry : (List<SmartDD__Sync_Tracking__c>) scope) {
            entry.SmartDD__Sync_Status__c = 'Processed';
        }
        update scope;
    }
		

    global void finish(Database.BatchableContext BC) {
        // Implement your finish logic here
        List<SmartDD__Sync_Tracking__c> pendingQueueEntries = [ SELECT Id, SmartDD__Record_Id__c
                                                               FROM SmartDD__Sync_Tracking__c
                                                               WHERE SmartDD__Sync_Status__c = 'Processing'
                                                                ];
        
         if (!pendingQueueEntries.isEmpty()) {
             CustomQueueManager.processQueue();
             System.debug('122 pendingQueueEntries --->'+pendingQueueEntries);
            } 
        System.debug('124 pendingQueueEntries --->'+pendingQueueEntries);
    }
    
     
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

    
}