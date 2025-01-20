trigger LeadEventTrigger on Lead (after insert, after update) {
    List<SmartDD__Lead_Platform_Event__e> leadPlatformEvents = new List<SmartDD__Lead_Platform_Event__e>();
    List<SmartDD__Sync_Tracking__c> syncTrackingRecords = new List<SmartDD__Sync_Tracking__c>();
    
    for (Lead leadEventRecord : Trigger.new) {
        leadPlatformEvents.add(new SmartDD__Lead_Platform_Event__e(SmartDD__Lead_Salesforce_ID__c = leadEventRecord.Id));
        // syncTrackingRecords.add(new SmartDD__Sync_Tracking__c(SmartDD__Record_Id__c = leadEventRecord.Id, SmartDD__Object_Type__c = 'Lead', SmartDD__Status__c = 'Pending'));
    }
    
    for (Lead leadEventRecord : Trigger.new) {
        //leadPlatformEvents.add(new SmartDD__Lead_Platform_Event__e(SmartDD__Lead_Salesforce_ID__c = leadEventRecord.Id));
        syncTrackingRecords.add(new SmartDD__Sync_Tracking__c(SmartDD__Record_Id__c = leadEventRecord.Id, SmartDD__Object_Type__c = 'Lead', SmartDD__Status__c = 'Pending'));
    }
    
    if (!syncTrackingRecords.isEmpty()) {
        system.debug('LeadEventTrigger inserting sync tracking records -----');
        insert syncTrackingRecords;
    }
    
    if (!leadPlatformEvents.isEmpty()) {
        system.debug('LeadEventTrigger  -----');
        EventBus.publish(leadPlatformEvents);
    } 
}