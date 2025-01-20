@isTest 
public class batchAutoReviewAllClusterTest 
{
    static testMethod void testMethod1() 
    {
        SmartDD__Manage_Master_Cluster_Id__c LeadMasterCluster = new SmartDD__Manage_Master_Cluster_Id__c();
        LeadMasterCluster.Name='Lead';
        insert LeadMasterCluster;
        system.assert(LeadMasterCluster.Id != null);
        
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        MasterCluster.SmartDD__Old_Master_Cluster_Id__c = 'a0V7F00000eXlymUAC';
        update MasterCluster;
        system.assert(MasterCluster.Id != null);
        
        SmartDD__Master_Cluster_Record__c MasterClusterRecord = new SmartDD__Master_Cluster_Record__c();
        MasterClusterRecord.SmartDD__Object_Name__c = 'Lead';
        insert MasterClusterRecord;
        system.assert(MasterClusterRecord.Id != null);
        
        SmartDD__Manage_Master_Cluster_Id__c MasterClusterNew = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        MasterClusterNew.SmartDD__New_Master_Cluster_Id__c = 'a0V7F00000eY4qzUAC';
        update MasterClusterNew;
        system.assert(MasterClusterNew.Id != null);
        SmartDD__Manage_Master_Cluster_Id__c MasterClusterLatest = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        
        List<SmartDD__Cluster__c> lstclauster= new List<SmartDD__Cluster__c>();
        for(Integer i=0 ;i <5;i++)
        {
            SmartDD__Cluster__c clust = new SmartDD__Cluster__c();
            clust.SmartDD__Cluster_Review_Status__c = 'Not Reviewed';
            //clust.All_Cluster_Record__c = TestSetUp.getAllclusterID();
            clust.SmartDD__Master_Cluster_Record_Id__c = MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c;
            lstclauster.add(clust);
        }
        insert lstclauster;
        Test.startTest();
        batchAutoReviewAllCluster obj = new batchAutoReviewAllCluster(MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        DataBase.executeBatch(obj); 
        Test.stopTest();
        List<SmartDD__Cluster__c> lstclaustercretaed = [SELECT Id, SmartDD__Cluster_Review_Status__c From SmartDD__Cluster__c WHERE SmartDD__Cluster_Review_Status__c = 'Auto Reviewed' WITH USER_MODE LIMIT 5];
        Integer lstsize = lstclaustercretaed.size();
        System.assertEquals(5, lstsize,'5 Cluster (Managed) records should be returned');
        System.assert(5 == lstsize);
    }
}