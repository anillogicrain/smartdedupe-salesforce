public with sharing class ManageTrainingFilesController {
      
    /*@AuraEnabled
    public static String getTrainingFilesList(String objectName) {        
        String isSuccess  = '' ;
        string userid = '';
        string organizationid = '';
        string trainingFile= '';
        string settingFile= '';
        string feilds = '';
        
       List<Dedupe_Configuration__c> lstAuthorizedUser = new List<Dedupe_Configuration__c> ([SELECT Id, UserId__c, Organization_Id__c, Username__c,Email__c,
                                                                                              Last_Name__c,   First_Name__c
                                                                                              FROM Dedupe_Configuration__c limit 1]);  
        if(lstAuthorizedUser.size() > 0){
            userid = lstAuthorizedUser[0].UserId__c;
            organizationid = lstAuthorizedUser[0].Organization_Id__c;
        }
        
        String StrJSONFileNameRequest = '';
        
        StrJSONFileNameRequest += '{';
        if(lstAuthorizedUser.size() > 0) {
            StrJSONFileNameRequest += '"organisationId":"' + organizationid + '",';
            StrJSONFileNameRequest += '"userId":"' + userid + '",';
            StrJSONFileNameRequest += '"objectName":"' + objectName + '"';
            
        }
        StrJSONFileNameRequest += '}';
        
        system.debug('JSONFieldFilterStr ****'+StrJSONFileNameRequest);
        isSuccess = httpJSONFileNameRequest(System.Label.SFImportAPI+'/dedupe/getTraining', StrJSONFileNameRequest);
        return isSuccess; 
    }*/
    
    /**************************
    Http Request Body
    **************************/
    /*public static string httpJSONFileNameRequest(String strAWSEndpointLead, string strBody) {       
        string strResponseBody='';
        string strResponseStatus='';   
        String isSuccess = ''; 
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            
            if(objSyncDataStatus.trainingFile != null && objSyncDataStatus.trainingFile != '') {
                List<Training_File_Details__c> lstDeleteFileName = new List<Training_File_Details__c>();
                lstDeleteFileName = [SELECT Id, CreatedDate, Setting_File_Name__c, Fields__c, Training_File_Name__c FROM Training_File_Details__c];
                if(lstDeleteFileName.Size() > 0) {
                    Delete lstDeleteFileName;     
                }
                List<Training_File_Details__c> lstFileName = new List<Training_File_Details__c>();
                Training_File_Details__c objFileName  = new Training_File_Details__c();
                objFileName.Training_File_Name__c = objSyncDataStatus.trainingFile;
                objFileName.Setting_File_Name__c = objSyncDataStatus.settingFile;
                objFileName.Fields__c = objSyncDataStatus.feilds;
                lstFileName.add(objFileName);
                System.debug('@#$objFileName: '+ objFileName);
                isSuccess = '1';
                Insert lstFileName;
            } else {
                isSuccess = '0';
            }
            return isSuccess;
            
        }
        catch(Exception e) {
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@Statement: '+ e.getMessage());
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static list<Training_File_Details__c> fetchTrainingFileDetails() {
       List<Training_File_Details__c> filesList = new List<Training_File_Details__c>();
       filesList = [SELECT Id, CreatedDate, Training_File_Name__c, Setting_File_Name__c, Fields__c FROM Training_File_Details__c];
       System.debug('!@#filesList  = '+ filesList );
       return filesList ;
    }
    @AuraEnabled
    public static void deleteTrainingFiles() {
        //System.debug('delete Method is calling...');
    }*/
    
    @AuraEnabled    
    public  static String getCustomSettingValue() {
        system.debug('Method Call ');
        //String orgId = system.Label.Canvas_APP + UserInfo.getOrganizationId();
        //String orgId = system.Label.Canvas_APP;
        //system.debug('orgId' + orgId);
       
        SmartDD__De_Dupe_Configuration__c objCustomSetting = SmartDD__De_Dupe_Configuration__c.getInstance('DeDupe Configuration');
        String appName = '';
        
        if(objCustomSetting != null){
            appName = objCustomSetting.SmartDD__Training_File_APP__c;
           
        }
        return appName;
    }
    
}