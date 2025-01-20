global class DedupeBatch implements Database.Batchable<SObject>, Database.Stateful  {
	global String objectName; 
    global Id userId;

        global DedupeBatch(String objectName, Id userId) {
        this.objectName = objectName;
        this.userId = userId;
    } 

    global Database.QueryLocator start(Database.BatchableContext BC) { 
        String query = 'SELECT Id FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE IsDuplicate__c = true'; 
        return Database.getQueryLocator(query); 
    } 

    global void execute(Database.BatchableContext BC, List<SObject> scope) { 
        DeduplicationService.processRecords(scope); 
    } 

    global void finish(Database.BatchableContext BC) { 
        System.debug('Batch deduplication process completed.'); 
        
        // Notify the user upon completion
        sendNotification(userId, 'Deduplication process completed successfully for object: ' + objectName);
    } 
    
    // Method to send in-app notification to the user
    private void sendNotification(Id userId, String message) {
        /*try {
            ConnectApi.InAppNotificationInput notification = new ConnectApi.InAppNotificationInput();
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