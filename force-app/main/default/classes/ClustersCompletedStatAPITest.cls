@isTest
public class ClustersCompletedStatAPITest {
     @isTest static void testMethod1() {
         Test.startTest();
         SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
         customsettingdedupeconfig.SmartDD__Clusters_Completed_Stat__c = 'Completed'; 
         customsettingdedupeconfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
       if((Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable())||(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable())||
               (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable())){
            insert customsettingdedupeconfig;
            System.assert(customsettingdedupeconfig.Id!=null);
        }
         SmartDD__ReDe_Dupe_Configuration__c customsettingreDedupeConfig = new SmartDD__ReDe_Dupe_Configuration__c();
         customsettingreDedupeConfig.Name = 'ReDeDupe Configuration';
          //customsettingreDedupeConfig.SmartDD__User_Configuration__c  = true;
           customsettingreDedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed'; 
            customsettingreDedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
            customsettingreDedupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
          if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()||
             (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable())||
             (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable())||
             (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isUpdateable())){
                //system.debug('reDedupeConfig'+reDedupeConfig);
                upsert customsettingreDedupeConfig;
                //system.debug('reDedupeConfig'+reDedupeConfig);
            }
          Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        ClustersCompletedStatAPI.fnUpdateClusterCompletedStat();
          Test.stopTest();
     }

}