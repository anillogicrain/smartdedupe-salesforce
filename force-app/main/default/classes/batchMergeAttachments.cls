global with sharing class batchMergeAttachments implements Database.Batchable<SObject> {
    Public String strMergedBackupQuery;
    Public List<Attachment> lstChildAttachmentsOld;
    Public List<Attachment> lstChildAttachmentsNew;
    Public List<String> lstClusterRecId;
    Public Set<Id> setMasterRecordId;
    Public Set<Id> setMergedRecId;
    Public String strNewMasterClusterIdParam;
    Public String ObjectNameParam;
    Public List<Sobject> sObjMasterUpdate;
    
    Public List<SmartDD__MergedRecordBackup__c> lstDelMergedBackup;
    
    public batchMergeAttachments(String strNewMasterClusterId, String ObjectName) {
        lstChildAttachmentsOld = new List<Attachment>();
        lstChildAttachmentsNew = new List<Attachment>();
        lstDelMergedBackup = new List<SmartDD__MergedRecordBackup__c>();
        lstClusterRecId = new List<String>();
        setMasterRecordId = new Set<Id>();
        setMergedRecId = new Set<Id>();
        strNewMasterClusterIdParam = strNewMasterClusterId;
        ObjectNameParam = ObjectName;
        sObjMasterUpdate = new List<SObject>();
        
        strMergedBackupQuery = 'SELECT Id, SmartDD__Obj_Record_Id__c, SmartDD__Obj_ChildRecird_Id__c, SmartDD__StringifiedJsonRecord__c FROM SmartDD__MergedRecordBackup__c WITH USER_MODE';
        //strMergedBackupQuery = 'SELECT Id, Cluster_Object_Id__c, Cluster_Record_External_Id__c FROM Child_Cluster_Record__c WHERE Master_Cluster_Record_Id__c =: strNewMasterClusterIdParam WITH USER_MODE';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('@#$strMergedBackupQuery : '+strMergedBackupQuery );
        return Database.getQueryLocator(strMergedBackupQuery);
    } 
    global void execute(Database.BatchableContext bc, List<SmartDD__MergedRecordBackup__c> lstMergedRecBackup) {
    for(SmartDD__MergedRecordBackup__c strMergedRecBackup : lstMergedRecBackup) {
            setMergedRecId.add(strMergedRecBackup.SmartDD__Obj_Record_Id__c);
        }
         List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterIdParam AND SmartDD__Cluster_Object_Id__c IN: setMergedRecId WITH USER_MODE]);
        if(lstClusterRecs.Size() > 0) {
            for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
                setMasterRecordId.add(strClusterRecords.SmartDD__Cluster_Object_Id__c);
            }
        }
        List<SmartDD__MergedRecordBackup__c> lstMergedRec = new List<SmartDD__MergedRecordBackup__c>([SELECT Id, SmartDD__Obj_Record_Id__c, SmartDD__Obj_ChildRecird_Id__c, SmartDD__StringifiedJsonRecord__c FROM SmartDD__MergedRecordBackup__c WHERE SmartDD__Obj_Record_Id__c IN : setMasterRecordId WITH USER_MODE]);
        System.debug('@#$lstMergedRec: '+lstMergedRec);
        for(SmartDD__MergedRecordBackup__c objMergedRecs : lstMergedRec) {
            String strChildRecIds = String.ValueOf(objMergedRecs.SmartDD__Obj_ChildRecird_Id__c);
            lstClusterRecId = strChildRecIds.Split(',');
            lstChildAttachmentsOld = [SELECT Id,Name,ParentId,ContentType,BodyLength,Body,OwnerId,Description FROM Attachment WHERE ParentId IN : lstClusterRecId WITH USER_MODE];
            if(lstChildAttachmentsOld.Size() > 0) {
                for(Attachment objOldAttachments: lstChildAttachmentsOld) {
                    Attachment objAttachmentNew = new Attachment();objAttachmentNew.Name = objOldAttachments.Name;objAttachmentNew.ParentId = objMergedRecs.SmartDD__Obj_Record_Id__c;objAttachmentNew.ContentType = objOldAttachments.ContentType;
                    //objAttachmentNew.BodyLength = objOldAttachments.BodyLength;
                    objAttachmentNew.Body = objOldAttachments.Body;objAttachmentNew.OwnerId = objOldAttachments.OwnerId ; objAttachmentNew.Description = objOldAttachments.Description; lstChildAttachmentsNew.add(objAttachmentNew);
                }
                Boolean  ParentId = Schema.sObjectType.Attachment.fields.ParentId.isCreateable();
        		Boolean  Name = Schema.sObjectType.Attachment.fields.Name.isCreateable(); 
        		Boolean  ContentType = Schema.sObjectType.Attachment.fields.ContentType.isCreateable();
                Boolean  Body = Schema.sObjectType.Attachment.fields.Body.isCreateable();
        		Boolean  OwnerId = Schema.sObjectType.Attachment.fields.OwnerId.isCreateable(); 
        		Boolean  Description = Schema.sObjectType.Attachment.fields.Description.isCreateable();
                if(ParentId && Name && ContentType && Body && OwnerId && Description)
                {
                     Insert lstChildAttachmentsNew;
                }
               if(Attachment.sObjectType.getDescribe().isDeletable())
               {
                   Delete lstChildAttachmentsOld;
               }
               }
        }
        sObject sObj = Schema.getGlobalDescribe().get(ObjectNameParam).newSObject();
        map<id,Sobject> sObjectMap = new map<id,Sobject>();
        for(SmartDD__MergedRecordBackup__c objMergedRec : lstMergedRec) {
            sObj = (SObject)JSON.deserialize(objMergedRec.SmartDD__StringifiedJsonRecord__c, Sobject.class);sObj.Id = objMergedRec.SmartDD__Obj_Record_Id__c;sObjMasterUpdate.add(sObj);
        }
        sObjectMap.putall(sObjMasterUpdate);
        if(sObjectMap.size()>0) {
            system.debug('@@sObjectMap: '+ sObjectMap.values());
            update sObjectMap.values();
        }
        //update sObjMasterUpdate;
        if (SmartDD__MergedRecordBackup__c.sObjectType.getDescribe().isDeletable()) {
   		    Delete lstMergedRec;
		}
			//lstDelMergedBackup = lstMergedRec;
        }
    global void finish(Database.BatchableContext bc) {
        //Delete lstDelMergedBackup;
    }
}