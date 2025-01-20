@RestResource(urlMapping='/Cluster')
global with sharing class ClusterAPI { //NOPMD
    @HttpPost
    global static String fnGetClusterData() {  //NOPMD
        //string strjson = '[{ "clusterid": "1", "leadid": "00Qf400000ENV5sEAH", "recordid": "151138","objectName":"Lead","pair_score":"0.9999698" }, { "clusterid": "1", "leadid": "00Qf400000ENVRbEAP", "recordid": "151139","objectName":"Lead","pair_score":"0.9999698" }, { "clusterid": "2", "leadid": "00Qf400000ENVUjEAP", "recordid": "151140","objectName":"Lead","pair_score":"1.0" }]';
        //string strjson = '[{ "clusterid": "1", "leadid": "00Qf400000ENV5sEAH", "recordid": "151138","objectName":"Lead","pair_score":"0.9999698", "totalRecords":"145","totalTrainingRecords":"125","trainingFileName":"ab8bc3eb-762c-4ab4-a0e8-1fe891c93aa3.json" }, { "clusterid": "1", "leadid": "00Qf400000ENVRbEAP", "recordid": "151139","objectName":"Lead","pair_score":"0.9999698","totalRecords":"145","totalTrainingRecords":"125","trainingFileName":"ab8bc3eb-762c-4ab4-a0e8-1fe891c93aa3.json" }, { "clusterid": "2", "leadid": "00Qf400000ENVUjEAP", "recordid": "151140","objectName":"Lead","pair_score":"1.0","totalRecords":"145","totalTrainingRecords":"125","trainingFileName":"ab8bc3eb-762c-4ab4-a0e8-1fe891c93aa3.json" }]';
        string strjson = RestContext.request.requestBody.toString();
        system.debug('strjson .............................................= ' +strjson);
        if(!String.isBlank(strjson)) {
            try { 
                List<insertClusterWrapper> lstWrpCluster = (List<insertClusterWrapper>) JSON.deserialize(strjson,List<insertClusterWrapper>.class);                
                String strObjName = 'Lead';
                Integer totalRecords = null;
                Integer trainingFileRecordCount = null;
                String strTrainingFileName = '';
                String strClusterType = '';
                //Assigning the common values in varialble for debug log table 
                strObjName = lstWrpCluster[0].objectName;
                totalRecords = lstWrpCluster[0].totalRecords;
                trainingFileRecordCount = lstWrpCluster[0].totalTrainingRecords;
                strTrainingFileName = lstWrpCluster[0].trainingFileName;
                strClusterType = lstWrpCluster[0].clusterType;
				
                // To update the status of cluster crete process is in progress.
                
                SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
                if(strClusterType == 'multiple'){
                dedupeConfig.SmartDD__Clusters_Created_Stat__c = false;
                dedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'In Progress';
                dedupeConfig.SmartDD__Total_CLusters_Created__c = totalRecords;
                dedupeConfig.SmartDD__Manage_Cluster_BatchId__c = '';
                if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()) {
 					system.debug('.................dedupeConfig.........................'+dedupeConfig);
                    upsert dedupeConfig; 
                    system.debug('dedupeConfig.........................'+dedupeConfig);
                	}
                }    
                
                List<SmartDD__All_CLuster_Record__c> lstClusterRecs = new List<SmartDD__All_CLuster_Record__c>();  
                String strNewMasterClusterId = '';
                if(lstWrpCluster.Size() > 0) {
                    SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(lstWrpCluster[0].objectName);
                    if(objMasterClusterId != null) {
                        strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
                    }
                }
                List<SmartDD__Cluster__c> lstClustersParent = new List<SmartDD__Cluster__c>();
                Set<Integer> setClusterRecords = new Set<Integer>(); 
                Set<Integer> setTableClustersRec = new Set<Integer>();
                Set<Integer> setClusterExternalIds = new Set<Integer>(); 
                // Prepare a set of External cluster Id to match with the existing records in Cluster Table.
                for(insertClusterWrapper objWrpClusters :lstWrpCluster){
                    setClusterExternalIds.add(Integer.ValueOf(objWrpClusters.clusterid));
                } 
                List<SmartDD__Cluster__c> lstParentClusterRecs = new List<SmartDD__Cluster__c>();  
                lstParentClusterRecs = [Select ID, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =:strNewMasterClusterId AND SmartDD__External_Cluster_Id__c IN: setClusterExternalIds WITH USER_MODE];
                for(SmartDD__Cluster__c objClusterRecs : lstParentClusterRecs) {setTableClustersRec.add(Integer.ValueOf(objClusterRecs.SmartDD__External_Cluster_Id__c));}
                for(insertClusterWrapper objWrpClusters :lstWrpCluster) {
                    /* To match with existing Cluster_Id & store Cluster Ids in Parent Table */
                    SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
                    if(!setTableClustersRec.contains(Integer.ValueOf(objWrpClusters.clusterid))){
                        objCluster.SmartDD__External_Cluster_Id__c = objWrpClusters.clusterid;
                        Decimal confidenceLevelScore = 0;
                        if(objWrpClusters.pair_score != 'None') {
                            confidenceLevelScore = Decimal.ValueOf(objWrpClusters.pair_score);
                        }
                        confidenceLevelScore = confidenceLevelScore * 100;
                        if(confidenceLevelScore < 10) { confidenceLevelScore = 10; }
                        objCluster.SmartDD__Confidence_Score__c = confidenceLevelScore;
                        objCluster.SmartDD__Object_Name__c = objWrpClusters.objectName;
                        if(strNewMasterClusterId != '') {
                            objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                            lstClustersParent.add(objCluster);  
                        }
                    }
                    setClusterRecords.add(Integer.ValueOf(objWrpClusters.clusterid));
                }
                /* Insert Records in Parent Object SmartDD__Cluster__c */
                if(lstClustersParent.size() > 0  && Schema.sObjectType.SmartDD__Cluster__c.isCreateable()) {
                    SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstClustersParent);   
                    insert decision.getRecords();
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
                for(insertClusterWrapper objWrpClusters :lstWrpCluster) {
                    SmartDD__Child_Cluster_Record__c objChildClusters = new SmartDD__Child_Cluster_Record__c();
                    objChildClusters.SmartDD__Cluster_Object_Id__c = objWrpClusters.leadid;
                    objChildClusters.SmartDD__Cluster_Record_External_Id__c = objWrpClusters.recordid;
                    objChildClusters.SmartDD__Object_Name__c = objWrpClusters.objectName;
                    objChildClusters.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                    if(mapExternalClusterId.get(Integer.ValueOf(objWrpClusters.clusterid)) != '') {
                        objChildClusters.SmartDD__Cluster_Id__c = mapExternalClusterId.get(Integer.ValueOf(objWrpClusters.clusterid));
                        lstChildClusterInsert.add(objChildClusters);
                    }
                }
                if(Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isCreateable())
                {	
                    SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstChildClusterInsert);   
                    insert decision.getRecords();
                }
                
                List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Distinct_Cluster_Counter__c, SmartDD__Total_Reviewed_Records__c, SmartDD__Requested_On_Object__c, SmartDD__Type_Of_Request__c, SmartDD__Total_Records_Operated__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
                if(lstDebugLog.size() < 1) {
                    SmartDD__Dedupe_Log__c objDedupeLogs = new SmartDD__Dedupe_Log__c(); 
                    Integer totalClustersGroup = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
                    objDedupeLogs.SmartDD__Total_CLusters_Created__c = totalClustersGroup;
                    objDedupeLogs.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                    objDedupeLogs.SmartDD__Requested_On_Object__c = strObjName;
                    objDedupeLogs.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                    objDedupeLogs.SmartDD__Time_Of_Request__c = Datetime.now();
                    objDedupeLogs.SmartDD__Type_Of_Request__c = 'Cluster List Request';
                    objDedupeLogs.SmartDD__Total_Records_Operated__c = dedupeConfig.SmartDD__Total_Records_Deduped__c;
                    objDedupeLogs.SmartDD__Training_File_Records_Count__c = trainingFileRecordCount;
                    objDedupeLogs.SmartDD__Training_File_Name__c = strObjName + '_' + strTrainingFileName;
                    lstDebugLog.add(objDedupeLogs);
                    SObjectAccessDecision decisionObjDebugLog = Security.stripInaccessible( AccessType.UPSERTABLE, lstDebugLog); 
                    Schema.DescribeSObjectResult schemaDedupeLog = SmartDD__Dedupe_Log__c.sObjectType.getDescribe();
                    if(( schemaDedupeLog.isCreateable() && schemaDedupeLog.isUpdateable() ) || Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable() || Schema.sObjectType.SmartDD__Dedupe_Log__c.isUpdateable() ){
                        upsert decisionObjDebugLog.getRecords();
                    }                    
                }
                SmartDD__Filter_Data__c filterRecs = SmartDD__Filter_Data__c.getInstance(lstWrpCluster[0].objectName);
                if(filterRecs != null) {
                    filterRecs.name = lstWrpCluster[0].objectName;  
                    filterRecs.SmartDD__Object_Name__c = lstWrpCluster[0].objectName;
                    filterRecs.SmartDD__Unique_Cluster_Saved__c = false;    

                    if(Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Filter_Data__c.isUpdateable() ){
                        upsert filterRecs;
                        system.debug('filterRecs.........................'+filterRecs);
                    }
                   
                } else {
                    SmartDD__Filter_Data__c filterRecsNew = new SmartDD__Filter_Data__c();filterRecsNew.name = lstWrpCluster[0].objectName; filterRecsNew.SmartDD__Object_Name__c = lstWrpCluster[0].objectName;filterRecsNew.SmartDD__Unique_Cluster_Saved__c = false; 
                    if(Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable() || Schema.sObjectType.SmartDD__Filter_Data__c.isUpdateable() ) {
                        upsert filterRecsNew;
                        system.debug('filterRecsNew.........................'+filterRecsNew);
                    }
                }
                return 'success';
            } 
            catch(System.TypeException e) {
                String error = '';error = e.getMessage();return error; 
            }    
        } else {
            return 'Request input was empty.';    
        }
    }      
     public class insertClusterWrapper {        //NOPMD
        public Integer clusterid {get;set;}   
        public String pair_score {get;set;}        //NOPMD
        public String leadid {get;set;}
        public String recordid {get;set;}
        public String objectName {get;set;}
        public Integer totalRecords {get;set;}        
        public Integer totalTrainingRecords {get;set;}  
        public String trainingFileName {get;set;}
        public String clusterType{get;set;}
         
        public insertClusterWrapper() {
            clusterid = null;
            pair_score = '';
            leadid = '';
            recordid = '';
            objectName = '';
            totalRecords = null;
            totalTrainingRecords = null;
            trainingFileName = '';
            clusterType = '';
        }
    } 
}