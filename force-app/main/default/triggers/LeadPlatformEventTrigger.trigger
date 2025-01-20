trigger LeadPlatformEventTrigger on SmartDD__Lead_Platform_Event__e (after insert) {
    
      SmartDD__Trigger_Configuration__c triggerActive = SmartDD__Trigger_Configuration__c.getInstance('SyncLeadTrigger');
    
    if(triggerActive != null && triggerActive.Active__c){
        
        //LeadPlatformEventTriggerHandler.lstLeadPlatformEvent = Trigger.New;        
        
        if(Trigger.isAfter && Trigger.isInsert){
            system.debug('After Insert : publish SmartDD__Lead_Platform_Event__e ');
            
            LeadPlatformEventTriggerHandler.updateLeads(Trigger.New);            
        }
    }	

}