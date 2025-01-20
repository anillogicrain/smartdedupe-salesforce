global class LeadEventTriggerHelper { 
   /* global static List<Lead> lstLead = new List<Lead>();
   // public static Map<Id, Lead> oldLead = new Map<Id,Lead>();
	
    global static void leadInserted(set<Id> setLeadIds){      
        List<SmartDD__Sync_Tracking__c> leadSyncRecords = new List<SmartDD__Sync_Tracking__c>();       
        List<SmartDD__Sync_Tracking__c> lstSyncTracking =  [SELECT Id, Name, SmartDD__Record_Id__c,  SmartDD__Object_Type__c,SmartDD__Status__c 
                                                            FROM SmartDD__Sync_Tracking__c  
                                                            WHERE SmartDD__Object_Type__c= 'Lead' 
                                                            AND SmartDD__Status__c = 'Pending' 
                                                            AND SmartDD__Record_Id__c IN : setLeadIds];
          
            system.debug('LeadEventTriggerHelper Sync Tracking Records: '+lstSyncTracking);
            
           if (lstSyncTracking != null && lstSyncTracking.size() > 0) {
                leadSyncRecords.addAll(lstSyncTracking);
            }
            
        if (lstSyncTracking != null && lstSyncTracking.size() > 0 ) {
            LeadSyncHandler.syncLeadRecords(leadSyncRecords);
        }
    }*/
}