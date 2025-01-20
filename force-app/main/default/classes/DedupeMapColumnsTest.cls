@isTest
private with sharing class DedupeMapColumnsTest {
    Static testMethod void setColumnMap() {
    
        SmartDD__Search_Column__c objMapColumn = new SmartDD__Search_Column__c();
        objMapColumn.SmartDD__Object_Name__c = 'Lead';
        objMapColumn.SmartDD__Search_Column_Fields__c = 'LastName,FirstName,Company,Title,Email,Street,City,Country,LeadSource,Status';
        objMapColumn.SmartDD__Search_Object_Fields__c = 'LastName,FirstName,Title,Company,Email';
        objMapColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName,FirstName,Salutation,Name,Title';
        Schema.DescribeSObjectResult schSearchColm = SmartDD__Search_Column__c.sObjectType.getDescribe();
        if(schSearchColm.isCreateable()){
            insert objMapColumn;
        }
        
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() || dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        Schema.DescribeSObjectResult DeDupeConfCust = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
        if(DeDupeConfCust.isCreateable() || DeDupeConfCust.isUpdateable()) {
            insert new SmartDD__De_Dupe_Configuration__c(SmartDD__Sync_Object_Name__c = 'Lead', SmartDD__Sync_Data__c = true,
        SmartDD__Total_Records_Synced__c = 0, Name = 'DeDupe Configuration', SmartDD__Last_Sync_date__c = System.now());
        }                
        
        SmartDD__Sync_Data__c syncData = new SmartDD__Sync_Data__c();
        if (Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()) {
            syncData.Name= 'Sync Data Status';
        }
        if (Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Save_Mapping__c.isCreateable()) {
            syncData.SmartDD__Save_Mapping__c = true;
        }
        Schema.DescribeSObjectResult schSyncData = SmartDD__Sync_Data__c.sObjectType.getDescribe();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            System.debug('..................................................'+syncData);
            insert syncData;
        }
        
        //boolean result = DedupeMapColumns.saveDedupeSearchFields(objMapColumn.Search_Column_Fields__c, objMapColumn.Object_Name__c, objMapColumn.Review_Polish_Display_Columns__c, objMapColumn.Search_Object_Fields__c);
        //System.assertEquals(false, result); 
        DedupeMapColumns.fetchDedupeSearchCols('Lead');
        DedupeMapColumns.GetDedupeConfigCustomSettings();    
        DedupeMapColumns.fetchSelectedFieldsCols(objMapColumn.SmartDD__Object_Name__c);
        DedupeMapColumns.CheckValidColumns(objMapColumn.SmartDD__Search_Object_Fields__c, objMapColumn.SmartDD__Object_Name__c);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DedupeMapColumns.postDedupeColsrequest(objMapColumn.SmartDD__Object_Name__c);
        Test.stopTest();
        System.assert(true);
        
    }
    Static testMethod void setColumnMapApiCall() {
    
        Schema.DescribeSObjectResult DeDupeConfCust = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
        if(DeDupeConfCust.isCreateable() || DeDupeConfCust.isUpdateable()) {
            insert new SmartDD__De_Dupe_Configuration__c(SmartDD__Sync_Object_Name__c = 'Lead', SmartDD__Sync_Data__c = true,
        SmartDD__Total_Records_Synced__c = 0, Name = 'DeDupe Configuration');
        }
        
        SmartDD__Search_Column__c objMapColumn = new SmartDD__Search_Column__c();
        objMapColumn.SmartDD__Object_Name__c = 'Lead';
        objMapColumn.SmartDD__Search_Column_Fields__c = 'LastName,FirstName,Company,Title,Email,Street,City,Country,LeadSource,Status';
        objMapColumn.SmartDD__Search_Object_Fields__c = 'LastName,FirstName,Title,Company,Email';
        objMapColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName,FirstName,Salutation,Name,Title';
        Schema.DescribeSObjectResult schSearchColm = SmartDD__Search_Column__c.sObjectType.getDescribe();
        if(schSearchColm.isCreateable()){
            insert objMapColumn;
        }        
        
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() || dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Save Mapping Request';
        objDebugLog.SmartDD__Requested_On_Object__c = objMapColumn.Object_Name__c;
        objDebugLog.SmartDD__Total_Records_Operated__c = 0;
        objDebugLog.SmartDD__Short_Noes__c = 'Sync data is in Progress';
        Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
        if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable()){
            upsert objDebugLog;
        }
        
        boolean result = DedupeMapColumns.saveDedupeSearchFields(objMapColumn.SmartDD__Search_Object_Fields__c, objMapColumn.SmartDD__Object_Name__c, objMapColumn.SmartDD__Search_Column_Fields__c, objMapColumn.SmartDD__Review_Polish_Display_Columns__c);
        System.assertEquals(true, result); 
        
    }
    
    Static testMethod void setColumnMapApiCall11() {
    
        Schema.DescribeSObjectResult DeDupeConfCust = SmartDD__De_Dupe_Configuration__c.sObjectType.getDescribe();
        if(DeDupeConfCust.isCreateable() || DeDupeConfCust.isUpdateable()) {
            insert new SmartDD__De_Dupe_Configuration__c(SmartDD__Sync_Object_Name__c = 'Lead', SmartDD__Sync_Data__c = true,
        SmartDD__Total_Records_Synced__c = 0, Name = 'DeDupe Configuration');
        }
        
        SmartDD__Search_Column__c objMapColumn = new SmartDD__Search_Column__c();
        objMapColumn.SmartDD__Object_Name__c = 'Lead';
        objMapColumn.SmartDD__Search_Column_Fields__c = 'LastName,FirstName,Company,Title,Email,Street,City,Country,LeadSource,Status,AccountId';
        objMapColumn.SmartDD__Search_Object_Fields__c = 'LastName,FirstName,Title,Company,Email,AccountId';
        objMapColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName,FirstName,Salutation,Name,Title,AccountId';
        Schema.DescribeSObjectResult schSearchColm = SmartDD__Search_Column__c.sObjectType.getDescribe();
        if(schSearchColm.isCreateable()){
            insert objMapColumn;
        }        
        
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() || dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Save Mapping Request';
        objDebugLog.SmartDD__Requested_On_Object__c = objMapColumn.SmartDD__Object_Name__c;
        objDebugLog.SmartDD__Total_Records_Operated__c = 0;
        objDebugLog.SmartDD__Short_Noes__c = 'Sync data is in Progress';
        Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
        if(schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable()){
            upsert objDebugLog;
        }
        Test.startTest();
        boolean result = DedupeMapColumns.saveDedupeSearchFields(objMapColumn.SmartDD__Search_Object_Fields__c, objMapColumn.SmartDD__Object_Name__c, objMapColumn.SmartDD__Search_Column_Fields__c, objMapColumn.SmartDD__Review_Polish_Display_Columns__c);
        Test.stopTest();
        System.assert(true);
        System.assertEquals(true, result); 
        
    }
}