@RestResource(urlMapping='/UpdateSyncStatus')
global with sharing class UpdateSyncStatusAPI {
    global static string externalSyncStatus{get; set;}
    @HttpPost
    global static void fnUpdateSyncData(){
            SmartDD__De_Dupe_Configuration__c dedupeExtStat = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeExtStat.SmartDD__ExternalSyncStatus__c = 'Completed'; 
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()){
                system.debug('!@#SmartDD__ExternalSyncStatus__c: '+ dedupeExtStat.SmartDD__ExternalSyncStatus__c);
                upsert dedupeExtStat;
            }
    } 
}