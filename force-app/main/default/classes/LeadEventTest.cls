@isTest
public class LeadEventTest {
    @isTest
    static void testLeadEventTrigger() {
        Test.startTest();
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            leads.add(new Lead(FirstName = 'Test', LastName = 'Lead' + i, Company = 'TestCompany' + i));
        }
        insert leads;
        
        Set<String> leadIds = new Set<String>();
        for (Lead lead : leads) {
            leadIds.add(lead.Id);
        }

        List<SmartDD__Sync_Tracking__c> syncTrackingRecords = [
            SELECT Id, SmartDD__Record_Id__c, SmartDD__Object_Type__c, SmartDD__Status__c
            FROM SmartDD__Sync_Tracking__c
            WHERE SmartDD__Record_Id__c IN :leadIds
        ];

        System.assertEquals(5, syncTrackingRecords.size(), 'Sync Tracking Records should be created for all Leads');
        Test.stopTest();
    }

    @isTest
    static void testLeadPlatformEventTrigger() {
        SmartDD__Trigger_Configuration__c config = new SmartDD__Trigger_Configuration__c(
            Name = 'SyncLeadTrigger', Active__c = true
        );
        insert config;
        
        Lead testLead = new Lead(FirstName = 'John', LastName = 'Doe', Company = 'Test Company', Status = 'New', Email = 'johndoe@example.com');
        insert testLead;

        List<SmartDD__Lead_Platform_Event__e> events = new List<SmartDD__Lead_Platform_Event__e>();
        for (Integer i = 0; i < 5; i++) {
            events.add(new SmartDD__Lead_Platform_Event__e(SmartDD__Lead_Salesforce_ID__c = testLead.Id));
        }
        EventBus.publish(events);

        Test.startTest();
        Test.stopTest();

        List<SmartDD__Sync_Tracking__c> updatedRecords = [
            SELECT SmartDD__Status__c
            FROM SmartDD__Sync_Tracking__c
            WHERE SmartDD__Status__c = 'Synced'
        ];
        //System.assert(updatedRecords.size() > 0, 'Expected some records to be synced.');
    }
}