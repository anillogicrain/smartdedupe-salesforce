// Queueable Apex Class
public class DedupeQueueable implements Queueable, Database.AllowsCallouts {
    private String objectName;
    private Id userId;
    
    public DedupeQueueable(String objectName, Id userId) {
        this.objectName = objectName;
        this.userId = userId;
    }
    
    public void execute(QueueableContext context) {
        try {
            if (!Schema.getGlobalDescribe().containsKey(objectName)) {
                System.debug('IllegalArgumentException '+!Schema.getGlobalDescribe().containsKey(objectName));
                throw new IllegalArgumentException('Invalid object name: ' + objectName);
            }
            
            // Build dynamic SOQL query to count duplicate records
            String countQuery = 'SELECT COUNT() FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE IsDuplicate__c = true';
            System.debug('countQuery '+countQuery);
            Integer recordCount = Database.countQuery(countQuery);
            System.debug('recordCount '+recordCount);
            
            if (recordCount == 0) {
                System.debug('No duplicate records found.');
                // Notify the user that no duplicates were found
                sendNotification(userId, 'No duplicate records found for object: ' + objectName);
                return;
            }
            
            // Decide on processing method based on record count
            if (recordCount <= 200) {
                // Small dataset: Process synchronously
                System.debug('recordCount less than or equal to 200 '+recordCount);
                String recordsQuery = 'SELECT Id FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE IsDuplicate__c = true LIMIT 200';
                System.debug('DQ L35recordsQuery '+recordsQuery);
                List<SObject> records = Database.query(recordsQuery);
                DeduplicationService.processRecords(records);
                System.debug('Dedupe Queue L39 processed records: '+ records);
                
                // Notify the user upon completion
                sendNotification(userId, 'Deduplication completed successfully for object: ' + objectName);
            } else {
                // Large dataset: Use Batch Apex
                DedupeBatch batch = new DedupeBatch(objectName, userId);
                Database.executeBatch(batch, 200);
            }
        } catch (Exception e) {
            System.debug('Error in DedupeQueueable: ' + e.getMessage());
            // Notify the user about the error
            sendNotification(userId, 'An error occurred during deduplication: ' + e.getMessage());
        }
    }
    
    // Method to send in-app notification to the user
    private void sendNotification(Id userId, String message) {
        /*try {
            ConnectApi.FeedItemInput notification = new ConnectApi.FeedItemInput();
            notification.Body = message;
            notification.Title = 'Deduplication Process Notification';
            notification.NotificationType = ConnectApi.NotificationType.Generic;
            notification.SenderId = UserInfo.getUserId();
            
            // Send the notification
            ConnectApi.Notifications.send(UserInfo.getOrganizationId(), userId, notification);
        } catch (Exception ex) {
            System.debug('Error sending in-app notification: ' + ex.getMessage());
            // Handle exceptions related to sending notifications if necessary
        }*/
        
        try {
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.body = new ConnectApi.MessageBodyInput();
            feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = message;
            feedItemInput.body.messageSegments.add(textSegment);
            
            // Post the feed item to the user's feed
            ConnectApi.ChatterFeeds.postFeedElement(null, userId, ConnectApi.FeedElementType.FeedItem, null);
        } catch (Exception ex) {
            System.debug('Error sending in-app notification: ' + ex.getMessage());
            // Handle exceptions related to sending notifications if necessary
        }
    }
}