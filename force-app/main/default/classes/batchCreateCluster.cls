global with sharing class batchCreateCluster implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public String strCreateQuery;
    public String strObjectNamePrm;
    public String strNewMasterClusterId;
    public String userid = '';
    public String organizationid = '';
    public String JSONFieldFilterStr = '';      //NOPMD
    public SmartDD__Dedupe_Log__c objDedupeLogsPrm; 
    
    public batchCreateCluster(String strObjName, String newMasterClusterId, SmartDD__Dedupe_Log__c objDedupeLogs) {
        strObjectNamePrm = strObjName;
        strNewMasterClusterId = newMasterClusterId;
        objDedupeLogsPrm = objDedupeLogs;
        strCreateQuery =  'SELECT SmartDD__External_Cluster_Id__c,SmartDD__Cluster_Object_Id__c,SmartDD__Confidence_Score__c,SmartDD__Cluster_Record_External_Id__c,SmartDD__Object_Name__c,SmartDD__Master_Cluster_Record_Id__c FROM SmartDD__All_CLuster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c = \'' + strNewMasterClusterId + '\' WITH USER_MODE';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(strCreateQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<SmartDD__All_CLuster_Record__c> lstClusterRecs) {
        List<SmartDD__Cluster__c> lstClustersParent = new List<SmartDD__Cluster__c>();  
                    
        Set<Integer> setClusterRecords = new Set<Integer>(); 
        Set<Integer> setTableClustersRec = new Set<Integer>();
        Set<Integer> setClusterExternalIds = new Set<Integer>(); 
        
        // Prepare a set of External cluster Id to match with the existing records in Cluster Table.
        for(SmartDD__All_CLuster_Record__c objClusterRec :lstClusterRecs){
            setClusterExternalIds.add(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c));
        } 
        
        List<SmartDD__Cluster__c> lstParentClusterRecs = new List<SmartDD__Cluster__c>();  
        lstParentClusterRecs = [Select ID, SmartDD__External_Cluster_Id__c FROM Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =:strNewMasterClusterId AND SmartDD__External_Cluster_Id__c IN: setClusterExternalIds WITH USER_MODE];
        
        for(SmartDD__Cluster__c objClusterRecs : lstParentClusterRecs) {
            setTableClustersRec.add(Integer.ValueOf(objClusterRecs.SmartDD__External_Cluster_Id__c));
        } 
        
        for(SmartDD__All_CLuster_Record__c objClusterRec :lstClusterRecs){
            /* To match with existing Cluster_Id & store Cluster Ids in Parent Table */
            SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
            if(!setTableClustersRec.contains(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c))){
                //objCluster.All_Cluster_Record__c = objClusterRec.Id;
                objCluster.SmartDD__External_Cluster_Id__c = objClusterRec.SmartDD__External_Cluster_Id__c;
                objCluster.SmartDD__Confidence_Score__c = objClusterRec.SmartDD__Confidence_Score__c;
                objCluster.SmartDD__Object_Name__c = objClusterRec.SmartDD__Object_Name__c;
                objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                lstClustersParent.add(objCluster); 
            }
            setClusterRecords.add(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c));
        }
        
        /* Insert Records in Parent Object Cluster__c */
        if(lstClustersParent.size() > 0)
        {
            if((Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isCreateable())||
               (Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__Master_Cluster_Record_Id__c.isCreateable())||
               (Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__Object_Name__c.isCreateable())||
              (Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__Confidence_Score__c.isCreateable()))
            {
                SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstClustersParent); 
                insert decision.getRecords();
            }
        } 
        Map<Integer, String> mapExternalClusterId = new Map<Integer,String>();
        List<SmartDD__Child_Cluster_Record__c> lstChildClusterInsert = new List<SmartDD__Child_Cluster_Record__c>();  
        List<SmartDD__Cluster__c> lstParentClusters = [Select Id,SmartDD__External_Cluster_Id__c,SmartDD__Master_Cluster_Record_Id__c From SmartDD__Cluster__c WHERE SmartDD__External_Cluster_Id__c IN: setClusterRecords AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        
        /* Creating Map of Java ClusterId and Salesforce ClusterId */
        for(SmartDD__Cluster__c objClusters: lstParentClusters) {
            if(objClusters.SmartDD__External_Cluster_Id__c != null) {
                mapExternalClusterId.put(integer.ValueOf(objClusters.SmartDD__External_Cluster_Id__c), objClusters.Id);
            }
        }
        
        /* To Insert Records in Child Object */
        for(SmartDD__All_CLuster_Record__c objClusterRec :lstClusterRecs){
            SmartDD__Child_Cluster_Record__c objChildClusters = new SmartDD__Child_Cluster_Record__c();
            objChildClusters.SmartDD__Cluster_Object_Id__c = objClusterRec.SmartDD__Cluster_Object_Id__c;
            objChildClusters.SmartDD__Cluster_Record_External_Id__c = objClusterRec.SmartDD__Cluster_Record_External_Id__c;
            objChildClusters.SmartDD__Object_Name__c = objClusterRec.SmartDD__Object_Name__c;
            objChildClusters.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
            if(mapExternalClusterId.get(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c)) != ''){
                objChildClusters.SmartDD__Cluster_Id__c = mapExternalClusterId.get(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c));
                lstChildClusterInsert.add(objChildClusters);
            }
        }
        if((Schema.sObjectType.SmartDD__All_CLuster_Record__c.fields.SmartDD__External_Cluster_Id__c.isAccessible())||
           (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Master_Cluster_Record_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Master_Cluster_Record_Id__c.isAccessible())||
          (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Object_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isCreateable())||
          (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isAccessible())||
          (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Object_Id__c.isCreateable())||
          (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isCreateable())||
          (Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isAccessible()))
        {
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstChildClusterInsert); 
            insert decision.getRecords(); 
        }
        
        
        Integer totalClustersGroup = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        objDedupeLogsPrm.SmartDD__Total_CLusters_Created__c = totalClustersGroup;
        List<SmartDD__Dedupe_Log__c> lstObjDedupeLogsPrm= new List<SmartDD__Dedupe_Log__c>();
        lstObjDedupeLogsPrm.add(objDedupeLogsPrm);
        
        if(Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable() || (Schema.sObjectType.SmartDD__Dedupe_Log__c.fields.SmartDD__Total_CLusters_Created__c.isCreateable() && Schema.sObjectType.SmartDD__Dedupe_Log__c.fields.SmartDD__Total_CLusters_Created__c.isUpdateable())) {
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDedupeLogsPrm);   
            upsert decision.getRecords();
        }
        
        SmartDD__Filter_Data__c filterRecs = SmartDD__Filter_Data__c.getInstance(strObjectNamePrm);
        if(filterRecs != null) {
            filterRecs.name = strObjectNamePrm;  
            filterRecs.SmartDD__Object_Name__c = strObjectNamePrm;
            filterRecs.SmartDD__Unique_Cluster_Saved__c = false;    
            if((Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isUpdateable())||(Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isUpdateable())||(Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isUpdateable()))
            {
                upsert filterRecs;
            }
        } else {
            SmartDD__Filter_Data__c filterRecsNew = new SmartDD__Filter_Data__c();
            filterRecsNew.name = strObjectNamePrm;  
            filterRecsNew.SmartDD__Object_Name__c = strObjectNamePrm;
          
            filterRecsNew.SmartDD__Unique_Cluster_Saved__c = false;   
            if((Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.name.isUpdateable())||(Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isUpdateable())||(Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isUpdateable()))
            {
                 upsert filterRecsNew;
            }   
        }
        
    }
    
    global void finish(Database.BatchableContext bc) {
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                SmartDD__Last_Name__c,   SmartDD__First_Name__c
                                                                                        FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        if(lstAuthorizedUser.size() > 0){
            userid = lstAuthorizedUser[0].SmartDD__UserId__c;
            organizationid = lstAuthorizedUser[0].SmartDD__Organization_Id__c; 
        }                                                                                        
        JSONFieldFilterStr += '{';
        JSONFieldFilterStr += '"Object Name":"' + strObjectNamePrm + '",';
        JSONFieldFilterStr += '"Organization Id":"' + organizationid + '",';
        JSONFieldFilterStr += '"UserId":"' + userid + '"';
        JSONFieldFilterStr += '}';
        system.debug('@#$JSONFieldFilterStr: '+JSONFieldFilterStr);
        httpJSONRequest(System.Label.SFImportAPI+'/cluster/statusUpdate', JSONFieldFilterStr);
         
    }
    
    //Http Request Body
    //@Future(callout=true)
    public static Void httpJSONRequest(String strEndPoint, string strBody) {
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setEndpoint(strEndPoint);
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes: >>>>'+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: >>>>'+jsonString);
            
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
            
        }
        
    } 
}