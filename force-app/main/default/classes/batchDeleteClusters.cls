global with sharing class batchDeleteClusters implements Database.Batchable<sObject> {
    
    public String strDeleteQuery;
    public String strobjectName;
    
    public batchDeleteClusters(String delQuery,String objectName) {
        strDeleteQuery = delQuery;
        strobjectName = objectName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(strDeleteQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<SmartDD__All_CLuster_Record__c> deleteCluster) {
        Boolean clusterDeleteCheck = SmartDD__All_CLuster_Record__c.sObjectType.getDescribe().isDeletable();
        If(deleteCluster.Size() > 0  && clusterDeleteCheck) {
           Database.DeleteResult[] drList = Database.delete(deleteCluster, false);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        List<SmartDD__Cluster__c> lstParentCluster = [SELECT Id FROM SmartDD__Cluster__c WHERE SmartDD__Object_Name__c =: strobjectName WITH USER_MODE Limit 5000];
        Boolean parentClusterDeleteCheck = SmartDD__Cluster__c.sObjectType.getDescribe().isDeletable();
        if(lstParentCluster.size() > 0 && parentClusterDeleteCheck) {delete lstParentCluster;}
        
        List<SmartDD__Child_Cluster_Record__c> lstChildClustersDelete = [SELECT Id FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Object_Name__c =: strobjectName WITH USER_MODE Limit 5000];
        Boolean childClusterDeleteCheck = SmartDD__Child_Cluster_Record__c.sObjectType.getDescribe().isDeletable();
        if(lstChildClustersDelete.size() > 0 && childClusterDeleteCheck) { delete lstChildClustersDelete;}
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__Clusters_Deleted__c = true;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Deleted__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Deleted__c.isUpdateable()) {
            upsert dedupeConfig;
        } 
    }
}