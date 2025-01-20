@RestResource(urlMapping='/ClustersCompletedStat')
global with sharing class ClustersCompletedStatAPI {
    @HttpPost
    global static void fnUpdateClusterCompletedStat(){
        try {
            SmartDD__De_Dupe_Configuration__c dedupeExtStat = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeExtStat.SmartDD__Clusters_Completed_Stat__c = 'Completed'; 
            dedupeExtStat.SmartDD__Last_Create_Cluster_Progress__c = 100;
           if((Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable())||(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable())||
               (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable())){
                 system.debug('dedupeExtStat'+dedupeExtStat);
                upsert dedupeExtStat;
                 system.debug('dedupeExtStat'+dedupeExtStat);
            }
            //Re-DeDupe Configuration Update.
            SmartDD__ReDe_Dupe_Configuration__c reDedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
            reDedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed'; 
            reDedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
            reDedupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
           if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()||(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable())||(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable())||(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isUpdateable())){
                system.debug('reDedupeConfig'+reDedupeConfig);
                upsert reDedupeConfig;
                system.debug('reDedupeConfig'+reDedupeConfig);
            }
        } catch(Exception e) {
            system.debug('The erro is: '+e.getMessage());
        }
    } 
}