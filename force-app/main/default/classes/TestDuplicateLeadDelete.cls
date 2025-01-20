global with sharing class TestDuplicateLeadDelete{

    Public Static String fnGetHexValue(String strCriteria){   
        String sha1Code = '';
        if(!String.IsBlank(strCriteria)){
            sha1Code = EncodingUtil.base64Encode(Crypto.generateDigest('sha1', Blob.valueOf(strCriteria)));
        }
        return sha1Code;
    }
    
    public Static void deleteDuplicate(){
        
        Map<String,String> mapOfUniqLead = New Map<String,String>();
        String query = '';
        String sobjectApiName = 'Lead';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sobjectApiName).getDescribe().fields.getMap();
        Set<String> setLeadMapping = new Set<String>{'isdeleted','masterrecordid','ownerid','createddate','createdbyid','lastvieweddate','lastmodifiedbyid','systemmodstamp','lastactivitydate','lastvieweddate','lastreferenceddate','lastmodifieddate','jigsaw','jigsawcompanyid','jigsawcontactid'};
        Set<String> setFields = new Set<String>();
        String strFields = '';
        
        for(String fieldName : fieldMap.keyset() ){
           If(!setLeadMapping.contains(fieldName)) {
                if(strFields == null || strFields == ''){
                    strFields = fieldName;
                    setFields.add(fieldName);
                    
                }else{
                    strFields = strFields + ' , ' + fieldName;                    
                }
            }
        }
        
        System.debug('strFields@@ ' + strFields);
        query = 'select ' + strFields + ' from ' + sobjectApiName + ' WITH USER_MODE';
        System.debug('query@@ ' + query);
        List <Lead> leadmainList = Database.query(query);
        System.debug('leadmainList@@ ' + leadmainList);       
        String strval ='';
        
        for(Lead objlead : leadmainList){
        
            for(String keyField : setFields){
                strval = string.ValueOf(objlead.get(keyField));
                strval = strval + ' , ' ;
            }
            String haxValue = fnGetHexValue(strval);
            mapOfUniqLead.put(haxValue,objlead.Id);
        }
        Set<Id> deleteId = new Set<Id>();
        for(String key : mapOfUniqLead.KeySet()){
            deleteId.add(mapOfUniqLead.get(key));
        }
        
        List<lead> deleteDuplicateLead = new List<Lead>([Select id FROM Lead WHERE Id NOT IN : deleteId WITH USER_MODE]);
        System.debug('deleteDuplicateLead @@ ' + deleteDuplicateLead);
        Boolean DuplicateLeadCheck = Schema.sObjectType.lead.isAccessible();   //NOPMD
        If(DuplicateLeadCheck && deleteDuplicateLead.Size() > 0){
            if(lead.sObjectType.getDescribe().isDeletable()){
                delete deleteDuplicateLead; 
            }
        }
    }
}