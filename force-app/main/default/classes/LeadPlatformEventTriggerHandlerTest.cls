@isTest
public class LeadPlatformEventTriggerHandlerTest {
	@isTest
    static void testUpdateLeads() {
        Lead testLead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company');
        insert testLead;

        SmartDD__Lead_Platform_Event__e testEvent = new SmartDD__Lead_Platform_Event__e(
            SmartDD__Lead_Salesforce_ID__c = testLead.Id
        );
        
        SmartDD__Sync_Tracking__c syncRecord = new SmartDD__Sync_Tracking__c(
            SmartDD__Object_Type__c = 'Lead',
            SmartDD__Status__c = 'Pending',
            SmartDD__Record_Id__c = testLead.Id
        );
        insert syncRecord;

        List<SmartDD__Lead_Platform_Event__e> eventList = new List<SmartDD__Lead_Platform_Event__e>();
        eventList.add(testEvent);

        Test.startTest();
        LeadPlatformEventTriggerHandler.updateLeads(eventList);
        Test.stopTest();
        
        syncRecord = [SELECT Id, SmartDD__Status__c FROM SmartDD__Sync_Tracking__c WHERE Id = :syncRecord.Id];
        System.assertNotEquals(null, syncRecord, 'Sync record should exist after inserting test data.');
        System.assertEquals('Pending', syncRecord.SmartDD__Status__c, 'Sync status should remain Pending before batch processing.');
        List<SmartDD__Sync_Tracking__c> pendingSyncRecords = [
            SELECT Id, SmartDD__Status__c
            FROM SmartDD__Sync_Tracking__c
            WHERE SmartDD__Object_Type__c = 'Lead' AND SmartDD__Status__c = 'Pending'
        ];
        
        System.assert(!pendingSyncRecords.isEmpty(), 'Pending sync records should exist for batch processing.');
        if (!pendingSyncRecords.isEmpty()) {
            syncRecord = [SELECT Id, SmartDD__Status__c FROM SmartDD__Sync_Tracking__c WHERE Id = :syncRecord.Id];
            System.assertEquals('Completed', syncRecord.SmartDD__Status__c, 'Sync status should be completed after batch processing');
        }
    }
}