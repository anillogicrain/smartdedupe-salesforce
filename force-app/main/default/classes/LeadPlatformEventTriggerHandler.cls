public class LeadPlatformEventTriggerHandler {
    public static List<SmartDD__Lead_Platform_Event__e> lstLeadPlatformEvent = new List<SmartDD__Lead_Platform_Event__e>();

    /*public static void afterInsert(){
        system.debug('Event Handler : After Insert  ');        
        LeadPlatformEventTriggerHelper.updateLeads(lstLeadPlatformEvent);
    }*/
    
    public static void updateLeads(List<SmartDD__Lead_Platform_Event__e> lstLeadPlatformEvent){
        system.debug('Platform Event Handler : After Insert from trigger');
        Set<Id> setLeadIds = new Set<Id>();
        for(SmartDD__Lead_Platform_Event__e objEvent: lstLeadPlatformEvent){            
            setLeadIds.add(objEvent.SmartDD__Lead_Salesforce_ID__c);            
        }
        
        system.debug('L16 LeadPlatformEventTriggerHandler setLeadIds: '+setLeadIds);
        
        if(setLeadIds.size() > 0){   
            List<SmartDD__Sync_Tracking__c> pendingSyncRecords = [
                SELECT Id, SmartDD__Record_Id__c, SmartDD__Status__c
                FROM SmartDD__Sync_Tracking__c
                WHERE SmartDD__Object_Type__c = 'Lead' AND SmartDD__Status__c = 'Pending' AND SmartDD__Record_Id__c IN :setLeadIds];
            
            system.debug('L24 LeadPlatformEventTriggerHandler pendingSyncRecords: '+pendingSyncRecords);
            
            if (!pendingSyncRecords.isEmpty()) {
                Set<Id> pendingSyncRecordIds = new Set<Id>();
                for (SmartDD__Sync_Tracking__c record : pendingSyncRecords) {
                    pendingSyncRecordIds.add(record.Id);
                }
                system.debug('L31 LeadPlatformEventTriggerHandler pendingSyncRecordIds: '+pendingSyncRecordIds);
                system.debug('L32 LeadPlatformEventTriggerHandler pendingSyncRecords is not empty :----- going to LeadSyncHandler');
                //LeadSyncHandler.syncLeadRecords(pendingSyncRecordIds);
                Database.executeBatch(new LeadSyncBatch(pendingSyncRecordIds),200);
            }
        }
    }
}