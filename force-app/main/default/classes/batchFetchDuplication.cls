global with sharing class batchFetchDuplication implements Database.Batchable<sobject>, Database.Stateful, Database.AllowsCallouts {
    
    public Map<String,String> mapOfUniqLead;
    public String strQuery;
    public Set<String> setAllFields;
    public Set<ID> duplicateLeads;
    public Integer TotalNumberOfRecords;
    public set<Id> uniqLeadId ;
    public String selectedObjectName;
    public batchFetchDuplication(String strQry, Set<String> setFields, String selectedObject) {
        mapOfUniqLead = New Map<String,String>();
        setAllFields = new Set<String>();
        strQuery = strQry;
        setAllFields = setFields;
        uniqLeadId = New Set<Id>();
        duplicateLeads = new Set<ID>();
        selectedObjectName = selectedObject;
    }
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(strQuery);
    }
      
    global void execute(Database.BatchableContext bc, List<sObject> lstOfLead) {
        
        
        String strJson = Json.Serialize(setAllFields );
        for(sObject objlead : lstOfLead){
            String strval ='';
            
            for(String keyField : setAllFields){
                If(!keyField.contains('id')) {
                    if(!String.IsBlank(string.ValueOf(objlead.get(keyField)))){
                        strval += string.ValueOf(objlead.get(keyField)) + '#' ;
                    }
                }
            }
            // preparing string with # in between.
            strval= strval.removeEnd('#');
            String HaxValue = fnGetHexValue(strval);
            mapOfUniqLead.put(HaxValue,objlead.id);
        }
    }
    Public Static String fnGetHexValue(String strCriteria){
        String sha1Code = '';
        if(!String.IsBlank(strCriteria)){
            sha1Code = EncodingUtil.base64Encode(Crypto.generateDigest('sha1', Blob.valueOf(strCriteria)));
        }
        return sha1Code;
    }
      
    global void finish(Database.BatchableContext bc) {
        Set<Id> deleteId = new Set<Id>();
        for(String key : mapOfUniqLead.KeySet()){
            deleteId.add(mapOfUniqLead.get(key));
        }
        
        string Delquery = 'select Id from ' + selectedObjectName + ' where Id NOT IN : deleteId WITH USER_MODE' ;
        List<sObject> deleteDuplicateLead = DataBase.query(Delquery);
        
        // get all lead which are not in HEX    
        // List<Lead> deleteDuplicateLead = [Select Id  from Lead where Id NOT IN : deleteId WITH USER_MODE];
        
        If(deleteDuplicateLead.Size() > 0){
            for(sObject objlead : deleteDuplicateLead){
              duplicateLeads.add(objlead.Id);  
            }
           
        } 
        List<SmartDD__Duplicate_Record__c> duplicaterecList = new List<SmartDD__Duplicate_Record__c>();
        
      
        for(Id leadId : duplicateLeads){
            SmartDD__Duplicate_Record__c DR = new SmartDD__Duplicate_Record__c();
            if(Schema.sObjectType.SmartDD__Duplicate_Record__c.fields.SmartDD__Batch_Process_Id__c.isCreateable()){
                // What is BC 
                DR.SmartDD__Batch_Process_Id__c = BC.getJobId();
            }
            if(Schema.sObjectType.SmartDD__Duplicate_Record__c.fields.SmartDD__Duplicate_Id__c.isCreateable()){
                DR.SmartDD__Duplicate_Id__c = leadId;
            }
            duplicaterecList.add(DR);
        }
        
        if (Schema.sObjectType.SmartDD__Duplicate_Record__c.isCreateable()) {
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, duplicaterecList);     
            insert decision.getRecords();
        }
    }
}