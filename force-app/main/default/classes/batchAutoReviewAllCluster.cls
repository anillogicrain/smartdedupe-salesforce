global with sharing class batchAutoReviewAllCluster implements Database.Batchable<sObject> {
    public String strQuery;
    public String masterClusterId = '';
    public batchAutoReviewAllCluster(String strNewMasterClusterId) {
        masterClusterId = strNewMasterClusterId;
    }
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        strQuery = 'SELECT Id, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE SmartDD__Cluster_Review_Status__c = \'Not Reviewed\' AND SmartDD__Master_Cluster_Record_Id__c =\''+masterClusterId+'\' WITH USER_MODE';
        return Database.getQueryLocator(strQuery);
    }
    // Execute method
    global void execute(Database.BatchableContext BC, List<SmartDD__Cluster__c> lstCLusterUpdate) {
        for(SmartDD__Cluster__c objClusterUpdate :lstCLusterUpdate) {
            objClusterUpdate.SmartDD__Cluster_Review_Status__c = 'Auto Reviewed';
        }
        if(lstCLusterUpdate.size() > 0) {
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstCLusterUpdate); 
            update decision.getRecords();
            
        }
    }
    // Finish Method
    global void finish(Database.BatchableContext BC) {

    }
}