@isTest 
public class batchDeleteClustersTest 
{
    static testMethod void testMethod1() 
    {
        SmartDD__De_Dupe_Configuration__c dedupeConfig = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfig.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfig.Name = 'DeDupe Configuration';   
        upsert dedupeConfig;
        
        SmartDD__Master_Cluster_Record__c objMasterClustRec = new SmartDD__Master_Cluster_Record__c();
        objMasterClustRec.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClustRec;
        
        SmartDD__Master_Cluster_Record__c objMasterCluster1 = new SmartDD__Master_Cluster_Record__c();
        objMasterCluster1.SmartDD__Object_Name__c = 'Lead';
        Insert objMasterCluster1;
        
        SmartDD__All_CLuster_Record__c objAllclusterRec1 = new SmartDD__All_CLuster_Record__c();
        objAllclusterRec1.SmartDD__Master_Cluster_Record_Id__c = objMasterCluster1.Id;
        objAllclusterRec1.SmartDD__Object_Name__c = 'Lead';
        Insert objAllclusterRec1;
        
        
        List<SmartDD__Cluster__c> lstclauster= new List<SmartDD__Cluster__c>();
        for(Integer i=0 ;i <20;i++)
        {
            SmartDD__Cluster__c clust = new SmartDD__Cluster__c();
            clust.SmartDD__External_Cluster_Id__c = 8;
            //clust.All_Cluster_Record__c = objAllclusterRec1.Id;
            lstclauster.add(clust);
        }
        insert lstclauster;
        
        List<SmartDD__All_CLuster_Record__c> lstAllclauster= new List<SmartDD__All_CLuster_Record__c>();
        for(Integer i=0 ;i <20;i++)
        {
            SmartDD__All_CLuster_Record__c objallclustRec = new SmartDD__All_CLuster_Record__c();
            objallclustRec.SmartDD__Object_Name__c = 'Lead';
            objallclustRec.SmartDD__Master_Cluster_Record_Id__c =  objMasterClustRec.id;
            lstAllclauster.add(objallclustRec);
        }
        insert lstAllclauster;
        
        String Query = 'SELECT Id FROM SmartDD__All_CLuster_Record__c WITH USER_MODE';
        
        Test.startTest();
        batchDeleteClusters obj = new batchDeleteClusters(Query,'Lead');
        DataBase.executeBatch(obj);
        Test.stopTest();
        for(SmartDD__All_CLuster_Record__c clone:lstAllclauster){
            Database.DeleteResult drList = Database.delete(clone, false);
        	System.assert(!drList.isSuccess());
        }
       
    }
}