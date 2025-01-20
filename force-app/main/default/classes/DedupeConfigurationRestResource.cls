@RestResource(urlMapping='/Dedupe_Configuration__c/*')
global with sharing class DedupeConfigurationRestResource {
  @HttpPost
    global static String doPost(String Username,String Password,String FirstName, String LastName, String Email, String OrganizationId, String UserId){   // NOPMD
        List<Dedupe_Configuration__c> lstDeDupeConfig = new List<Dedupe_Configuration__c>();
        Dedupe_Configuration__c deDupeConfig = new Dedupe_Configuration__c();
        deDupeConfig.Username__c = Username;
        deDupeConfig.First_Name__c = FirstName;
        deDupeConfig.Last_Name__c = LastName;
        deDupeConfig.Email__c = Email;
        deDupeConfig.Organization_Id__c = OrganizationId;
        deDupeConfig.UserId__c = UserId;
        lstDeDupeConfig.add(deDupeConfig);
        if(Schema.sObjectType.Dedupe_Configuration__c.isCreateable() ){
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstDeDupeConfig);                 
            insert decision.getRecords();
        }        
        
        return deDupeConfig.id;
    }

}