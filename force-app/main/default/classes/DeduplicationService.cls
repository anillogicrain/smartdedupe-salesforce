public class DeduplicationService {
    /*public static Boolean isProcessing = false; 
    public static void processRecords(List<SObject> records) { 
        if (isProcessing) { 
            return; 
        } 
        isProcessing = true; 
        try { 
            for (SObject record : records) { 
                record.put('IsDuplicate__c', false); // Mark as processed 
            } 
            update records; // Save changes 
        } finally { 
            isProcessing = false; 
        } 
    } */
    
    public static void processRecords(List<SObject> records) {
        // Avoid recursion if triggers might cause re-entry
        Set<Id> processedIds = new Set<Id>();
        
        for (SObject record : records) {
            Id recordId = (Id)
                record.get('Id');
            System.debug('DeduplicationService recordId '+recordId);
            if (!processedIds.contains(recordId)) {
                record.put('IsDuplicate__c', false); // Mark as processed
                processedIds.add(recordId);
            }
        }
        if (!records.isEmpty()) {
            update records; // Save changes
        }
    }
}