public class CustomQueueManager {
    public static void addToQueue(List<Lead> leads) {
        List<SmartDD__Sync_Tracking__c> queueEntries = new List<SmartDD__Sync_Tracking__c>();
		system.debug('entry in queue');
        for (Lead lead : leads) {
            queueEntries.add(new SmartDD__Sync_Tracking__c(SmartDD__Record_Id__c = lead.Id, SmartDD__Sync_Status__c = 'New'));
        }
        system.debug('L8 queueEntries >>> '+queueEntries);
        insert queueEntries;
        processQueue();
    }
    
    // Method to get the size of the Flex Queue
    public static Integer getFlexQueueSize() {
        List<AsyncApexJob> jobs = [
            SELECT Id
            FROM AsyncApexJob
            WHERE Status = 'Holding'
        ];
        system.debug('L20 jobs >>> '+jobs);
        return jobs.size();
    }


    public static void processQueue() {
        Integer flexQueueSize = getFlexQueueSize();
        
         List<SmartDD__Sync_Tracking__c> pendingQueueEntries = [ SELECT Id, SmartDD__Record_Id__c
                                                               FROM SmartDD__Sync_Tracking__c
                                                               WHERE SmartDD__Sync_Status__c = 'Processing'
                                                                ];
        if (flexQueueSize < 100) {
            if (!pendingQueueEntries.isEmpty()) {
                System.debug('L34 CustomQueueManager ---> pendingQueueEntries is empty, batch class entry');
                MyBatchClass batch = new MyBatchClass(pendingQueueEntries);
                Database.executeBatch(batch, 1000);
                 System.debug('33 CustomQueueManager --->'+pendingQueueEntries);
            }
            if(pendingQueueEntries.isEmpty()){
                System.debug('L39 CustomQueueManager ---> pendingQueueEntries is empty');
                List<SmartDD__Sync_Tracking__c> queueEntries = [
                    SELECT Id, SmartDD__Record_Id__c
                    FROM SmartDD__Sync_Tracking__c
                    WHERE SmartDD__Sync_Status__c = 'New'
                    LIMIT : (100 - flexQueueSize) * 200
                ];
                
                for (SmartDD__Sync_Tracking__c entry : queueEntries) {
                    entry.SmartDD__Sync_Status__c = 'Processing';
                }
                system.debug('L51 queueEntries >>> '+queueEntries);
                update queueEntries;
                
                if (!queueEntries.isEmpty()) {
                    System.debug('L34 CustomQueueManager ---> queueEntries is empty, batch class entry');
                    MyBatchClass batch = new MyBatchClass(queueEntries);
                    Database.executeBatch(batch, 1000);
                }
            }    
        }
    }
}