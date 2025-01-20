global class LeadSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private String query;

    public LeadSyncBatch(Set<Id> leadSyncRecordIds) {
        
      //  String testString = String.valueOf(leadSyncRecordIds); 
        
        String idsString = String.join(new List<Id>(leadSyncRecordIds), '\',\'');
        String whereClause = 'WHERE Id IN (\'' + idsString + '\')';
       
        this.query = 'SELECT Id, SmartDD__Record_Id__c, SmartDD__Status__c FROM SmartDD__Sync_Tracking__c '+whereClause;// WHERE Id IN :'+testString;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('query----------->'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<SmartDD__Sync_Tracking__c> scope) {
        
        List<Lead> lstNewLeadTrigger = new List<Lead>();
        
        List<SmartDD__Sync_Tracking__c> syncTrackingListToUpdate = new List<SmartDD__Sync_Tracking__c>();
        
        for (SmartDD__Sync_Tracking__c entry : (List<SmartDD__Sync_Tracking__c>) scope) {
            lstNewLeadTrigger.add(new Lead(Id = entry.SmartDD__Record_Id__c));
        }
        
        system.debug('executing leadsyncbatch : --> ' + scope);
        Http http = new Http();
        String apexError = ''; 
        String errMsg = ''; 
        String strResponseBody='';
        String strResponseStatus='';
        String strJsonConcat='';
        String endPoint = System.Label.SFImportAPI + '/object/updateData';
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c
                                                                  FROM SmartDD__Dedupe_Configuration__c  limit 1];
        // Organization Id
        String orgId = lstDedupeConfig[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstDedupeConfig[0].SmartDD__UserId__c;
        // Object Name
        String objectName = 'Lead'; 
		
        system.debug('L40 LeadSyncBatch lstDedupeConfig --> '+lstDedupeConfig);
        List<SmartDD__Search_Column__c> lstDedupeColumns = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Object_Fields__c
                                                                                                FROM SmartDD__Search_Column__c
                                                                                                WHERE SmartDD__Object_Name__c = :objectName]);
        system.debug('L42 LeadSyncBatch lstDedupeColumns --> '+lstDedupeColumns);
        
        String fieldnames = lstDedupeColumns[0].SmartDD__Search_Object_Fields__c;
        List<String> lstDedupeFieldAPIName = fieldnames.split(',');
             
        for (SmartDD__Sync_Tracking__c tracking : scope) {
            strJsonConcat += tracking.SmartDD__Record_Id__c + ', ';                                   
        }
        
        if(!String.isBlank(strJsonConcat)){
            strJsonConcat = strJsonConcat.removeEnd(', ');
            system.debug('L55 LeadSyncBatch strJsonConcat ==> '+strJsonConcat);
            
            String strJsonStruct =  syncLeadWithExternalServer(orgId,userId,objectName, lstDedupeFieldAPIName,strJsonConcat);
            system.debug('L58 LeadSyncBatch strJsonStruct ==> '+strJsonStruct);
            
            try{
                HttpResponse response = httpJSONRequest(endPoint, strJsonStruct);
                if (response.getStatusCode() == 200){
                   for(SmartDD__Sync_Tracking__c tracking : scope){
                        SmartDD__Sync_Tracking__c objSync = new SmartDD__Sync_Tracking__c();
                        objSync.Id = tracking.Id;
                        objSync.SmartDD__Status__c = 'Synced';
                        syncTrackingListToUpdate.add(objSync); 
                	}
                    ApiSyncErrorLogs.addErrorLog('POST', endPoint, 'updateData', 'LEAD', 'PASS', strJsonStruct, strResponseBody, apexError);
                } else{
                    for(SmartDD__Sync_Tracking__c tracking : scope){
                        tracking.SmartDD__Status__c = 'Error';
                        syncTrackingListToUpdate.add(tracking);
                    }
                }
                
                if(syncTrackingListToUpdate!= null && syncTrackingListToUpdate.size()>0){
                    update syncTrackingListToUpdate;
                }
                if(lstNewLeadTrigger!= null && lstNewLeadTrigger.size()>0){
                    update lstNewLeadTrigger;
                }
                
                system.debug('L83 LeadSyncBatch lstNewLeadTrigger --> '+lstNewLeadTrigger);
                system.debug('L84 LeadSyncBatch response.getBody() --> '+response.getBody());
                
            } catch (Exception e) {
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
    }

    global void finish(Database.BatchableContext bc) {
        system.debug('batch class finished');
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