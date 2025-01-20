global with sharing class batchDeleteDuplication implements Database.Batchable<sobject>, Database.Stateful,Database.AllowsCallouts {
    
    public String strDeleteQuery;
    public set<Id> duplicaterecodId;
    public String selectedObjectName ='Account';
    
    public batchDeleteDuplication(String strDelQry,Set<Id> allduplicaterecodId,String selectedObject) {
        strDeleteQuery =  strDelQry; 
        duplicaterecodId = allduplicaterecodId;
        selectedObjectName = selectedObject;
    }
     
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(strDeleteQuery);
    } 
    global void execute(Database.BatchableContext bc, List<sObject> deleteDuplicateLead) {
        // Boolean leadDeleteCheck = Schema.getGlobalDescribe().get(selectedObjectName).getDescribe().isDeletable();
        If( (deleteDuplicateLead !=null && deleteDuplicateLead.Size() > 0 ) && ( 
                                               Schema.getGlobalDescribe().get('Account').getDescribe().isDeletable() && 
                                               Schema.getGlobalDescribe().get('Contact').getDescribe().isDeletable() && 
                                               Schema.getGlobalDescribe().get('Lead').getDescribe().isDeletable()                                                 
                                             ) 
          									)  
        {
            delete deleteDuplicateLead;     
        }
    } 
    global void finish(Database.BatchableContext bc) {
    
    }
}