@isTest
public class batchGatherAllClustersTest {
    @isTest static void testMethod1() {
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
            System.assert(customsettingdedupeconfig.Id!=null);
        }
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
       	dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        SmartDD__Filter_Data__c  filterRecs = new SmartDD__Filter_Data__c();
        filterRecs.name = 'Lead';
        filterRecs.SmartDD__Object_Name__c = 'Lead';
        filterRecs.SmartDD__Unique_Cluster_Saved__c = false;
        Insert filterRecs;
        
        SmartDD__Manage_Master_Cluster_Id__c LeadMasterCluster = new SmartDD__Manage_Master_Cluster_Id__c();
        LeadMasterCluster.Name='Lead';
        LeadMasterCluster.SmartDD__New_Master_Cluster_Id__c = 'a0N3g000001JQK0EAO';
        insert LeadMasterCluster;
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRec = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRec.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterRec;
        
        SmartDD__All_CLuster_Record__c objAllClusterRec = new SmartDD__All_CLuster_Record__c();
        objAllClusterRec.SmartDD__Object_Name__c = 'Lead';
        objAllClusterRec.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterRec.Id;
        insert objAllClusterRec;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllClusterRec.Id;
            cluster.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterRec.Id;
            clusters.add(cluster);
        }
        insert clusters;
        
        List<ClusterAPI.insertClusterWrapper> lstWrpCluster = new List<ClusterAPI.insertClusterWrapper>();
        ClusterAPI.insertClusterWrapper objClapiClwrap = new ClusterAPI.insertClusterWrapper();
        objClapiClwrap.clusterid = 1;
        objClapiClwrap.recordid = '151138';
        objClapiClwrap.objectName = 'Lead';
        lstWrpCluster.add(objClapiClwrap);
        
        Test.startTest();
        batchGatherAllClusters obj = new batchGatherAllClusters(lstWrpCluster);
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
}