global with sharing class DedupeMapColumns {        // NOPMD
    @AuraEnabled 
    public static List<wrpObjectFieldsList> fetchDedupeSearchCols(String ObjectName) {      // NOPMD
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        SObjectType accountType = Schema.getGlobalDescribe().get(ObjectName);
        Map<String,Schema.SObjectField> MapOfSObj = accountType.getDescribe().fields.getMap();      // NOPMD
        
        wrpObjectFieldsList objwrp = new wrpObjectFieldsList();
        
        List<SmartDD__Lead_Unused_Fields__c> lstLeadUnusedFlds = new List<SmartDD__Lead_Unused_Fields__c>([select SmartDD__Field_Name__c from SmartDD__Lead_Unused_Fields__c WHERE SmartDD__Object_Name__c =: ObjectName WITH USER_MODE]);
        Set<String> strUnusedLeadFlds = new Set<String>();
        for(SmartDD__Lead_Unused_Fields__c unusedFields : lstLeadUnusedFlds){
            strUnusedLeadFlds.add(unusedFields.SmartDD__Field_Name__c);
        }
        
        List<SmartDD__Review_and_Polish_Unused_Fields__c> lstRvwPolishUnusedFlds = new List<SmartDD__Review_and_Polish_Unused_Fields__c>([select SmartDD__Field_Name__c from SmartDD__Review_and_Polish_Unused_Fields__c WHERE SmartDD__Object_Name__c =: ObjectName WITH USER_MODE]);       
        Set<String> strUnusedRvwPolishFlds = new Set<String>();     
        for(SmartDD__Review_and_Polish_Unused_Fields__c unUsedRvwPolishFields : lstRvwPolishUnusedFlds){     
            strUnusedRvwPolishFlds.add(unUsedRvwPolishFields.SmartDD__Field_Name__c);        
        }
        
        for(String stringOfSObj : MapOfSObj.keyset()) {
            String strFieldname = String.valueOf(MapOfSObj.get(stringOfSObj).getDescribe().getname());
            SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
            DescribeSObjectResult d = r.getDescribe();
            String strFieldType = String.valueOf(d.fields.getMap().get(strFieldname).getDescribe().getType());
            
            if(!strUnusedLeadFlds.contains(strFieldname) && MapOfSObj.get(strFieldname).getDescribe().isAccessible() && strFieldType != 'TEXTAREA') {
                String fieldLabelName = String.valueOf(MapOfSObj.get(stringOfSObj).getDescribe().getLabel());
                wrpFields objField = new wrpFields();
                if(stringOfSObj == 'OwnerId'){
                    objField.fieldLabelName = 'Owner Name';
                    objField.fieldApiName = 'Owner.Name';
                } else if(stringOfSObj == 'AccountId'){
                    objField.fieldLabelName = 'Account Name';objField.fieldApiName = 'Account.Name';
                } else{
                    objField.fieldLabelName = fieldLabelName;
                    objField.fieldApiName =  String.valueOf(MapOfSObj.get(stringOfSObj).getDescribe().getname());
                }
                objwrp.FieldsList.add(objField);
                
            }
            if(!strUnusedRvwPolishFlds.contains(strFieldname) && MapOfSObj.get(strFieldname).getDescribe().isAccessible()) {            
                String strFieldLabelName = String.valueOf(MapOfSObj.get(stringOfSObj).getDescribe().getLabel());        
                wrpFields objField = new wrpFields();       
                if(stringOfSObj == 'OwnerId'){      
                    objField.fieldLabelName = 'Owner Name';     
                    objField.fieldApiName = 'Owner.Name';       
                } else if(stringOfSObj == 'AccountId'){
                    objField.fieldLabelName = 'Account Name';objField.fieldApiName = 'Account.Name';
                } else{       
                    objField.fieldLabelName = strFieldLabelName;        
                    objField.fieldApiName =  String.valueOf(MapOfSObj.get(stringOfSObj).getDescribe().getname());       
                }       
                objwrp.ReviewPolishFieldsList.add(objField);        
            }
        }
        objwrp.FieldsList.sort();
        objwrp.ReviewPolishFieldsList.sort();
        newWrpList.add(objwrp);
        return newWrpList;
    }

    
    @AuraEnabled
    // Method to fetch Sync Data Status from custom setting Check DeDupe Configuration
    public static SmartDD__De_Dupe_Configuration__c GetDedupeConfigCustomSettings() {           // NOPMD
        SmartDD__Sync_Data__c syncdata = SmartDD__Sync_Data__c.getValues('Sync Data Status');
        System.debug('syncdata.............................'+syncdata);
        if(syncdata != null) {
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
            syncdata.SmartDD__Save_Mapping__c = false;
            if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Sync_Data__c.isUpdateable()){
                upsert syncdata;
            }
        }
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration'); 
        
        // This will reset the sync process after clicking the sync button if it already have took more then 2 hours
        Long modifiedDateTime = DateTime.now().getTime();
        Long createdDateTime = System.now().getTime();
        If(dedupeconfig.SmartDD__Last_Sync_date__c != null) {
            createdDateTime = dedupeconfig.SmartDD__Last_Sync_date__c.getTime();    
        }
        Decimal diffMilliSecs = Decimal.valueOf(modifiedDateTime - createdDateTime);
        Decimal dDays = diffMilliSecs/1000/60/60/24;
        Integer iDays = Integer.valueOf(math.floor(dDays));
        Decimal remainderDays = dDays- iDays;
        
        Decimal dHours = remainderDays * 24;
        Integer iHours = Integer.valueOf(math.floor(dHours));
        Decimal remainderHours = dHours - iHours;
        
        if(iDays > 0 || iHours > 4) {
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()) {
                dedupeconfig.SmartDD__Data_Mapping__c = false;dedupeconfig.SmartDD__Sync_Data__c = false;
            }
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Sync_date__c.isCreateable()){
                dedupeconfig.SmartDD__Last_Sync_date__c = System.now();
            }
            if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()){
                upsert dedupeconfig;
            }
        }
        
        if(dedupeconfig != null && dedupeconfig.SmartDD__Sync_Data__c == true) {
            // Code to add logs in Dedupe Log Object.
            List<SmartDD__Dedupe_Log__c> lstObjDebugLog = new List<SmartDD__Dedupe_Log__c>();

            SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
            objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
            objDebugLog.SmartDD__Type_Of_Request__c = 'Save Mapping Request';
            objDebugLog.SmartDD__Requested_On_Object__c = dedupeconfig.SmartDD__Sync_Object_Name__c;
            objDebugLog.SmartDD__Total_Records_Operated__c = dedupeconfig.SmartDD__Total_Records_Synced__c;
            objDebugLog.SmartDD__Short_Noes__c = 'Sync data is in Progress';

            lstObjDebugLog.add(objDebugLog);
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDebugLog); 
            Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
            if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable() || Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Log__c.isUpdateable() ){
                upsert decision.getRecords();
            }
        }
        return dedupeconfig;
    }
    
    @AuraEnabled
    public static List<SmartDD__Search_Column__c> fetchSelectedFieldsCols(String objectName) {
        List<SmartDD__Search_Column__c> lstSelectedFieldsCols = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Column_Fields__c, SmartDD__Search_Object_Fields__c, SmartDD__Review_Polish_Display_Columns__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :objectName WITH USER_MODE ]);
        if(lstSelectedFieldsCols.size() > 0){
            return lstSelectedFieldsCols;
        } else {
            return null;
        }
        
    }
    
    @AuraEnabled
    public static String CheckValidColumns(String dedupeFieldCols, String objectName) {         // NOPMD
        List<String> lstDedupeFieldCols = new List<String>();
        List<sObject> sobjList = new List<sObject>();
        String invalidColumns = '';
        Set<String> allowedObjectNames = new Set<String>{'Lead', 'Account', 'Contact'};
        system.debug('@#$%dedupeFieldCols: '+dedupeFieldCols);
        system.debug('@#$%objectName: '+objectName);
        if (!allowedObjectNames.contains(objectName)) {
            return 'Invalid object name';
        }
        
        lstDedupeFieldCols = dedupeFieldCols.split(',');
        system.debug('@#$%lstDedupeFieldCols : '+lstDedupeFieldCols );
        // Use proper variable names for the lists
        List<String> lstObjectFields = new List<String>();
        List<String> lstFieldConditions = new List<String>();
        
        for(String strDedupeCols : lstDedupeFieldCols) {            
           // String strQuery = 'SELECT '+ strDedupeCols +' FROM '+ objectName +' WHERE '+ strDedupeCols +' != null WITH USER_MODE LIMIT 30'; 
            lstObjectFields.add(strDedupeCols);
            lstFieldConditions.add(strDedupeCols + ' != null');
            
            String strQuery = 'SELECT ' + String.join(lstObjectFields, ',') +
                ' FROM ' + objectName  +
                ' WHERE ' + String.join(lstFieldConditions, ' OR ') +
                ' WITH USER_MODE LIMIT 30';
            system.debug('@#$%strQuery: '+strQuery );
            sobjList = Database.query(strQuery);            // NOPMD
            system.debug('@#$%sobjList : '+sobjList.Size());
            if(sobjList.Size() < 20) {
                invalidColumns += strDedupeCols + ','; 
            } 
        } 
        if(invalidColumns != '') {
            invalidColumns = invalidColumns.removeEnd(',');
        }
        system.debug('@#$%invalidColumns : '+invalidColumns );
        return invalidColumns;
    }
    
    @AuraEnabled
    public static Boolean saveDedupeSearchFields(String leadSelectedField, String objectName, String leadSelectedColumns, String leadRvwPolishColumns) {    // NOPMD
        Boolean blnCallApi = true;
        List<String> lstObjectFields = new List<String>();
        List<String> lstLeadSelectedField = new List<String>();
        
        List<SmartDD__Search_Column__c> lstDedupeSearchField = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Column_Fields__c, SmartDD__Search_Object_Fields__c, SmartDD__Review_Polish_Display_Columns__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :objectName WITH USER_MODE]);
        
        SmartDD__Search_Column__c objDedupeSearchField = new SmartDD__Search_Column__c();
        if(lstDedupeSearchField.size() > 0) {
            objDedupeSearchField = lstDedupeSearchField[0];
        }
        
        /****************************************************/
        if(objDedupeSearchField.SmartDD__Search_Object_Fields__c != '' && objDedupeSearchField.SmartDD__Search_Object_Fields__c != null){
            lstObjectFields = objDedupeSearchField.SmartDD__Search_Object_Fields__c.split(',');
        }
        lstLeadSelectedField = leadSelectedField.split(',');
        
        Integer CountFields = 0;            // NOPMD
        if(lstObjectFields.size() == lstLeadSelectedField.size()) {
            
            for(String strParamRec: lstLeadSelectedField) {
                for(String strTabRec: lstObjectFields) {
                    if(strParamRec == strTabRec) {
                        CountFields++;
                    }
                }
            }
            if(CountFields == lstLeadSelectedField.size()) {
                blnCallApi = true;
            } else {
                blnCallApi = false;
            }
        } else {
            blnCallApi = false;
        }
        /****************************************************/
        
        if(leadSelectedField != null && leadSelectedField != '' && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Object_Fields__c.isUpdateable()){
            objDedupeSearchField.SmartDD__Search_Object_Fields__c = leadSelectedField;
        }
        
        if(leadSelectedColumns != null && leadSelectedColumns != '' && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Column_Fields__c.isUpdateable()){  
            objDedupeSearchField.SmartDD__Search_Column_Fields__c = leadSelectedColumns;
        }
        
        if(leadRvwPolishColumns != null && leadRvwPolishColumns != '' && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Review_Polish_Display_Columns__c.isUpdateable()){       
            objDedupeSearchField.SmartDD__Review_Polish_Display_Columns__c = leadRvwPolishColumns;
        }
        if(Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Object_Name__c.isUpdateable()) {
            objDedupeSearchField.SmartDD__Object_Name__c = objectName;
        }
        Schema.DescribeSObjectResult dscSrchColumn = SmartDD__Search_Column__c.sObjectType.getDescribe();
        if(dscSrchColumn.isCreateable() && dscSrchColumn.isUpdateable() || Schema.sObjectType.SmartDD__Search_Column__c.isCreateable() || Schema.sObjectType.SmartDD__Search_Column__c.isUpdateable()){
            upsert objDedupeSearchField ;
        }
        
        if(blnCallApi != true) {
            SmartDD__Sync_Data__c saveMappingVal = SmartDD__Sync_Data__c.getValues('Sync Data Status');
            if (Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Save_Mapping__c.isUpdateable()) {
                saveMappingVal.SmartDD__Save_Mapping__c = true;
            }
            Schema.DescribeSObjectResult dscSyncDataUpdt = SmartDD__Sync_Data__c.sObjectType.getDescribe();
            if(dscSyncDataUpdt.isCreateable() && dscSyncDataUpdt.isUpdateable()){
                upsert saveMappingVal;
            }
            
            SmartDD__De_Dupe_Configuration__c saveConfigMappingVal = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Data_Mapping__c.isUpdateable()) {
                saveConfigMappingVal.SmartDD__Data_Mapping__c = true;
            }
            Schema.DescribeSObjectResult dscDedupeConfigUpdt = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
            if(dscDedupeConfigUpdt.isCreateable() && dscDedupeConfigUpdt.isUpdateable()){
                upsert saveConfigMappingVal;
            }
        }
        
        SmartDD__De_Dupe_Configuration__c deDupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        string strQueryTotalRec = 'SELECT COUNT() FROM '+ objectName + ' WITH USER_MODE';
        Integer totalRecords = Database.countQuery(strQueryTotalRec);   // NOPMD
        if(deDupeConfig != null) {            
            deDupeConfig.SmartDD__Sync_Object_Name__c = objectName;
            deDupeConfig.SmartDD__Total_Records_Synced__c = totalRecords;
            deDupeConfig.SmartDD__Synced_By_UserName__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            if(objectName == 'Lead') {
                deDupeConfig.SmartDD__Lead__c = true;
            } else if(objectName == 'Account') {                
                deDupeConfig.SmartDD__Account__c = true;
            } else if(objectName == 'Contact') {
                deDupeConfig.SmartDD__Contact__c = true;
            }
            Schema.DescribeSObjectResult dscDedupeConfigUpdt = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
            if(dscDedupeConfigUpdt.isUpdateable()){
                update deDupeConfig;
            }
        }
        return blnCallApi;
    }
    
    
    @AuraEnabled
    public static Boolean nextDedupeSearchFields(String leadSelectedField, String objectName, String leadSelectedColumns, String leadRvwPolishColumns) {    // NOPMD
        Boolean blnCallApi = true;
        List<String> lstObjectFields = new List<String>();
        List<String> lstLeadSelectedField = new List<String>();
        
        List<SmartDD__Search_Column__c> lstDedupeSearchField = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Column_Fields__c, SmartDD__Search_Object_Fields__c, SmartDD__Review_Polish_Display_Columns__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :objectName WITH USER_MODE]);
        
        SmartDD__Search_Column__c objDedupeSearchField = new SmartDD__Search_Column__c();
        if(lstDedupeSearchField.size() > 0) {
            objDedupeSearchField = lstDedupeSearchField[0];
        }
        
        /****************************************************/
        if(objDedupeSearchField.SmartDD__Search_Object_Fields__c != '' && objDedupeSearchField.SmartDD__Search_Object_Fields__c != null){
            lstObjectFields = objDedupeSearchField.SmartDD__Search_Object_Fields__c.split(',');
        }
        lstLeadSelectedField = leadSelectedField.split(',');
        
        Integer CountFields = 0;            // NOPMD
        if(lstObjectFields.size() == lstLeadSelectedField.size()) {
            
            for(String strParamRec: lstLeadSelectedField) {
                for(String strTabRec: lstObjectFields) {
                    if(strParamRec == strTabRec) {
                        CountFields++;
                    }
                }
            }
             blnCallApi = false;        
        } else {
            blnCallApi = false;
        }
        /****************************************************/
        
        if(leadSelectedField != null && leadSelectedField != '' && 
           Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Object_Fields__c.isCreateable() && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Object_Fields__c.isUpdateable()){
            objDedupeSearchField.SmartDD__Search_Object_Fields__c = leadSelectedField;
        }
        
        if(leadSelectedColumns != null && leadSelectedColumns != '' && 
           Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Column_Fields__c.isCreateable() && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Column_Fields__c.isUpdateable()){  
            objDedupeSearchField.SmartDD__Search_Column_Fields__c = leadSelectedColumns;
        }
        
        if(leadRvwPolishColumns != null && leadRvwPolishColumns != '' && 
           Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Review_Polish_Display_Columns__c.isCreateable() && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Review_Polish_Display_Columns__c.isUpdateable()){       
            objDedupeSearchField.SmartDD__Review_Polish_Display_Columns__c = leadRvwPolishColumns;
        }
        if(Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Object_Name__c.isUpdateable()) {
            objDedupeSearchField.SmartDD__Object_Name__c = objectName;
        }
        Schema.DescribeSObjectResult dscSrchColumn = SmartDD__Search_Column__c.sObjectType.getDescribe();
        if(dscSrchColumn.isCreateable() && dscSrchColumn.isUpdateable() || Schema.sObjectType.SmartDD__Search_Column__c.isCreateable() || Schema.sObjectType.SmartDD__Search_Column__c.isUpdateable()){
            upsert objDedupeSearchField ;
        }
        
        if(blnCallApi != true) {
            SmartDD__Sync_Data__c saveMappingVal = SmartDD__Sync_Data__c.getValues('Sync Data Status');
            if (Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Save_Mapping__c.isCreateable() && Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Save_Mapping__c.isUpdateable()) {
                saveMappingVal.SmartDD__Save_Mapping__c = true;
            }
            Schema.DescribeSObjectResult dscSyncDataUpdt = SmartDD__Sync_Data__c.sObjectType.getDescribe();
            if(dscSyncDataUpdt.isCreateable() && dscSyncDataUpdt.isUpdateable()){
                upsert saveMappingVal;
            }
            
            SmartDD__De_Dupe_Configuration__c saveConfigMappingVal = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
            if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Data_Mapping__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Data_Mapping__c.isUpdateable()) {
                saveConfigMappingVal.SmartDD__Data_Mapping__c = true;
            }
            Schema.DescribeSObjectResult dscDedupeConfigUpdt = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
            if(dscDedupeConfigUpdt.isCreateable() && dscDedupeConfigUpdt.isUpdateable()){
                upsert saveConfigMappingVal;
            }
        }
        
        SmartDD__De_Dupe_Configuration__c deDupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        string strQueryTotalRec = 'SELECT COUNT() FROM '+ objectName + ' WITH USER_MODE';
        Integer totalRecords = Database.countQuery(strQueryTotalRec);   // NOPMD
        if(deDupeConfig != null) {
            if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Object_Name__c.isUpdateable()) {
            	deDupeConfig.SmartDD__Sync_Object_Name__c = objectName;
            }
            if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Total_Records_Synced__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Total_Records_Synced__c.isUpdateable()) {
            	deDupeConfig.SmartDD__Total_Records_Synced__c = totalRecords;
            }
            if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Synced_By_UserName__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Synced_By_UserName__c.isUpdateable()) {
            	deDupeConfig.SmartDD__Synced_By_UserName__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            }
            
            if(objectName == 'Lead') {
                if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Lead__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Lead__c.isUpdateable()) {
                    deDupeConfig.SmartDD__Lead__c = true;
                }       
            } else if(objectName == 'Account') {
                if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Account__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Account__c.isUpdateable()) {
                    deDupeConfig.SmartDD__Account__c = true;
                }  
                
            } else if(objectName == 'Contact') {
                if (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Contact__c.isCreateable() && Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Contact__c.isUpdateable()) {
                    deDupeConfig.SmartDD__Contact__c = true;
                }                  
            }
            Schema.DescribeSObjectResult dscDedupeConfigUpdt = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
            if(dscDedupeConfigUpdt.isUpdateable()){
            	update deDupeConfig;
            }
        }
        return blnCallApi;
    }
    
    
    
    @AuraEnabled
    public static String postDedupeColsrequest(String filterObjectName) {       // NOPMD
        String fieldnames = '';
        String strDedupeFields = '';
        String strDedupeDisplayCols = '';
        String strDedupeRvwPolishCols = '';
        List<String> lstDedupeFieldAPIName = new List<String>();
        List<String> lstDisplayAPIName = new List<String>();
        List<String> lstRevwPlshAPIName = new List<String>();
        
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                                SmartDD__Last_Name__c, SmartDD__First_Name__c
                                                                                                                FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        
        List<SmartDD__Search_Column__c> lstDedupeColumns = new List<SmartDD__Search_Column__c>([SELECT SmartDD__Object_Name__c, SmartDD__Search_Column_Fields__c, SmartDD__Search_Object_Fields__c, SmartDD__Review_Polish_Display_Columns__c FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c = :filterObjectName WITH USER_MODE]);
        
        fieldnames = lstDedupeColumns[0].SmartDD__Search_Object_Fields__c;
        lstDedupeFieldAPIName = fieldnames.split(',');
        
        fieldnames = lstDedupeColumns[0].SmartDD__Search_Column_Fields__c;
        lstDisplayAPIName = fieldnames.split(',');
        
        fieldnames = lstDedupeColumns[0].SmartDD__Review_Polish_Display_Columns__c;
        lstRevwPlshAPIName = fieldnames.split(',');
        
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(filterObjectName);          // NOPMD
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        
        for (String dedupeFieldAPIName: lstDedupeFieldAPIName) {  
            String dedupeFieldlabel = '';
            String dedupeFieldName = '';
            if(dedupeFieldAPIName != 'Owner.Name' && dedupeFieldAPIName != 'Account.Name'){
                dedupeFieldlabel = fieldMap.get(dedupeFieldAPIName).getDescribe().getLabel();
                dedupeFieldName = fieldMap.get(dedupeFieldAPIName).getDescribe().getname();
            } else if(dedupeFieldAPIName == 'Account.Name') {
                dedupeFieldlabel = 'Account Name';
                dedupeFieldName = 'Account.Name';
            } else {
                dedupeFieldlabel = 'Owner Name';
                dedupeFieldName = 'Owner.Name';
            }
            strDedupeFields +=  dedupeFieldName + '::' + dedupeFieldlabel + ', ';
        }
        strDedupeFields = strDedupeFields.removeEnd(', ');
        
        for(String displayColsAPIName: lstDisplayAPIName) {
            String displayFieldlabel = '';
            String displayColAPIName = '';
            if(displayColsAPIName != 'Owner.Name' && displayColsAPIName != 'Account.Name'){
                displayFieldlabel = fieldMap.get(displayColsAPIName).getDescribe().getLabel();
                displayColAPIName = fieldMap.get(displayColsAPIName).getDescribe().getname();
            } else if(displayColsAPIName == 'Account.Name') {
                displayFieldlabel = 'Account Name';
                displayColAPIName = 'Account.Name';
            } else{
                displayFieldlabel = 'Owner Name';
                displayColAPIName = 'Owner.Name';
            }
            strDedupeDisplayCols +=  displayColAPIName + '::' + displayFieldlabel + ', ';
        }
        strDedupeDisplayCols = strDedupeDisplayCols.removeEnd(', ');
        
        for(String rvwPolshAPIName: lstRevwPlshAPIName) {
            String rvwPolshlabel = '';
            String rvwPolshColsAPIName = '';
            if(rvwPolshAPIName != 'Owner.Name' && rvwPolshAPIName != 'Account.Name'){
                rvwPolshlabel = fieldMap.get(rvwPolshAPIName).getDescribe().getLabel();
                rvwPolshColsAPIName = fieldMap.get(rvwPolshAPIName).getDescribe().getname();
            } else if(rvwPolshAPIName == 'Account.Name') {
                rvwPolshlabel = 'Account Name';
                rvwPolshColsAPIName = 'Account.Name';
            } else{
                rvwPolshlabel = 'Owner Name';
                rvwPolshColsAPIName = 'Owner.Name';
            }
            strDedupeRvwPolishCols +=  rvwPolshColsAPIName + '::' + rvwPolshlabel + ', ';
        }
        strDedupeRvwPolishCols = strDedupeRvwPolishCols.removeEnd(', ');
        
        String JSONFieldFilterStr = '';     // NOPMD
        
        JSONFieldFilterStr += '{';
        if(lstAuthorizedUser.size() > 0){
            JSONFieldFilterStr += '"organisationId":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"userId":"' + lstAuthorizedUser[0].SmartDD__UserId__c + '",';
            JSONFieldFilterStr += '"objectName":"' + filterObjectName + '",';
            JSONFieldFilterStr += '"dedupeFields":"' + strDedupeFields + '",';
            JSONFieldFilterStr += '"displayColumns":"' + strDedupeDisplayCols + '",';
            JSONFieldFilterStr += '"reviewPolishDisplayColumns":"' + strDedupeRvwPolishCols + '"';
        }
        
        JSONFieldFilterStr += '}';
        system.debug('@@Mapping column' + JSONFieldFilterStr);
        String isSuccess = httpDedupeJSONRequest(System.Label.SFImportAPI+'/columnMap/save', JSONFieldFilterStr);
        system.debug('@@Success' + isSuccess);
        // Code to add logs in Dedupe Log Object.
        List<SmartDD__Dedupe_Log__c> lstObjDebugLog = new List<SmartDD__Dedupe_Log__c>();
        
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Save Mapping Request';
        objDebugLog.SmartDD__Json_Request_Body__c = JSONFieldFilterStr;
        objDebugLog.SmartDD__Json_Response_Body__c = isSuccess;
        objDebugLog.SmartDD__Requested_On_Object__c = filterObjectName;
        lstObjDebugLog.add(objDebugLog);
        
        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDebugLog); 
        
        Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
        if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable()){
            upsert decision.getRecords();
        }
        
        return isSuccess;
    }
    
    /*****************************************************
Http Request Body
******************************************************/
    public static string httpDedupeJSONRequest(String strAWSEndpointLead, string strBody) {
        Http objHTTP = new Http();
        string strResponseBody='';
        string strResponseStatus='';
        
        HttpRequest objHTTPRequest = new HttpRequest();
        Http httpProtocol = new Http();
        objHTTPRequest.setTimeout(60000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);
        try {
            Http http = new Http();
            HTTPResponse statusRes = http.send(objHTTPRequest);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            return objSyncDataStatus.isSuccess;
        }
        catch(Exception e) {
            return e.getMessage();
        }
    }
    
    /******************************************************
wrapper class
******************************************************/
    public class wrpObjectFieldsList {              // NOPMD
        @AuraEnabled public List<wrpFields> FieldsList {get;set;}       // NOPMD
        @AuraEnabled public List<wrpFields> ReviewPolishFieldsList {get;set;}   // NOPMD
        
        public wrpObjectFieldsList() {
            FieldsList = new List<wrpFields>();
            ReviewPolishFieldsList = new List<wrpFields>();
        }
    }
    global class wrpFields implements Comparable {      // NOPMD
        @AuraEnabled global String fieldLabelName {get;set;}
        @AuraEnabled global String fieldApiName {get;set;}
        global wrpFields() {
            fieldLabelName = '';
            fieldApiName ='';
        }  
        global Integer compareTo(Object ObjToCompare) {     // NOPMD
            return fieldLabelName.CompareTo(((wrpFields)ObjToCompare).fieldLabelName);
        }
    }
}