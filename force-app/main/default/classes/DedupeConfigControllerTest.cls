/**************************************************************************
* Test Class: DedupeConfigControllerTestClass
* dateCreated : 2018-10-03
*
* Purpose/Methods:
* - Code coverage Test class of the DedupeConfigController class
*
* Unit Test: {Dedupe Configuration & Field Mapping} 
*
***************************************************************************/
@IsTest
public with sharing class DedupeConfigControllerTest {
    static testMethod void dedupeConfigTest() {
       
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
        dedupeconfig.SmartDD__SF_Import_Consumer_Key__c = 'Test';
        dedupeconfig.SmartDD__SF_Import_Consumer_Secret__c = 'Test';
        dedupeconfig.SmartDD__Training_File_Consumer_Key__c = 'Test';
        dedupeconfig.SmartDD__Training_File_Consumer_Secret__c = 'Test';
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__SF_Import_Consumer_Key__c = 'Test';
        customsettingdedupeconfig.SmartDD__SF_Import_Consumer_Secret__c = 'Test';
        customsettingdedupeconfig.SmartDD__Training_File_Consumer_Key__c = 'Test';
        customsettingdedupeconfig.SmartDD__Training_File_Consumer_Secret__c = 'Test';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        Id [] fixedSearchResults = new Id[]{u.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        boolean result = DedupeConfigController.searchUser('testdedupe@gmail.com','test11@gmail.com');
        System.assertEquals(true, result); 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        DedupeConfigController.getUserProfileName();
        DedupeConfigController.getDedupeConfig();
        DedupeConfigController.saveDedupeConfig(dedupeconfig,true);
        DedupeConfigController.dedupeConfigCustomsetting();
        //DedupeConfigController.postDedupeAuthRecords('hello');
        DedupeConfigController.checkCredentials('SmartDD__Dedupe_Configuration__c');
       
    }
    static testMethod void dedupeConfigTesttosetnullUserId() {
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = '';
        dedupeconfig.SmartDD__Last_Name__c = '';
        dedupeconfig.SmartDD__Email__c = '';
        dedupeconfig.SmartDD__Username__c = '';
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = userInfo.getUserId();        
        dedupeconfig.SmartDD__SF_Import_Consumer_Key__c = 'Test';
        dedupeconfig.SmartDD__SF_Import_Consumer_Secret__c = 'Test';
        dedupeconfig.SmartDD__Training_File_Consumer_Key__c = 'Test';
        dedupeconfig.SmartDD__Training_File_Consumer_Secret__c = 'Test';
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        customsettingdedupeconfig.SmartDD__SF_Import_Consumer_Key__c = 'Test';
        customsettingdedupeconfig.SmartDD__SF_Import_Consumer_Secret__c = 'Test';
        customsettingdedupeconfig.SmartDD__Training_File_Consumer_Key__c = 'Test';
        customsettingdedupeconfig.SmartDD__Training_File_Consumer_Secret__c = 'Test';
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
        }
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DedupeConfigController.getDedupeConfig();
        Test.startTest();
        DedupeConfigController.saveDedupeConfig(dedupeconfig,true);
        Test.stopTest();
        System.assert(true);
    }
    }