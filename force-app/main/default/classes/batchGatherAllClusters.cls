global with sharing class batchGatherAllClusters implements Database.Batchable<sobject>, Database.Stateful 
{
    List<ClusterAPI.insertClusterWrapper> lstWrpCluster = new List<ClusterAPI.insertClusterWrapper>();
    public batchGatherAllClusters(List<ClusterAPI.insertClusterWrapper> wrapperListData){
        lstWrpCluster = wrapperListData;
    }
    global Integer recordsProcessed = 0;
    global database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(
            'Select ID, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WITH USER_MODE'
        );
    }
    global void execute(database.BatchableContext BC, List<SmartDD__Cluster__c> scope){
        
        List<SmartDD__Cluster__c> lstClustersParent = new List<SmartDD__Cluster__c>();  
        Set<Integer> setClusterRecords = new Set<Integer>(); 
        Set<Integer> setTableClustersRec = new Set<Integer>(); 
        List<SmartDD__Cluster__c> lstParentClusterRecs = new List<SmartDD__Cluster__c>();  
        lstParentClusterRecs = scope;
        
        for(SmartDD__Cluster__c objClusterRecs : lstParentClusterRecs) {
            setTableClustersRec.add(Integer.ValueOf(objClusterRecs.SmartDD__External_Cluster_Id__c));
        } 
        
        for(ClusterAPI.insertClusterWrapper objWrpClusters :lstWrpCluster){
            /* To match with existing Cluster_Id & store Cluster Ids in Parent Table */
            SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
            if(!setTableClustersRec.contains(objWrpClusters.clusterid)){
                if (Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isAccessible()||Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isCreateable()) 
                {
                    objCluster.SmartDD__External_Cluster_Id__c = objWrpClusters.clusterid;
                    lstClustersParent.add(objCluster); 
                }
                
            }
            setClusterRecords.add(objWrpClusters.clusterid);
        }
        
        /* Insert Records in Parent Object Cluster__c */
        if(lstClustersParent.size() > 0) {
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstClustersParent);     
            insert decision.getRecords();
        }
        
        Map<Integer, String> mapExternalClusterId = new Map<Integer,String>();
        List<SmartDD__Child_Cluster_Record__c> lstChildClusterInsert = new List<SmartDD__Child_Cluster_Record__c>();  
        List<SmartDD__Cluster__c> lstParentClusters = [Select Id,SmartDD__External_Cluster_Id__c From SmartDD__Cluster__c WHERE SmartDD__External_Cluster_Id__c IN :setClusterRecords WITH USER_MODE];
        
        /* Creating Map of Java ClusterId and Salesforce ClusterId */
        for(SmartDD__Cluster__c objClusters: lstParentClusters) {
            if(objClusters.SmartDD__External_Cluster_Id__c != null) {
                mapExternalClusterId.put(integer.ValueOf(objClusters.SmartDD__External_Cluster_Id__c), objClusters.Id);
            }
        }
        
        /* To Insert Records in Child Object */
       
        for(ClusterAPI.insertClusterWrapper objWrpClusters :lstWrpCluster){
            SmartDD__Child_Cluster_Record__c objChildClusters = new SmartDD__Child_Cluster_Record__c();
            
            objChildClusters.SmartDD__Cluster_Object_Id__c = objWrpClusters.leadid;
            objChildClusters.SmartDD__Cluster_Record_External_Id__c = objWrpClusters.recordid;
            //objChildClusters.Cluster_Id__c = '';
            if(mapExternalClusterId.get(objWrpClusters.clusterid) != '')
            {
               if(Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isAccessible() && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isAccessible())
               {
                   objChildClusters.SmartDD__Cluster_Id__c = mapExternalClusterId.get(objWrpClusters.clusterid);
                   lstChildClusterInsert.add(objChildClusters);

               }
            }
        }
        if(Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isCreateable() && 
           Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Object_Id__c.isCreateable())
        {
             insert lstChildClusterInsert;
        }
       
        
        SmartDD__Filter_Data__c  filterRecs = SmartDD__Filter_Data__c.getInstance('Filter Records');
        if(filterRecs != null)
        {
            if (Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isCreateable() && Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isUpdateable()) {
                filterRecs.SmartDD__Unique_Cluster_Saved__c = false;
                upsert filterRecs;
            }
        }
        
       
    }
    global void finish(database.BatchableContext BC){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId() WITH USER_MODE];
    }
}