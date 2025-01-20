public class SyncContactTriggerHandler extends TriggerHandler  {
	public override void afterInsert() {
        syncNewContactRecord(Trigger.new);
    }
        
    public static void syncNewContactRecord(List<Contact> lstNewContactRec) {
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1];
        // Organization Id
        String orgId = lstDedupeConfig[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstDedupeConfig[0].SmartDD__UserId__c;
        // Object Name
        String objectName = 'Contact'; 
        
        Set<String> strContactRecordIds = new Set<String>();    
        for(Contact objContactRec : lstNewContactRec) {
            strContactRecordIds.add(objContactRec.Id);
        }
        // To Set record Ids
        String contactRecordIds = '';
        for(String objContactRec : strContactRecordIds) {
            contactRecordIds +=  objContactRec + ', ';
        }
        contactRecordIds = contactRecordIds.removeEnd(', ');
        
        // To set Dedupe Field Columns.
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
        
        postSyncDedupeRecords(orgId, userId, objectName, strDedupeFields, contactRecordIds);
     }
    
    /******************************************************/
    //POST DedupeSync JSON DATA
    /******************************************************/
    @Future(callout=true)
    public static void postSyncDedupeRecords(String orgId, String userId, String objectName, String strDedupeFields, String contactRecordIds) { //NOPMD
        
        String JSONSyncRecString = ''; //NOPMD
        JSONSyncRecString  += '{';
        
            JSONSyncRecString  += '"organisationId":"' + orgId + '",';
            JSONSyncRecString  += '"userId":"' + userId + '",';
            JSONSyncRecString  += '"objectName":"' + objectName + '",';
            JSONSyncRecString  += '"dedupeFields":"' + strDedupeFields + '",';
            JSONSyncRecString  += '"recordIds":"' + contactRecordIds + '"';
        
        JSONSyncRecString  += '}';
        system.debug('@#$JSONSyncRecString: '+JSONSyncRecString);
        httpJSONRequest(System.Label.SFImportAPI+'/object/updateData', JSONSyncRecString);
    }
    
    /******************************************************/
    //Http Request Body
    /******************************************************/
    public static void httpJSONRequest(String strAWSEndpointContact, string strBody) {
        Http objHTTP = new Http();
        string strResponseBody='';
        string strResponseStatus='';
    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http httpProtocol = new Http();
        objHTTPRequest.setTimeout(60000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointContact);
        
        Http http = new Http();
        HTTPResponse statusRes = http.send(objHTTPRequest);
        String jsonString =  statusRes.getBody();
        system.debug('@@ jsonString ' + jsonString);
    }
}