/********************************************************************************************
* NAME         : MergeRecordRulesCtrl
* DESCRIPTION  : This class is use to create the Automation Merge Rules.
* 
* @AUTHOR: dev team
* @DATE: 01/29/2019
*
*
* MODIFICATION LOG:
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
dev team                        01/29/2019                            -
********************************************************************************************/
global with sharing class MergeRecordRulesCtrl{ //NOPMD
    public Static List<SmartDD__ManageRule_Master_Record__c> ManageRuleList = new List<SmartDD__ManageRule_Master_Record__c>(); //NOPMD
    public Static List<SmartDD__ManageRule_Master_Record__c> lstdelRec = new List<SmartDD__ManageRule_Master_Record__c>();
    
    @AuraEnabled 
    public static List<string> getMasterRecordSelection(){
        List<SmartDD__Master_Record_Selection__c> lstMasterRecordsFlds = new List<SmartDD__Master_Record_Selection__c>([select SmartDD__Field_Name__c from SmartDD__Master_Record_Selection__c WITH USER_MODE LIMIT 200]);
        List<string> strMasterRecordFlds = new List<string>();
        for(SmartDD__Master_Record_Selection__c masterRecsFields : lstMasterRecordsFlds){
            strMasterRecordFlds.add(masterRecsFields.SmartDD__Field_Name__c);
        }
        system.debug('@#$strMasterRecordFlds: '+strMasterRecordFlds);
        return strMasterRecordFlds;    
    }
    
    @AuraEnabled 
    public static List<string> getManageRuleExceptions(){
        List<SmartDD__Manage_Rule_Exceptions__c> lstManageRuleException = new List<SmartDD__Manage_Rule_Exceptions__c>([select SmartDD__Field_Name__c from SmartDD__Manage_Rule_Exceptions__c WITH USER_MODE LIMIT 200]);
        List<string> strManageRuleException = new List<string>();
        for(SmartDD__Manage_Rule_Exceptions__c exceptionRules : lstManageRuleException){
            strManageRuleException.add(exceptionRules.SmartDD__Field_Name__c);
        }
        strManageRuleException.sort();
        system.debug('@#$strManageRuleException: '+strManageRuleException);
        return strManageRuleException;    
    }
    
    
    
    @AuraEnabled
    public static List<String> saveMergeRuleFilters(String selObject, String MergeRuleName, Integer ConfidenceScore,String MasterRecord,Id MasterRecordId,String ObjFieldAPIName,String MasterPopFieldVals,String MasterOrderBy,String DefaultSelectionPriority,String OverrideMaster, List<SmartDD__ManageRule_Specific_FieldVal__c> SpecificFieldList, List<SmartDD__ManageRule_Exception__c> ExceptionsList){ //NOPMD
        list<SmartDD__ManageRule_Master_Record__c> lstMstrRecCriteria = [SELECT Id, SmartDD__Priority__c FROM SmartDD__ManageRule_Master_Record__c where SmartDD__Object_Name__c =: selObject WITH USER_MODE];
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteria = new SmartDD__ManageRule_Master_Record__c();
        
       
        objMstrRecCriteria.SmartDD__Object_Name__c = selObject;
        objMstrRecCriteria.SmartDD__Merge_Rule_Name__c = MergeRuleName;
        objMstrRecCriteria.SmartDD__Least_Confidence_Score__c = ConfidenceScore;
        objMstrRecCriteria.SmartDD__Master_Record_Type__c = MasterRecord;
        objMstrRecCriteria.SmartDD__Object_Field_API_Name__c = ObjFieldAPIName;
        objMstrRecCriteria.SmartDD__Master_Popup_Field_Values__c = MasterPopFieldVals;
        objMstrRecCriteria.SmartDD__Master_Order_By__c = MasterOrderBy;
        objMstrRecCriteria.SmartDD__Default_Field_Value_Selection_Priority__c = DefaultSelectionPriority;
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteria.SmartDD__Default_Override_Master_Record__c = OverrideMaster;
        if(MasterRecordId == null) {
            decimal Prioritysize = lstMstrRecCriteria.size() + 1; //NOPMD
            objMstrRecCriteria.SmartDD__Priority__c = Prioritysize;
        }
        if(objMstrRecCriteria.SmartDD__Priority__c == 1) {
            objMstrRecCriteria.SmartDD__Status__c = 'Active';
        }
        
        
        
        List<string> lstreturnvalue = new List<string>();
        String errormsg = '';
        List<Id> lstMasterRecId = new List<Id>(); 
        
        // Upserting records of SpecificField Val child table.   
        List<SmartDD__ManageRule_Specific_FieldVal__c> lstSpecificFields = new List<SmartDD__ManageRule_Specific_FieldVal__c> (); 
        Integer cnt=1;
        if(SpecificFieldList.size() > 0){
            for(SmartDD__ManageRule_Specific_FieldVal__c objSpecificFieldValue: SpecificFieldList) {
                System.debug('@@@ objSpecificFieldValue : ' +objSpecificFieldValue);
                if (String.isBlank(objSpecificFieldValue.SmartDD__Specific_Field_Name__c) || String.isBlank(objSpecificFieldValue.SmartDD__Specific_Rule_Name__c) || String.isBlank(objSpecificFieldValue.SmartDD__Specific_Master_Override_Type__c)){                       
                    errormsg += 'Please add Specific Field Value '+ cnt + '<br/>';
                    System.debug('@@@ objSpecificFieldValue errormsg : ' +errormsg);
                }
                cnt++;     
            }
        }
        List<SmartDD__ManageRule_Exception__c> lstExceptionFields = new List<SmartDD__ManageRule_Exception__c> (); 
        /*
Integer cntEx = 1;
if(ExceptionsList.size() > 0){
for(ManageRule_Exception__c objExceptionValue: ExceptionsList) { 
System.debug('@@@ objExceptionValue : ' +objExceptionValue);
if (String.isBlank(objExceptionValue.Exception_Exclude_Rule__c) || String.isBlank(objExceptionValue.Run_Exception_Rule__c)) {                       
errormsg += 'Please add Exception rule '+ cntEx + '<br/>'; 
System.debug('@@@ objExceptionValue errormsg : ' +errormsg);
}
cntEx++;     
}
}
*/
        if(errormsg == '') {
            // Upserting records of master table.
            if(Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Object_Name__c.isUpdateable() && 
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Merge_Rule_Name__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Merge_Rule_Name__c.isUpdateable() && 
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Least_Confidence_Score__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Least_Confidence_Score__c.isUpdateable() && 
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Record_Type__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Record_Type__c.isUpdateable() && 
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Object_Field_API_Name__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Object_Field_API_Name__c.isUpdateable() &&	  
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Popup_Field_Values__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Popup_Field_Values__c.isUpdateable() && 	  
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Order_By__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Order_By__c.isUpdateable() &&	  
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Default_Field_Value_Selection_Priority__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Default_Field_Value_Selection_Priority__c.isUpdateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Default_Override_Master_Record__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Default_Override_Master_Record__c.isUpdateable() && 	  
               Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isUpdateable() &&  Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Status__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Status__c.isUpdateable())
            {
                
                if(MasterRecordId != null){
                    if(Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.Id.isAccessible()){ //NOPMD
                        objMstrRecCriteria.Id = MasterRecordId;
                    }
                    if(Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.isUpdateable() || Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.Id.isUpdateable()) //NOPMD
                    {
                        //objMstrRecCriteria = new SmartDD__ManageRule_Master_Record__c(Id=MasterRecordId);
                        //objMstrRecCriteria.Id = MasterRecordId;
                        update objMstrRecCriteria;
                    }
                }
                if(MasterRecordId == null){
                   if(SmartDD__ManageRule_Master_Record__c.sObjectType.getDescribe().isCreateable() || Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.Id.isCreateable()) //NOPMD
                    {
                        insert objMstrRecCriteria;
                    }
                }
            }
            
            lstMasterRecId.add(objMstrRecCriteria.Id);
            
            if(SpecificFieldList.size() > 0){
                for(SmartDD__ManageRule_Specific_FieldVal__c objSpecificFieldValue: SpecificFieldList) {
                    objSpecificFieldValue.SmartDD__Master_Record_Criteria_Name__c = objMstrRecCriteria.Id;
                    lstSpecificFields.add(objSpecificFieldValue); 
                }
            }
            if(ExceptionsList.size() > 0){
                for(SmartDD__ManageRule_Exception__c objExceptionValue: ExceptionsList) { 
                    objExceptionValue.SmartDD__Master_Record_Criteria_Name__c = objMstrRecCriteria.Id;
                    lstExceptionFields.add(objExceptionValue); 
                }
            }
        }
        
        lstreturnvalue.add(errormsg); 
        system.debug('@!#$errormsg: '+errormsg);
        if(lstSpecificFields.size() > 0 && errormsg == ''){
            Set<String> setSpecificRecordNew = new Set<String>();
            for(SmartDD__ManageRule_Specific_FieldVal__c objSpecificNew : lstSpecificFields) {
                objSpecificNew.SmartDD__Master_Record_Criteria_Name__c = objMstrRecCriteria.Id;
                setSpecificRecordNew.add(objSpecificNew.Id);
            }
            Set<String> setSpecificRecExist = new Set<String>();
            lstSpecificFields =  [select Id from SmartDD__ManageRule_Specific_FieldVal__c where SmartDD__Master_Record_Criteria_Name__c =: lstMasterRecId WITH USER_MODE];
            for(SmartDD__ManageRule_Specific_FieldVal__c specificRecExist :lstSpecificFields){ 
                setSpecificRecExist.add(specificRecExist.Id);
            }
            for(String str: setSpecificRecExist) {
                if(setSpecificRecordNew.contains(str)) {
                    setSpecificRecExist.remove(str);
                }           
            }
            if(setSpecificRecExist.size() > 0) {
                if(SmartDD__ManageRule_Specific_FieldVal__c.sObjectType.getDescribe().isDeletable()){
                    lstSpecificFields =  [Select Id from SmartDD__ManageRule_Specific_FieldVal__c where Id in :setSpecificRecExist WITH USER_MODE];
                    Delete lstSpecificFields;
                }                    
            }
            if(Schema.sObjectType.SmartDD__ManageRule_Specific_FieldVal__c.isCreateable()) {
                upsert SpecificFieldList; //NOPMD
            }
        }
        
        // Upserting records of Exception child table. 
        if(lstExceptionFields.size() > 0 && errormsg == '') {
            Set<String> setExceptionRecordNew = new Set<String>();
            for(SmartDD__ManageRule_Exception__c objExceptionNew : lstExceptionFields) {
                objExceptionNew.SmartDD__Master_Record_Criteria_Name__c = objMstrRecCriteria.Id;
                setExceptionRecordNew.add(objExceptionNew.Id);
            }
            Set<String> setExceptionRecExist = new Set<String>();
            List<SmartDD__ManageRule_Exception__c> lstManageRuleExp = new List<SmartDD__ManageRule_Exception__c>();
            lstManageRuleExp = [select Id from SmartDD__ManageRule_Exception__c where SmartDD__Master_Record_Criteria_Name__c =: lstMasterRecId WITH USER_MODE];
            for(SmartDD__ManageRule_Exception__c exceptionRecExist :lstManageRuleExp){ 
                setExceptionRecExist.add(exceptionRecExist.Id);
            }
            for(String str: setExceptionRecExist) {
                if(setExceptionRecordNew.contains(str)) {
                    setExceptionRecExist.remove(str);
                }           
            }
            if(setExceptionRecExist.size() > 0) {
                if(SmartDD__ManageRule_Exception__c.sObjectType.getDescribe().isDeletable()){
                    List<SmartDD__ManageRule_Exception__c> lstManageRuleExpDlt = new List<SmartDD__ManageRule_Exception__c>();
                    lstManageRuleExpDlt = [Select Id from SmartDD__ManageRule_Exception__c where Id in :setExceptionRecExist WITH USER_MODE];
                    Delete lstManageRuleExpDlt;
                }                    
            }
            /*if(Schema.sObjectType.SmartDD__ManageRule_Exception__c.isCreateable()) {
upsert ExceptionsList;
}*/	
        }
        
        system.debug('@@#$lstreturnvalue: '+lstreturnvalue);
        return lstreturnvalue;
    }
    
    @AuraEnabled
    public static List<wrpObjectFieldsList> fetchSelectedRecFields(String selectedObject, String selectedMarterRecType){ //NOPMD
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> MapOfSObj = schemaMap.get(selectedObject).getDescribe().fields.getMap(); //NOPMD
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        wrpObjectFieldsList objWrp = new wrpObjectFieldsList();
        for(String StringOfSObj: MapOfSObj.keyset()){ //NOPMD
            String strFieldname = String.valueOf(MapOfSObj.get(StringOfSObj).getDescribe().getname());
            String fieldLabelName = String.valueOf(MapOfSObj.get(StringOfSObj).getDescribe().getLabel());
            
            Schema.DescribeFieldResult lfieldLabel = MapOfSObj.get(StringOfSObj).getDescribe();
            Schema.DisplayType dataType = lfieldLabel.getType();
            string fieldType = String.ValueOf(dataType);
            
            wrpFields objField = new wrpFields(); 
            if(strFieldname != 'GeocodeAccuracy' && strFieldname != 'LeadSource' && strFieldname != 'ConvertedAccountId' && strFieldname != 'ConvertedContactId' && strFieldname != 'ConvertedOpportunityId' && strFieldname != 'CreatedById' && strFieldname != 'LastModifiedById' && strFieldname != 'Jigsaw' && strFieldname != 'JigsawContactId' && strFieldname != 'Longitude'  && strFieldname != 'Latitude' && strFieldname != 'CompanyDunsNumber' && strFieldname != 'DandbCompanyId' && strFieldname != 'IndividualId' && strFieldname != 'SmartDD__SICCode__c' && strFieldname != 'SmartDD__ProductInterest__c' && strFieldname != 'SmartDD__Primary__c' && strFieldname != 'SmartDD__CurrentGenerators__c' && strFieldname != 'SmartDD__DedupeId__c') {   
                if(selectedMarterRecType == 'Highest value in the user-defined field' || selectedMarterRecType == 'Lowest value in the user-defined field'){  
                    if(fieldType == 'int' || fieldType == 'double' || fieldType == 'currency'){
                        objField.fieldLabelName = fieldLabelName;
                        objField.fieldAPIName = strFieldname;
                        objWrp.FieldsList.add(objField);
                    }
                }
                else if(selectedMarterRecType == 'First record with a value in the user-defined field'){  
                    if(fieldType == 'url' || fieldType == 'textarea' || fieldType == 'string' || fieldType == 'reference' || fieldType == 'int' || fieldType == 'double' || fieldType == 'currency' ||
                       fieldType == 'picklist' || fieldType == 'phone' || fieldType == 'email' || fieldType == 'datetime' || fieldType == 'date'){
                           objField.fieldLabelName = fieldLabelName;
                           objField.fieldAPIName = strFieldname;
                           objWrp.FieldsList.add(objField);
                       }
                }
                else if(selectedMarterRecType == 'Prioritized on the given field and values'){  
                    if(fieldType == 'url' || fieldType == 'textarea' || fieldType == 'string' || fieldType == 'int' || fieldType == 'currency' ||
                       fieldType == 'picklist' || fieldType == 'email'){
                           objField.fieldLabelName = fieldLabelName;
                           objField.fieldAPIName = strFieldname;
                           objWrp.FieldsList.add(objField);
                       }
                }
                else if(selectedMarterRecType == 'Newest by the given date field' || selectedMarterRecType == 'Oldest by the given date field'){  
                    if(fieldType == 'date' ||fieldType == 'datetime'){
                        objField.fieldLabelName = fieldLabelName;
                        objField.fieldAPIName = strFieldname;
                        objWrp.FieldsList.add(objField);
                    }
                }
                else if(selectedMarterRecType == 'Record with field value not on specified ignore list'){  
                    if(fieldType == 'url' || fieldType == 'textarea' || fieldType == 'string' || fieldType == 'int' || fieldType == 'double' || fieldType == 'currency' ||
                       fieldType == 'picklist' || fieldType == 'email'){
                           objField.fieldLabelName = fieldLabelName;
                           objField.fieldAPIName = strFieldname;
                           objWrp.FieldsList.add(objField);
                       }
                }
            }
        }
        newWrpList.add(objWrp);
        system.debug('@@#newWrpList: '+newWrpList);
        return newWrpList;
    }
    
    @AuraEnabled
    public static List<wrpObjectFieldsList> fetchExceptionFields(String selectedObject){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> MapOfSObj = schemaMap.get(selectedObject).getDescribe().fields.getMap(); //NOPMD
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        wrpObjectFieldsList objWrp = new wrpObjectFieldsList();
        for(String StringOfSObj: MapOfSObj.keyset()){ //NOPMD
            String strFieldname = String.valueOf(MapOfSObj.get(StringOfSObj).getDescribe().getname());
            String fieldLabelName = String.valueOf(MapOfSObj.get(StringOfSObj).getDescribe().getLabel());
            
            Schema.DescribeFieldResult lfieldLabel = MapOfSObj.get(StringOfSObj).getDescribe();
            Schema.DisplayType dataType = lfieldLabel.getType();
            string fieldType = String.ValueOf(dataType);
            
            wrpFields objField = new wrpFields();  
            if(fieldType == 'url' || fieldType == 'textarea' || fieldType == 'string' || fieldType == 'reference' || fieldType == 'int' || fieldType == 'double' || fieldType == 'currency' ||
               fieldType == 'picklist' || fieldType == 'phone' || fieldType == 'email' || fieldType == 'datetime' || fieldType == 'date'){
                   objField.fieldLabelName = fieldLabelName;
                   objField.fieldAPIName = strFieldname;
                   objWrp.FieldsList.add(objField);
               }
        }
        newWrpList.add(objWrp);
        system.debug('@@#newWrpListException: '+newWrpList);
        return newWrpList;
    }
    
    @AuraEnabled 
    public static List<String> checkSpecificFieldValueType(String ObjectName, String selSpecificFieldVal){ //NOPMD
        List<String> pickListValuesList= new List<String>();
        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        system.debug('@#$%selSpecificFieldVal: '+selSpecificFieldVal);
        if(selSpecificFieldVal != null && selSpecificFieldVal != '') {
            Schema.DisplayType fieldDataType = d.fields.getMap().get(selSpecificFieldVal).getDescribe().getType();
            if(String.Valueof(fieldDataType) == 'picklist' || String.Valueof(fieldDataType) == 'PICKLIST'){
                List<String> picklistValues = new List<String>();     
                for(Schema.PicklistEntry p : Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(selSpecificFieldVal).getDescribe().getPicklistValues()) {
                    picklistValues.add(p.getLabel());
                }
                return picklistValues;
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<SmartDD__Merge_Specific_Field_Values__c> getObjFields(String selectedObject){
        List<SmartDD__Merge_Specific_Field_Values__c> lstobjFieldList = new List<SmartDD__Merge_Specific_Field_Values__c>([SELECT SmartDD__Field_Name__c, SmartDD__Field_API_Name__c, SmartDD__Specific_Field_Rules__c,Name FROM SmartDD__Merge_Specific_Field_Values__c where SmartDD__Object_Name__c =:selectedObject WITH USER_MODE]);
        lstobjFieldList.sort();
        if(lstobjFieldList.Size() > 0) {
            for(SmartDD__Merge_Specific_Field_Values__c objSpecificFields: lstobjFieldList) {
                if(objSpecificFields.SmartDD__Field_API_Name__c == 'OwnerId') {
                    objSpecificFields.SmartDD__Field_Name__c = 'Owner Name';
                    objSpecificFields.SmartDD__Field_API_Name__c = 'Owner.Name';
                } else if(objSpecificFields.SmartDD__Field_API_Name__c == 'AccountId'){
                    objSpecificFields.SmartDD__Field_Name__c = 'Account Name';
                    objSpecificFields.SmartDD__Field_API_Name__c = 'Account.Name';
                }
            }
        }
        return lstobjFieldList;
    }
    
    /**********************************************************************************************
Purpose: get ManageRule Master record from id to edit ManageRule Master record. 
**********************************************************************************************/
    @AuraEnabled
    public static editMasterWrapper editMasterRecord(string MasterRecid){ //NOPMD
        editMasterWrapper objMasterWrapper = new editMasterWrapper();
        if(!String.IsBlank(MasterRecid)){
            List<SmartDD__ManageRule_Master_Record__c> lstMasterRec = new List<SmartDD__ManageRule_Master_Record__c>([SELECT Id, SmartDD__Merge_Rule_Name__c, SmartDD__Least_Confidence_Score__c, SmartDD__Master_Record_Type__c, SmartDD__Master_Order_By__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Default_Override_Master_Record__c, SmartDD__Object_Field_API_Name__c, SmartDD__Master_Popup_Field_Values__c, SmartDD__Object_Name__c, Name FROM SmartDD__ManageRule_Master_Record__c where Id=:MasterRecid WITH USER_MODE ORDER BY CreatedDate ASC]);
            
            List<SmartDD__ManageRule_Specific_FieldVal__c> lstSpecificCriteria = new List<SmartDD__ManageRule_Specific_FieldVal__c>([SELECT SmartDD__Master_Record_Criteria_Name__c, SmartDD__Specific_Field_Name__c, SmartDD__Specific_Rule_Name__c, SmartDD__Specific_Master_Override_Type__c, SmartDD__Specific_Popup_Field_Values__c, Id, Name FROM SmartDD__ManageRule_Specific_FieldVal__c where SmartDD__Master_Record_Criteria_Name__c=:MasterRecid WITH USER_MODE ORDER BY CreatedDate ASC]);
            
            List<SmartDD__ManageRule_Exception__c> lstExceptionCriteria = new List<SmartDD__ManageRule_Exception__c>([SELECT SmartDD__Master_Record_Criteria_Name__c, SmartDD__Exception_Exclude_Rule__c, SmartDD__Exception_Field_Name__c, SmartDD__Run_Exception_Rule__c, SmartDD__Exception_Popup_Field_Values__c, Id, Name FROM SmartDD__ManageRule_Exception__c where SmartDD__Master_Record_Criteria_Name__c=:MasterRecid WITH USER_MODE ORDER BY CreatedDate ASC]);
            
            if(lstMasterRec.size() > 0){            
                objMasterWrapper.objMasterRecords = lstMasterRec[0];
            }
            if(lstSpecificCriteria.size() > 0){
                objMasterWrapper.lstSpecificValCriterias = lstSpecificCriteria;
            }
            if(lstExceptionCriteria.size() > 0){
                objMasterWrapper.lstExceptionRules = lstExceptionCriteria;
            }
        }
        return objMasterWrapper;              
    }
    @AuraEnabled
    public static List<SmartDD__ManageRule_Master_Record__c> getMergeRules(String selectedObject) {
        string objectName = selectedObject;
        String query = 'SELECT Id, LastModifiedDate, SmartDD__Merge_Rule_Name__c, SmartDD__Least_Confidence_Score__c, SmartDD__Status__c, SmartDD__Master_Record_Type__c, SmartDD__Priority__c,SmartDD__Master_Order_By__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Default_Override_Master_Record__c,SmartDD__Object_Field_API_Name__c, SmartDD__Master_Popup_Field_Values__c,SmartDD__Object_Name__c, Name FROM SmartDD__ManageRule_Master_Record__c where  SmartDD__Object_Name__c =: objectName WITH USER_MODE ORDER BY createdDate ASC';
        ManageRuleList = Database.query(query);
        system.debug('@@#queryResult' + query);
        //return ManageRuleList;
        for(SmartDD__ManageRule_Master_Record__c objMasterRecords : ManageRuleList) {
            if(objMasterRecords.SmartDD__Object_Field_API_Name__c != null && objMasterRecords.SmartDD__Object_Field_API_Name__c != '') {
                objMasterRecords.SmartDD__Object_Field_API_Name__c = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(objMasterRecords.SmartDD__Object_Field_API_Name__c).getDescribe().getLabel();
            }
        }
        system.debug('@#$ManageRuleList: '+ManageRuleList);
        return ManageRuleList;
    }
    @AuraEnabled
    public static List<SmartDD__ManageRule_Master_Record__c> delSlctRec(List<String> slctRec, String selectedObject){
        String objectName = selectedObject;
        try{
            lstdelRec = [SELECT Id,SmartDD__Status__c,SmartDD__Priority__c FROM SmartDD__ManageRule_Master_Record__c WHERE Id IN: slctRec WITH USER_MODE];
            List<SmartDD__ManageRule_Master_Record__c> lstActiveRec = new List<SmartDD__ManageRule_Master_Record__c>([SELECT Id,SmartDD__Status__c,SmartDD__Priority__c FROM SmartDD__ManageRule_Master_Record__c WHERE SmartDD__Status__c = 'Active' AND SmartDD__Object_Name__c =: objectName WITH USER_MODE]);
            List<SmartDD__ManageRule_Master_Record__c> lstDeleteRec = new List<SmartDD__ManageRule_Master_Record__c>();
            for(SmartDD__ManageRule_Master_Record__c  objMngRule :lstdelRec){
                if(objMngRule.Id == lstActiveRec[0].Id){
                    return null; 
                }
                else{
                    lstDeleteRec.add(objMngRule);
                }
            }
            if(lstDeleteRec.size() > 0) {
                if(SmartDD__ManageRule_Master_Record__c.sObjectType.getDescribe().isDeletable())
                {
                    Delete lstDeleteRec;
                }
            }
        } catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        List<SmartDD__ManageRule_Master_Record__c> lstExsistingrec = [SELECT Id,SmartDD__Status__c,SmartDD__Priority__c FROM SmartDD__ManageRule_Master_Record__c WHERE SmartDD__Status__c != 'Active' AND SmartDD__Object_Name__c =: objectName WITH USER_MODE ORDER BY CreatedDate DESC];
        List<SmartDD__ManageRule_Master_Record__c> lstInsertRec = new List<SmartDD__ManageRule_Master_Record__c>();
        integer count = 1;
        for(SmartDD__ManageRule_Master_Record__c msterRec : lstExsistingrec){
            count = count+1;
            msterRec.SmartDD__Priority__c = count;
            System.debug('msterRec @@@@@ ' + msterRec);
            lstInsertRec.add(msterRec);
        }
        if(lstInsertRec.size() > 0 && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isCreateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isUpdateable()) {
            Upsert lstInsertRec;
        } 
        ManageRuleList = Database.query('SELECT Id, LastModifiedDate, SmartDD__Merge_Rule_Name__c, SmartDD__Least_Confidence_Score__c, SmartDD__Priority__c,SmartDD__Status__c, SmartDD__Master_Record_Type__c, SmartDD__Master_Order_By__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Default_Override_Master_Record__c,SmartDD__Object_Field_API_Name__c, SmartDD__Master_Popup_Field_Values__c, SmartDD__Object_Name__c, Name,(SELECT SmartDD__Master_Record_Criteria_Name__c, SmartDD__Specific_Field_Name__c, SmartDD__Specific_Rule_Name__c, SmartDD__Specific_Master_Override_Type__c, Id, Name FROM SmartDD__Specific_Field_Values__r) FROM SmartDD__ManageRule_Master_Record__c where SmartDD__Object_Name__c =:objectName WITH USER_MODE ORDER BY createdDate ASC');
        return ManageRuleList;
    }
    
    @AuraEnabled
    public static void updateRecStatus(String selectedRecord, String selectedObject){
        String objectName = selectedObject;
        List<SmartDD__ManageRule_Master_Record__c> activeRule = new List<SmartDD__ManageRule_Master_Record__c>();
        activeRule = [SELECT Id,SmartDD__Status__c,SmartDD__Priority__c FROM SmartDD__ManageRule_Master_Record__c where SmartDD__Status__c = 'Active' AND SmartDD__Object_Name__c =:objectName WITH USER_MODE];
        decimal tempstr;
        List<SmartDD__ManageRule_Master_Record__c> lstSelectedActiveRecord = new List<SmartDD__ManageRule_Master_Record__c>();
        lstSelectedActiveRecord = [SELECT Id, SmartDD__Status__c,SmartDD__Priority__c FROM SmartDD__ManageRule_Master_Record__c where Id =: selectedRecord WITH USER_MODE];
        lstSelectedActiveRecord[0].SmartDD__Status__c = 'Active';
        tempstr = lstSelectedActiveRecord[0].SmartDD__Priority__c;
        lstSelectedActiveRecord[0].SmartDD__Priority__c = 1;
        if(activeRule.size() > 0) {
            for(SmartDD__ManageRule_Master_Record__c objRule: activeRule) {
                objRule.SmartDD__Status__c = 'Inactive';
                objRule.SmartDD__Priority__c = tempstr;
            }
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, activeRule); 
            Update decision.getRecords();
        }
        
        
        if(Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Status__c.isUpdateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isUpdateable())
        {
            Update lstSelectedActiveRecord;
        }
        
    }
    @AuraEnabled
    public static void SwapPriority(String selectedRecordId, integer selectedPrio){ //NOPMD
        System.debug('451 selectedRecordId --> '+ selectedRecordId);
        System.debug('452 selectedPrio --> '+ selectedPrio);
        Map<Id, SmartDD__ManageRule_Master_Record__c> mapPrio = new Map<Id, SmartDD__ManageRule_Master_Record__c>([SELECT Id, SmartDD__Priority__c,SmartDD__Status__c FROM SmartDD__ManageRule_Master_Record__c Where Id =: selectedRecordId OR  SmartDD__Priority__c =: selectedPrio WITH USER_MODE]);
        List<SmartDD__ManageRule_Master_Record__c> UpdatelstPrio = new List<SmartDD__ManageRule_Master_Record__c>(); //NOPMD
        Decimal tmpStr = 0;
        
        if(selectedPrio == 1){
            mapPrio.get(selectedRecordId).SmartDD__Status__c ='Active';
        }else{
            mapPrio.get(selectedRecordId).SmartDD__Status__c ='Inactive';
        } 
        
        if(mapPrio.size() > 1 && mapPrio.containsKey(selectedRecordId)){
            for(Id MrgRuleId : mapPrio.keySet()){ //NOPMD
                SmartDD__ManageRule_Master_Record__c MrgRule  = mapPrio.get(MrgRuleId); //NOPMD
                if(MrgRuleId != selectedRecordId && MrgRule.SmartDD__Priority__c == selectedPrio){
                    MrgRule.SmartDD__Priority__c = mapPrio.get(selectedRecordId).SmartDD__Priority__c;
                    if(MrgRule.SmartDD__Priority__c != 1){
                        MrgRule.SmartDD__Status__c ='Inactive';
                    } else{
                        MrgRule.SmartDD__Status__c ='Active';
                    }
                }
            }
            mapPrio.get(selectedRecordId).SmartDD__Priority__c = selectedPrio; 
            if(Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Status__c.isUpdateable() && Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isUpdateable())
            {
                update mapPrio.values();
            }
        }
    }
    
    
    /******************************************************
wrapper class
******************************************************/
    public class wrpObjectFieldsList{ //NOPMD
        @AuraEnabled public List<wrpFields> FieldsList{get;set;} //NOPMD
        public wrpObjectFieldsList(){
            FieldsList = new List<wrpFields>(); 
        }
    }    
    public class wrpFields{ //NOPMD
        @AuraEnabled public string fieldAPIName{get;set;}
        @AuraEnabled public string fieldLabelName{get;set;}
        public wrpFields(){
            fieldLabelName = '';
            fieldAPIName = '';
        }
    }
    public class editMasterWrapper {   //NOPMD 
        @AuraEnabled public SmartDD__ManageRule_Master_Record__c  objMasterRecords {get;set;}        
        @AuraEnabled public List<SmartDD__ManageRule_Specific_FieldVal__c> lstSpecificValCriterias {get;set;}
        @AuraEnabled public List<SmartDD__ManageRule_Exception__c> lstExceptionRules {get;set;}
        public editMasterWrapper() {
            objMasterRecords = new SmartDD__ManageRule_Master_Record__c();
            lstSpecificValCriterias = new List<SmartDD__ManageRule_Specific_FieldVal__c>();
            lstExceptionRules = new List<SmartDD__ManageRule_Exception__c>();
        }
    } 
}