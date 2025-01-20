@isTest
public class LeadSyncBatchTest {
	@testSetup
    static void setupTestData() {
        List<SmartDD__Sync_Tracking__c> syncTrackingRecords = new List<SmartDD__Sync_Tracking__c>();
        for (Integer i = 0; i < 5; i++) {
            Lead lead = new Lead(FirstName = 'Test', LastName = 'User ' + i, Company = 'TestCompany');
            insert lead;
            
            syncTrackingRecords.add(new SmartDD__Sync_Tracking__c(
                SmartDD__Record_Id__c = lead.Id,
                SmartDD__Status__c = 'Pending'
            ));
        }
        insert syncTrackingRecords;

        insert new SmartDD__Dedupe_Configuration__c(
            SmartDD__UserId__c = 'TestUserId',
            SmartDD__Organization_Id__c = 'TestOrgId',
            SmartDD__Username__c = 'TestUser',
            SmartDD__Email__c = 'testuser@example.com',
            SmartDD__First_Name__c = 'Test',
            SmartDD__Last_Name__c = 'User'
        );

        insert new SmartDD__Search_Column__c(
            SmartDD__Object_Name__c = 'Lead',
            SmartDD__Search_Object_Fields__c = 'FirstName,LastName,Email'
        );
    }
    
    @isTest
    static void testLeadSyncBatch() {
        Set<Id> syncTrackingIds = new Set<Id>();
        for (SmartDD__Sync_Tracking__c record : [SELECT Id FROM SmartDD__Sync_Tracking__c]) {
            syncTrackingIds.add(record.Id);
        }

        Test.startTest();
        LeadSyncBatch batch = new LeadSyncBatch(syncTrackingIds);
        Test.setMock(HttpCalloutMock.class, new LeadSyncHttpMock());
        Database.executeBatch(batch);
        Test.stopTest();

        for (SmartDD__Sync_Tracking__c record : [SELECT SmartDD__Status__c FROM SmartDD__Sync_Tracking__c]) {
            System.assertEquals('Synced', record.SmartDD__Status__c, 'Record should be marked as Synced');
        }
    }
    
    @isTest
    static void testErrorHandling() {
        Set<Id> syncTrackingIds = new Set<Id>();
        for (SmartDD__Sync_Tracking__c record : [SELECT Id FROM SmartDD__Sync_Tracking__c]) {
            syncTrackingIds.add(record.Id);
        }

        Test.startTest();
        LeadSyncBatch batch = new LeadSyncBatch(syncTrackingIds);
        Test.setMock(HttpCalloutMock.class, new LeadSyncErrorHttpMock());
        Database.executeBatch(batch);
        Test.stopTest();

        for (SmartDD__Sync_Tracking__c record : [SELECT SmartDD__Status__c FROM SmartDD__Sync_Tracking__c]) {
            System.assertEquals('Error', record.SmartDD__Status__c, 'Record should be marked as Error');
        }
    }
    
    //Mock class
    private class LeadSyncHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }
    
    private class LeadSyncErrorHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(401);
            res.setBody('{"status":"error"}');
            return res;
        }
    }
}