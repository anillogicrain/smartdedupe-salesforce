/********************************************************************************************
* NAME         : FilterController
* DESCRIPTION  : This class is use to Manage FilterData in De-dupe.
*
* @AUTHOR: dev team
* @DATE: 10/16/2018
*
*
* MODIFICATION LOG:
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
dev team                        10/16/2018                            -
********************************************************************************************/
global with sharing class FilterController {    // NOPMD
    public Static List<wrpFields> lstCheckedAccount = new List<wrpFields>();
    public Static List<wrpFields> lstCheckedLead = new List<wrpFields>();
    public Static List<wrpFields> lstCheckedContact = new List<wrpFields>();
    public Static List<String> lstUnCheckedAccount = new List<String>();
    public Static List<String> lstUnCheckedLead = new List<String>();
    public Static List<String> lstUnCheckedContact = new List<String>();
    /**********************************************************************************************
Purpose: fetch filter Name to bind picklist.
**********************************************************************************************/
    @AuraEnabled
    public static List<string> getFiltername(String SelectedObjName){         // NOPMD      
        List<string> lstfilternames = new List<string>();
        List<SmartDD__Filter__c> lstFilters = new List<SmartDD__Filter__c>();
        if(Schema.sObjectType.SmartDD__Filter__c.isAccessible())   {

            for(SmartDD__Filter__c filter : [select id,Name,SmartDD__Object_Name__c from SmartDD__Filter__c WHERE SmartDD__Object_Name__c=:SelectedObjName WITH SECURITY_ENFORCED limit 49999]) { 
                string strname = filter.Id +'#'+ filter.Name;           
                lstfilternames.add(strname);
            }
            return lstfilternames;   
        }
        
        return lstfilternames;        
    }
    
    @AuraEnabled    
    public static String getCustomSettingValue() {
        //String orgId = system.Label.Canvas_APP_Import + UserInfo.getOrganizationId();
        //String orgId = system.Label.Canvas_APP_Import;
        /*SmartDD__De_Dupe_Configuration__c objCustomSetting = SmartDD__De_Dupe_Configuration__c.getInstance('DeDupe Configuration');
if(objCustomSetting != null){
return objCustomSetting.SF_Import_APP_Name;
}*/
        //return orgId;
        SmartDD__De_Dupe_Configuration__c objCustomSetting = SmartDD__De_Dupe_Configuration__c.getInstance('DeDupe Configuration');
        String appName = '';
        
        if(objCustomSetting != null){
            appName = objCustomSetting.SmartDD__SF_Import_APP_Name__c;
            
        }
        return appName;       
    }
    
    /**********************************************************************************************
Purpose: Update custom setting value with object name deduped.
**********************************************************************************************/
    public static void updateDedupeObjectName(String objectType, String filterId){
        String queryConditions = '';
        List<sObject> lstTotalCount = new List<sObject>();
        Integer totalCount = 0;
        if(!String.IsBlank(filterId)){
            queryConditions = getQueryConditionString(filterId);
        }   
        
        String querytotalCount = ''; 
        querytotalCount += 'Select Count(Id) from '+ String.escapeSingleQuotes(objectType) ;
        
        if(!String.IsBlank(queryConditions)){
            querytotalCount += ' where '+ queryConditions + ' WITH SECURITY_ENFORCED';                   
        }
        lstTotalCount = database.query(querytotalCount);
        totalCount = Integer.valueOf(lstTotalCount[0].get('expr0'));
        
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__DeDupe_Object_Name__c = objectType;
        dedupeConfig.SmartDD__Total_Records_Deduped__c = totalCount;
        dedupeConfig.SmartDD__Last_Dedupe_Time__c = String.ValueOf(Datetime.now());
        
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__DeDupe_Object_Name__c.isUpdateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Total_Records_Deduped__c.isUpdateable() &&  Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Dedupe_Time__c.isUpdateable()) {
            update dedupeConfig;
        }
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRec = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRec.SmartDD__Object_Name__c = objectType;
        if(Schema.sObjectType.SmartDD__Master_Cluster_Record__c.fields.SmartDD__Object_Name__c.isCreateable()) {
            insert objMasterClusterRec;
        }
        system.debug('!@#objectType: '+objectType);
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(objectType);
        system.debug('@Boolean1: '+objMasterClusterRec.Id);       
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            objMasterClusterId.SmartDD__Old_Master_Cluster_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
        }
        system.debug('@Boolean2: '+objMasterClusterRec.Id);
        if(objMasterClusterRec.Id != null) {
            system.debug('@Boolean3: '+objMasterClusterRec.Id);
            objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMasterClusterRec.Id;
            objMasterClusterId.SmartDD__Process_Type__c = 'Dedupe';
        }
        
        if(Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.isAccessible() 
           && Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.isUpdateable() || Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Old_Master_Cluster_Id__c.isAccessible() ||Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__New_Master_Cluster_Id__c.isAccessible() || Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Process_Type__c.isAccessible() || Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Old_Master_Cluster_Id__c.isUpdateable() ||Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__New_Master_Cluster_Id__c.isUpdateable() || Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Process_Type__c.isUpdateable()) {
               update objMasterClusterId;
           }                
    }
    
    /**********************************************************************************************
Purpose: delete filter records. 
**********************************************************************************************/ 
    
    @AuraEnabled 
    public static String startDeduplication(String objectName) { 
        System.debug('objectName: '+objectName);
        try { 
            // Validate input 
            if (String.isBlank(objectName)) { 
                System.debug('IllegalArgumentException: '+String.isBlank(objectName));
                throw new IllegalArgumentException('Object name must be provided.'); 
            } 
            
            // Check if the object exists 
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
            if (!globalDescribe.containsKey(objectName)) { 
                System.debug('IllegalArgumentException: '+!globalDescribe.containsKey(objectName));
                throw new IllegalArgumentException('Invalid object name: ' + objectName); 
            }
            
            // Get the sObject type 
            Schema.SObjectType sObjectType = globalDescribe.get(objectName); 
            System.debug('sObjectType: '+sObjectType);
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe(); 
            System.debug('describeResult: '+describeResult);
            
            // Check if the IsDuplicate__c field exists 
            if (!describeResult.fields.getMap().containsKey('IsDuplicate__c')) { 
                System.debug('IllegalArgumentException: '+!describeResult.fields.getMap().containsKey('IsDuplicate__c'));
                throw new IllegalArgumentException('Field IsDuplicate__c does not exist on ' + objectName); 
            } 
            
            // Get the ID of the current user 
            Id userId = UserInfo.getUserId();
            System.debug('userId: '+userId);
            
            // Enqueue the deduplication process asynchronously, passing the user ID 
            string enqueue = System.enqueueJob(new DedupeQueueable(objectName, userId));
            System.debug('enqueue: '+enqueue);
            
            // Return immediately 
            return 'Deduplication process has been initiated. You will be notified upon completion.'; 
        } catch (Exception e) { 
            
            // Log the error and throw an exception to be handled by the Lightning component 
            System.debug('Error during deduplication: ' + e.getMessage()); 
            throw new AuraHandledException('An error occurred during deduplication: ' + e.getMessage()); 
        } 
    }
    
    public class AuthorizationException extends Exception {}

    @AuraEnabled 
    public static List<String> getFilterNames(String selectedObjName) { 
        // Ensure proper security checks 
        if (!Schema.sObjectType.SmartDD__Filter__c.isAccessible()) { 
            throw new AuthorizationException('Access to SmartDD__Filter__c is not permitted.'); 
        } 
        
        // Fetch filter names while respecting FLS and CRUD 
        List<String> filterNames = new List<String>(); 
        List<SmartDD__Filter__c> filters = [SELECT Id, Name FROM SmartDD__Filter__c WHERE SmartDD__Object_Name__c = :selectedObjName WITH SECURITY_ENFORCED LIMIT 50000]; 
        for (SmartDD__Filter__c filter : filters) { 
            filterNames.add(filter.Id + '#' + filter.Name); 
        } 
        return filterNames; 
    } 
    
    @AuraEnabled
    public static void deleteFilterRecord(string filterid){ 
        if(filterid != null){
            SmartDD__Filter__c filters = [select Name,SmartDD__Object_Name__c from SmartDD__Filter__c where id=:filterid WITH SECURITY_ENFORCED];
            if (Schema.sObjectType.SmartDD__Filter__c.isDeletable()) {
                delete filters;
            }                              
        }                                 
    }
    /**********************************************************************************************
Purpose: get filter record from id to edit filter record. 
**********************************************************************************************/
    @AuraEnabled
    public static FilterWrapper editFilterRecord(string filterid){
        FilterWrapper objFilterWrapper = new FilterWrapper();
        if(!String.IsBlank(filterid)){
            List<SmartDD__Filter__c> lstFilters = new List<SmartDD__Filter__c>([Select id,Name,SmartDD__Object_Name__c,SmartDD__FilterLogic__c from SmartDD__Filter__c where Id=:filterid WITH SECURITY_ENFORCED]);
            List<SmartDD__Filter_Criteria__c> lstFilterCriteria = new List<SmartDD__Filter_Criteria__c>([Select id, Name, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c  from SmartDD__Filter_Criteria__c where SmartDD__Filter_Name__c=:filterid WITH SECURITY_ENFORCED]);
            
            if(lstFilters.size() > 0){            
                objFilterWrapper.objFilter = lstFilters[0];
            }
            if(lstFilterCriteria.size() > 0){
                objFilterWrapper.lstFilterCriterias = lstFilterCriteria;
            }
        }
        return objFilterWrapper;              
    }
    /**********************************************************************************************
Purpose: get list of objects that are synced. 
**********************************************************************************************/
    @AuraEnabled
    public static List<String> getSyncedObjList() {
        List<String> lstSyncedObjects = new List<String>(); 
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        if(dedupeconfig.SmartDD__Lead__c == true) {
            lstSyncedObjects.add('Lead');
        }
        if(dedupeconfig.SmartDD__Account__c == true) {
            lstSyncedObjects.add('Account');
        }
        if(dedupeconfig.SmartDD__Contact__c == true) {
            lstSyncedObjects.add('Contact');
        }
        return lstSyncedObjects;
    }
    /**********************************************************************************************
Purpose: fetch all fields from object
**********************************************************************************************/
    @AuraEnabled
    public static List<wrpObjectFieldsList> fetchObjectColumns(String filterObjName) {          // NOPMD     
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        List<String> lstColmnAPIName = new List<String>();
        Map<String, Schema.SObjectField> MapOfSObj = Schema.getGlobalDescribe().get(filterObjName).getDescribe().fields.getMap();    // NOPMD
        wrpObjectFieldsList objwrp = new wrpObjectFieldsList();
        
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c>([SELECT Id, SmartDD__Object_Name__c, SmartDD__Search_Column_Fields__c 
                                                                                                FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c =: filterObjName WITH SECURITY_ENFORCED]);
        
        if(lstObjectColumns.Size() > 0){
            lstColmnAPIName = lstObjectColumns[0].SmartDD__Search_Column_Fields__c.split(',');
            
            for(String objDedupeFilter : lstColmnAPIName){
                if(objDedupeFilter != null && objDedupeFilter != ''){
                    String fieldLabelName = '';
                    if(objDedupeFilter == 'Owner.Name'){
                        fieldLabelName = 'Owner Name';
                    } else if(objDedupeFilter == 'Account.Name'){
                        fieldLabelName = 'Account Name';
                    } else{
                        if(objDedupeFilter != null && MapOfSObj.containsKey(objDedupeFilter)) {
                            fieldLabelName = String.valueOf(MapOfSObj.get(objDedupeFilter).getDescribe().getLabel());
                        }
                    }
                    wrpFields objField = new wrpFields();
                    objField.fieldName = fieldLabelName;
                    objField.fieldApiName = objDedupeFilter;
                    objwrp.FieldsList.add(objField);
                }
            }
        }
        newWrpList.add(objwrp);
        return newWrpList;
    }
    /**********************************************************************************************
Purpose: Update Per Page Record Size Custom Setting.
**********************************************************************************************/
    @AuraEnabled
    public static Void UpdatePerPageRecordSize(Integer recordSizeParam){     // NOPMD
        SmartDD__Dedupe_Per_Page_Record_Size__c perPageRecordSize = SmartDD__Dedupe_Per_Page_Record_Size__c.getValues('Dedupe Display Records');
        perPageRecordSize.SmartDD__Per_Page_Record__c = recordSizeParam;
        if(Schema.sObjectType.SmartDD__Dedupe_Per_Page_Record_Size__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Per_Page_Record_Size__c.isUpdateable() ){
            upsert perPageRecordSize;
        }
       
    }
    /**********************************************************************************************
Purpose: Get Per Page Record Size Custom Setting.
**********************************************************************************************/
    @AuraEnabled
    public static SmartDD__Dedupe_Per_Page_Record_Size__c GetPerPageRecordSize() {  // NOPMD
        SmartDD__Dedupe_Per_Page_Record_Size__c perPageRecordSize = SmartDD__Dedupe_Per_Page_Record_Size__c.getValues('Dedupe Display Records');
        return perPageRecordSize;
    }
    /**********************************************************************************************
Purpose: fetch lead records 
**********************************************************************************************/
    @AuraEnabled 
    public static lightningTableWrapper fetchLead(String ObjectName,String fieldstoget, String sortField, String searchKey, boolean isAsc,decimal pageNumber, Integer pageSize, String filterId) { //NOPMD
        String queryConditions = '';
        String queryString = '';
        String queryStringTotal = '';
        String searchQuery = '';
        String searchQueryTotal = '';
        Boolean flagSearchFilter = false;
        Integer offset = 0;
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        
        if(!String.IsBlank(filterId)){
            queryConditions = getQueryConditionString(filterId);
        }
        if(searchKey != null && searchKey != ''){
            flagSearchFilter = true;
            searchKey = searchKey.trim();
        }
        if(pageSize != null){
            offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(pageSize);
        }
        else{
            SmartDD__Dedupe_Per_Page_Record_Size__c perPageRecordSize = SmartDD__Dedupe_Per_Page_Record_Size__c.getValues('Dedupe Display Records');
            pageSize = integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);
            offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);
        }
        queryString += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget)+
            ' from '+ String.escapeSingleQuotes(ObjectName) ;
        queryStringTotal += 'Select Count(Id) from '+ String.escapeSingleQuotes(ObjectName);
        
        if(!String.IsBlank(queryConditions) && (flagSearchFilter == false)){
            queryString += ' where '+ queryConditions+ ' WITH SECURITY_ENFORCED';
            queryStringTotal += ' where '+ queryConditions + ' WITH SECURITY_ENFORCED';                   
        }
        else if(flagSearchFilter == true){
            searchQuery += 'FIND \'' + string.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(ObjectName) + ' (' + String.escapeSingleQuotes(fieldstoget);
            searchQueryTotal = 'FIND \'' + string.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(ObjectName) + ' (Id';
            if(!String.IsBlank(queryConditions)){
                searchQuery += ' WHERE '+ queryConditions;
                searchQueryTotal += ' WHERE '+ queryConditions + ')';
            }
            else{
                searchQueryTotal += ')';
            }
        }
        if (sortField != '' && sortField != null) {
            queryString += ' order by ' + sortField;
            searchQuery += ' order by ' + sortField; 
            // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
            if (isAsc) {
                queryString += ' desc NULLS LAST';
                searchQuery += ' desc NULLS LAST';
            } else {
                queryString += ' asc';
                searchQuery += ' asc';
            }
        }
        queryString += ' Limit '+ pageSize + ' Offset '+offset;
        
        if(flagSearchFilter == true){
            searchQuery += ' Limit '+ pageSize + ' Offset '+offset +')';
        }
        if(flagSearchFilter == true){
            
            List<List<SObject>> results = search.query(searchQuery);
            objTableWrapper.sObjectrecords = ((List<sObject>)results[0]);
            List<List<SObject>> resultTotal = search.query(searchQueryTotal);
            objTableWrapper.sObjectTotalRecords = ((List<sObject>)resultTotal[0]);
            objTableWrapper.total = objTableWrapper.sObjectTotalRecords.size();
            objTableWrapper.page = 1;
        }
        else{                   
            objTableWrapper.page = Integer.valueOf(pageNumber);
            objTableWrapper.sObjectrecords = database.query(queryString);
            objTableWrapper.sObjectTotalRecords = database.query(queryStringTotal);
            objTableWrapper.total = Integer.valueOf(objTableWrapper.sObjectTotalRecords[0].get('expr0'));
        }
        return objTableWrapper;
    }   
    /**********************************************************************************************
Purpose: to get picklist value from picklist field in object.  
**********************************************************************************************/
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname){  // NOPMD
        List<String> optionlist = new List<String>();        
        Map<String,Schema.SObjectType> mapObjSchema = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> mapObjFields = mapObjSchema.get(objectName.toLowerCase()).getDescribe().fields.getMap();         
        List<Schema.PicklistEntry> picklistValues = mapObjFields.get(field_apiname).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry pickoptions : picklistValues) {
            optionlist.add(pickoptions.getValue());
        }
        return optionlist;
    }     
    /**********************************************************************************************
Purpose: To fetch Field Picklist Option by selected objectname  
**********************************************************************************************/
    @AuraEnabled
    public static List<string> FieldPicklistOptions (string strObjectname){     // NOPMD
        List<string> fieldoptions = new List<string>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objSchema = schemaMap.get(strObjectname);
        Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
        
        for (String fieldName: fieldMap.keySet()) {
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            if((fielddataType == Schema.DisplayType.String || fielddataType == Schema.DisplayType.Picklist || 
                fielddataType == Schema.DisplayType.Textarea || fielddataType == Schema.DisplayType.Phone || 
                fielddataType == Schema.DisplayType.Email || fielddataType == Schema.DisplayType.URL) &&
               (fielddataType != Schema.DisplayType.address || fielddataType != Schema.DisplayType.id || 
                fielddataType != Schema.DisplayType.reference || fielddataType != Schema.DisplayType.boolean ) && 
               ( fieldName!= 'Id' && fieldName!= 'MasterRecordId' && fieldName!='OwnerId' && fieldName!='AccountId' && fieldName!='CreatedDate' &&
                fieldName!='CreatedById' && fieldName!= 'LastViewedDate' && fieldName!= 'LastModifiedById' && fieldName!= 'SystemModstamp' 
                && fieldName!= 'LastActivityDate' && fieldName!= 'LastViewedDate' && fieldName!= 'LastReferencedDate' &&
                fieldName!= 'LastModifiedDate' && fieldName!= 'Jigsaw' && fieldName!= 'JigsawCompanyId' 
                && fieldName!= 'JigsawContactId' && fieldName!= 'Address' && fieldName!= 'GeocodeAccuracy' && fieldName!= 'SmartDD__CurrentGenerators__c'
                && fieldName!= 'DandbCompanyId' && fieldName!= 'SmartDD__DedupeId__c' && fieldName!= 'Description' && fieldName!= 'EmailBouncedReason'
                && fieldName!= 'PhotoUrl' && fieldName!= 'SmartDD__ProductInterest__c' && fieldName!= 'SmartDD__Primary__c' && fieldName!= 'SmartDD__SICCode__c')){
                    
                    String fieldapiName = fieldMap.get(fieldName).getDescribe().getname();
                    String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                    String picklistoption = fieldapiName+'#'+fieldLabel;
                    fieldoptions.add(picklistoption);
                    
                    
                }
            
        }
        fieldoptions.sort();
        return fieldoptions;
    }    
    /**********************************************************************************************
Purpose:  to validate Filter value according to selected field  
**********************************************************************************************/ 
    public static string getDescribe (string objectname,string selectedFieldname,string selectedfieldValue){        // NOPMD
        String type = objectname;
        String fieldtype;
        String error = '';
        String fieldLabel = '';
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        //It provides to get the object fields label.
        
        fieldLabel = fieldMap.get(selectedFieldname).getDescribe().getLabel();
        //It provides to get the object fields data type.
        Schema.DisplayType fielddataType = fieldMap.get(selectedFieldname).getDescribe().getType();
        if(!String.isBlank(selectedfieldValue)){
            if (fielddataType == Schema.DisplayType.boolean){
                if(selectedfieldValue != 'true' && selectedfieldValue != 'false'){
                    error = 'Please give value as true or false'+'<br/>';
                } 
            }
            else if (fielddataType == Schema.DisplayType.String){
                if(selectedfieldValue.isNumeric() == true){
                    error = 'Please enter valid Name.';
                }
            }
            else if (fielddataType == Schema.DisplayType.Phone){
                String phoneNumber = selectedfieldValue;
                Pattern phonePattern = Pattern.compile('\\D*?(\\d\\D*?){1,15}'); 
                Pattern numericPattern = Pattern.compile('[0-9]{1,15}');
                Matcher phoneMatcher = phonePattern.matcher(phoneNumber);
                Matcher numericMatcher = numericPattern.matcher(phoneNumber);
                
                try{
                    if(!numericMatcher.matches()){
                        
                        if(selectedFieldname == 'Phone' || selectedFieldname == 'MobilePhone'){     // NOPMD
                            error = 'Please Enter Valid phone Number in Value'+'<br/>';
                        }
                        if(selectedFieldname == 'Fax'){     // NOPMD
                            error = 'Please Enter Valid Fax Number in Value'+'<br/>';
                        }
                        if(phoneNumber.length() > 15){      // NOPMD
                            error = 'Number is too large'+'<br/>'; 
                        } 
                    }            
                } 
                catch(System.TypeException e) {
                    error = e.getMessage();
                }            
            }        
            else if (fielddataType == Schema.DisplayType.email){
                String email = selectedfieldValue;
                String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                
                Pattern MyPattern = Pattern.compile(emailRegex);        // NOPMD
                Matcher MyMatcher = MyPattern.matcher(email);           // NOPMD
                if (!MyMatcher.matches()){
                    error = 'Please Enter Valid Email in Value'+'<br/>';
                }
            }    
            else if(fielddataType == Schema.DisplayType.integer || fielddataType == Schema.DisplayType.double || fielddataType == Schema.DisplayType.currency || fielddataType == Schema.DisplayType.percent) {
                try {
                    if(fielddataType == Schema.DisplayType.percent && selectedfieldValue != ''){
                        String lastCharacter = selectedfieldValue.substring(selectedfieldValue.length() - 1 );
                        if(lastCharacter == '%') {              // NOPMD
                            selectedfieldValue = selectedfieldValue.substring(0, selectedfieldValue.length() - 1 );
                        }
                    }
                    Decimal result; 
                    if(selectedfieldValue != ''){
                        result = Decimal.valueOf(selectedfieldValue);
                    }
                }
                catch(System.TypeException e) {
                    error = 'Please enter valid number in value'+'<br/>';
                }
            }
            else if(fielddataType == Schema.DisplayType.date) {
                date result;
                try {
                    if(selectedfieldValue != ''){
                        result = Date.parse(selectedfieldValue);
                    }
                }
                catch(System.TypeException e) {
                    String[] dateData = selectedfieldValue.split('-');
                    
                    if( dateData.size() == 3 ) {
                        result = Date.newInstance(
                            Integer.valueOf( dateData[2] ),
                            Integer.valueOf( dateData[0] ),
                            Integer.valueOf( dateData[1] )
                        );
                    }
                    else {
                        error = 'Date format must be MM/dd/yyyy.in value'+'<br/>';
                    }
                }
            }
            else if(fielddataType == Schema.DisplayType.DateTime) {
                datetime resultdatetime;
                try {
                    if(selectedfieldValue != ''){
                        resultdatetime= DateTime.parse(selectedfieldValue);
                    }
                }
                catch(System.TypeException e) {
                    String[] dateData = selectedfieldValue.split('-');
                    
                    if( dateData.size() == 3 ) {
                        resultdatetime = DateTime.newInstance(
                            Integer.valueOf( dateData[2] ),
                            Integer.valueOf( dateData[0] ),
                            Integer.valueOf( dateData[1] )
                        );
                    }
                    else {
                        error = 'Datetime format must be MM/dd/yyyy hh:mm AM/PM. in value'+'<br/>';
                    }
                }
            }
        }
        return error ;
    }
    /**********************************************************************************************
Purpose:  Save filter and filtercriteria. 
**********************************************************************************************/ 
    @AuraEnabled
    public static  List<String> saveFilterCriterias(List<SmartDD__Filter_Criteria__c> filterCriteriaDetails,SmartDD__Filter__c filterDetails, String objectname){ //NOPMD
        String errormsg = '';
        List<string> lstreturnvalue = new List<string>();
        try{
            String filterdataid;
            Integer cnt=1;
            
            List<Id> lstFilterId = new List<Id>(); 
            List<SmartDD__Filter_Criteria__c> lstFilterCriterias = new List<SmartDD__Filter_Criteria__c> ();
            
            if(filterCriteriaDetails.size() > 0){
                for(SmartDD__Filter_Criteria__c objFilterCriteria : filterCriteriaDetails){
                    system.debug('objFilterCriteria'+objFilterCriteria);
                    if (String.isBlank(objFilterCriteria.SmartDD__Operator__c) || String.isBlank(objFilterCriteria.SmartDD__Field__c) || objFilterCriteria.SmartDD__Field__c == '--None--' || objFilterCriteria.SmartDD__Field__c == '' || objFilterCriteria.SmartDD__Field__c == null || objFilterCriteria.SmartDD__Operator__c == '' ){                       
                        errormsg += 'Please specify Filter Criteria '+ cnt + '<br/>';                             
                    }
                    if ((!String.isBlank(objFilterCriteria.SmartDD__Operator__c) || objFilterCriteria.SmartDD__Operator__c != '') && (!String.isBlank(objFilterCriteria.SmartDD__Field__c) || objFilterCriteria.SmartDD__Field__c != '')){ 
                        errormsg += getDescribe(objectname,objFilterCriteria.SmartDD__Field__c,objFilterCriteria.SmartDD__Value__c);                       
                        if(getDescribe(objectname,objFilterCriteria.SmartDD__Field__c,objFilterCriteria.SmartDD__Value__c) == ''){                        
                            lstFilterCriterias.add(objFilterCriteria); 
                        }                
                    } 
                    cnt++;     
                }
                system.debug('lstFilterCriterias'+lstFilterCriterias);
                system.debug('beforerrormsg'+errormsg);
            }            
            
            if(lstFilterCriterias.size() > 0 && errormsg == ''){
                system.debug('Aftererrormsg'+errormsg);
                Map<Integer,String> TempMap = fnBindFilterCriteria(lstFilterCriterias);     // NOPMD
                string strFilterLogic = filterDetails.SmartDD__FilterLogic__c;
                errormsg += validatelogic(strFilterLogic,TempMap);
                if(validatelogic(strFilterLogic,TempMap) == ''){  
                    if( (Schema.SObjectType.SmartDD__Filter_Criteria__c.isCreateable() ||  Schema.SObjectType.SmartDD__Filter_Criteria__c.isUpdateable()) || Schema.SObjectType.SmartDD__Filter__c.isCreateable() || Schema.SObjectType.SmartDD__Filter__c.isUpdateable() || Schema.SObjectType.SmartDD__Filter__c.fields.SmartDD__FilterLogic__c.isAccessible()  ){
                        upsert filterDetails; // NOPMD
                    }
                }
            }
            
            lstreturnvalue.add(errormsg); 
            
            if(lstFilterCriterias.size() > 0 && errormsg == ''){
                /* if(Schema.SObjectType.Filter__c.isCreateable()){
upsert filterDetails;
}*/                
                
                Set<String> setFCRecord = new Set<String>();
                for(SmartDD__Filter_Criteria__c objfc : lstFilterCriterias) {
                    lstFilterId.add(filterDetails.Id);
                    objfc.SmartDD__Filter_Name__c=filterDetails.Id;
                    setFCRecord.add(objfc.Id);
                }
                Set<String> setFCRecordExist = new Set<String>();
                for(SmartDD__Filter_Criteria__c filtercriteria : [select id from SmartDD__Filter_Criteria__c where SmartDD__Filter_Name__c =: lstFilterId WITH SECURITY_ENFORCED]){ 
                    setFCRecordExist.add(filtercriteria.Id);
                }                  
                for(String str: setFCRecordExist) {
                    if(setFCRecord.contains(str)) {
                        setFCRecordExist.remove(str);
                    }           
                }
                if(setFCRecordExist.size() > 0) {
                    if(Schema.SObjectType.SmartDD__Filter_Criteria__c.isDeletable()){
                        Delete [Select Id from SmartDD__Filter_Criteria__c where Id in :setFCRecordExist WITH SECURITY_ENFORCED];
                    }                    
                }     
                if( (lstFilterCriterias.size() != 0 && String.isblank(errormsg)) || Schema.SObjectType.SmartDD__Filter_Criteria__c.isCreateable() || Schema.SObjectType.SmartDD__Filter_Criteria__c.isUpdateable()){
                    if(Schema.SObjectType.SmartDD__Filter_Criteria__c.isCreateable() || Schema.SObjectType.SmartDD__Filter_Criteria__c.isUpdateable()){
                        upsert lstFilterCriterias; // NOPMD
                    }                     
                }
            }            
            
            if(filterDetails.id != null){      
                filterdataid = filterDetails.id; 
                if(!string.isBlank(filterdataid)){
                    lstreturnvalue.add(filterdataid);
                }
            } 
            system.debug('lstreturnvalue'+lstreturnvalue);           
            return lstreturnvalue;
        }
        catch(Exception ex){errormsg = 'Exception Error'+ ex.getMessage();lstreturnvalue.add(errormsg);return lstreturnvalue;
                           }        
    }  
    /**********************************************************************************************
Purpose:  validations for filter logic
**********************************************************************************************/
    public static string validatelogic(string strFilterLogic,Map<Integer,string> mapFilterCriteria){    // NOPMD
        String errormsg = '';
        set<Integer> setIntTokens = new set<Integer>();
        integer TokenCount = 0;         // NOPMD
        for(String strlogic : tokenizeFilterLogic(strFilterLogic)){
            Integer indexToken = null;
            try{
                indexToken = Integer.valueOf(strlogic);
                setIntTokens.Add(indexToken);
            }catch(Exception e){
                String upperCaseToken = strlogic.toUpperCase();
                
                if(upperCaseToken != 'AND' && upperCaseToken != 'OR' && upperCaseToken != 'NOT' && upperCaseToken != ')' && upperCaseToken != '('){
                    
                    errormsg += 'Invalid strlogic: \'' + strlogic + '\'. Only AND, OR, parentheses and numbers can be used.';
                    return errormsg ;
                }
            }
            
            if(indexToken != null) {
                TokenCount++;
                if(!mapFilterCriteria.containskey(indexToken)){
                    errormsg += 'The filter logic references an undefined filter: '+indexToken+'.';
                    return errormsg;
                }
            }
        }
        if(!String.IsBlank(strFilterLogic) && TokenCount != mapFilterCriteria.size()){
            errormsg += 'Some filter conditions are defined but not referenced in your filter logic.';return errormsg;
        }        
        if(mapFilterCriteria.size() > 1 && setIntTokens.size() > 1){
            for(Integer intToken: mapFilterCriteria.keyset()){
                if(!setIntTokens.contains(intToken)){
                    errormsg += 'Some filter conditions are defined but not referenced in your filter logic.';return errormsg;
                }
            }
        }        
        if(strFilterLogic!= null){           
            String fLogic = String.escapeSingleQuotes(strFilterLogic);
            String opFilterCriteria = fnGetCriteriaString(fLogic,mapFilterCriteria);
            String squery = 'Select id from '+ String.escapeSingleQuotes('Lead') + ' Where ('+opFilterCriteria+') WITH SECURITY_ENFORCED Limit 1';
            try{
                List<sobject> lstobject = Database.query(squery);       //NOPMD
            }
            catch(Exception ex){
                errormsg = 'Please correct the filter logic.';
                return errormsg;

            }
        }
        return errormsg;
    }
    /**********************************************************************************************
Purpose: To get single token from Filter Logic
**********************************************************************************************/
    private static String[] tokenizeFilterLogic(String filterLogic){        //NOPMD
        if(String.IsBlank(filterLogic)){
            return new String[] {};
                }
        else{
            List<String> result = new List<String>();
            String buffer = '';
            for(Integer i=0; i<filterLogic.length(); i++){
                String subStr = filterLogic.substring(i,i+1);
                
                if(subStr == '('){
                    if(!String.IsBlank(buffer.trim())){
                        result.add(buffer.trim());
                        buffer = '';
                    }
                    result.add('(');
                }else if(subStr == ')'){
                    if(!String.IsBlank(buffer.trim())){
                        result.add(buffer.trim());
                        buffer = '';
                    }
                    result.add(')');
                }else if(subStr == ' '){
                    if( String.IsBlank(buffer.trim())){
                        buffer += subStr;
                    }else{
                        result.add(buffer.trim());
                        buffer = '';
                    }
                }else{
                    buffer += subStr;
                }
            }
            
            if(!String.IsBlank( buffer.trim())){
                result.add(buffer.trim());
            }
            return result;
        }
    }    
    /**********************************************************************************************
Purpose:  wrapper class for filter criteria 
**********************************************************************************************/
    public class FilterWrapper {        
        @AuraEnabled public SmartDD__Filter__c objFilter {get;set;}        
        @AuraEnabled public List<SmartDD__Filter_Criteria__c> lstFilterCriterias {get;set;}
        
        public FilterWrapper() {
            objFilter = new SmartDD__Filter__c();
            lstFilterCriterias = new List<SmartDD__Filter_Criteria__c>();
        }
    }    
    /**********************************************************************************************
Purpose:  fetch filter criterias and filter logic 
**********************************************************************************************/
    public static String getQueryConditionString(String filterId) {
        String strQueryConditions = '';
        if(Schema.sObjectType.SmartDD__Filter__c.isAccessible() ){
       
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filterId WITH SECURITY_ENFORCED];
        
        Map<Integer,String> tempMap = fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        // String strQueryConditions = '';
        String strlogic = objFilter.SmartDD__FilterLogic__c;
        strQueryConditions += fnGetCriteriaString(strlogic,tempMap);
        return strQueryConditions;
        }
        return strQueryConditions;
    }    
    /**********************************************************************************************
Purpose:  create query string using filterlogic 
**********************************************************************************************/
    public static String fnGetCriteriaString(String filterLogic, Map<Integer, String> filterMap){
        String result = '';
        if(filterLogic == null  || filterLogic == ''){
            for(String strfilter : filterMap.values()) {
                result += strfilter + ' AND ';
            }
            result = result.removeEnd(' AND ');
        }
        else{
            for(String token : tokenizeFilterLogic(filterLogic)){
                if(token == '(' || token == ')' || token.toUpperCase() == 'AND' || token.toUpperCase() == 'OR' || token.toUpperCase() == 'NOT'){
                    result += ' ' + token;
                }else{
                    result += ' ' + filterMap.get(Integer.valueOf(token));
                }
            }
        }
        return result;
    }    
    /**********************************************************************************************
Purpose: To bind filter criteria value.
**********************************************************************************************/
    public static Map<Integer,String> fnBindFilterCriteria(List<SmartDD__Filter_Criteria__c> lstFilterCriteria){    // NOPMD
        Map<Integer,String> mapAllFilterCriteria = new Map<Integer,String>();
        Integer Count = 0;           // NOPMD
        for(SmartDD__Filter_Criteria__c objFilterCriterias: lstFilterCriteria){
            Count++;           
            String filter = '';            
            String strSearchOn = 'Lead';
            Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
            Schema.DescribeSObjectResult objResult = objtype.getDescribe();
            
            if(!String.Isblank(objFilterCriterias.SmartDD__Field__c)){
                String oldOperator = objFilterCriterias.SmartDD__Operator__c;
                String oldField = objFilterCriterias.SmartDD__Field__c;
                string strDynamicField1 = string.valueof(objFilterCriterias.SmartDD__Field__c);
                strDynamicField1 = CreateFieldName(string.valueof(objFilterCriterias.SmartDD__Field__c),strSearchOn);
                objFilterCriterias.SmartDD__Operator__c = fillOperator(objFilterCriterias.SmartDD__Operator__c);
                String strFiled1Val = strDynamicField1;
                String strOperator1Val = objFilterCriterias.SmartDD__Operator__c;
                objFilterCriterias.SmartDD__Operator__c =  oldOperator;
                objFilterCriterias.SmartDD__Field__c =  oldField;
                String strValue1 = objFilterCriterias.SmartDD__Value__c;
                
                if(!string.IsBlank(strOperator1Val)){
                    if(!strFiled1Val.contains('.name') && (!strFiled1Val.contains('__r.name'))){
                        if(objResult.fields.getMap().get(strFiled1Val) != null ){   // NOPMD
                            Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get(strFiled1Val).getDescribe();
                            filter = fnGetStringCriteria(strFiled1Val,strOperator1Val,strValue1,fldtype1,null);
                        }
                    }else{filter = fnGetStringCriteria(strFiled1Val,strOperator1Val,strValue1,null,'String');
                         }
                }    
                if(!String.IsBlank(filter)){
                    mapAllFilterCriteria.put(Count,filter);
                }
            }
        }
        return mapAllFilterCriteria;
    }
    
    /**********************************************************************************************
Purpose: To get Field name based on Field label
**********************************************************************************************/
    public static String CreateFieldName(String strFieldLabel,String strSearchOn){      // NOPMD
        String strFieldName = '';
        strSearchOn = 'Lead';
        
        if(Schema.getGlobalDescribe().get(strSearchOn) != null){
            Schema.SObjectType objSchema = Schema.getGlobalDescribe().get(strSearchOn);
            Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
            List<String> lstfieldNames = new List<String>();
            lstfieldNames.addall(fieldMap.keySet());
            
            for(String fieldName: lstfieldNames){
                String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                if(fieldLabel == strFieldLabel){
                    strFieldName = fieldName;
                    break;
                }
            }
        }        
        if(String.Isblank(strFieldName)){
            strFieldName = checkfieldLabel(strFieldLabel);
        }
        return strFieldName;
    }    
    /**********************************************************************************************
Purpose: To get Operator for filter
**********************************************************************************************/
    public static String fillOperator(String strOperator){
        if(strOperator == 'equals') strOperator  = '=';             // NOPMD
        else if(strOperator == 'not equal to') strOperator = '!=';  // NOPMD
        else if(strOperator == 'less than') strOperator = '<';      // NOPMD
        else if(strOperator == 'greater than') strOperator = '>';   // NOPMD
        else if(strOperator == 'less or equal') strOperator = '<='; // NOPMD
        else if(strOperator == 'greater or equal') strOperator = '>=';  // NOPMD
        else if(strOperator == 'contains') strOperator = 'Like';        // NOPMD
        else if(strOperator == 'does not contain') strOperator = 'NotLike'; // NOPMD
        else if(strOperator == 'starts with') strOperator = 'startswith';   // NOPMD
        return strOperator;
    }
    /**********************************************************************************************
Purpose: To get Criteria string base on field,operater and value.
**********************************************************************************************/
    public static String fnGetStringCriteria(String strFiledVal,String strOperatorVal,String strValue,Schema.DescribeFieldResult ftype, String strftype){        // NOPMD
        String filterCriteria='';
        if(ftype != null && (ftype.getType() == Schema.DisplayType.Date || ftype.getType() == Schema.DisplayType.DateTime)){strValue = setStringToDateFormat(strValue);
                                                                                                                           }
        if(strValue == null && strOperatorVal != '!=' && strOperatorVal != 'NotLike'){strOperatorVal = '=';
                                                                                     }
        if(strValue == null && strOperatorVal == 'NotLike'){strOperatorVal = '!=';
                                                           }        
        if(strOperatorVal == 'Like'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE) || strftype == 'String'){
                    
                    if(ftype == null || (ftype != null && ftype.getType() != Schema.DisplayType.MULTIPICKLIST)){
                        string ValueLike = '%'+ fnCheckBlankValue(strValue)+'%';         // NOPMD
                        filterCriteria += String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueLike) + '\'';
                    }else{string ValueLike = fnCheckBlankValue(strValue);filterCriteria += String.escapeSingleQuotes(strFiledVal) +' includes (\''+ String.escapeSingleQuotes(ValueLike) + '\')';  // NOPMD
                         }
                }
        }else if(strOperatorVal == 'NotLike'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE ) || strftype == 'String'){
                    
                    if(ftype == null || (ftype != null && ftype.getType() != Schema.DisplayType.MULTIPICKLIST)){
                        string ValueNotLike =  '%'+fnCheckBlankValue(strValue)+'%'; // NOPMD
                        filterCriteria += '(Not '+ String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueNotLike) +'\')';
                    }else{
                        string ValueNotLike =  fnCheckBlankValue(strValue);filterCriteria += String.escapeSingleQuotes(strFiledVal) +' EXCLUDES (\''+ String.escapeSingleQuotes(ValueNotLike ) + '\')';  // NOPMD
                    }
                }
        }else if(strOperatorVal == 'startswith'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE 
                && ftype.getType() != Schema.DisplayType.MULTIPICKLIST) || strftype == 'String'){
                    
                    string ValueSW =  fnCheckBlankValue(strValue)+'%';   // NOPMD
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueSW) + '\'';
                }
        }else if(strOperatorVal == '='){
            if(String.isBlank(strValue)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' null';
            }else{
                string Value =  strValue.trim();     // NOPMD
                if(ftype != null && (ftype.getType() == Schema.DisplayType.BOOLEAN || ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER 
                                     || ftype.getType() == Schema.DisplayType.DOUBLE)){
                                         
                                         filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                                         if(!String.isBlank(Value)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                                   }else{filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                                                        }
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                         if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                                   }else{
                                                                       filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                                                   }
                                     }else{
                                         filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                                     }
            }
        }else if(strOperatorVal == '!='){
            if(String.isBlank(strValue)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' null';
                                        }else{
                                            string Value =  strValue.trim();     // NOPMD
                                            if(ftype != null && (ftype.getType() == Schema.DisplayType.BOOLEAN || ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER 
                                                                 || ftype.getType() == Schema.DisplayType.DOUBLE)){
                                                                     
                                                                     filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                                                                     if(!String.isBlank(Value)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                                                               }else{filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                                                                                    }
                                                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                                                     if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                                                               }else{filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                                                                                    }
                                                                 }else{
                                                                     filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                                                                 }
                                        }
        }else if(strOperatorVal == '<'){
            string Value = fnCheckBlankValue(strValue);  // NOPMD
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY
                                 || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                                     filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                                     if(!String.isBlank(Value)){filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                               }
                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                     if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                                               }
                                 }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                                     filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                                 }
        }
        else if(strOperatorVal == '>'){
            string Value = fnCheckBlankValue(strValue);  // NOPMD
            
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                if(!String.isBlank(Value)){
                    filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){
                    filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }
        else if(strOperatorVal == '<='){
            string Value = fnCheckBlankValue(strValue);  // NOPMD
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                if(!String.isBlank(Value)){
                    filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){
                    filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }
        else if(strOperatorVal == '>='){
            string Value = fnCheckBlankValue(strValue);  // NOPMD
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                if(!String.isBlank(Value)){
                    filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){
                    filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }else{
            string Value =  strValue.trim();     // NOPMD
            filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
        }
        return filterCriteria;
    }    
    /********************************************************************
Purpose : get the label of particular field.
********************************************************************/
    public static String checkfieldLabel(String strFiledLabel){
        String fieldLabel = '';
        if(!String.Isblank(strFiledLabel)){
            Schema.SObjectType objtype = Schema.getGlobalDescribe().get('Lead');
            Schema.DescribeSObjectResult objResult = objtype.getDescribe();
            string strfvalue = strFiledLabel.replace(' Name','Id');
            
            if(!String.Isblank(strfvalue) && objResult.fields.getMap().get(strfvalue) != null && objResult.fields.getMap().get(strfvalue).getDescribe() != null){
                fieldLabel = strfvalue.replace('Id','.name');
            }
            else{
                if(strfvalue.contains(' ')){
                    strfvalue = strfvalue.replace(' ','_');
                }
                fieldLabel = strfvalue.replace('Id','__r.name');
            }
        }
        return fieldLabel;
    }    
    /**********************************************************************************************
Purpose: To get date format for SOQL.
**********************************************************************************************/
    public static String setStringToDateFormat(String myDate){
        if(!String.isBlank(myDate) && myDate.contains('/')){
            String[] strDate = myDate.split('/');
            return strDate[2]+'-'+strDate[0]+'-'+strDate[1];
        }else{
            return null;
        }
    }    
    /**********************************************************************************************
Purpose:  Check the value is blank or not.
**********************************************************************************************/     
    public static string fnCheckBlankValue(string strValue){
        if(!string.isblank(strValue)){
            strValue = strValue.trim();
        }
        return strValue;
    }        
    /**********************************************************************************************
Purpose:  To remove deselected field(s) and add new selected field(S).
**********************************************************************************************/
    public static String checksum(List<wrpFields> leadSelectedField, List<wrpFields> AccountSelectedField, List<wrpFields> ContactSelectedField) {  // NOPMD
        List<SmartDD__Dedupe_Filter_Data__c> ExsistDedupeFilter = new List<SmartDD__Dedupe_Filter_Data__c>([SELECT Id, Name, SmartDD__Object_Name__c, SmartDD__Field_API_Name__c,SmartDD__Field_Label__c, SmartDD__Field_Name__c   // NOPMD
                                                                                                            FROM SmartDD__Dedupe_Filter_Data__c WITH SECURITY_ENFORCED limit 49999]);     // NOPMD    
        //Existing Set
        Set<String> setAccountFilter = new Set<String>();
        Set<String> setContactFilter = new Set<String>();
        Set<String> setLeadFilter = new Set<String>();
        if(ExsistDedupeFilter.size() > 0){
            for(SmartDD__Dedupe_Filter_Data__c objFilterData : ExsistDedupeFilter){
                if(objFilterData.SmartDD__Object_Name__c == 'Account') {
                    setAccountFilter.add(objFilterData.SmartDD__Field_API_Name__c);
                    
                }
                if(objFilterData.SmartDD__Object_Name__c == 'Contact') {
                    setContactFilter.add(objFilterData.SmartDD__Field_API_Name__c);
                    
                }
                if(objFilterData.SmartDD__Object_Name__c == 'Lead') {
                    setLeadFilter.add(objFilterData.SmartDD__Field_API_Name__c);
                }
            }
        }       
        
        //New Selected Set of checkbox
        Set<String> setAccountSelectedFilter = new Set<String>();
        Set<String> setContactSelectedFilter = new Set<String>();
        Set<String> setLeadSelectedFilter = new Set<String>();
        
        //Inserted Selected CheckBox And Deleted Unselected CheckBox
        for(wrpFields objwrpObjectField: leadSelectedField) {
            if(!setLeadFilter.contains(objwrpObjectField.fieldApiName)) {
                lstCheckedLead.add(objwrpObjectField);
            }
            setLeadSelectedFilter.add(objwrpObjectField.fieldApiName);
        }
        for(String str: setLeadFilter) {
            if(!setLeadSelectedFilter.contains(str)){
                lstUnCheckedLead.add(str);
            }
        }
        for(wrpFields objwrpObjectField: AccountSelectedField) {
            if(!setAccountFilter.contains(objwrpObjectField.fieldApiName)) {
                lstCheckedAccount.add(objwrpObjectField);
            }
            setAccountSelectedFilter.add(objwrpObjectField.fieldApiName);
        }
        for(String str:setAccountFilter) {
            if(!setAccountSelectedFilter.contains(str)){
                lstUnCheckedAccount.add(str);
            }
        }
        for(wrpFields objwrpObjectField: ContactSelectedField) {
            if(!setContactFilter.contains(objwrpObjectField.fieldApiName)) {
                lstCheckedContact.add(objwrpObjectField);
            }
            setContactSelectedFilter.add(objwrpObjectField.fieldApiName);
        }
        for(String str: setContactFilter) {
            if(!setContactSelectedFilter.contains(str)){
                lstUnCheckedContact.add(str);
            }
        }
        return 'Test Success';
    }    
    /**********************************************************************************************
Purpose:  Save list of selected fields.
**********************************************************************************************/
    @AuraEnabled
    public static String saveDedupeFilterData(String leadSelectedField,String AccountSelectedField,String ContactSelectedField, String externalFilterId, String filterObjectName) {         // NOPMD
        checksum((List<wrpFields>)JSON.deserialize(leadSelectedField,List<wrpFields>.class) ,(List<wrpFields> ) JSON.deserialize(AccountSelectedField,List<wrpFields>.class),(List<wrpFields> ) JSON.deserialize(ContactSelectedField,List<wrpFields>.class));
        List<SmartDD__Dedupe_Filter_Data__c> lstDedupeFilter = new List<SmartDD__Dedupe_Filter_Data__c>();
        for(wrpFields leadString : lstCheckedLead) {
            SmartDD__Dedupe_Filter_Data__c objDedupeFilter = new SmartDD__Dedupe_Filter_Data__c();
            objDedupeFilter.SmartDD__Object_Name__c = 'Lead';
            objDedupeFilter.SmartDD__Field_Name__c = leadString.fieldApiName;
            objDedupeFilter.SmartDD__Field_API_Name__c = leadString.fieldApiName;
            objDedupeFilter.SmartDD__Field_Label__c = leadString.fieldName;
            lstDedupeFilter.add(objDedupeFilter);
        }
        for(wrpFields accountString : lstCheckedAccount) {
            SmartDD__Dedupe_Filter_Data__c objDedupeFilter = new SmartDD__Dedupe_Filter_Data__c();
            objDedupeFilter.SmartDD__Object_Name__c = 'Account';
            objDedupeFilter.SmartDD__Field_Name__c = accountString.fieldApiName;
            objDedupeFilter.SmartDD__Field_API_Name__c = accountString.fieldApiName;
            objDedupeFilter.SmartDD__Field_Label__c = accountString.fieldName;
            lstDedupeFilter.add(objDedupeFilter);
        }
        for(wrpFields contactString : lstCheckedContact) {
            SmartDD__Dedupe_Filter_Data__c objDedupeFilter = new SmartDD__Dedupe_Filter_Data__c();
            objDedupeFilter.SmartDD__Object_Name__c = 'Contact';
            objDedupeFilter.SmartDD__Field_Name__c = contactString.fieldApiName;
            objDedupeFilter.SmartDD__Field_API_Name__c = contactString.fieldApiName;
            objDedupeFilter.SmartDD__Field_Label__c = contactString.fieldName;
            lstDedupeFilter.add(objDedupeFilter);
        }       
        if(lstDedupeFilter.size()>0){
             SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstDedupeFilter); 
            if(Schema.sObjectType.SmartDD__Dedupe_Filter_Data__c.isCreateable()) {
                insert decision.getRecords();
            }
        }
        List<SmartDD__Dedupe_Filter_Data__c> lstDeleteDedupeFilter = new List<SmartDD__Dedupe_Filter_Data__c>([SELECT Id, Name, SmartDD__Object_Name__c, SmartDD__Field_API_Name__c, SmartDD__Field_Name__c ,SmartDD__Field_Label__c
                                                                                                               FROM SmartDD__Dedupe_Filter_Data__c 
                                                                                                               WHERE SmartDD__Field_API_Name__c In : lstUnCheckedAccount Or SmartDD__Field_API_Name__c In : lstUnCheckedLead Or SmartDD__Field_API_Name__c In : lstUnCheckedContact WITH SECURITY_ENFORCED]);
        
        
        if(lstDeleteDedupeFilter.size()>0){
            if(Schema.sObjectType.SmartDD__Dedupe_Filter_Data__c.isDeletable()) {
                delete lstDeleteDedupeFilter;
            }
        }        
        return 'Test Success';
    }    
    /**************************************************************
This method is used to fetch externalfilterId and object name 
**************************************************************/
    @AuraEnabled
    public static List<SmartDD__Filter__c > getObjectName(String selectedFilterId) {
        List<SmartDD__Filter__c > lstFilterCriteria = new List<SmartDD__Filter__c >([SELECT SmartDD__Object_Name__c 
                                                                                     FROM SmartDD__Filter__c 
                                                                                     WHERE Id =: selectedFilterId WITH SECURITY_ENFORCED]);
        return lstFilterCriteria ;
    } 
    /**********************************************************************************************
Purpose: Update Filter data Custom Setting.
**********************************************************************************************/
    @AuraEnabled
    public static Void UpdateFilterdataId(String selectedFilterId, String objectName, Integer totalTrainingRecCount){    // NOPMD
        System.debug('totalTrainingRecCount.........................................................'+totalTrainingRecCount);
        System.debug('selectedFilterId ' + selectedFilterId);
        System.debug('objectName ' + objectName);
        SmartDD__Filter_Data__c filterdata = SmartDD__Filter_Data__c.getValues(objectName);
        if(filterdata != null) {
            filterdata.name = objectName;
            filterdata.SmartDD__Object_Name__c = objectName;
            filterdata.SmartDD__Filter_Id__c= selectedFilterId;
            if (Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Filter_Data__c.isUpdateable()){
            upsert filterdata;
            }
        } else {
            SmartDD__Filter_Data__c filterdataNew = new SmartDD__Filter_Data__c();
            filterdataNew.name = objectName;
            filterdataNew.SmartDD__Object_Name__c = objectName;
            filterdataNew.SmartDD__Filter_Id__c= selectedFilterId;
            if (Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Filter_Data__c.isUpdateable()){
            upsert filterdataNew;
            }
        }
        /** Check total training record is greater then 20 */
        if(totalTrainingRecCount > 20){            
            //Call StartDedupe API here.
            String JSONFieldFilterStr = '';  // NOPMD
            List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                                    SmartDD__Last_Name__c,SmartDD__Response__c,SmartDD__Request__c, SmartDD__First_Name__c
                                                                                                                    FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1]);
            System.debug('###lstAuthorizationUser' + lstAuthorizedUser);     // NOPMD
            SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            Id configId;
            if(lstAuthorizedUser.size() > 0) {
                configId = lstAuthorizedUser[0].Id;
                JSONFieldFilterStr += '{';
                JSONFieldFilterStr += '"Object Name":"' + objectName + '",';
                JSONFieldFilterStr += '"Organization Id":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
                JSONFieldFilterStr += '"Field Name":"' + +'",';
                JSONFieldFilterStr += '"Filter Records":"' + dedupeConfig.SmartDD__Total_Records_Deduped__c + '"';
                JSONFieldFilterStr += '}';
            }
            system.debug('@@JSONFieldFilterStr..' + JSONFieldFilterStr);
            httpCreateClusterJSONRequest(System.Label.SFImportAPI+'/lead/startDedupes', JSONFieldFilterStr, configId);            
        }        
    }
    @future(callout=true)
    public static void httpCreateClusterJSONRequest(String strAWSEndpointLead, string strBody, Id configId) {  
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        SmartDD__Dedupe_Configuration__c objdedupeConfig = new SmartDD__Dedupe_Configuration__c();
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes:....... '+statusRes);           
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@Json Create jsonString:....................................... '+jsonString);    
            
            if(configId != null){
                List<SmartDD__Dedupe_Configuration__c> lstObjDedupeConfing = new List<SmartDD__Dedupe_Configuration__c>();
                
                SmartDD__Dedupe_Configuration__c objDedupeConfing = new SmartDD__Dedupe_Configuration__c();   
                objDedupeConfing.Id = configId;
                objDedupeConfing.SmartDD__Request__c = 'EndPoint: ' + strAWSEndpointLead + ' ' + 'RequestBody: ' + strBody;
                objDedupeConfing.SmartDD__Response__c = jsonString; 
                
                lstObjDedupeConfing.add(objDedupeConfing);
                SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstObjDedupeConfing); 
                
                if(Schema.sObjectType.SmartDD__Dedupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Configuration__c.isUpdateable())    {
                    update decision.getRecords();            
                    system.debug('@@ objDedupeConfing' + objDedupeConfing);    
                }
                
            }
            
            
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
        
    }
    
    public static String getResponse(String response) {
        return response;
    } 
    
    
    
    @AuraEnabled
    public static Integer getTrainingFileRecCount(String selectedObjectname) {
        List<SmartDD__Search_Column__c> lstDedupeCols = new List<SmartDD__Search_Column__c>([SELECT Id, SmartDD__Object_Name__c, SmartDD__Search_Object_Fields__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c =: selectedObjectname WITH SECURITY_ENFORCED]);
        String strDedupeFields = '';
        if(lstDedupeCols.Size() > 0) {
            strDedupeFields = lstDedupeCols[0].SmartDD__Search_Object_Fields__c;
        }
        
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c>([SELECT Id, 
                                                                                                               SmartDD__UserId__c, SmartDD__Organization_Id__c, 
                                                                                                               SmartDD__Username__c, SmartDD__Email__c,
                                                                                                               SmartDD__Last_Name__c, SmartDD__First_Name__c
                                                                                                               FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1]);
        System.debug('lstAuthorizedUser:'+lstAuthorizedUser);        // NOPMD
        String JSONFieldFilterStr = '';  // NOPMD
        if(lstAuthorizedUser.size() > 0) {
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"Object Name":"' + selectedObjectname + '",';
            JSONFieldFilterStr += '"Organization Id":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"Field Name":"' + strDedupeFields + '"';
            JSONFieldFilterStr += '}';
        }
        system.debug('JSONFieldFilterStr ****'+JSONFieldFilterStr);
        
        string totalTrainingRecCount = httpTrainingRecCountJSON(System.Label.SFImportAPI+'/manageTraining/getTotalTrainingRecord', JSONFieldFilterStr);
        system.debug('totalTrainingRecCount ****'+totalTrainingRecCount);
        return Integer.ValueOf(totalTrainingRecCount);    
    }
    /******************************************************
Http Request Body
******************************************************/
    public static string httpTrainingRecCountJSON(String strAWSEndpointLead, string strBody) {       
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes: '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: '+jsonString);
            return objSyncDataStatus.totalTrainingRecords;
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
            return e.getMessage();
        }
    }
    
    /******************************************************
POST DedupeFilterData JSON DATA 
******************************************************/
    @AuraEnabled
    global static String postDedupeFilterRecords(String selectedFilterId, String filterId, String selectedObjectname) {    // NOPMD
        system.debug('@@ selectedObjectname ' + selectedObjectname);           
        system.debug('In Method');
        String queryConditions = '';
        String isSuccess  = '' ;
        string BatchProcessId = '';  // NOPMD
        string ExceedLimit = '';     // NOPMD
        string userid = '';
        string organizationid = '';
        if(!String.IsBlank(filterId)){
            queryConditions = getQueryConditionString(filterId);
        }        
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                                SmartDD__Last_Name__c, SmartDD__First_Name__c
                                                                                                                FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1]);
        if(lstAuthorizedUser.size() > 0){
            userid = lstAuthorizedUser[0].SmartDD__UserId__c;
            organizationid = lstAuthorizedUser[0].SmartDD__Organization_Id__c; 
        }
        String objectName = selectedObjectname;                
        string ObjectLabel = selectedObjectname.removeEnd('__c');    // NOPMD
        string fieldName = 'SmartDD__'+ObjectLabel+'ParentId__c';
        //Check whether the field exists or not
        boolean blnfieldExist = doesFieldExist('SmartDD__TempDedupeNote__c', fieldName);
        //To create a custom field dynamically in TempDedupeNote__c object 
        system.debug('@#$blnfieldExist: '+blnfieldExist);
        if(blnfieldExist != true) {
            system.debug('@#$ObjectLabel: '+ObjectLabel);
            MetadataService.MetadataPort service = createService();
            MetadataService.CustomField customField = new MetadataService.CustomField();
            customField.fullName = 'SmartDD__TempDedupeNote__c.' + fieldName;
            customField.label = ObjectLabel;
            customField.type_x = 'Lookup';
            customField.relationshipLabel = 'TempDedupeNotes';
            customField.relationshipName = 'TempDedupeNotes';
            customField.referenceTo = selectedObjectname;
            List<MetadataService.SaveResult> results =
                service.createMetadata(
                    new MetadataService.Metadata[] { customField });
            handleSaveResults(results[0]);
        }
        //To create a custom field 'IsMerged__c' dynamically in dedupe objects 
        string ObjectLabelMerge = selectedObjectname.removeEnd('__c');       // NOPMD
        string fieldNameMerge = 'SmartDD__IsMerged';
        String chkFieldName = fieldNameMerge +'__c';
        //Check whether the field exists or not
        boolean blnfieldExistMerge = doesFieldExist(selectedObjectname, chkFieldName);
        system.debug('@#$blnfieldExistMerge: '+blnfieldExistMerge);
        if(blnfieldExistMerge != true) {
            system.debug('@#$ObjectLabelMerge: '+ObjectLabelMerge);
            MetadataService.MetadataPort service = createService();
            MetadataService.CustomField customField = new MetadataService.CustomField();
            customField.fullName = selectedObjectname + '.' + fieldNameMerge + '__c';
            customField.label = fieldNameMerge;
            customField.defaultvalue = 'false';
            customField.type_x = 'Checkbox';
            List<MetadataService.SaveResult> results =
                service.createMetadata(
                    new MetadataService.Metadata[] { customField });
            handleSaveResults(results[0]);
        }
        
        String queryStringTotal = '';        
        queryStringTotal += 'Select Id from '+ String.escapeSingleQuotes(ObjectName);        
        if(!String.IsBlank(queryConditions)){
            queryStringTotal += ' where '+ queryConditions + ' WITH SECURITY_ENFORCED';                   
        } 
        
        String queryStringTotalwrp = '';        
        queryStringTotalwrp += 'Select Id from '+ String.escapeSingleQuotes(ObjectName);        
        if(!String.IsBlank(queryConditions)){
            queryStringTotalwrp += ' where '+ queryConditions;                   
        } 
        queryStringTotalwrp += ' WITH SECURITY_ENFORCED LIMIT 200';
        
        system.debug('queryStringTotalwrp ****'+queryStringTotalwrp );  
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        objTableWrapper.sObjectTotalRecords = database.query(queryStringTotalwrp);
        objTableWrapper.total = objTableWrapper.sObjectTotalRecords.size(); 
        
        system.debug('objTableWrapper.total****'+ objTableWrapper.total);
        
        // Code to add logs in Dedupe Log Object.
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Dedupe Request';
        List<SmartDD__Filter__c> lstFilter = new List<SmartDD__Filter__c>([SELECT Id, Name, SmartDD__Object_Name__c, SmartDD__FilterLogic__c FROM SmartDD__Filter__c WHERE Id =: filterId WITH SECURITY_ENFORCED]);
        if(lstFilter.size() > 0 && lstFilter[0].Name != '') {
            objDebugLog.SmartDD__Filter_Name__c = lstFilter[0].Name;
        }
        objDebugLog.SmartDD__Requested_On_Object__c = objectName;
        Integer totalRecords = 0;
        
        if(objTableWrapper.total == 200) {
            system.debug('In If method');
            string strQueryTotalRec = 'SELECT COUNT() FROM '+ objectName;
            if(!String.IsBlank(queryConditions)){
                strQueryTotalRec += ' where '+ queryConditions + ' WITH SECURITY_ENFORCED';                   
            } 
            totalRecords = Database.countQuery(strQueryTotalRec); // NOPMD
            objDebugLog.SmartDD__Total_Records_Operated__c = totalRecords;
            
            
            ExceedLimit = '200';
            
            SmartDD__StartDedupeStatus__c startdedupedataSuccess = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');            
            startdedupedataSuccess.SmartDD__IsSuccess__c = null ;  
            system.debug('Start IsSuccess****'+startdedupedataSuccess.SmartDD__IsSuccess__c);
            if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.isCreateable() || Schema.sObjectType.SmartDD__StartDedupeStatus__c.isUpdateable()){
                upsert startdedupedataSuccess;
            }
            
            batchFetchDedupeRecord fetchrecord = new batchFetchDedupeRecord(queryStringTotal,objectname,userid,organizationid);  
            BatchProcessId =  Database.executeBatch(fetchrecord,1000);
            system.debug('BatchProcessId ****'+BatchProcessId);
            
            objDebugLog.SmartDD__Batch_Id__c = String.valueOf(BatchProcessId);
            
            SmartDD__StartDedupeStatus__c startdedupedata = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');            
            startdedupedata.SmartDD__StartDedupeBatchId__c = String.valueOf(BatchProcessId) ;  
            system.debug('Start DeDupe BatchProcessId ****'+startdedupedata.SmartDD__StartDedupeBatchId__c);
            if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.isCreateable() || Schema.sObjectType.SmartDD__StartDedupeStatus__c.isUpdateable()){
                upsert startdedupedata;
            }
            SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = String.valueOf(BatchProcessId);
            system.debug('DeDupe Configuration BatchProcessId ****'+dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c);
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__StartDedupeStatus__c.isUpdateable()) {
                upsert dedupeConfig;
            }
            
            SmartDD__ReDe_Dupe_Configuration__c reDedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
            reDedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
            reDedupeConfig.SmartDD__ReDeduped_Object_Name__c = objectName;
            reDedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
            reDedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
            reDedupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
            if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isUpdateable()) {
                upsert reDedupeConfig;
            } 
            //System.debug('ExceedLimit+isSuccess: ' + ExceedLimit+ ' # '+isSuccess+ ' # '+datetime.now());
            return ExceedLimit+'#'+BatchProcessId;
        } 
        else {
            system.debug('In else method');
            String JSONFieldFilterStr = ''; // NOPMD
            Set<String> recordIds = (new Map<String,SObject>(objTableWrapper.sObjectTotalRecords)).keySet();
            List<String> lstRecordIds = new List<String>(recordIds);
            String strRecordIds = String.join(lstRecordIds, '","');
            
            SmartDD__Manage_Cluster_Org_Tab_Id__c objOrgTabNameId = SmartDD__Manage_Cluster_Org_Tab_Id__c.getValues('Org Tab Name');
            
            system.debug('recordIds****'+ recordIds);
            JSONFieldFilterStr += '{';
            if(lstAuthorizedUser.size() > 0) {
                JSONFieldFilterStr += '"organisationId":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
                JSONFieldFilterStr += '"userId":"' + lstAuthorizedUser[0].SmartDD__UserId__c + '",';
                JSONFieldFilterStr += '"objectName":"' + objectName + '",';
                //JSONFieldFilterStr += '"sfdcTabName":"' + objOrgTabNameId.SmartDD__TabName__c + '",';
                JSONFieldFilterStr += '"sfdcTabName":"DedupeManageClusterPage",';
                JSONFieldFilterStr += '"recordIds":["';
                JSONFieldFilterStr += strRecordIds.replace('00 Q', '00Q');
                JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
                JSONFieldFilterStr += '"],';
                JSONFieldFilterStr += '"type":"dedupe"';
                JSONFieldFilterStr += '}';
            }
            JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
            system.debug('JSONFieldFilterStr ****'+JSONFieldFilterStr);
            
            objDebugLog.SmartDD__Total_Records_Operated__c = lstRecordIds.Size();
            
            isSuccess = httpDedupeJSONRequest(System.Label.SFImportAPI+'/dedupe/start', JSONFieldFilterStr);
            system.debug('BatchProcessIdLASTTT ****'+BatchProcessId);
            system.debug('isSuccessLASTTT****'+isSuccess);
            SmartDD__Dedupe_Log__c objDebugLog1 = new SmartDD__Dedupe_Log__c();
            objDebugLog1.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            objDebugLog1.SmartDD__Time_Of_Request__c = Datetime.now();
            objDebugLog1.SmartDD__Type_Of_Request__c = 'Dedupe Request';
            objDebugLog1.SmartDD__Requested_On_Object__c = objectName;
            objDebugLog1.SmartDD__Json_Response_Body__c = isSuccess;
            List<SmartDD__Filter__c> lstFilter1 = new List<SmartDD__Filter__c>([SELECT Id, Name, SmartDD__Object_Name__c, SmartDD__FilterLogic__c FROM SmartDD__Filter__c WHERE Id =: filterId WITH SECURITY_ENFORCED]);
            if(lstFilter1.size() > 0 && lstFilter1[0].Name != '') {
                objDebugLog1.SmartDD__Filter_Name__c = lstFilter1[0].Name;
            }
            if(Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable() ){
                insert objDebugLog1;
            }           
        }
        Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
        // if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable()){
        //     //upsert objDebugLog;
        // }
        
        List<SmartDD__TempDedupeNote__c> lstDeleteTempNotes = new List<SmartDD__TempDedupeNote__c>([SELECT Id FROM SmartDD__TempDedupeNote__c WHERE SmartDD__Object_Name__c =: selectedObjectname WITH SECURITY_ENFORCED]);
        if((lstDeleteTempNotes.Size() > 0 && lstDeleteTempNotes.Size() < 5000) || Schema.sObjectType.SmartDD__TempDedupeNote__c.isDeletable()) {           
            Delete lstDeleteTempNotes;
        }
        System.debug('ExceedLimit+isSuccess: ' + ExceedLimit+ ' # '+isSuccess+ ' # '+datetime.now());
        return ExceedLimit+'#'+isSuccess+'#'+datetime.now(); 
    }
    
    public class MetadataServiceExamplesException extends Exception { }
    
    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    /**
* Example helper method to interpret a SaveResult, throws an exception if errors are found
**/
    public static void handleSaveResults(MetadataService.SaveResult saveResult)     //NOPMD
    {
        // Nothing to see?
        if(saveResult==null || saveResult.success){
            return;
        }
          
        // Construct error message and throw an exception
        if(saveResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors){
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                     ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0){
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
            }
        }
        }
        if(!saveResult.success){
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
        }
    }
    // This method will check and return boolean if a field exists in an object
    public static boolean doesFieldExist(String objName, string fieldName)
    {
        try {
            SObject so = Schema.getGlobalDescribe().get(objName).newSObject();
            return so.getSobjectType().getDescribe().fields.getMap().containsKey(fieldName);
        }
        catch(Exception ex) { System.debug(ex.getMessage()); }
        
        return false;
    }
    
    /******************************************************
Http Request Body
******************************************************/
    @RemoteAction
    public static string httpDedupeJSONRequest(String strAWSEndpointLead, string strBody) {       
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes: '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: '+jsonString);
            return objSyncDataStatus.isSuccess + '#' + objSyncDataStatus.successMessage;
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
            return e.getMessage();
        }
    }       
    
    @AuraEnabled
    public static string checkCredentials(String objectType, String filterId){
        string httpResMessage ;
        String strDelClstrResp = '';
        string[] lstDelClusterResp;
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = [SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1];
        String JSONObjectTypeString = '';  // NOPMD
        JSONObjectTypeString += '{';
        if(lstDedupeConfig.size() > 0) {
            JSONObjectTypeString += '"Object Name":"'+ objectType +'",';
            JSONObjectTypeString += '"Organization Id":"'+ lstDedupeConfig[0].SmartDD__Organization_Id__c +'",';
            JSONObjectTypeString += '"UserId":"'+ lstDedupeConfig[0].SmartDD__UserId__c +'"';
        }
        
        JSONObjectTypeString += '}';
        // Calling endpoint through HTTP request.
        HttpRequest objSaveData = httpJSONRequest(System.Label.SFImportAPI+'/object/checkBeforeSync', JSONObjectTypeString);
        Http http = new Http();
        
        try{
            HTTPResponse saveReq = http.send(objSaveData);
            String jsonSaveString =  saveReq.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonSaveString);
            system.debug('@#$objSyncDataStatus: '+objSyncDataStatus);
            if(objSyncDataStatus.error != null)  {
                SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                dedupeConfig.SmartDD__Dedupe_Started_Stat__c = true;
                if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
                    upsert dedupeConfig;
                } 
                if(objSyncDataStatus.errorDescription == 'authentication failure') {
                    httpResMessage = objSyncDataStatus.errorDescription;
                } else if(objSyncDataStatus.errorDescription == 'Database not available.' ) {
                    httpResMessage = objSyncDataStatus.errorDescription;
                } else if(objSyncDataStatus.errorDescription == 'client identifier invalid' ) { 
                    httpResMessage = 'Connected App Details Wrong';
                }
            }
            else {                 
                
                httpResMessage = 'success';
            }
            system.debug('@#$httpResMessage: '+httpResMessage);
            return httpResMessage;
        }
        catch(Exception e){
            httpResMessage = e.getMessage();
            return httpResMessage ;
        } 
    }
    
    @AuraEnabled
    Public static SmartDD__De_Dupe_Configuration__c getDedupeStartedStat(){
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        if(dedupeconfig.SmartDD__Dedupe_Started_Stat__c == true) {
            system.debug('getDedupeStartedStat - > if:'+dedupeconfig.SmartDD__Dedupe_Started_Stat__c);
            SmartDD__De_Dupe_Configuration__c dedupeClCreated = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            dedupeClCreated.SmartDD__Dedupe_Started_Stat__c = false;
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
                upsert dedupeClCreated;
            }
            dedupeconfig.SmartDD__Dedupe_Started_Stat__c = true;
        }
        return dedupeconfig;
    }
    
    
    @AuraEnabled
    Public static SmartDD__De_Dupe_Configuration__c getDeDupeConfiguration(){
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        return dedupeconfig;
    }
    
    @AuraEnabled
    Public static List<wrpCreateClusteState> getReviewStatus(String selObjectname){
        List<wrpCreateClusteState> newWrpList = new List<wrpCreateClusteState>();
        wrpCreateClusteState objWrp = new wrpCreateClusteState();
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selObjectname);
        List<SmartDD__Cluster__c > lstCluster;
        system.debug('@@####New_Master_Cluster_Id__c..... '+objMasterClusterId.SmartDD__New_Master_Cluster_Id__c);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            lstCluster  = new List<SmartDD__Cluster__c > ([SELECT Id, SmartDD__Object_Name__c, Name, SmartDD__Total_Child_Records__c, SmartDD__Master_Cluster_Record_Id__c FROM SmartDD__Cluster__c Where 
                                                           SmartDD__Master_Cluster_Record_Id__c =: objMasterClusterId.SmartDD__New_Master_Cluster_Id__c AND SmartDD__Total_Child_Records__c > 1 WITH SECURITY_ENFORCED LIMIT 10]);                              
            system.debug('@@lstCluster' + lstCluster);                
            objWrp.objWrpClusterList =  lstCluster;
        }   
        SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(selObjectname);
        objWrp.strWrpBatchId  = manageClusterBatch.SmartDD__Batch_Id__c;
        
        newWrpList.add(objWrp);
        return newWrpList;
    }
    
    @AuraEnabled
    Public static String getDedupeStatusPageStat(){
        system.debug('####getDedupeStatusPageStat');
        string userid = '';
        string organizationid = '';
        String selectedObject = '';
        String JSONFieldFilterStr = ''; // NOPMD
        String resMessage = '';
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, 
                                                                                                                SmartDD__UserId__c, SmartDD__Organization_Id__c, 
                                                                                                                SmartDD__Username__c, SmartDD__Email__c,
                                                                                                                SmartDD__Last_Name__c, SmartDD__First_Name__c
                                                                                                                FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1]);
        system.debug('lstAuthorizedUser ??' + lstAuthorizedUser);        // NOPMD
        if(lstAuthorizedUser.size() > 0){
            userid = lstAuthorizedUser[0].SmartDD__UserId__c;
            organizationid = lstAuthorizedUser[0].SmartDD__Organization_Id__c; 
        }
        
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        selectedObject = dedupeconfig.SmartDD__DeDupe_Object_Name__c;
        if(lstAuthorizedUser.size() > 0) {
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"dbName":"' + organizationid + '",';
            JSONFieldFilterStr += '"objectName":"' + selectedObject + '",';
            JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
            JSONFieldFilterStr += '}';
        } 
        system.debug('@#$JSONFieldFilterStr : '+JSONFieldFilterStr);
        resMessage = httpStatusPageJSONRequest(System.Label.SFImportAPI+'/lead/getClusterStatus', JSONFieldFilterStr);
        
        return resMessage;
    }
    
    /******************************************************
Http Request Body
******************************************************/
    public static string httpStatusPageJSONRequest(String strAWSEndpointLead, string strBody) {       
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes: '+statusRes);
            String jsonString =  statusRes.getBody();
            system.debug('@@#$jsonString : '+jsonString );
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: '+jsonString);
            return objSyncDataStatus.successMessage;
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    Public static SmartDD__Dedupe_Configuration__c credentialDetails(){
        SmartDD__Dedupe_Configuration__c objDedupeConfig = new SmartDD__Dedupe_Configuration__c();
        objDedupeConfig = [select id, name, SmartDD__Username__c from SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1];
        return objDedupeConfig;
    }
    
    @AuraEnabled
    // Method to fetch Sync Data Status from custom setting Check DeDupe Configuration
    public static SmartDD__De_Dupe_Configuration__c GetDedupeConfigCustomSettings(String selectedObjectname) {  // NOPMD
        
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        system.debug('dedupeconfig'+dedupeconfig);
        if(dedupeconfig.SmartDD__Sync_Data__c != true) {
            system.debug('dedupeconfig.SmartDD__Sync_Data__c'+dedupeconfig.SmartDD__Sync_Data__c);
            SmartDD__De_Dupe_Configuration__c dedupeClCreated = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
            system.debug('dedupeClCreated'+dedupeClCreated);
            dedupeClCreated.SmartDD__Dedupe_Started_Stat__c = true;
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
                upsert dedupeClCreated;
            }
        }
        dedupeconfig.SmartDD__Deduped_By_UserName__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        return dedupeconfig;
    }
    
    // Method is used to reset the IsMerged value for the selected object
    @AuraEnabled
    public static void resetMergedFlag(String selectedObjectname, String filterId) {
        try{
        List<SmartDD__MergedRecordBackup__c> lstMergedRecs = new List<SmartDD__MergedRecordBackup__c>([SELECT Id FROM SmartDD__MergedRecordBackup__c WITH SECURITY_ENFORCED LIMIT 5000]);
        if (SmartDD__MergedRecordBackup__c.sObjectType.getDescribe().isDeletable()) {
            Delete lstMergedRecs;
        }
        /*List<sObject> lstSObjMergeQuery = new List<sObject>();
        String strMergedRecords = 'SELECT Id, SmartDD__IsMerged__c FROM '+ String.escapeSingleQuotes(selectedObjectname) +' WHERE SmartDD__IsMerged__c = true WITH SECURITY_ENFORCED';
        lstSObjMergeQuery = database.query(strMergedRecords);
        system.debug('lstSObjMergeQuery' + lstSObjMergeQuery);
        for(sObject objMerged: lstSObjMergeQuery) {
            objMerged.put('SmartDD__IsMerged__c',false);
        }
        update lstSObjMergeQuery;*/
        batchFetchMergeRecord batchFetchMerge = new batchFetchMergeRecord(selectedObjectname);
		Database.executeBatch(batchFetchMerge,1000);
        
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Pending';
        dedupeConfig.SmartDD__Single_Clusters_Completed_Stat__c = 'Pending';
        if((Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable()) || (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Single_Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Single_Clusters_Completed_Stat__c.isUpdateable())) {
            upsert dedupeConfig;
        } 
        updateDedupeObjectName(selectedObjectname,filterId);    
        }catch(Exception e){
            System.debug(e);
        }
                        
    }
    
    @AuraEnabled
    public static String saveAuthCredentials(String userName, String password) {
        List<SmartDD__Dedupe_Configuration__c> lstAuthUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                          SmartDD__Last_Name__c, SmartDD__First_Name__c, SmartDD__Manual_Cluster__c,
                                                                                                          SmartDD__SF_Import_Consumer_Key__c,SmartDD__SF_Import_Consumer_Secret__c
                                                                                                          FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED]);
        String JSONAuthUserString = '';     // NOPMD
        JSONAuthUserString += '{';
        for(SmartDD__Dedupe_Configuration__c obj : lstAuthUser) {
            JSONAuthUserString += '"Username":"' + userName + '",';
            JSONAuthUserString += '"Password":"' + passWord + '",';
            JSONAuthUserString += '"First Name":"' + obj.SmartDD__First_Name__c + '",';
            JSONAuthUserString += '"Last Name":"' + obj.SmartDD__Last_Name__c + '",';
            JSONAuthUserString += '"Email":"' + obj.SmartDD__Email__c + '",';
            JSONAuthUserString += '"SFImport_ConsumerKey":"' + obj.SmartDD__SF_Import_Consumer_Key__c + '",';
            JSONAuthUserString += '"SFImport_ConsumerSecret":"' + obj.SmartDD__SF_Import_Consumer_Secret__c + '",';
            JSONAuthUserString += '"Organization Id":"' + obj.SmartDD__Organization_Id__c + '",';
            JSONAuthUserString += '"UserId":"'+ obj.SmartDD__UserId__c + '",';
            JSONAuthUserString += '"IsMannualCluster":"'+ obj.SmartDD__Manual_Cluster__c + '"';
        }
        JSONAuthUserString += '}';
        System.debug('@#$JSONAuthUserString: '+ JSONAuthUserString);
        HttpRequest objSaveData = httpJSONRequest(System.Label.SFImportAPI+'/user/save', JSONAuthUserString);
        
        String resultMessage;
        Http http = new Http();
        try{
            HTTPResponse saveReq = http.send(objSaveData);
            String jsonSaveString =  saveReq.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonSaveString);
            system.debug('objSyncDataStatus'+objSyncDataStatus);
            if(objSyncDataStatus.isSuccess == '1') {
                String result = checkCredentials('Lead','');
                system.debug('result++++'+result);
                if(result == 'authentication failure'){
                    resultMessage = 'authentication failure';
                } else {
                    resultMessage = 'success';
                    for(SmartDD__Dedupe_Configuration__c objDedupeConf : lstAuthUser) {
                        objDedupeConf.SmartDD__Username__c = userName; 
                        //objDedupeConf.SmartDD__Password__c = passWord; 
                    }
                    SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstAuthUser); 
                    update decision.getRecords();
                } 
            }
        }
        catch(Exception e){     // NOPMD
        }
        return resultMessage;
    }
    
    //Http Request Body
    public static HttpRequest httpJSONRequest(String strAWSEndpointLead, string strBody) {
        HttpRequest objHTTPRequest = new HttpRequest();
        Http httpProtocol = new Http();
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setEndpoint(strAWSEndpointLead);
        
        return objHTTPRequest;
    }
    
    
    @AuraEnabled
    public static AsyncApexJobWrapper AsyncApexJobRecords(Id BatchProcessId){   // NOPMD
        
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper(); 
        if(BatchProcessId != null || BatchProcessId != ''){      
            objApexJob.lstAsyncApexJob = [SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH SECURITY_ENFORCED];
            objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems; 
            objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed; 
            objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status; 
        }
        return objApexJob; 
    }
    
    /** Get Customsetting field Clusters_Completed_Stat__c value. */
    @AuraEnabled
    Public static SmartDD__De_Dupe_Configuration__c getClustersCompletedStat(){
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');  
        system.debug('getClustersCompletedStat.....>>'+dedupeconfig);
        return dedupeconfig;
        
    }
    
    /** Update Customsetting field Last_Create_Cluster_Progress__c value.*/
    @AuraEnabled
    Public static SmartDD__De_Dupe_Configuration__c updateCreateClusterProgress(Integer lastCreateClusterProgress, Integer clusterEstimatedTime) {
        
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        dedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = lastCreateClusterProgress;
        dedupeConfig.SmartDD__Cluster_Estimated_Time__c = clusterEstimatedTime;
        
        
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isUpdateable()) {
            update dedupeConfig;
        }                 
        return dedupeConfig;
    }
    
    /** Update Customsetting field Last_Create_Cluster_Progress__c and Clusters_Completed_Stat__c value.*/
    @AuraEnabled
    Public static SmartDD__De_Dupe_Configuration__c updateLastCreateCluster(){
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        dedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
        dedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
        
        
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable()) {
            update dedupeConfig;
        }        
        return dedupeConfig;
    }
    
    
    /** Update ProcessStatus from java side.*/
    @AuraEnabled
    Public static String updateprocessStatus(String objectName){
        //Call StartDedupe API here.
        String JSONFieldFilterStr = ''; // NOPMD
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                                SmartDD__Last_Name__c, SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH SECURITY_ENFORCED limit 1]);
        if(lstAuthorizedUser.size() > 0) {
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"Object Name":"' + objectName + '",';
            JSONFieldFilterStr += '"Organization Id":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"UserId":"' + lstAuthorizedUser[0].SmartDD__UserId__c + '"';
            JSONFieldFilterStr += '}';
        }  
        system.debug('BEFORE JAVA CALL:....................................... ');
        httpProcessStatusJSONRequest(System.Label.SFImportAPI+'/cluster/processStatusUpdate', JSONFieldFilterStr);  
        system.debug('AFTER  JAVA CALL:....................................... ');
        return 'Success';
    }
    
    
    public static void httpProcessStatusJSONRequest(String strAWSEndpointLead, string strBody) {       
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes:....... '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@Json ClusterStatus jsonString:....................................... '+jsonString);
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
    }
    
    @AuraEnabled 
    Public static void setStartDedupeBatch() {                             
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';  
        System.debug('@@setStartDedupeBatch: '+ dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c);
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()
           && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isAccessible() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isAccessible() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isUpdateable()){            
               update dedupeConfig;        
           }            
    }
    
    @AuraEnabled 
    public static string CheckApiStatus() {                         // NOPMD
        
        SmartDD__StartDedupeStatus__c startdedupedata = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');
        String apistatus = startdedupedata.SmartDD__IsSuccess__c;             
        startdedupedata.SmartDD__StartDedupeBatchId__c = '' ;                 
        if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.isCreateable()){
            upsert startdedupedata;
        }   
        
        //system.debug('@@apistatus'+apistatus);
        //return apistatus; 
        System.debug('apistatus: ' + apistatus);
        return apistatus;
        
    }        
    
    /******************************************************
wrapper class
******************************************************/
    public class wrpObjectFieldsList {  // NOPMD
        @AuraEnabled public String strObjectName {get;set;}
        @AuraEnabled public List<String> objectFieldsList {get;set;}
        @AuraEnabled public List<wrpFields> FieldsList {get;set;}   // NOPMD
        
        public wrpObjectFieldsList(){
            strObjectName = '';
            objectFieldsList = new List<String>();
            FieldsList = new List<wrpFields>();
        }
    }
    public class wrpFields {    // NOPMD
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldApiName {get;set;}
        @AuraEnabled public String fieldTypeName {get;set;}
        @AuraEnabled public Boolean isSelected {get;set;}
        
        public wrpFields(){
            fieldName = '';
            fieldApiName ='';
            fieldTypeName = '';
            isSelected = false;
        }  
    }
    public class AsyncApexJobWrapper{
        @AuraEnabled public Integer TotalJobItems{get;set;} // NOPMD
        @AuraEnabled public String JobItemStatus{get;set;}  // NOPMD
        @AuraEnabled public Integer JobItemsProcessed{get;set;} // NOPMD
        @AuraEnabled public List<AsyncApexJob> lstAsyncApexJob{get;set;}
    }
    
    public class wrpCreateClusteState { // NOPMD
        @AuraEnabled public String strWrpBatchId {get;set;}
        @AuraEnabled public List<SmartDD__Cluster__c> objWrpClusterList {get;set;}
        
        public wrpCreateClusteState(){
            strWrpBatchId = '';
            objWrpClusterList = new List<SmartDD__Cluster__c>();
        }
    }
}