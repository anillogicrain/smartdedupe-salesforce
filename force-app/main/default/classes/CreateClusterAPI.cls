@RestResource(urlMapping='/CreateCluster')
global with sharing class CreateClusterAPI {     // NOPMD
    @HttpPost
    global static String fnSaveClusterData() {   // NOPMD
        //string strjson = '[{ "clusterid": "1", "leadid": "00Qf400000ENV5sEAH", "recordid": "151138" }, { "clusterid": "1", "leadid": "00Qf400000ENVRbEAP", "recordid": "151139" }, { "clusterid": "2", "leadid": "00Qf400000ENVUjEAP", "recordid": "151140" }]';
        //string strjson = '[{"totalRecords":"145","totalTrainingRecords":"125","objectName":"Lead","trainingFileName":"ab8bc3eb-762c-4ab4-a0e8-1fe891c93aa3.json"}]';
        string strjson = RestContext.request.requestBody.toString();
        system.debug('strjson = ' +strjson);
        if(!String.isBlank(strjson)) {
            try {  
                List<insertClusterWrapper> lstWrpCluster = (List<insertClusterWrapper>) JSON.deserialize(strjson,List<insertClusterWrapper>.class);
                String strObjName = 'Lead';
                Integer totalRecords = null;
                Integer trainingFileRecordCount = null;
                String strTrainingFileName = '';
                String strNewMasterClusterId = '';
                for(insertClusterWrapper objWrpRecPrm :lstWrpCluster) {
                    strObjName = objWrpRecPrm.objectName;
                    totalRecords = objWrpRecPrm.totalRecords;
                    trainingFileRecordCount = objWrpRecPrm.totalTrainingRecords;
                    strTrainingFileName = objWrpRecPrm.trainingFileName;
                }
                SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                dedupeConfig.SmartDD__Clusters_Created_Stat__c = false;
                dedupeConfig.SmartDD__Total_CLusters_Created__c = totalRecords;
                dedupeConfig.SmartDD__Manage_Cluster_BatchId__c = '';
                if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()) {
                    upsert dedupeConfig;
                } 
                SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjName);
                if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
                    strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
                }
                
                // Code to add logs in Dedupe Log Object.
                List<SmartDD__Dedupe_Log__c> lstObjDedupeLogs=new List<SmartDD__Dedupe_Log__c>();
                SmartDD__Dedupe_Log__c objDedupeLogs = new SmartDD__Dedupe_Log__c();
                objDedupeLogs.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                objDedupeLogs.SmartDD__Requested_On_Object__c = strObjName;
                objDedupeLogs.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                objDedupeLogs.SmartDD__Time_Of_Request__c = Datetime.now();
                objDedupeLogs.SmartDD__Type_Of_Request__c = 'Cluster List Request';
                objDedupeLogs.SmartDD__Total_Records_Operated__c = dedupeConfig.SmartDD__Total_Records_Deduped__c;
                objDedupeLogs.SmartDD__Training_File_Records_Count__c = trainingFileRecordCount;
                objDedupeLogs.SmartDD__Training_File_Name__c = strObjName + '_' + strTrainingFileName;
                
                List<SmartDD__All_CLuster_Record__c> lstClusterRecs = new List<SmartDD__All_CLuster_Record__c>([SELECT SmartDD__External_Cluster_Id__c,SmartDD__Cluster_Object_Id__c,SmartDD__Confidence_Score__c,SmartDD__Cluster_Record_External_Id__c,SmartDD__Object_Name__c,SmartDD__Master_Cluster_Record_Id__c FROM SmartDD__All_CLuster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE LIMIT 2000]);  
                Integer totalClusters = Database.countQuery('SELECT count() FROM SmartDD__All_CLuster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
                system.debug('@#$totalClusters: '+totalClusters);
                if(totalClusters < 2000) {
                    List<SmartDD__Cluster__c> lstClustersParent = new List<SmartDD__Cluster__c>();  
                    Set<Integer> setClusterRecords = new Set<Integer>(); 
                    Set<Integer> setTableClustersRec = new Set<Integer>(); 
                    
                    List<SmartDD__Cluster__c> lstParentClusterRecs = new List<SmartDD__Cluster__c>();  
                    lstParentClusterRecs = [Select ID, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =:strNewMasterClusterId WITH USER_MODE];
                    
                    for(SmartDD__Cluster__c objClusterRecs : lstParentClusterRecs) {
                        setTableClustersRec.add(Integer.ValueOf(objClusterRecs.SmartDD__External_Cluster_Id__c));
                    } 
                    
                    for(SmartDD__All_CLuster_Record__c objClusterRec :lstClusterRecs){
                        /* To match with existing Cluster_Id & store Cluster Ids in Parent Table */
                        SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
                        if(!setTableClustersRec.contains(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c))){
                            //objCluster.All_Cluster_Record__c = objClusterRec.Id;
                            objCluster.SmartDD__External_Cluster_Id__c = objClusterRec.SmartDD__External_Cluster_Id__c;objCluster.SmartDD__Confidence_Score__c = objClusterRec.SmartDD__Confidence_Score__c;objCluster.SmartDD__Object_Name__c = objClusterRec.SmartDD__Object_Name__c;objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;lstClustersParent.add(objCluster); 
                        }
                        setClusterRecords.add(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c));
                    }
                    
                    
                    /* Insert Records in Parent Object Cluster__c */
                    if(lstClustersParent.size() > 0 && Schema.sObjectType.SmartDD__Cluster__c.isCreateable() ) {
                        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstClustersParent);     
                        insert decision.getRecords();
                    }
                    
                    Map<Integer, String> mapExternalClusterId = new Map<Integer,String>();
                    List<SmartDD__Child_Cluster_Record__c> lstChildClusterInsert = new List<SmartDD__Child_Cluster_Record__c>();  
                    List<SmartDD__Cluster__c> lstParentClusters = [Select Id,SmartDD__External_Cluster_Id__c,SmartDD__Master_Cluster_Record_Id__c From SmartDD__Cluster__c WHERE SmartDD__External_Cluster_Id__c IN :setClusterRecords AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
                    
                    /* Creating Map of Java ClusterId and Salesforce ClusterId */
                    for(SmartDD__Cluster__c objClusters: lstParentClusters) {
                        if(objClusters.SmartDD__External_Cluster_Id__c != null) {
                            mapExternalClusterId.put(integer.ValueOf(objClusters.SmartDD__External_Cluster_Id__c), objClusters.Id);
                        }
                    }
                    
                    /* To Insert Records in Child Object */
                    for(SmartDD__All_CLuster_Record__c objClusterRec :lstClusterRecs){
                        SmartDD__Child_Cluster_Record__c objChildClusters = new SmartDD__Child_Cluster_Record__c();
                        objChildClusters.SmartDD__Cluster_Object_Id__c = objClusterRec.SmartDD__Cluster_Object_Id__c;objChildClusters.SmartDD__Cluster_Record_External_Id__c = objClusterRec.SmartDD__Cluster_Record_External_Id__c;objChildClusters.SmartDD__Object_Name__c = objClusterRec.SmartDD__Object_Name__c;objChildClusters.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                        if(mapExternalClusterId.get(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c)) != ''){
                            objChildClusters.SmartDD__Cluster_Id__c = mapExternalClusterId.get(Integer.ValueOf(objClusterRec.SmartDD__External_Cluster_Id__c));lstChildClusterInsert.add(objChildClusters);
                        }
                    }
                    if(Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isCreateable()){
                        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstChildClusterInsert);     
                        insert decision.getRecords();
                    }
                    
                    
                    Integer totalClustersGroup = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
                    objDedupeLogs.SmartDD__Total_CLusters_Created__c = totalClustersGroup;
                    lstObjDedupeLogs.add(objDedupeLogs);
                    if(Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Log__c.isUpdateable()) {
                        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, lstObjDedupeLogs);   
                        upsert decision.getRecords();
                    }
                    
                    SmartDD__Filter_Data__c filterRecs = SmartDD__Filter_Data__c.getInstance(strObjName);
                    if(filterRecs != null) {
                        filterRecs.name = strObjName;
                        filterRecs.SmartDD__Object_Name__c = strObjName;
                        filterRecs.SmartDD__Unique_Cluster_Saved__c = false;
                        if(Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Filter_Data__c.isUpdateable()){     //NOPMD
                            upsert filterRecs;
                        }
                        
                    } else {
                        SmartDD__Filter_Data__c filterRecsNew = new SmartDD__Filter_Data__c();
                        filterRecsNew.name = strObjName;
                        filterRecsNew.SmartDD__Object_Name__c = strObjName;
                        filterRecsNew.SmartDD__Unique_Cluster_Saved__c = false;
                        if(Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Filter_Data__c.isUpdateable()){     //NOPMD
                        upsert filterRecsNew;
                        }
                    }
                    
                    
                    String userid  = '';
                    String organizationid  = '';
                    List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id,
                    
                  
                    
                   SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                                SmartDD__Last_Name__c,   SmartDD__First_Name__c
                                                                                        FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
                    if(lstAuthorizedUser.size() > 0){
                        userid = lstAuthorizedUser[0].SmartDD__UserId__c;
                        organizationid = lstAuthorizedUser[0].SmartDD__Organization_Id__c; 
                    }   
                      
                    // Update Status to java side for clusters created.
                    String JSONStatusUpdate = '';                                   // NOPMD                                                                   
                    JSONStatusUpdate += '{';
                    JSONStatusUpdate += '"Object Name":"' + strObjName + '",';
                    JSONStatusUpdate += '"Organization Id":"' + organizationid + '",';
                    JSONStatusUpdate += '"UserId":"' + userid + '"';
                    JSONStatusUpdate += '}';
                    System.debug('@#$JSONStatusUpdate: '+JSONStatusUpdate);
                    httpJSONRequest(System.Label.SFImportAPI+'/cluster/statusUpdate', JSONStatusUpdate);
                    
                    // Updating status for clusters created
                    dedupeConfig.SmartDD__Clusters_Created_Stat__c = true;
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()) {
                        upsert dedupeConfig;
                    }
                } else {
                    SmartDD__De_Dupe_Configuration__c dedupeConfigDetails = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                    dedupeConfigDetails.SmartDD__Clusters_Created_Stat__c = true; batchCreateCluster createClusterRecords = new batchCreateCluster(strObjName, strNewMasterClusterId, objDedupeLogs);
                    Id batchProcessId = Database.executeBatch(createClusterRecords,200);dedupeConfigDetails.SmartDD__Manage_Cluster_BatchId__c = batchProcessId;
                    if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()) {
                        upsert dedupeConfigDetails;
                    }
                }
                return 'success';
            } 
            catch(System.TypeException e) {
                String error = '';error = e.getMessage();return error; 
            }    
        }
        else {
            return 'Request input was empty.';    
        }
    }     
    //Http Request Body
    @Future(callout=true)
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
            system.debug('@@#$statusRes: '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: '+jsonString);
            
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
        
    } 
    
    public class insertClusterWrapper {        // NOPMD
        public Integer totalRecords {get;set;}        
        public Integer totalTrainingRecords {get;set;}  
        public String trainingFileName {get;set;}
        public String objectName {get;set;}
        public insertClusterWrapper() {
            totalRecords = null;
            totalTrainingRecords = null;
            objectName = '';
            trainingFileName = '';
        }
    } 
}