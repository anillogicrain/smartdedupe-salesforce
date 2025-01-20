global with sharing class SyncLeadTriggerHandler extends TriggerHandler { //NOPMD
    
   /* public override void afterInsert() {
        syncNewLeadRecord(Trigger.new);
    }
    public static void syncNewLeadRecord(List<Lead> lstNewLeadRec) {
        Set<String> strLeadRecordIds = new Set<String>();  
        List<SmartDD__Sync_Tracking__c> trackingRecords = new List<SmartDD__Sync_Tracking__c>();
        for(Lead objLeadRec : lstNewLeadRec) {
            trackingRecords.add(new SmartDD__Sync_Tracking__c(
                SmartDD__Record_Id__c = objLeadRec.Id,
                SmartDD__Object_Type__c = 'Lead',
                SmartDD__Status__c = 'Pending'
            ));  
        }
        if(trackingRecords.size () > 0){
            
            insert trackingRecords;
            if (trackingRecords.size() == lstNewLeadRec.size()) {                              
                Database.executeBatch(new LeadPlateformEventHandler(),1000);
            }
        }
    }    
    public static Integer getFlexQueueSize() {
        // Query to count the number of jobs in the Flex Queue
        List<AsyncApexJob> jobs = [
            SELECT Id
            FROM AsyncApexJob
            WHERE Status = 'Holding'
        ];
        
        // Return the size of the Flex Queue
        return jobs.size();
    }
    public static void checkFlexQueue() {
        Integer flexQueueSize = getFlexQueueSize();
        System.debug('Current Flex Queue size: ' + flexQueueSize);
        
        // Add your logic here to handle the queue size
        if (flexQueueSize >= 100) {
            System.debug('Flex Queue is full. Please wait before submitting new jobs.');
        } else {
            System.debug('Flex Queue has space for more jobs.');
            Database.executeBatch(new LeadPlateformEventHandler(),1000);
        }
    }  */
}