global with sharing class batchManageClusters implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        Set<String> clusterId = new Set<String>();
        List<SmartDD__Manage_Master_Cluster_Id__c> clusters = [Select id, SmartDD__New_Master_Cluster_Id__c,SmartDD__Old_Master_Cluster_Id__c, SmartDD__Object_Name__c From SmartDD__Manage_Master_Cluster_Id__c WITH USER_MODE LIMIT 200];
        for(SmartDD__Manage_Master_Cluster_Id__c objCluster : clusters){
            clusterId.add(objCluster.SmartDD__New_Master_Cluster_Id__c);clusterId.add(objCluster.SmartDD__Old_Master_Cluster_Id__c);
        }
        String Query = 'SELECT Id, SmartDD__Master_Cluster_Record_Id__c, SmartDD__Object_Name__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c  WHERE SmartDD__Master_Cluster_Record_Id__c NOT IN : clusterId WITH USER_MODE';
        return Database.getQueryLocator(Query);
    }
    public void execute(Database.BatchableContext BC, List<SmartDD__Cluster__c>scope){
        if(SmartDD__Cluster__c.sObjectType.getDescribe().isDeletable()) {
                    delete scope;
                }
        }
    public void finish(Database.BatchableContext BC){
    }
}