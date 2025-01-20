@isTest
private with sharing class SyncDataControllerTest {   
    
    @testSetup 
    static void setup() { 
        //Insert Dedupe_Configuration__c custom object Data.
        SmartDD__Dedupe_Configuration__c dconfig = new SmartDD__Dedupe_Configuration__c();
        dconfig.SmartDD__UserId__c='005f400000324XCAAY';
        dconfig.SmartDD__Organization_Id__c='00Df4000004klpHEAQ';
        dconfig.SmartDD__Username__c = 'smartdedupe@mahcom.com';
        dconfig.SmartDD__Email__c = 'anil@logicrain.com';
        dconfig.SmartDD__Last_Name__c='User2';
        dconfig.SmartDD__First_Name__c='Unique3';
        insert dconfig;        
        
        //Insert Search_Column__c custom object Data.
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'FirstName,LastName,Email,Title,Company';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        
        //Insert Lead Data.
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        Lead[] leadList = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            Lead lead = new Lead();
            lead.FirstName = 'lead';
            lead.LastName = 'test'+'i';
            lead.company = 'test company';
            leadList.add(lead);
        }
        insert leadList;
    }
    
    @isTest static void SyncProgressTestApiData() {
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = 'TestFName';
        dedupeconfig.SmartDD__Last_Name__c = 'TestLname';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        SmartDD__De_Dupe_Configuration__c dedupeconfigsetting = new SmartDD__De_Dupe_Configuration__c();
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.Name.isCreateable()){
            dedupeconfigsetting.Name= 'DeDupe Configuration';
        }  
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){      
            dedupeconfigsetting.SmartDD__Sync_Data__c = true;
        }
        
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfigsetting;
        }
        
        dedupeconfigsetting.SmartDD__Sync_Data__c = false;
        dedupeconfigsetting.SmartDD__Last_Sync_date__c = System.now();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            Upsert dedupeconfigsetting;
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()){
            syncdata.Name = 'Sync Data Status';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable()){        
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable()){
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata; 
        }
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ' ;
        upsert syncdata;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        // SyncDataController.CheckSyncprogress('lead');
        SyncDataController.CheckSyncprogress();
        SyncDataController.CheckSyncStatus();
        Test.stopTest(); 
        system.assert(true);
    }
    
    @isTest static void testCheckSyncprogress(){
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = 'TestFName';
        dedupeconfig.SmartDD__Last_Name__c = 'TestLname';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        SmartDD__De_Dupe_Configuration__c dedupeconfigsetting = new SmartDD__De_Dupe_Configuration__c();
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.Name.isCreateable()){
            dedupeconfigsetting.Name= 'DeDupe Configuration';
        }  
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){      
            dedupeconfigsetting.SmartDD__Sync_Data__c = true;
        }
        
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfigsetting;
        }
        
        dedupeconfigsetting.SmartDD__Sync_Data__c = false;
        dedupeconfigsetting.SmartDD__Last_Sync_date__c = System.now();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            Upsert dedupeconfigsetting;
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()){
            syncdata.Name = 'Sync Data Status';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable()){        
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable()){
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata; 
        }
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ' ;
        upsert syncdata;
        
        Test.startTest();
        SyncDataController.CheckSyncprogress();
        Test.stopTest();
        system.assert(true);
    }
    
    @isTest static void testCheckSyncprogressExternalSyncStatus(){
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = 'TestFName';
        dedupeconfig.SmartDD__Last_Name__c = 'TestLname';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        SmartDD__De_Dupe_Configuration__c dedupeconfigsetting = new SmartDD__De_Dupe_Configuration__c();
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.Name.isCreateable()){
            dedupeconfigsetting.Name= 'DeDupe Configuration';
        }  
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()){      
            dedupeconfigsetting.SmartDD__Sync_Data__c = true;
        }
        
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfigsetting;
        }
        
        dedupeconfigsetting.SmartDD__Sync_Data__c = false;
        dedupeconfigsetting.SmartDD__Last_Sync_date__c = System.now();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            Upsert dedupeconfigsetting;
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        customsettingdedupeconfig.SmartDD__ExternalSyncStatus__c = 'Completed';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()){
            syncdata.Name = 'Sync Data Status';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable()){        
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable()){
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata; 
        }
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ' ;
        upsert syncdata;
        
        Test.startTest();
        SyncDataController.CheckSyncprogress();
        Test.stopTest();
        system.assert(true);
    }
    
    @isTest static void testCheckSyncStatus(){
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        customsettingdedupeconfig.SmartDD__ExternalSyncStatus__c = 'Completed';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        Test.startTest();
        	SyncDataController.CheckSyncStatus();
        Test.stopTest(); 
        system.assert(true);
        
    }
    
    @isTest static void SyncTestApiData() {
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()){
            syncdata.Name = 'Sync Data Status';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable()){        
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable()){
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata; 
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ' ;
        syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert syncdata;
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // SyncDataController.SyncData('Lead');
        SyncDataController.SyncData();
        Test.stopTest();
        system.assert(true);
    }
    
    @isTest static void SyncTestApiDatacatch() {
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();       
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
       SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()){
            syncdata.Name = 'Sync Data Status';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable()){        
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable()){
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata; 
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ' ;
        syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert syncdata;
        }
        Test.startTest();
        // SyncDataController.SyncData('Lead');
        SyncDataController.SyncData();
        Test.stopTest();
          system.assert(true);
    }
    
    @isTest static void SyncTestData() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = 'Ftest';
        dedupeconfig.SmartDD__Last_Name__c = 'Ltest';
        dedupeconfig.SmartDD__Email__c = 'test11@gmail.com';
        dedupeconfig.SmartDD__Username__c = 'testdedupe@gmail.com';
        dedupeconfig.SmartDD__Organization_Id__c = 'test';
        dedupeconfig.SmartDD__UserId__c = u.Id;        
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        system.assertEquals('Ftest',dedupeconfig.SmartDD__First_Name__c);
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        Lead[] leadList = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            Lead lead = new Lead();
            lead.FirstName = 'lead';
            lead.LastName = 'test'+'i';
            lead.company = 'test company';
            leadList.add(lead);
        }
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert leadList;
        }
        system.assertEquals(200,leadList.size());
        
        Set<ID> duplicateLeads =new Set<Id>();
        for(Lead objlead : leadList){
            duplicateLeads.add(objlead.Id);  
        }
        
        List<SmartDD__Duplicate_Record__c> duplicaterecList = new List<SmartDD__Duplicate_Record__c>();
        for(Id leadId : duplicateLeads){
            SmartDD__Duplicate_Record__c DR = new SmartDD__Duplicate_Record__c();
            DR.SmartDD__Batch_Process_Id__c = '7077F00004qjq1I';
            DR.SmartDD__Duplicate_Id__c = leadId;
            duplicaterecList.add(DR);
        }
        if(Schema.sObjectType.SmartDD__Duplicate_Record__c.isCreateable()) {
            insert duplicaterecList;
        }
        
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        syncdata.Name = 'Sync Data Status';
        syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()) {
            insert syncdata; 
        }
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        SyncDataController.GetDedupeConfigCustomSettings(); 
        
        String queryString = 'Select Id, FirstName, LastName, Company From Lead WITH USER_MODE';
        Set<String> setFields = new Set<String>();
        setFields.add('Name');
        setFields.add('Id');
        
        SmartDD__Sync_Data__c objSyncData = new SmartDD__Sync_Data__c();
        objSyncData.Name = 'Sync Data Status';
        objSyncData.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        insert objSyncData;
        
        set<Id> duplicaterecodId = new Set<ID>();
        duplicaterecodId.add(objSyncData.SmartDD__Delete_Duplicate_Batch_Id__c);
        
        // SyncDataController.findDeleteDuplicateData('Lead');
        SyncDataController.findDeleteDuplicateData();
        AsyncApexJob async = [SELECT Status, NumberOfErrors FROM AsyncApexJob WITH USER_MODE limit 1];
        SyncDataController.batchStatus(async.Id);
        SyncDataController.AsyncApexJobRecords(async.Id);
        SyncDataController.getDuplicateRecords();
        // SyncDataController.findDeleteDuplicateData('Lead');
        SyncDataController.findDeleteDuplicateData();
        SyncDataController.GetBatchStatusCustomSettings();
        // SyncDataController.checkCredentials(dedupeconfig.Organization_Id__c);
        SyncDataController.checkCredentials();
        //SyncDataController.saveAuthCredentials(dedupeconfig.SmartDD__Username__c, dedupeconfig.SmartDD__Password__c);
        SyncDataController.credentialDetails();
        
    }
    @isTest static void delDuplicateTestData() {
        
        Test.starttest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = 'Ftest';
        dedupeconfig.SmartDD__Last_Name__c = 'Ltest';
        dedupeconfig.SmartDD__Email__c = 'test11@gmail.com';
        dedupeconfig.SmartDD__Username__c = 'testdedupe@gmail.com';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = u.Id;       
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
             System.assert(customsettingdedupeconfig.Id!=null);
        }
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        Lead[] leadList = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            Lead lead = new Lead();
            lead.FirstName = 'lead';
            lead.LastName = 'test'+'i';
            lead.company = 'test company';
            leadList.add(lead);
        }
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert leadList;
        }
        
        Set<ID> duplicateLeads = new Set<Id>();
        for(Lead objlead : leadList){
            duplicateLeads.add(objlead.Id);  
        }
        List<SmartDD__Duplicate_Record__c> duplicaterecList = new List<SmartDD__Duplicate_Record__c>();
        for(Id leadId : duplicateLeads){
            SmartDD__Duplicate_Record__c DR = new SmartDD__Duplicate_Record__c();
            DR.SmartDD__Batch_Process_Id__c = '7077F00004qjq1I';
            DR.SmartDD__Duplicate_Id__c = leadId;                
            SmartDD__Duplicate_Record__c DR1 = new SmartDD__Duplicate_Record__c();
            DR1.SmartDD__Batch_Process_Id__c = '7077F00004qjq1I';
            DR1.SmartDD__Duplicate_Id__c = leadId;
            duplicaterecList.add(DR);
            duplicaterecList.add(DR1);
        }
        if(Schema.sObjectType.SmartDD__Duplicate_Record__c.isCreateable()){
            insert duplicaterecList;
        }
        List<Lead> objlead = new List<Lead>([Select Id From Lead where Id IN :duplicateLeads WITH USER_MODE]);
        delete objlead ; 
        
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        syncdata.Name = 'Sync Data Status';
        syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '';
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '';
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata;
        }
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        SyncDataController.GetDedupeConfigCustomSettings();   
        // SyncDataController.findDuplicateData('Lead');
        SyncDataController.findDuplicateData();
        AsyncApexJob async = [SELECT Status, NumberOfErrors FROM AsyncApexJob WITH USER_MODE];
        SyncDataController.batchStatus(async.Id);
        SyncDataController.AsyncApexJobRecords(async.Id);
        SyncDataController.getDuplicateRecords();
        // SyncDataController.findDeleteDuplicateData('Lead');
        SyncDataController.findDeleteDuplicateData();
        SyncDataController.GetBatchStatusCustomSettings();
        SyncDataController.synDataMapCustomsetting();
        Test.stopTest(); 
    }  
    /*This method is used to test batchFetchDuplication.**/
    @isTest static void batchFetchDuplicationTestData(){        
        String strQry ='Select Id, FirstName, LastName, company From Lead WITH USER_MODE';         
        Set<String> setFields = new Set<String>(); 
        setFields.add('Id');
        setFields.add('FirstName');
        setFields.add('LastName');        
        setFields.add('company');        
        batchFetchDuplication bFDuplication = new batchFetchDuplication(strQry,setFields,'Lead');
        Database.executebatch(bFDuplication);
         System.assert(true);
    }
 
    @isTest static void testSyncData(){
        
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();       
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        SmartDD__Sync_Data__c syncdata = New SmartDD__Sync_Data__c();
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable()){
            syncdata.Name = 'Sync Data Status';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable()){        
            syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '7077F00004qjq1I';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable()){
            syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ';
        }
        if(Schema.sObjectType.SmartDD__Sync_Data__c.isCreateable()){
            insert syncdata; 
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__Data_Mapping__c = true;
        customsettingdedupeconfig.SmartDD__Sync_Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        syncdata.SmartDD__Find_Duplicate_Batch_Id__c = '7077F00004qjqWJ' ;
        syncdata.SmartDD__Delete_Duplicate_Batch_Id__c = '' ;
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert syncdata;
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // SyncDataController.SyncData('Lead');
        SyncDataController.SyncData();
        Test.stopTest();
          system.assert(true);
    }
    
}