/********************************************************************************************
* NAME         : SyncDataController
* DESCRIPTION  : This class is use to send the selected object in json.
*
* @AUTHOR: Dev team
* @DATE: 10/16/2018
*
*
* MODIFICATION LOG:
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
Dev team                            10/16/2018                            -
********************************************************************************************/
global with sharing class SyncDataController { //NOPMD
    
    @AuraEnabled
    global static string SyncData() { //NOPMD
        SmartDD__De_Dupe_Configuration__c deDupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        String syncObjectName = deDupeConfig.SmartDD__Sync_Object_Name__c;
        String objectType = syncObjectName;
        system.debug('SyncDataobjectType'+objectType);
        string strerrorMessaeg = SyncDatarecords(objectType);
        System.debug('strerrorMessaeg :'+ strerrorMessaeg );
        return strerrorMessaeg ;
    }
    
    @AuraEnabled
    public static SmartDD__De_Dupe_Configuration__c SyncCountRecordsData() { //NOPMD
        SmartDD__De_Dupe_Configuration__c deDupeConfiguration = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        return deDupeConfiguration;
    }
    
    //POST SyncDatarecords JSON DATA
    global static string SyncDatarecords(String objectType) { //NOPMD
        string httpResMessage ;
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
        
        String JSONObjectTypeString = ''; //NOPMD
        JSONObjectTypeString += '{';
        if(lstDedupeConfig.size() > 0) {
            JSONObjectTypeString += '"Object Name":"'+ objectType +'",';
            JSONObjectTypeString += '"Organization Id":"'+ lstDedupeConfig[0].SmartDD__Organization_Id__c +'",';
            JSONObjectTypeString += '"UserId":"'+ lstDedupeConfig[0].SmartDD__UserId__c +'"';
        }
        
        JSONObjectTypeString += '}';
        System.debug('JSONObjectTypeString Sync Data :'+JSONObjectTypeString);
        
        // Code to add logs in Dedupe Log Object.
        List<SmartDD__Dedupe_Log__c> lstObjDebugLog  = new List<SmartDD__Dedupe_Log__c>();
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Sync Record Request';
        objDebugLog.SmartDD__Json_Request_Body__c = JSONObjectTypeString;
        objDebugLog.SmartDD__Requested_On_Object__c = objectType;
        string strQueryTotalRec = 'SELECT COUNT() FROM '+ objectType + ' WITH USER_MODE';
        Integer totalRecords = Database.countQuery(strQueryTotalRec); //NOPMD
        objDebugLog.SmartDD__Total_Records_Operated__c = totalRecords;
        
        // Calling endpoint through HTTP request.
        HttpRequest objSaveData = httpJSONRequest(System.Label.SFImportAPI+'/object/saveData', JSONObjectTypeString);
        Http http = new Http();
        try {
            HTTPResponse saveReq = http.send(objSaveData);
            String jsonSaveString =  saveReq.getBody();
            //objDebugLog.Json_Response_Body__c = jsonSaveString;
            Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
            if(schemaDedupeLog.isCreateable() || schemaDedupeLog.isUpdateable()){
                SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDebugLog); 
                upsert decision.getRecords(); //NOPMD
            }
            JSONSyncData objSyncDataStatus;
            
            if(Test.isRunningTest()){
                objSyncDataStatus.error = 'test error message';
                objSyncDataStatus.errorDescription = 'authentication failure';
            } else {
                objSyncDataStatus = JSONSyncData.parse(jsonSaveString );
            }
            if(objSyncDataStatus.error != null && objSyncDataStatus.errorDescription == 'authentication failure') {
                httpResMessage = objSyncDataStatus.errorDescription;
                SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                dedupeconfig.SmartDD__Data_Mapping__c = false;dedupeconfig.SmartDD__Sync_Data__c = false;
                if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
                    upsert dedupeconfig; //NOPMD
                }
                SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
                syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;syncdata.SmartDD__Save_Mapping__c = false;
                if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Sync_Data__c.isUpdateable() ){ 
                    upsert syncdata; 
                }
                List<SmartDD__Duplicate_Record__c> lstOfallDuplicateRecords  = [Select Id,SmartDD__Duplicate_Id__c FROM SmartDD__Duplicate_Record__c WITH USER_MODE];
                if(lstOfallDuplicateRecords.size() > 0){
                    if(Schema.SObjectType.SmartDD__Duplicate_Record__c.isDeletable()){
                        delete lstOfallDuplicateRecords; //NOPMD
                    }            
                }
            }
            else {
                httpResMessage = 'success';
            }
        }
        catch(Exception e){
            SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeconfig.SmartDD__Data_Mapping__c = false;
            dedupeconfig.SmartDD__Sync_Data__c = false;
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
                upsert dedupeconfig; //NOPMD
            }
            
            SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Save_Mapping__c = false;
            if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
                upsert syncdata;
            }
            System.debug('Sync Data Status: '+syncdata);
            
            List<SmartDD__Duplicate_Record__c> lstOfallDuplicateRecords  = [Select Id,SmartDD__Duplicate_Id__c FROM SmartDD__Duplicate_Record__c WITH USER_MODE];
            if(lstOfallDuplicateRecords.size() > 0){
                if(Schema.SObjectType.SmartDD__Duplicate_Record__c.isDeletable()){
                    delete lstOfallDuplicateRecords; //NOPMD
                }            
            }
            //objDebugLog.Json_Response_Body__c = httpResMessage;
            Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
            if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable()){
                SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDebugLog); 
                upsert decision.getRecords(); //NOPMD
            }
            httpResMessage = e.getMessage();
            
            return httpResMessage ;
        }
        
        //Delete Duplicate Records from Duplicate Records Object
        List<SmartDD__Duplicate_Record__c> lstOfallDuplicateRecords  = [Select Id,SmartDD__Duplicate_Id__c FROM SmartDD__Duplicate_Record__c WITH USER_MODE];
        if(lstOfallDuplicateRecords.size() > 0){
            if(Schema.SObjectType.SmartDD__Duplicate_Record__c.isDeletable()){
                delete lstOfallDuplicateRecords; //NOPMD
            }            
        }
        system.debug('httpResMessage@@ ' + httpResMessage);
        return httpResMessage;
    }
    
    @AuraEnabled
    public static string checkCredentials(){ //NOPMD
        SmartDD__De_Dupe_Configuration__c deDupeConfiguration = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        String syncObjectName = deDupeConfiguration.SmartDD__Sync_Object_Name__c;
        String objectType = syncObjectName;
        system.debug('checkCredentialsobjectType'+objectType);
        string httpResMessage ;
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
        String JSONObjectTypeString = ''; //NOPMD
        JSONObjectTypeString += '{';
        if(lstDedupeConfig.size() > 0) {
            JSONObjectTypeString += '"Object Name":"'+ objectType +'",';
            JSONObjectTypeString += '"Organization Id":"'+ lstDedupeConfig[0].SmartDD__Organization_Id__c +'",';
            JSONObjectTypeString += '"UserId":"'+ lstDedupeConfig[0].SmartDD__UserId__c +'"';
        }
        
        JSONObjectTypeString += '}';
        // Calling endpoint through HTTP request.
        HttpRequest objSaveData = httpJSONRequest(System.Label.SFImportAPI+'/object/checkBeforeSync', JSONObjectTypeString);
        Http http = new Http();
        try{
            HTTPResponse saveReq = http.send(objSaveData);
            system.debug('saveReq'+saveReq);
            String jsonSaveString =  saveReq.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonSaveString);
            if(objSyncDataStatus.error != null)  {
                if(objSyncDataStatus.errorDescription == 'authentication failure') {
                    httpResMessage = objSyncDataStatus.errorDescription;
                } else if(objSyncDataStatus.errorDescription == 'Database not available.' ) {
                    httpResMessage = objSyncDataStatus.errorDescription;
                } else if(objSyncDataStatus.errorDescription == 'client identifier invalid' ) { 
                    httpResMessage = 'Connected App Details Wrong';
                }
            }
            else {
                SmartDD__De_Dupe_Configuration__c dedupeExtStat = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                dedupeExtStat.SmartDD__ExternalSyncStatus__c = 'Processing'; 
                if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
                    upsert dedupeExtStat; //NOPMD
                }
                httpResMessage = 'success';
            }
        }
        catch(Exception e){
            SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeconfig.SmartDD__Data_Mapping__c = false;
            dedupeconfig.SmartDD__Sync_Data__c = false;
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()){
                upsert dedupeconfig; //NOPMD
            }
            
            SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Save_Mapping__c = false;
            if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
                upsert syncdata;
            }
            httpResMessage = e.getMessage();
            return httpResMessage ;
        } 
        return httpResMessage;
    }
       
    
    // Method to fetch Sync Data value from custom setting Check DeDupe Configuration
    @AuraEnabled
    public static SmartDD__De_Dupe_Configuration__c GetDedupeConfigCustomSettings() { //NOPMD
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        return dedupeconfig;
    }
    
    //Http Request Body
    public static HttpRequest httpJSONRequest(String strAWSEndpointLead, string strBody) {
        HttpRequest objHTTPRequest = new HttpRequest();
        Http httpProtocol = new Http();
        objHTTPRequest.setTimeout(10000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setEndpoint(strAWSEndpointLead);
        
        return objHTTPRequest;
    }
    
    @AuraEnabled
    public static String CheckSyncStatus() { //NOPMD
        SmartDD__De_Dupe_Configuration__c deDupeConfiguration = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        String syncObjectName = deDupeConfiguration.SmartDD__Sync_Object_Name__c;
        String objectType = syncObjectName;
        system.debug('CheckSyncStatussobjectType'+objectType);
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        if(dedupeconfig.SmartDD__ExternalSyncStatus__c != 'Completed') {
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){
                dedupeconfig.SmartDD__Sync_Data__c = true;
            }
        }
        else{
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){
                dedupeconfig.SmartDD__Data_Mapping__c = false;
                dedupeconfig.SmartDD__Sync_Data__c = false;
            }
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Sync_date__c.isCreateable()){
                dedupeconfig.SmartDD__Last_Sync_date__c = System.now();
            }
        }
        system.debug('dedupeconfig.SmartDD__ExternalSyncStatus__c   ' + dedupeconfig.SmartDD__ExternalSyncStatus__c);
        return dedupeconfig.SmartDD__ExternalSyncStatus__c;
    }
    
    @AuraEnabled
    // To check the status of the records been inserted.
    public static Map<String, Integer> CheckSyncprogress() { //NOPMD
        SmartDD__De_Dupe_Configuration__c deDupeConfiguration = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        String syncObjectName = deDupeConfiguration.SmartDD__Sync_Object_Name__c;
        String objectType = syncObjectName;
        string strQueryTotalRec = 'SELECT COUNT() FROM '+ String.escapeSingleQuotes(objectType) + ' WITH USER_MODE';
        Integer totalRecords = Database.countQuery(strQueryTotalRec); //NOPMD
        try {
            if(totalRecords > 1) {
                List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c, SmartDD__Email__c, SmartDD__Last_Name__c, SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
                
                String JSONObjectTypeString = ''; //NOPMD
                JSONObjectTypeString += '{';
                if(lstDedupeConfig.size() > 0) {
                    JSONObjectTypeString += '"Object Name":"'+ objectType +'",';
                    JSONObjectTypeString += '"Organization Id":"'+ lstDedupeConfig[0].SmartDD__Organization_Id__c +'",';
                    JSONObjectTypeString += '"UserId":"'+ lstDedupeConfig[0].SmartDD__UserId__c +'"';
                }        
                JSONObjectTypeString += '}';
                System.debug('JSONObjectTypeString :'+JSONObjectTypeString);
                HttpRequest objCheckStatusReq = httpJSONRequest(System.Label.SFImportAPI+'/object/check', JSONObjectTypeString);
                Http http = new Http();
                HTTPResponse statusRes = http.send(objCheckStatusReq); // we need to add 
                String jsonString =  statusRes.getBody();
                JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString); 
            
                SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                if(objSyncDataStatus.duplicateRecords == null){
                    objSyncDataStatus.duplicateRecords = String.ValueOf(0); 
                }
                if(objSyncDataStatus.insertedRecords == null){
                    objSyncDataStatus.insertedRecords = String.ValueOf(0); 
                }
                if(objSyncDataStatus.totalRecords== null){
                    objSyncDataStatus.totalRecords= String.ValueOf(0); 
                }
                if(objSyncDataStatus.duplicateRecords != null && objSyncDataStatus.insertedRecords != null && objSyncDataStatus.totalRecords != null && Integer.ValueOf(objSyncDataStatus.totalRecords) > 0) {
                    Integer statPercentVal = (Integer.ValueOf(objSyncDataStatus.duplicateRecords) + Integer.ValueOf(objSyncDataStatus.insertedRecords)) * 100 / Integer.ValueOf(objSyncDataStatus.totalRecords);
                    if(statPercentVal != 100) {
                        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){ //NOPMD
                            dedupeconfig.SmartDD__Sync_Data__c = true;
                        }
                    }
                    else{
                        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){dedupeconfig.SmartDD__Data_Mapping__c = false;
                            dedupeconfig.SmartDD__Sync_Data__c = false;
                        }
                        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Sync_date__c.isCreateable()){dedupeconfig.SmartDD__Last_Sync_date__c = System.now();
                        }
                    }
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){upsert dedupeconfig;
                    }            
                    //Update SyncData Custom setting Value
                    SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;syncdata.SmartDD__Save_Mapping__c = false;
                    if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){upsert syncdata;
                    }       
                    Map<String, Integer> syncDataStatus = new Map<String, Integer>{'duplicateRecords' => Integer.ValueOf(objSyncDataStatus.duplicateRecords), 'insertedRecords' => Integer.ValueOf(objSyncDataStatus.insertedRecords), 'totalRecords' => Integer.ValueOf(objSyncDataStatus.totalRecords), 'Processing' => 0, 'Completed' => 0};
                    Integer intPercentVal = (Integer.ValueOf(objSyncDataStatus.duplicateRecords) + Integer.ValueOf(objSyncDataStatus.insertedRecords)) * 100 / Integer.ValueOf(objSyncDataStatus.totalRecords);
                    if(intPercentVal >= 100) {SmartDD__De_Dupe_Configuration__c dedupeUpdateExtStat = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                        dedupeUpdateExtStat.SmartDD__ExternalSyncStatus__c = 'Completed'; 
                        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()){ //NOPMD
                            system.debug('!@#ExternalSyncStatus__c: '+ dedupeUpdateExtStat.SmartDD__ExternalSyncStatus__c);
                            upsert dedupeUpdateExtStat;
                        }
                        syncDataStatus = new Map<String, Integer>{'Processing' => 0, 'Completed' => 1};
                    }return syncDataStatus;
                }
                else{
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){
                        dedupeconfig.SmartDD__Data_Mapping__c = false;
                        dedupeconfig.SmartDD__Sync_Data__c = false;
                    }
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
                        upsert dedupeconfig;
                    } 
                    SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
                    syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;
                    syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
                    syncdata.SmartDD__Save_Mapping__c = false;
                    if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
                        upsert syncdata;
                    } 
                    return null;
                }
            } else {SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');if(dedupeconfig.SmartDD__ExternalSyncStatus__c != 'Completed') {
                    /*if(Schema.sObjectType.De_Dupe_Configuration__c.fields.Sync_Data__c.isCreateable()){
                        dedupeconfig.Sync_Data__c = true;
                        //upsert dedupeconfig;
                    }*/
                    Map<String, Integer> syncDataStatus = new Map<String, Integer>{'Processing' => 1, 'Completed' => 0};system.debug('@#$syncDataStatus12 : '+ syncDataStatus);
                    return syncDataStatus;
                } else {
                    system.debug('@#$ExternalSyncStatus__c : '+ dedupeconfig.SmartDD__ExternalSyncStatus__c );
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){
                        dedupeconfig.SmartDD__Data_Mapping__c = false;
                        dedupeconfig.SmartDD__Sync_Data__c = false;
                    }
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Sync_date__c.isCreateable()){
                        dedupeconfig.SmartDD__Last_Sync_date__c = System.now();
                    }
                    if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){upsert dedupeconfig;
                    }
                    Map<String, Integer> syncDataStatus = new Map<String, Integer>{'Processing' => 0, 'Completed' => 1};system.debug('@#$syncDataStatus34 : '+ syncDataStatus);
                    return syncDataStatus;
                }
            }
        } catch(Exception e) { 
            SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeconfig.SmartDD__Data_Mapping__c = false;
            dedupeconfig.SmartDD__Sync_Data__c = false;
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
                upsert dedupeconfig;
            }
            system.debug('@#$syncDataStatus56 : ');
            SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Save_Mapping__c = false;
            if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
                upsert syncdata;
            }return null;
        }
    }    
    @AuraEnabled
    //To find lead duplicate records
    public static Id findDuplicateData() { //NOPMD
        Id BatchProcessId; //NOPMD
        SmartDD__De_Dupe_Configuration__c deDupeConfiguration = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        String syncObjectName = deDupeConfiguration.SmartDD__Sync_Object_Name__c;
        String objectType = syncObjectName;
        system.debug('findDuplicateDataobjectType'+syncObjectName);
        if(objectType != '' && objectType != null){
            // lead object
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            // lead fields
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectType).getDescribe().fields.getMap();
            /*
            Set<String> setLeadFieldMapping = new Set<String>{'isdeleted','latitude','longitude','geocodeaccuracy','photourl',
                + 'emailbouncedreason','emailbounceddate','isconverted','converteddate',
                + 'convertedaccountid','convertedcontactid', 'dandbcompanyid','convertedopportunityid',
                + 'numberoflocations__c','dedupeid__c','createddate','lastmodifieddate','lastactivitydate',
                + 'lastvieweddate', 'lastreferenceddate', 'jigsaw', 'jigsawcontactid','siccode__c',
                + 'isunreadbyowner','systemmodstamp','productinterest__c','currentgenerators__c','primary__c'
                };
            */
            Set<String> setFields = new Set<String>();
            
            Set<String> setLeadFieldMapping = new Set<String>();
            for(SmartDD__Lead_Unused_Fields__c fieldName : [select SmartDD__Field_Name__c from SmartDD__Lead_Unused_Fields__c WHERE SmartDD__Object_Name__c =: objectType WITH USER_MODE]){ //NOPMD
                setLeadFieldMapping.add(fieldName.SmartDD__Field_Name__c);
            }
            
            List<SmartDD__Search_Column__c> lstMapFieldColumns = new List<SmartDD__Search_Column__c>([SELECT Id, Name, SmartDD__Object_Name__c, SmartDD__Search_Object_Fields__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c =: objectType WITH USER_MODE]);
            List<String> lstDedupeFields = new List<String>();
            lstDedupeFields = lstMapFieldColumns[0].SmartDD__Search_Object_Fields__c.Split(',');
            // strFields used to prepare SOQL Query
            String strFields = '';
            String query = '';   
            // skip declared fields from all lead object fields.
            /*for(String fieldName : fieldMap.keyset() ){
                If(!setLeadFieldMapping.contains(fieldName)) {
                    if(!setFields.contains(fieldName)){
                        setFields.add(fieldName);
                        strFields += fieldName + ',';
                    }
                }
            }*/
            for(String fieldName : lstDedupeFields){
                if(!setFields.contains(fieldName)){
                    setFields.add(fieldName);
                    strFields += fieldName + ',';
                }   
            }
            
            strFields = strFields.removeEnd(',');
            query = 'select ' + strFields + ' from ' + objectType + ' WITH USER_MODE';
            batchFetchDuplication leadDuplicateBatch = new batchFetchDuplication(query,setFields,objectType);
            BatchProcessId  = Database.executeBatch(leadDuplicateBatch,200);
            system.debug('BatchProcessId'+BatchProcessId);
            SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
            if(BatchProcessId != null || BatchProcessId != ''){
                if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isUpdateable()){
                    syncdata.SmartDD__Find_Duplicate_Batch_Id__c = BatchProcessId ;
                }
            }
            if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
                upsert syncdata;
            }               
            SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeconfig.SmartDD__Sync_Data__c = true;
            system.debug('dedupeconfig'+dedupeconfig);
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
                upsert dedupeconfig;
            } 
            system.debug('dedupeconfig'+dedupeconfig);
        }
        return BatchProcessId;
    }
    //To get batch status 
    @AuraEnabled
    public static String batchStatus(Id BatchProcessId) { //NOPMD
        AsyncApexJob async; 
        if(BatchProcessId != null || BatchProcessId != ''){
           async = [SELECT Status, NumberOfErrors FROM AsyncApexJob  WHERE Id =: BatchProcessId WITH USER_MODE];
        }
        return async.Status;
    }    
    @AuraEnabled
    Public static AsyncApexJobWrapper AsyncApexJobRecords(Id BatchProcessId){ //NOPMD
        
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper(); 
        if(BatchProcessId != null || BatchProcessId != ''){      
            objApexJob.lstAsyncApexJob = [SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE];
            objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems; 
            objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed; 
            objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status; 
        }
        return objApexJob; 
    }    
    //To get total number of lead duplicate records 
    @AuraEnabled
    Public static integer getDuplicateRecords(){
        Integer duplicateleadCount = 0;
        duplicateleadCount = database.countQuery('select count() from SmartDD__Duplicate_Record__c WITH USER_MODE');
        return duplicateleadCount;
    }
    //Delete all duplicate records from lead 
    @AuraEnabled
    public static Id findDeleteDuplicateData(){
       SmartDD__De_Dupe_Configuration__c deDupeConfiguration = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
       String syncObjectName = deDupeConfiguration.SmartDD__Sync_Object_Name__c;
       String objectType = syncObjectName;
        
       system.debug('findDeleteDuplicateDatabjectType'+syncObjectName);
        
       Id delprcocessId;
        List<SmartDD__Duplicate_Record__c> lstOfDuplicateRscords  = [Select Id,SmartDD__Duplicate_Id__c FROM SmartDD__Duplicate_Record__c WITH USER_MODE];
        set<Id> duplicaterecodId = new Set<ID>();
        if(lstOfDuplicateRscords.size() > 0 ){
            for(SmartDD__Duplicate_Record__c duplictrec : lstOfDuplicateRscords){
                duplicaterecodId.add(duplictrec.SmartDD__Duplicate_Id__c);
            }
        }
        if(Schema.SObjectType.SmartDD__Duplicate_Record__c.isDeletable()){
            delete lstOfDuplicateRscords; //NOPMD
        }
        // string Delquery = 'Select Id  from Lead where Id IN : duplicaterecodId';
        string Delquery = 'select Id from ' + objectType + ' where Id IN : duplicaterecodId WITH USER_MODE' ; //NOPMD
        // List<Lead> lstOfLead = DataBase.query(Delquery);
        batchDeleteDuplication deleteBatchRecords = New batchDeleteDuplication(Delquery,duplicaterecodId,objectType);
        Id BatchProcessId = Database.executeBatch(deleteBatchRecords,200); //NOPMD
        
        SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
        syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = BatchProcessId ;
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            upsert syncdata;
        }      
        return BatchProcessId ; 
    }
    //To fetch Sync Data value from custom setting for Check status of batch
    @AuraEnabled
    public static string GetBatchStatusCustomSettings() { //NOPMD
        string BatchProcessId =''; //NOPMD
        SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status'); 
            if(syncdata.SmartDD__Find_Duplicate_Batch_Id__c != ''){
                BatchProcessId = syncdata.SmartDD__Find_Duplicate_Batch_Id__c + '#fatchdata' ;
            }else if(syncdata.SmartDD__Delete_Duplicate_Batch_Id__c != ''){
                BatchProcessId = syncdata.SmartDD__Delete_Duplicate_Batch_Id__c + '#deletedata' ;
            }        
        return BatchProcessId ;
    }
    //get Save Mapping is true or false
    @AuraEnabled
    public static Boolean synDataMapCustomsetting(){
        Boolean hasUseMapping;
        SmartDD__Sync_Data__c synDataMap = SmartDD__Sync_Data__c.getValues('Sync Data Status');
        hasUseMapping = synDataMap.SmartDD__Save_Mapping__c ;
        return hasUseMapping;
    }
    
    @AuraEnabled
    Public static SmartDD__Dedupe_Configuration__c credentialDetails(){
        SmartDD__Dedupe_Configuration__c objDedupeConfig = new SmartDD__Dedupe_Configuration__c();
        objDedupeConfig = [select id, name, SmartDD__Username__c from SmartDD__Dedupe_Configuration__c  WITH USER_MODE limit 1];
        return objDedupeConfig;
    }
    
    //Wrapperclass for to find number of duplicate lead records.
    public class duplicateRecordsWrapper{ //NOPMD
        @AuraEnabled public Integer duplicateleadCount{get;set;}@AuraEnabled public List<SmartDD__Duplicate_Record__c> lstrec{get;set;}
    }
    public class AsyncApexJobWrapper{
        @AuraEnabled public Integer TotalJobItems{get;set;} //NOPMD
        @AuraEnabled public String JobItemStatus{get;set;} //NOPMD
        @AuraEnabled public Integer JobItemsProcessed{get;set;} //NOPMD
        @AuraEnabled public List<AsyncApexJob> lstAsyncApexJob{get;set;} //NOPMD
    }
    
   
}