global with sharing class DedupeConfigController {      // NOPMD
    public Static List<String> lstCheckedAccount = new List<String>();
    public Static List<String> lstCheckedLead = new List<String>();
    public Static List<String> lstCheckedContact = new List<String>();
    public Static List<String> lstUnCheckedAccount = new List<String>();
    public Static List<String> lstUnCheckedLead = new List<String>();
    public Static List<String> lstUnCheckedContact = new List<String>();
  	public String JSONAuthUserString {get;set;}         // NOPMD
    public String JSONObjectTypeString {get;set;}        // NOPMD  
    
    @AuraEnabled
    public static SmartDD__Dedupe_Configuration__c getDedupeConfig() {
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = 
                    new List<SmartDD__Dedupe_Configuration__c>([SELECT Id, Name, SmartDD__First_Name__c, SmartDD__Last_Name__c, SmartDD__NameSpace__c, SmartDD__Email__c, SmartDD__Username__c, SmartDD__Organization_Id__c, SmartDD__UserId__c,SmartDD__Manual_Cluster__c,
                                                    SmartDD__SF_Import_Consumer_Secret__c,SmartDD__SF_Import_Consumer_Key__c,SmartDD__Training_File_Consumer_Key__c,SmartDD__Training_File_Consumer_Secret__c  FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE Limit 1]);
            
            if(lstDedupeConfig != null && lstDedupeConfig.size() > 0){
                return lstDedupeConfig[0];
            }
          return null;        
    }
    @AuraEnabled
    public static string getUserProfileName() {
        Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =:profileId WITH USER_MODE].Name;
        return profileName;
    }
    
    @AuraEnabled
    public static String saveDedupeConfig(SmartDD__Dedupe_Configuration__c newDedupeConfig, boolean isMannualFlag) {  // NOPMD
       
        List<SmartDD__Dedupe_Configuration__c> lstnewDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        
        List<User> lstuser = [select Id,Username from user where Username =:newDedupeConfig.SmartDD__Username__c WITH USER_MODE];
        if(lstuser.size() > 0){
            if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__UserId__c.isAccessible()) {
                newDedupeConfig.SmartDD__UserId__c = lstuser[0].Id;
                newDedupeConfig.SmartDD__Manual_Cluster__c = isMannualFlag;
            }
            
        }else{
            if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__UserId__c.isAccessible()) {
                newDedupeConfig.SmartDD__UserId__c = null;
            }
        }
        
        if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__Organization_Id__c.isAccessible()) {
            newDedupeConfig.SmartDD__Organization_Id__c = UserInfo.getOrganizationId();
        }
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__SF_Import_Consumer_Key__c.isAccessible()) {
            newDedupeConfig.SmartDD__SF_Import_Consumer_Key__c = dedupeconfig.SmartDD__SF_Import_Consumer_Key__c;              
        }
        if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__SF_Import_Consumer_Secret__c.isAccessible()) {
            newDedupeConfig.SmartDD__SF_Import_Consumer_Secret__c = dedupeconfig.SmartDD__SF_Import_Consumer_Secret__c;
        }
        if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__Training_File_Consumer_Key__c.isAccessible()) {
            newDedupeConfig.SmartDD__Training_File_Consumer_Key__c = dedupeconfig.SmartDD__Training_File_Consumer_Key__c; 
        }
        if (Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__Training_File_Consumer_Secret__c.isAccessible()) {
            newDedupeConfig.SmartDD__Training_File_Consumer_Secret__c = dedupeconfig.SmartDD__Training_File_Consumer_Secret__c;
        }
        
        lstNewDedupeConfig.add(newDedupeConfig);
        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstNewDedupeConfig); 
        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if( (dsr.isCreateable() && dsr.isUpdateable() ) || Schema.sObjectType.SmartDD__Dedupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Configuration__c.isUpdateable() ){ 
            upsert decision.getRecords();
        }
        // Code to add logs in Dedupe Log Object.
        List<SmartDD__Dedupe_Log__c> lstObjDebugLog = new List<SmartDD__Dedupe_Log__c>();
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Configuration Submit Request';
        
        lstObjDebugLog.add(objDebugLog);
        SObjectAccessDecision decisionObjDebugLog = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDebugLog); 
        
        Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
        if(( schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable() ) || Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Log__c.isUpdateable() ){
            upsert decisionObjDebugLog.getRecords();
        }
        
        //postDedupeAuthRecords(objDebugLog.Id);
        
        //return 'Test Success';
        return objDebugLog.Id;
    }
    /******************************************************/
    //Search User
    /******************************************************/
    @AuraEnabled
    public static Boolean searchUser(String searchUsername, String searchEmail){
        String searchTerms = '';
        if(!String.isEmpty(searchUsername.trim())){
            searchTerms += '("' + searchUsername + '")';
        }
        if(!String.isEmpty(searchEmail.trim())){
            if(!String.isEmpty(searchTerms)){
                searchTerms += ' AND ';
            }
            searchTerms += '("' + searchEmail + '")';
        }      
        String searchQuery = 'FIND \'' + searchTerms + '\' IN ALL FIELDS RETURNING User(Username,Email)';
        system.debug('searchQuery' + searchQuery);
        List<List<sObject>> searchUsernameEmail = search.query(searchQuery);
        Boolean hasUser = (searchUsernameEmail != null && searchUsernameEmail.Size() > 0 && searchUsernameEmail[0] != null && searchUsernameEmail[0].Size() > 0);
        
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeconfig.SmartDD__User_Configuration__c = hasUser;
        
        Schema.DescribeSObjectResult dsrdedupecustomsetting = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
        if( ( dsrdedupecustomsetting.isCreateable() && dsrdedupecustomsetting.isUpdateable() ) || ( Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable() ) ){
            upsert dedupeconfig;
        }
        return hasUser;
    } 
    /******************************************************/
    //Check Credentials
    /******************************************************/
    @AuraEnabled
    public static String checkCredentials(String objectName) {
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c, SmartDD__NameSpace__c, SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
        system.debug('@@ lstDedupeConfig' + lstDedupeConfig);
        String JSONObjectTypeString = '';       // NOPMD
         string httpResMessage ;
        JSONObjectTypeString += '{';
        if(lstDedupeConfig.size() > 0) {
            JSONObjectTypeString += '"Object Name":"'+ objectName +'",';
            JSONObjectTypeString += '"Organization Id":"'+ lstDedupeConfig[0].SmartDD__Organization_Id__c +'",';
            JSONObjectTypeString += '"UserId":"'+ lstDedupeConfig[0].SmartDD__UserId__c +'"';
        }
        
        JSONObjectTypeString += '}';
        System.debug('@#$JSONObjectTypeString: '+JSONObjectTypeString);
        HttpRequest objSaveData = httpJSONCheckPwd(System.Label.SFImportAPI+'/object/checkBeforeSync', JSONObjectTypeString);
        
        // Code to add logs in Dedupe Log Object.
        List<SmartDD__Dedupe_Log__c> lstObjDebugLog  = new List<SmartDD__Dedupe_Log__c>();  // +

        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Configuration Check Request';
        objDebugLog.SmartDD__Json_Request_Body__c = JSONObjectTypeString;
                
        Http http = new Http();
        try{
            HTTPResponse saveReq = http.send(objSaveData);
            String jsonSaveString =  saveReq.getBody(); objDebugLog.SmartDD__Json_Response_Body__c = String.valueOf(jsonSaveString);
            system.debug('@#$Json_Response_Body__c: '+ objDebugLog.SmartDD__Json_Response_Body__c);
            SmartDD.JSONSyncData objSyncDataStatus = SmartDD.JSONSyncData.parse(jsonSaveString );
            system.debug('@#$objSyncDataStatus: '+ objSyncDataStatus);
            system.debug('@#$error: '+ objSyncDataStatus.error);
            system.debug('@#$objSyncDataStatus.errorDescription: '+ objSyncDataStatus.errorDescription);
            if(objSyncDataStatus.error != null)  {
                if(objSyncDataStatus.errorDescription == 'authentication failure') {
                    httpResMessage = objSyncDataStatus.errorDescription;
                } else if(objSyncDataStatus.errorDescription == 'Database not available.' ) {
                    httpResMessage = objSyncDataStatus.errorDescription;
                } else if(objSyncDataStatus.errorDescription == 'client identifier invalid' ) { 
                    httpResMessage = 'Connected App Details Wrong';
                } else if(objSyncDataStatus.error == 'LicenseKey Invalid, Please Enter Valid Key.' ) { 
                    httpResMessage = 'LicenseKey Invalid';
                }
            }
            else {
                httpResMessage = 'Success';
            }
            
            lstObjDebugLog.add(objDebugLog); 
            
        }
        catch(Exception e){
            httpResMessage = e.getMessage();
        } 
        
        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDebugLog); 
                                                                
        Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
        if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable()){          
            upsert decision.getRecords();
        }
        
        system.debug('httpResMessage'+httpResMessage);
        return httpResMessage;
    } 
    
    //Http Request Body
    public static HttpRequest httpJSONCheckPwd(String strAWSEndpointLead, string strBody) {
        HttpRequest objHTTPRequest = new HttpRequest();
        Http httpProtocol = new Http();objHTTPRequest.setTimeout(120000);objHTTPRequest.setMethod('POST');objHTTPRequest.setBody(strBody);objHTTPRequest.setHeader('Content-Type', 'application/json');objHTTPRequest.setEndpoint(strAWSEndpointLead);
        
        return objHTTPRequest;
    }
    
    @AuraEnabled
    public static SmartDD__De_Dupe_Configuration__c dedupeConfigCustomsetting(){
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        return dedupeconfig ;
    }
    /******************************************************/
    //POST DedupeAuthorizedUser JSON DATA
    /******************************************************/    
    @AuraEnabled
    public static String postDedupeAuthRecords(String LogId) {          // NOPMD
        
        List<SmartDD__Dedupe_Configuration__c> lstAuthUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c,SmartDD__NameSpace__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                SmartDD__Last_Name__c,SmartDD__Request__c,SmartDD__Response__c, SmartDD__First_Name__c, SmartDD__Manual_Cluster__c,
                                                                                        SmartDD__SF_Import_Consumer_Key__c,SmartDD__SF_Import_Consumer_Secret__c,
                                                                                        SmartDD__Training_File_Consumer_Key__c,SmartDD__Training_File_Consumer_Secret__c
                                                                                        FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE LIMIT 200]);
        
        system.debug('lstAuthUser : ' + lstAuthUser);
        System.Url orgDomain = System.Url.getOrgDomainUrl();
		String url = orgDomain.toExternalForm();
		System.debug('URL: ' + url);
        String JSONAuthUserString = '';             // NOPMD
        Id cofigId;
        String prefix = System.Label.Dedupe_Prefix;
        system.debug('prefix:::'+prefix);
        JSONAuthUserString += '{';
        for(SmartDD__Dedupe_Configuration__c obj : lstAuthUser) {            
            JSONAuthUserString += '"First Name":"' + obj.SmartDD__First_Name__c + '",';
            JSONAuthUserString += '"Last Name":"' + obj.SmartDD__Last_Name__c + '",';            
            JSONAuthUserString += '"Namespace":"' + prefix + '",';          
            JSONAuthUserString += '"Email":"' + obj.SmartDD__Email__c + '",';
            JSONAuthUserString += '"SFImport_ConsumerKey":"' + obj.SmartDD__SF_Import_Consumer_Key__c + '",';
            JSONAuthUserString += '"SFImport_ConsumerSecret":"' + obj.SmartDD__SF_Import_Consumer_Secret__c + '",';            
            JSONAuthUserString += '"Organization Id":"' + obj.SmartDD__Organization_Id__c + '",';
            JSONAuthUserString += '"UserId":"'+ obj.SmartDD__UserId__c + '",';
            JSONAuthUserString += '"IsMannualCluster":"'+ obj.SmartDD__Manual_Cluster__c + '",';
            JSONAuthUserString += '"Hostname":"'+ url + '"';
        }
        JSONAuthUserString += '}';
        
        System.debug('@#$JSONAuthUserString: '+ JSONAuthUserString);
        
        String strResponse = httpJSONRequest(System.Label.SFImportAPI+'/user/save', JSONAuthUserString);
		SmartDD__Dedupe_Configuration__c objDedupeConf = new SmartDD__Dedupe_Configuration__c();	
        objDedupeConf.id = cofigId;
        objDedupeConf.SmartDD__Request__c = JSONAuthUserString;
        system.debug('JSONAuthUserString:::'+JSONAuthUserString);
        objDedupeConf.SmartDD__Response__c = strResponse; 
          system.debug('strResponse:::'+strResponse);
         system.debug('objDedupeConf:::'+objDedupeConf);
         system.debug('Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.id.isUpdateable():::'+Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.id.isUpdateable());
        if(objDedupeConf != null){
            if(Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.id.isUpdateable() && Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__Request__c.isUpdateable() && Schema.sObjectType.SmartDD__Dedupe_Configuration__c.fields.SmartDD__Response__c.isUpdateable())
            {
                update objDedupeConf;
            }
            
        }return strResponse;
    }
    /******************************************************/
    //Http Request Body
    /******************************************************/
    public static String httpJSONRequest(String strAWSEndpointLead, string strBody) {
        Http objHTTP = new Http(); string strResponseBody='';
        string strResponseStatus='';
    
        HttpRequest objHTTPRequest = new HttpRequest();Http httpProtocol = new Http();
        objHTTPRequest.setTimeout(60000);objHTTPRequest.setMethod('POST'); objHTTPRequest.setHeader('Content-Type', 'application/json');
        system.debug('@#$strBody'+strBody);
        objHTTPRequest.setBody(strBody);
        system.debug('strAWSEndpointLead'+strAWSEndpointLead);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);
        
        Http http = new Http();HTTPResponse statusRes = http.send(objHTTPRequest);
        String jsonString =  statusRes.getBody();
        system.debug('@#$jsonString'+jsonString);
        SmartDD.JSONSyncData objSyncDataStatus = SmartDD.JSONSyncData.parse(jsonString);
        system.debug('@#$objSyncDataStatus: '+objSyncDataStatus.error);
        system.debug('@#$isSuccess: '+objSyncDataStatus.isSuccess);
        if(objSyncDataStatus.isSuccess != '1' && objSyncDataStatus.error != '') {
            return objSyncDataStatus.error;
        } else {
            return 'Success';
        }
        
    }
    
    /******************************************************/
    //wrapper class
    /******************************************************/
    global class wrpObjectFieldsList {                          // NOPMD
        @AuraEnabled global String strObjectName {get;set;}
        @AuraEnabled global List<String> objectFieldsList {get;set;}
        @AuraEnabled global List<wrpFields> FieldsList {get;set;}    // NOPMD
        
        global wrpObjectFieldsList() {
            strObjectName = ''; objectFieldsList = new List<String>(); FieldsList = new List<wrpFields>();
        }
    }
    global class wrpFields {             // NOPMD
        @AuraEnabled global String fieldName {get;set;}
        @AuraEnabled global Boolean isSelected {get;set;}
        global wrpFields() {
            fieldName = '';isSelected = false;
        }
    }
}