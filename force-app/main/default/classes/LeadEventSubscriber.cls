public class LeadEventSubscriber {
 	
    /*@InvocableMethod(label='Get Event Record')
    public static void handleLeadLoaded(List<SmartDD__Lead_Platform_Event__e> events) {
        List<Id> leadIds = new List<Id>();
        System.debug('5 : events --> '+events);
        for (SmartDD__Lead_Platform_Event__e event : events) {
            if (event.SmartDD__Lead_Salesforce_ID__c != null) {
                leadIds.add(event.SmartDD__Lead_Salesforce_ID__c);
            }    
        }
        
        // Add leads to custom queue or process directly
        if (!leadIds.isEmpty()) {
        	CustomQueueManager.addToQueue([SELECT Id FROM Lead WHERE Id IN :leadIds]); System.debug('13 LeadEventSubscriber : Queue --> '+leadIds);
        } else {
            System.debug('No valid Lead IDs found to process.');
        }    
    }*/
    
    
}