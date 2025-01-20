global class LeadSyncHandler{
    public static void syncLeadRecords(List<SmartDD__Sync_Tracking__c> leadSyncRecords){
        
        for(SmartDD__Sync_Tracking__c syncTrackingRecords : leadSyncRecords){
            system.debug('syncTrackingRecords :-->'+syncTrackingRecords);
            String errMsg = '';
            String apexError = '';
            String endPoint = System.Label.SFImportAPI+'/object/updateData';
            
            Http http = new Http();
            HttpRequest objHTTPRequest = new HttpRequest();
            objHTTPRequest.setTimeout(120000);
            objHTTPRequest.setMethod('POST');
            objHTTPRequest.setHeader('Content-Type', 'application/json');
            objHTTPRequest.setBody(JSON.serialize(syncTrackingRecords));
            objHTTPRequest.setEndpoint(endPoint);
            
            try{
                HttpResponse response = http.send(objHTTPRequest);
                System.debug(' LeadSyncHandler response: '+response);
                if (response.getStatusCode() == 200){
                    syncTrackingRecords.SmartDD__Status__c = 'Synced';
                    System.debug('Synced successfully: ' + response.getBody());
                } else{
                    syncTrackingRecords.SmartDD__Status__c = 'Error';
                    System.debug('Failed to sync: ' + response.getBody());
                }
            } catch (exception e){
                errMsg = 'Something went wrong';
                apexError = e.getMessage() + ',' + '  Line No: ' + e.getLineNumber() + ',' + e.getStackTraceString();
                System.debug(apexError);
            }
        }
        
         update leadSyncRecords;
    }
}