@RestResource(urlMapping='/UpdateCreateClusterStat')
global with sharing class UpdateCreateClusterStatAPI {
    global static string externalCreateClusterStat{get; set;}
    @HttpPost
    global static void fnUpdateClusterCreateData(){
            SmartDD__De_Dupe_Configuration__c dedupeExtStat = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeExtStat.SmartDD__Clusters_Created_Stat__c = true; 
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()){
                upsert dedupeExtStat; 
                 system.debug('dedupeExtStat......................'+dedupeExtStat);
            }
    } 
}