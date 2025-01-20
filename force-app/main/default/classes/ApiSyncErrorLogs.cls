public class ApiSyncErrorLogs {
    
      public static void addErrorLog(String apiType,String endpoint,String apiName,String objectName, String result, String reqBody, String resBody, String errorMsg){
        
          SmartDD__Sync_API_Log__c objSynclogs = new SmartDD__Sync_API_Log__c();
          objSynclogs.SmartDD__API_Type__c = apiType;
          objSynclogs.SmartDD__API_Endpoint__c = endpoint;
          objSynclogs.SmartDD__API_Name__c = apiName;
          objSynclogs.SmartDD__Object__c = objectName;
          objSynclogs.SmartDD__Result__c = result;          
          objSynclogs.SmartDD__Request_Body__c = reqBody;
          objSynclogs.SmartDD__Response_Body__c = resBody;         
          objSynclogs.SmartDD__Error_Message__c = errorMsg;
          insert objSynclogs;
    }

}