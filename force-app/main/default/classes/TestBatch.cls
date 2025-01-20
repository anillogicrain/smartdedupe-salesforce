global with sharing class TestBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
 
    global Database.QueryLocator start(Database.BatchableContext context) {
        /*return Database.getQueryLocator([
            SELECT Id, Record_Id__c, Operation_Type__c FROM Sync_Tracking__c WHERE Object_Type__c = 'Lead' AND Status__c = 'Pending'
        ]);*/
         string query ='';
         return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<sObject> scope) {
            }
     global void finish(Database.BatchableContext context) {
        
    }

}