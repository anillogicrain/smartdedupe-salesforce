global with sharing class batchUniqueRecordsDelete implements Database.Batchable<sobject>, Database.Stateful,Database.AllowsCallouts {
    
    Public String strDuplicateRecordQuery;
    Public Map<Id,Id> mapofclusterId;
    Public Integer count;
    Public Set<Id> duplicaterecodId;
    Public String ObjectNamePrms;
    Public List<SObject> lstOfDeletePolishedRecords;
    Public String strNewMasterClusterIdParam;
    
    public batchUniqueRecordsDelete(String tempDuplicateRecordQuery, String strNewMasterClusterId, String ObjectName) {
        strDuplicateRecordQuery = tempDuplicateRecordQuery;
        ObjectNamePrms = ObjectName;
        duplicaterecodId = new Set<Id>();
        strNewMasterClusterIdParam = strNewMasterClusterId;
        lstOfDeletePolishedRecords = new List<SObject>();
        mapofclusterId = new Map<Id,Id>();
        count = 0;
    }
     
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(strDuplicateRecordQuery);
    } 
    global void execute(Database.BatchableContext bc, List<SObject> lstOfDedupeObject) {
        Set<Id> setParentRecId = new Set<Id>();
        for(sObject objRecord : lstOfDedupeObject){
            setParentRecId.add(objRecord.id);
        }
        
        List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterIdParam AND SmartDD__Cluster_Object_Id__c IN: setParentRecId WITH USER_MODE]);
        
        if(lstClusterRecs.Size() > 0) {
            for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
                mapofclusterId.put(strClusterRecords.SmartDD__Cluster_Object_Id__c,strClusterRecords.SmartDD__Cluster_Object_Id__c);
            }
        }
        
        for(sObject objRecord : lstOfDedupeObject){
            if(!mapofclusterId.containsKey(objRecord.id)){
                duplicaterecodId.add(objRecord.id);
            }
        }
        string strDelquery = 'Select Id  from ' + String.escapeSingleQuotes(ObjectNamePrms) + ' where Id IN : duplicaterecodId WITH USER_MODE';
        lstOfDeletePolishedRecords = DataBase.query(strDelquery);
        If(lstOfDeletePolishedRecords.Size() > 0) {
           count += lstOfDeletePolishedRecords.size();
           system.debug('count @@@ ' + count);
           if (SmartDD__Child_Cluster_Record__c.sObjectType.getDescribe().isDeletable()) {
           		delete lstOfDeletePolishedRecords; 
           }
        }
        
    } 
    global void finish(Database.BatchableContext bc) {
        SmartDD__Filter_Data__c cs = SmartDD__Filter_Data__c.getInstance(ObjectNamePrms);
        
        if(cs != null) {
            cs.name = ObjectNamePrms;cs.SmartDD__Object_Name__c = ObjectNamePrms;
            cs.SmartDD__Deleted_Records__c = count;cs.SmartDD__Unique_Cluster_Saved__c = true;
            if(Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Deleted_Records__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Deleted_Records__c.isUpdateable() &&
   			   Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isUpdateable() && 
   			   Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isUpdateable() && 
   			   Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isUpdateable())
            {
                upsert cs;
            }
        } else {
            SmartDD__Filter_Data__c csNew = new SmartDD__Filter_Data__c();
            csNew.name = ObjectNamePrms;
            csNew.SmartDD__Object_Name__c = ObjectNamePrms;
            csNew.SmartDD__Deleted_Records__c = count;
            csNew.SmartDD__Unique_Cluster_Saved__c = true;
             if(Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Deleted_Records__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Deleted_Records__c.isUpdateable() &&
   			    Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isUpdateable() && 
   				Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isUpdateable() && 
   				Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isUpdateable())
             {
                  upsert csNew;
             }
        }
    }
}