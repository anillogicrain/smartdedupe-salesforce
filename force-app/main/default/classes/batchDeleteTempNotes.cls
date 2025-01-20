global with sharing class batchDeleteTempNotes implements Database.Batchable<sObject>{
    Public String strDedupedParentIdParams = '';
    Public Set<Id> setParentRecId;
    Public String strNewMasterClusterIdParam;
    Public Map<Id,Id> mapofclusterId;
    
    public batchDeleteTempNotes(String strDedupedParentId, String strNewMasterClusterId) {
        strDedupedParentIdParams = strDedupedParentId;
        setParentRecId = new Set<Id>();
        strNewMasterClusterIdParam = strNewMasterClusterId;
        mapofclusterId = new Map<Id,Id>();
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        String Query = 'SELECT Id, Name, '+ strDedupedParentIdParams +', SmartDD__Body__c, SmartDD__MergeType__c, SmartDD__Title__c FROM SmartDD__TempDedupeNote__c WITH USER_MODE';
        return Database.getQueryLocator(Query);
    }
    
    public void execute(Database.BatchableContext BC, List<SmartDD__TempDedupeNote__c> lstTempNotes){
        List<Note> lstNote = new List<Note>();
        Integer countNotes = 0;
        for(SmartDD__TempDedupeNote__c objTempNotes : lstTempNotes){
            Id dedupedParentId = (Id)objTempNotes.get(strDedupedParentIdParams);
            setParentRecId.add(dedupedParentId);
        }
        
        List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c = :strNewMasterClusterIdParam AND SmartDD__Cluster_Object_Id__c IN :setParentRecId WITH USER_MODE]);
        if(lstClusterRecs.Size() > 0) {
            for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
                mapofclusterId.put(strClusterRecords.SmartDD__Cluster_Object_Id__c,strClusterRecords.SmartDD__Cluster_Object_Id__c);
            }
        }
        for(SmartDD__TempDedupeNote__c objTempNotes : lstTempNotes){
            Id dedupedParentId = (Id)objTempNotes.get(strDedupedParentIdParams);
            if(mapofclusterId.containsKey(dedupedParentId)) {
                Note masterRecNotes = new Note();masterRecNotes.ParentId = dedupedParentId;masterRecNotes.Title = objTempNotes.SmartDD__Title__c;masterRecNotes.Body = objTempNotes.SmartDD__Body__c;
                lstNote.add(masterRecNotes); countNotes = countNotes + 1;
            }
        }
        if(Schema.sObjectType.Note.fields.ParentId.isCreateable() && Schema.sObjectType.Note.fields.Title.isCreateable() && Schema.sObjectType.Note.fields.Body.isCreateable())
        {
             insert lstNote;
        }
       
        if(SmartDD__TempDedupeNote__c.sObjectType.getDescribe().isDeletable())
        {
            delete lstTempNotes;
        }
        
    }
    public void finish(Database.BatchableContext BC){
    }
}