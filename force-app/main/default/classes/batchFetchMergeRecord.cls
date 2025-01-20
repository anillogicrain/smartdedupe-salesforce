global with sharing class batchFetchMergeRecord implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public String selectedObjectname;

    public batchFetchMergeRecord(String selectedObjectname) {
        this.selectedObjectname = selectedObjectname;
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, SmartDD__IsMerged__c FROM ' + String.escapeSingleQuotes(selectedObjectname) + ' WHERE SmartDD__IsMerged__c = true';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<sObject> scope) {
        for (sObject objMerged : scope) {
            objMerged.put('SmartDD__IsMerged__c', false);
        }
        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, scope);
        update decision.getRecords();
    }

    global void finish(Database.BatchableContext context) {
        
    }

}