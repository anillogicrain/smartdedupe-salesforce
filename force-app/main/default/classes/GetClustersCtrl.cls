/********************************************************************************************
* NAME         : GetClustersCtrl
* DESCRIPTION  : This class is use to get the clusters inserted from java side.
* 
* @AUTHOR: dev team
* @DATE: 03/22/2019
*
*
* MODIFICATION LOG:
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
  dev team                        03/22/2019                            -
********************************************************************************************/
global with sharing class GetClustersCtrl { //NOPMD
    @AuraEnabled
    public static List<SmartDD__Cluster__c> getClusterRecords() {
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>();
        lstClusters = [SELECT Id, Name, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WITH USER_MODE ORDER BY Name ASC];    
        return lstClusters;
    }
     
    /**********************************************************************************************
    Purpose: get list of objects that are synced. 
    **********************************************************************************************/
    @AuraEnabled
    public static List<String> getSyncedObjList() {
        List<String> lstSyncedObjects = new List<String>(); 
        SmartDD__De_Dupe_Configuration__c dedupeconfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        if(dedupeconfig.SmartDD__Lead__c == true) {
            lstSyncedObjects.add('Lead');
        }
        if(dedupeconfig.SmartDD__Account__c == true) {
            lstSyncedObjects.add('Account');
        }
        if(dedupeconfig.SmartDD__Contact__c == true) {
            lstSyncedObjects.add('Contact');
        }
        return lstSyncedObjects;
    }
    
    @AuraEnabled
    public static String deDupeObjectName(){
        String deDupeObjectName;
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        deDupeObjectName = dedupeConfig.SmartDD__DeDupe_Object_Name__c;
        return deDupeObjectName;
    }
    
    @AuraEnabled
    Public static AsyncApexJobWrapper rededupeBatchStatus(Id BatchProcessId){   //NOPMD
        
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper(); 
        if(BatchProcessId != null || BatchProcessId != ''){      
            objApexJob.lstAsyncApexJob = [SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE];objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems;objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed;objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status; 
        }
        return objApexJob; 
    }
    
    @AuraEnabled
    Public static AsyncApexJobWrapper AsyncApexJobRecords() {   //NOPMD
        
        SmartDD__De_Dupe_Configuration__c dedupeConfigSetting = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        String BatchProcessId = dedupeConfigSetting.SmartDD__Manage_Cluster_BatchId__c; //NOPMD
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper(); 
        if(BatchProcessId != null && BatchProcessId != ''){      
            objApexJob.lstAsyncApexJob = [SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE];
            objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems;objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed; objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status; 
        } else {
            objApexJob.JobItemStatus = 'Completed'; 
        }
        objApexJob.ClustersCompletedStat = dedupeConfigSetting.SmartDD__Clusters_Completed_Stat__c;
        objApexJob.startDedupeBatchId = dedupeConfigSetting.SmartDD__Start_Dedupe_Batch_Id__c;
        objApexJob.LastCreateClusterProgress = dedupeConfigSetting.SmartDD__Last_Create_Cluster_Progress__c;
        return objApexJob; 
    }
    
    @AuraEnabled
    public static lightningTableWrapper getClusterDetails(String ClusterId, String fieldstoget, String ObjectName, String sortField, String searchKey, boolean isAsc,decimal pageNumber, Integer pageSize) {//NOPMD
    
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(ObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        } 
        /*if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        }*/
        Set<Id> setClusterRecId = new Set<Id>();
        List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: ClusterId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
            setClusterRecId.add(strClusterRecords.SmartDD__Cluster_Object_Id__c);
        }
        System.debug('@#$%setClusterRecId: '+setClusterRecId);
        
        //List<Lead> lstClusterChildRecords = new List<Lead>([SELECT Id, LastName, FirstName, Company, Phone, Email FROM Lead WHERE Id In : setClusterRecId WITH USER_MODE]);
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        
        String queryString = '';
        String queryStringTotal = '';
        String searchQuery = '';
        String searchQueryTotal = '';
        Boolean flagSearchFilter = false;
        Integer offset = 0;
        
        if(searchKey != null && searchKey != ''){
            flagSearchFilter = true;
            searchKey = searchKey.trim();
        }
        
        if(pageSize != null){
            offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(pageSize);
        }
        else{
            SmartDD__Cluster_Detail_Page_Size__c perPageRecordSize = SmartDD__Cluster_Detail_Page_Size__c.getValues('Cluster Detail Page Record Size');
            pageSize = integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c); offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);
        }
        if(fieldstoget != '') {
            queryString += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget)+
                                 ' from '+ String.escapeSingleQuotes(ObjectName) +
                                 ' WHERE Id In : setClusterRecId WITH USER_MODE';
        } else {
            queryString += 'Select Id from '+ String.escapeSingleQuotes(ObjectName) +' WHERE Id In : setClusterRecId WITH USER_MODE';
        }
                             
        queryStringTotal += 'Select Count(Id) from '+ String.escapeSingleQuotes(ObjectName) +' WHERE Id In : setClusterRecId WITH USER_MODE';                             
                             
        if(flagSearchFilter == true){
            searchQuery += 'FIND \'' + string.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(ObjectName) + ' (' + String.escapeSingleQuotes(fieldstoget);
            searchQueryTotal = 'FIND \'' + string.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(ObjectName) + ' (Id';
            
            searchQuery += ' WHERE Id In : setClusterRecId';
            searchQueryTotal += ' WHERE Id In : setClusterRecId)';
        }                             
                             
        if (sortField != '' && sortField != null) {
            queryString += ' order by ' + sortField;
            searchQuery += ' order by ' + sortField; 
            // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
            if (isAsc) {
                queryString += ' desc NULLS LAST';
                searchQuery += ' desc NULLS LAST';
            } else {
                queryString += ' asc';
                searchQuery += ' asc';
            }
        }
        
        queryString += ' Limit '+ pageSize + ' Offset '+offset;      
        
        if(flagSearchFilter == true) {
            searchQuery += ' Limit '+ pageSize + ' Offset '+offset +')';
        }                       
        System.debug('@#queryString : '+queryString);
        System.debug('@#queryString : '+queryStringTotal);
        if(flagSearchFilter == true) {
            List<List<SObject>> results = search.query(searchQuery);
            objTableWrapper.sObjectrecords = ((List<sObject>)results[0]);
            List<List<SObject>> resultTotal = search.query(searchQueryTotal);
            objTableWrapper.sObjectTotalRecords = ((List<sObject>)resultTotal[0]);
            objTableWrapper.total = objTableWrapper.sObjectTotalRecords.size();
            objTableWrapper.page = 1;
        }
        else {
            objTableWrapper.page = Integer.valueOf(pageNumber);
            objTableWrapper.sObjectrecords = database.query(queryString);
            objTableWrapper.sObjectTotalRecords = database.query(queryStringTotal);
            objTableWrapper.total = Integer.valueOf(objTableWrapper.sObjectTotalRecords[0].get('expr0'));
            system.debug('!@#objTableWrapper: '+objTableWrapper);
        }
        return objTableWrapper;
    }
    
    /**********************************************************************************************
    Purpose: Update Per Page Record Size Custom Setting.
    **********************************************************************************************/
    @AuraEnabled
    public static Void UpdateClusterDetailRecordSize(Integer recordSizeParam){  // NOPMD
        SmartDD__Cluster_Detail_Page_Size__c perPageRecordSize = SmartDD__Cluster_Detail_Page_Size__c.getValues('Cluster Detail Page Record Size');
        perPageRecordSize.SmartDD__Per_Page_Record__c = recordSizeParam;        
        if(Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isCreateable() || Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isUpdateable()||Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.isCreateable() || Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.isUpdateable()){
            upsert perPageRecordSize; // NOPMD
        }        
    }
    /**********************************************************************************************
    Purpose: Get Per Page Record Size Custom Setting.
    **********************************************************************************************/
    @AuraEnabled
    public static SmartDD__Cluster_Detail_Page_Size__c GetClusterDetailRecordSize() { //NOPMD
        SmartDD__Cluster_Detail_Page_Size__c perPageRecordSize = SmartDD__Cluster_Detail_Page_Size__c.getValues('Cluster Detail Page Record Size');
        return perPageRecordSize;
    }
    
    /**********************************************************************************************
    Purpose: Update Per Page Record Size Custom Setting.
    **********************************************************************************************/
    @AuraEnabled
    public static Void UpdatePerPageRecordSize(Integer recordSizeParam){ //NOPMD
        SmartDD__Cluster_Page_Size__c perPageRecordSize = SmartDD__Cluster_Page_Size__c.getValues('Cluster Page Record Size');
        perPageRecordSize.SmartDD__Per_Page_Record__c = recordSizeParam;
        if(Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isCreateable() || Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isUpdateable()||Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.isCreateable() || Schema.SObjectType.SmartDD__Cluster_Detail_Page_Size__c.isUpdateable()){
            upsert perPageRecordSize;   // NOPMD
        }
    }
    /**********************************************************************************************
    Purpose: Get Per Page Record Size Custom Setting.
    **********************************************************************************************/
    @AuraEnabled
    public static SmartDD__Cluster_Page_Size__c GetPerPageRecordSize() { //NOPMD
        SmartDD__Cluster_Page_Size__c perPageRecordSize = SmartDD__Cluster_Page_Size__c.getValues('Cluster Page Record Size');
        return perPageRecordSize;
    }
    
    /**********************************************************************************************
    Purpose: Update Tab Name in Selected Tab Id custom setting.
    **********************************************************************************************/
    @AuraEnabled
    public static Void UpdateSelectedTabName(String tabName){   // NOPMD
        if(Schema.SObjectType.SmartDD__Selected_Tab_Id__c.fields.SmartDD__Tab_Id_Name__c.isAccessible() || Schema.SObjectType.SmartDD__Selected_Tab_Id__c.fields.SmartDD__Tab_Id_Name__c.isCreateable() || Schema.SObjectType.SmartDD__Selected_Tab_Id__c.fields.SmartDD__Tab_Id_Name__c.isUpdateable()||Schema.SObjectType.SmartDD__Selected_Tab_Id__c.isCreateable() || Schema.SObjectType.SmartDD__Selected_Tab_Id__c.isUpdateable()){
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        selectedTabName.SmartDD__Tab_Id_Name__c = tabName;
        upsert selectedTabName; // NOPMD
        }
    }
    /**********************************************************************************************
    Purpose: Get Per Page Record Size Custom Setting.
    **********************************************************************************************/
    @AuraEnabled
    public static String GetSelectedTabName() { // NOPMD
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        return selectedTabName.SmartDD__Tab_Id_Name__c;
    }
    
    @AuraEnabled 
    public static fetchClusterWrpper fetchClusters(decimal pageNumber, Integer pageSize, String sortField, boolean isAsc, String selObjectName) {   // NOPMD
        
        String queryString = '';
        String queryStringTotal = '';
        String queryEntireRecs = '';
        String queryNotReviewed = '';
        Set<Id> setSObjectId = new Set<Id>();
        Set<Id> setEntireSObjectId = new Set<Id>();
        List<SmartDD__Cluster__c> lstClusterRecs = new List<SmartDD__Cluster__c>();
        List<SmartDD__Cluster__c> lstEntireClusterRecs = new List<SmartDD__Cluster__c>();
        
        Integer offset = 0;
        fetchClusterWrpper objClusterWrapper = new fetchClusterWrpper();
        
        if(pageSize != null){
            offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(pageSize);
        }
        else{
            SmartDD__Cluster_Page_Size__c perPageRecordSize = SmartDD__Cluster_Page_Size__c.getValues('Cluster Page Record Size');
            pageSize = integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);
        }
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        /*if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        }*/
        
        sObject sObj = Schema.getGlobalDescribe().get(selObjectName).newSObject();
        /*List<sObject> lstSObjMergeQuery = new List<sObject>();
        String strMergedRecords = 'SELECT Id, IsMerged__c FROM '+ String.escapeSingleQuotes(selObjectName) +' WHERE IsMerged__c = true WITH USER_MODE';
        lstSObjMergeQuery = database.query(strMergedRecords);
        for(sObject objMerged: lstSObjMergeQuery) {
            objMerged.put('IsMerged__c',false);
        }
        update lstSObjMergeQuery;*/
        System.debug('@@@@@strNewMasterClusterId............................'+strNewMasterClusterId);
        String strQueryTotalDupRecs = 'Select SUM(SmartDD__Total_Child_Records__c) from SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        List<sObject> sObjTotalDuplicateRecs = new List<sObject>();
        sObjTotalDuplicateRecs = database.query(strQueryTotalDupRecs);
        Integer totalDuplicateRecs = 0;
        if(sObjTotalDuplicateRecs.Size() > 0) {
            totalDuplicateRecs = Integer.valueOf(sObjTotalDuplicateRecs[0].get('expr0'));
        }
        
        // Setting Up Debug Log
        List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Distinct_Cluster_Counter__c, SmartDD__Total_Reviewed_Records__c, SmartDD__Requested_On_Object__c, SmartDD__Type_Of_Request__c, SmartDD__Total_Records_Operated__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
        if(lstDebugLog.size() > 0) {
            List<SmartDD__Dedupe_SaveYourData_Log__c> lstSaveYourDataLogChk = new List<SmartDD__Dedupe_SaveYourData_Log__c>([SELECT Id FROM SmartDD__Dedupe_SaveYourData_Log__c 
                                                                                                           WHERE SmartDD__Dedupe_Log__c =: lstDebugLog[0].Id 
                                                                                                           AND SmartDD__Save_Record_Status__c = 'Duplicate Records'
                                                                                                           AND SmartDD__Records_Operated__c =: totalDuplicateRecs WITH USER_MODE]);
            if(lstSaveYourDataLogChk.size() == 0) {
                lstDebugLog[0].SmartDD__Total_Duplicate_Records__c = totalDuplicateRecs;
                List<SmartDD__Dedupe_SaveYourData_Log__c> lstSaveYourDataLog = new List<SmartDD__Dedupe_SaveYourData_Log__c>();
                for(Integer i=1; i<=2; i++) {
                    SmartDD__Dedupe_SaveYourData_Log__c objSaveYourDataLog = new SmartDD__Dedupe_SaveYourData_Log__c();
                    objSaveYourDataLog.SmartDD__Dedupe_Log__c = lstDebugLog[0].Id;
                    objSaveYourDataLog.SmartDD__Requested_On_Object__c = lstDebugLog[0].SmartDD__Requested_On_Object__c;
                    objSaveYourDataLog.SmartDD__Type_Of_Request__c = lstDebugLog[0].SmartDD__Type_Of_Request__c;
                    if(i == 1) {
                        objSaveYourDataLog.SmartDD__Save_Record_Status__c = 'Total Records Operated';
                        objSaveYourDataLog.SmartDD__Records_Operated__c = lstDebugLog[0].SmartDD__Total_Records_Operated__c;
                    } else {
                        objSaveYourDataLog.SmartDD__Save_Record_Status__c = 'Duplicate Records';
                        objSaveYourDataLog.SmartDD__Records_Operated__c = totalDuplicateRecs;
                    }
                    lstSaveYourDataLog.add(objSaveYourDataLog);
                }                  
                if( (totalDuplicateRecs != null && totalDuplicateRecs > 0 ) || Schema.SObjectType.SmartDD__Dedupe_Log__c.isUpdateable()) {
                    SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstDebugLog); 
                    Update decision.getRecords();     //NOPMD
                }
                if(lstSaveYourDataLog.Size() > 0 ||  Schema.SObjectType.SmartDD__Dedupe_Log__c.isCreateable()) {
                    SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstSaveYourDataLog); 
                    Insert decision.getRecords();   //NOPMD
                }
            }
        }
        
        queryString += 'Select Id, Name, SmartDD__Object_Name__c, SmartDD__External_Cluster_Id__c, SmartDD__Confidence_Score__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c, (SELECT SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Records__r LIMIT 1) FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        queryStringTotal += 'Select Count(Id) from SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        queryEntireRecs += 'Select Id, Name, SmartDD__Object_Name__c, SmartDD__External_Cluster_Id__c, SmartDD__Confidence_Score__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c, (SELECT SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Records__r LIMIT 1) FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        queryNotReviewed += 'Select Count(Id) FROM SmartDD__Cluster__c WHERE SmartDD__Cluster_Review_Status__c = \'Not Reviewed\' AND SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        SmartDD__Selected_Tab_Id__c focusTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        if (sortField != '' && sortField != null) {
            queryString += ' order by ' + sortField;
            queryEntireRecs += ' order by ' + sortField;
            
            // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
            if (isAsc) {
                queryString += ' desc NULLS LAST';
                queryEntireRecs += ' desc NULLS LAST';
            } else {
                queryString += ' asc';
                queryEntireRecs += ' asc';
            }
        }
        
        queryString += ' Limit '+ pageSize + ' Offset '+offset;
        
        lstClusterRecs = database.query(queryString);
        
        for(SmartDD__Cluster__c objCluster: lstClusterRecs) {
            if(objCluster.SmartDD__Child_Cluster_Records__r[0] != null) {
                fetchSObjectWrpper objSObjWrp = new fetchSObjectWrpper();
                objSObjWrp.clusterRecId = objCluster.SmartDD__Child_Cluster_Records__r[0].SmartDD__Cluster_Object_Id__c;
                objSObjWrp.clusterId = objCluster.Id;
                objSObjWrp.confidenceLevelCount = (Integer)objCluster.SmartDD__Confidence_Score__c;
                objSObjWrp.sObjectName = objCluster.SmartDD__Object_Name__c;
                objSObjWrp.externalClusterId = integer.valueOf(objCluster.SmartDD__External_Cluster_Id__c);
                objSObjWrp.totalChildRecs = integer.valueOf(objCluster.SmartDD__Total_Child_Records__c);
                objSObjWrp.clusterReviewStatus = objCluster.SmartDD__Cluster_Review_Status__c;
                setSObjectId.add(objCluster.SmartDD__Child_Cluster_Records__r[0].SmartDD__Cluster_Object_Id__c );
                objClusterWrapper.lstSObjWrapper.add(objSObjWrp);
            }
        }
        system.debug('selObjectName'+selObjectName);
        String strMapSObjQuery = 'SELECT Id,Name FROM ' + selObjectName + ' WHERE Id IN:setSObjectId WITH USER_MODE';
        system.debug('strMapSObjQuery'+strMapSObjQuery);
        
        Map<Id,sObject> mapSObjectRec = new Map<Id,sObject>(database.query(strMapSObjQuery));   //NOPMD
        for(fetchSObjectWrpper objSObjWrp: objClusterWrapper.lstSObjWrapper) {
            if(mapSObjectRec.containsKey(objSObjWrp.clusterRecId)) {
                objSObjWrp.sObjectRecordId = mapSObjectRec.get(objSObjWrp.clusterRecId).Id;
                objSObjWrp.sObjectRecordName = String.ValueOf(mapSObjectRec.get(objSObjWrp.clusterRecId).get('Name'));
            }
        }
        
        lstEntireClusterRecs = database.query(queryEntireRecs);
        for(SmartDD__Cluster__c objCluster: lstEntireClusterRecs) {
            if(objCluster.SmartDD__Child_Cluster_Records__r[0] != null) {
                fetchSObjectWrpper objSObjWrp = new fetchSObjectWrpper();
                objSObjWrp.clusterRecId = objCluster.SmartDD__Child_Cluster_Records__r[0].SmartDD__Cluster_Object_Id__c;
                objSObjWrp.clusterId = objCluster.Id;
                objSObjWrp.confidenceLevelCount = (Integer)objCluster.SmartDD__Confidence_Score__c;
                objSObjWrp.sObjectName = objCluster.SmartDD__Object_Name__c;
                objSObjWrp.externalClusterId = integer.valueOf(objCluster.SmartDD__External_Cluster_Id__c);
                objSObjWrp.totalChildRecs = integer.valueOf(objCluster.SmartDD__Total_Child_Records__c);
                objSObjWrp.clusterReviewStatus = objCluster.SmartDD__Cluster_Review_Status__c;
                setEntireSObjectId.add(objCluster.SmartDD__Child_Cluster_Records__r[0].SmartDD__Cluster_Object_Id__c );
                objClusterWrapper.lstSObjEntireRecWrp.add(objSObjWrp);
            }
        }
        String strEntireMapSObjQuery = 'SELECT Id,Name FROM ' + selObjectName + ' WHERE Id IN:setEntireSObjectId WITH USER_MODE';
        Map<Id,sObject> mapEntireClusterSObjectRec = new Map<Id,sObject>(database.query(strEntireMapSObjQuery));    //NOPMD
        for(fetchSObjectWrpper objSObjWrp: objClusterWrapper.lstSObjEntireRecWrp) {
            if(mapEntireClusterSObjectRec.containsKey(objSObjWrp.clusterRecId)) {
                objSObjWrp.sObjectRecordId = mapEntireClusterSObjectRec.get(objSObjWrp.clusterRecId).Id;
                objSObjWrp.sObjectRecordName = String.ValueOf(mapEntireClusterSObjectRec.get(objSObjWrp.clusterRecId).get('Name'));
            }
        }
        system.debug('#$%queryString: '+queryString);
        objClusterWrapper.page = Integer.valueOf(pageNumber);
        objClusterWrapper.sObjectrecords = database.query(queryString);
        objClusterWrapper.sObjectTotalRecords = database.query(queryStringTotal);
        objClusterWrapper.sObjectEntireList = database.query(queryEntireRecs);
        objClusterWrapper.sObjectTotalNotReviewed = database.query(queryNotReviewed);
        objClusterWrapper.total = Integer.valueOf(objClusterWrapper.sObjectTotalRecords[0].get('expr0'));       
        objClusterWrapper.totalNotReviewed = Integer.valueOf(objClusterWrapper.sObjectTotalNotReviewed[0].get('expr0'));
        objClusterWrapper.selectedTabName = String.valueOf(focusTabName.SmartDD__Tab_Id_Name__c);
        system.debug('total' +objClusterWrapper.total);          
        return objClusterWrapper;
    }
    
    /** Update Customsetting field Last_Create_Cluster_Progress__c and Clusters_Completed_Stat__c value.*/
    @AuraEnabled
    Public static SmartDD__ReDe_Dupe_Configuration__c updateLastCreateCluster(){
        SmartDD__ReDe_Dupe_Configuration__c dedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
        dedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
        dedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
        dedupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isUpdateable()) {
            update dedupeConfig;
        }        
        return dedupeConfig;
    }
    
    /** Update ProcessStatus from java side.*/
    @AuraEnabled
    Public static String updateprocessStatus(String objectName){
        //Call StartDedupe API here.
        String JSONFieldFilterStr = '';     //NOPMD
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                              SmartDD__Last_Name__c,SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        if(lstAuthorizedUser.size() > 0) {
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"Object Name":"' + objectName + '",';
            JSONFieldFilterStr += '"Organization Id":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"UserId":"' + lstAuthorizedUser[0].SmartDD__UserId__c + '"';
            JSONFieldFilterStr += '}';
        }  
        system.debug('BEFORE JAVA CALL:....................................... ');
        httpProcessStatusJSONRequest(System.Label.SFImportAPI+'/cluster/processStatusUpdate', JSONFieldFilterStr);  
        system.debug('AFTER  JAVA CALL:....................................... ');
        return 'Success';
    }
    
    public static void httpProcessStatusJSONRequest(String strAWSEndpointLead, string strBody) {       
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes:....... '+statusRes);
            String jsonString =  statusRes.getBody();JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@Json ClusterStatus jsonString:....................................... '+jsonString);
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
    }
    
    /**********************************************************************************************
    Purpose: Update custom setting value with object name deduped.
    **********************************************************************************************/
    @AuraEnabled
    public static void updateDedupeObjectName(String selectedObjectname) {
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__DeDupe_Object_Name__c = selectedObjectname;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isUpdateable()) {
            update dedupeConfig;
        }
        
        SmartDD__ReDe_Dupe_Configuration__c rededupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        rededupeConfig.SmartDD__ReDeduped_Object_Name__c = selectedObjectname;
        rededupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isUpdateable()) {
            update rededupeConfig;
        }
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRec = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRec.SmartDD__Object_Name__c = selectedObjectname;
        if(Schema.sObjectType.SmartDD__Master_Cluster_Record__c.isCreateable()) {
            insert objMasterClusterRec;
        }
        system.debug('!@#selectedObjectname: '+selectedObjectname);
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selectedObjectname);
        system.debug('@Boolean1: '+objMasterClusterRec.Id);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            objMasterClusterId.SmartDD__Old_Master_Cluster_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
        }
        system.debug('@Boolean2: '+objMasterClusterRec.Id);
        if(objMasterClusterRec.Id != null) {
            system.debug('@Boolean3: '+objMasterClusterRec.Id);
            objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMasterClusterRec.Id;
        }
        
        if(Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.isAccessible() ||  Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.isUpdateable() ) {
            update objMasterClusterId;
        }
        
        List<SmartDD__TempDedupeNote__c> lstTempDedupeNote = new List<SmartDD__TempDedupeNote__c>([SELECT Id, SmartDD__LeadParentId__c, SmartDD__Object_Name__c FROM SmartDD__TempDedupeNote__c WHERE SmartDD__Object_Name__c =: selectedObjectname WITH USER_MODE LIMIT 20000]);
        Set<Id> setTempDedupeNote = new Set<Id>();
        for(SmartDD__TempDedupeNote__c objTempNotes: lstTempDedupeNote) {
            setTempDedupeNote.add(objTempNotes.SmartDD__LeadParentId__c);
        }
        system.debug('@#$setTempDedupeNote: '+setTempDedupeNote);
        // To reset the IsMerged__c value of SObject records.
        List<sObject> lstSObjMergeQuery = new List<sObject>();
        String strMergedRecords = 'SELECT Id, SmartDD__IsMerged__c FROM '+ String.escapeSingleQuotes(selectedObjectname) +' WHERE SmartDD__IsMerged__c = true WITH USER_MODE';
        lstSObjMergeQuery = database.query(strMergedRecords);
        for(sObject objMerged: lstSObjMergeQuery) {
            if(!setTempDedupeNote.contains(objMerged.Id)) {
                objMerged.put('SmartDD__IsMerged__c',false);
            }
        }
        update lstSObjMergeQuery;       //NOPMD
        
        /** Check total training record is greater then 20 */             
        String JSONFieldFilterStr = ''; //NOPMD
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                              SmartDD__Last_Name__c,   SmartDD__First_Name__c
                                                                                              FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        
        SmartDD__De_Dupe_Configuration__c dedupeConfigs = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        Id configId;
        if(lstAuthorizedUser.size() > 0) {
            configId = lstAuthorizedUser[0].Id;
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"Object Name":"' + selectedObjectname + '",';
            JSONFieldFilterStr += '"Organization Id":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"Field Name":"' + +'",';
            JSONFieldFilterStr += '"Filter Records":"' + dedupeConfigs.SmartDD__Total_Records_Deduped__c + '"';
            JSONFieldFilterStr += '}';
        }    
        //Call StartDedupe API here.
        httpCreateClusterJSONRequest(System.Label.SFImportAPI+'/lead/startDedupes', JSONFieldFilterStr, configId);
    }
    @future(callout=true)
    public static void httpCreateClusterJSONRequest(String strAWSEndpointLead, string strBody, Id configId ) {   
    SmartDD__Dedupe_Configuration__c objdedupeConfig = new SmartDD__Dedupe_Configuration__c();    
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(120000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes:....... '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@Json Create jsonString:....................................... '+jsonString);
            
           if(configId != null){
            SmartDD__Dedupe_Configuration__c objDedupeConfing = new SmartDD__Dedupe_Configuration__c();   
            objDedupeConfing.Id = configId;
            objDedupeConfing.SmartDD__Request__c = 'EndPoint: ' + strAWSEndpointLead + ' ' + 'RequestBody: ' + strBody;
            objDedupeConfing.SmartDD__Response__c = jsonString; 
            if(Schema.SObjectType.SmartDD__Dedupe_Configuration__c.isUpdateable() || Schema.SObjectType.SmartDD__Dedupe_Configuration__c.isAccessible() ){
                    update objDedupeConfing;        // NOPMD
                    system.debug('@@ objDedupeConfing' + objDedupeConfing);   
                } 
            }
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
    }
    
    public class fetchClusterWrpper {   //NOPMD
        @AuraEnabled public Integer page { get;set; }
        @AuraEnabled public List<sObject> sObjectrecords { get;set; }
        @AuraEnabled public List<sObject> sObjectTotalRecords { get;set; }
        @AuraEnabled public List<sObject> sObjectEntireList { get;set; }
        @AuraEnabled public List<sObject> sObjectTotalNotReviewed { get;set; }
        @AuraEnabled public Integer total { get;set; }
        @AuraEnabled public Integer totalNotReviewed { get;set; }
        @AuraEnabled public String selectedTabName { get;set; }
        @AuraEnabled public List<fetchSObjectWrpper> lstSObjWrapper {get;set;}
        @AuraEnabled public List<fetchSObjectWrpper> lstSObjEntireRecWrp {get;set;}
        
        public fetchClusterWrpper(){
            page = 0;
            sObjectrecords = new List<sObject>();
            sObjectTotalRecords = new List<sObject>();
            sObjectEntireList = new List<sObject>();
            sObjectTotalNotReviewed = new List<sObject>();
            total = 0;
            totalNotReviewed = 0;
            selectedTabName = '';
            lstSObjWrapper = new List<fetchSObjectWrpper>();
            lstSObjEntireRecWrp = new List<fetchSObjectWrpper>();
        }
    }
    public class fetchSObjectWrpper {   //NOPMD
        @AuraEnabled public String clusterRecId { get;set; }
        @AuraEnabled public String clusterId { get;set; }
        @AuraEnabled public Integer confidenceLevelCount { get;set; }
        @AuraEnabled public String sObjectRecordId { get;set; }
        @AuraEnabled public String sObjectRecordName { get;set; }
        @AuraEnabled public String sObjectName { get;set; }
        @AuraEnabled public Integer externalClusterId { get;set; }
        @AuraEnabled public Integer totalChildRecs { get;set; }
        @AuraEnabled public String clusterReviewStatus { get;set; }
        
        public fetchSObjectWrpper(){
            clusterRecId = '';
            clusterId = '';
            confidenceLevelCount = null;
            sObjectRecordId = '';
            sObjectRecordName = '';
            sObjectName = '';
            externalClusterId = null;
            totalChildRecs = 0;
            clusterReviewStatus = 'Not Reviewed';
        }
    }
    
    /*******************************************************
    Purpose: fetch all fields from Review and Polish Columns
    *******************************************************/
    @AuraEnabled
    public static List<wrpObjectFieldsList> fetchReviewClusterColumns(String filterObjName) {
        system.debug('@#$%filterObjName: '+filterObjName);
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        List<String> lstColmnAPIName = new List<String>();
        SObjectType schemaObjectName = Schema.getGlobalDescribe().get(filterObjName);
        Map<String, Schema.SObjectField> MapOfSObject = schemaObjectName.getDescribe().fields.getMap();     // NOPMD
        wrpObjectFieldsList objwrp = new wrpObjectFieldsList();
        
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c >([SELECT Id, SmartDD__Object_Name__c, SmartDD__Review_Polish_Display_Columns__c 
                                                                              FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c =: filterObjName WITH USER_MODE]);
        
        if(lstObjectColumns.Size() > 0){
            lstColmnAPIName = lstObjectColumns[0].SmartDD__Review_Polish_Display_Columns__c.split(',');
            
            for(String objDedupeFilter : lstColmnAPIName){
                if(objDedupeFilter != null && objDedupeFilter != ''){
                    String fieldLabelName = '';
                    if(objDedupeFilter == 'Owner.Name'){
                        fieldLabelName = 'Owner Name';
                    } else if(objDedupeFilter == 'Account.Name'){
                        fieldLabelName = 'Account Name';
                    } else{
                        fieldLabelName = String.valueOf(MapOfSObject.get(objDedupeFilter).getDescribe().getLabel());
                    }
                    wrpFields objField = new wrpFields();
                    objField.fieldName = fieldLabelName;
                    objField.fieldApiName = objDedupeFilter;
                    objwrp.FieldsList.add(objField);
                }
            }
        }
        newWrpList.add(objwrp);
        system.debug('@#$%newWrpList: '+newWrpList);
        return newWrpList;
    }
    
    @AuraEnabled
    public static String navigateClusterChildRecs(String navigateTo, String clusterId) {    //NOPMD
        String selObjectName = 'Lead';
        
        /* List stores the external Id of selected cluster Ids */
        List<SmartDD__Cluster__c> lstClusterId = new List<SmartDD__Cluster__c>();
        lstClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Id =: clusterId WITH USER_MODE];
        
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        /*if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        }*/
        
        //AggregateResult[] groupedResults = [SELECT Max(External_Cluster_Id__c) MaxVal FROM Cluster__c WITH USER_MODE];
        List<SmartDD__Cluster__c> lstMaxClusterIdVal = new List<SmartDD__Cluster__c>();
        lstMaxClusterIdVal = [SELECT Id, Name, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE ORDER BY Name DESC LIMIT 1];
        String clusterName = lstMaxClusterIdVal[0].Name;
        Integer maxClusterIdVal = integer.valueOf(clusterName.split('-',2)[1]);
        System.debug('@#$maxClusterIdVal: '+maxClusterIdVal);
        
           
        /* Integer variable will store the next cluster Id of the selected cluster Id */
        String nextClusterName = lstClusterId[0].Name;
        Integer nextExternalClusterId = Integer.valueof(nextClusterName.split('-',2)[1]);
        system.debug('@#$navigateTo0000: '+ navigateTo);
        if(navigateTo == 'Next') {
            system.debug('@#$navigateTo2222: '+ navigateTo);
            nextExternalClusterId = nextExternalClusterId + 1;
            system.debug('@#$nextExternalClusterId1111: '+ nextExternalClusterId);
        }
        else {
            system.debug('@#$navigateTo1111: '+ navigateTo);
            nextExternalClusterId = nextExternalClusterId - 1;
            system.debug('@#$nextExternalClusterId2222: '+ nextExternalClusterId);
        }
        List<SmartDD__Cluster__c> lstNextClusterId = new List<SmartDD__Cluster__c>();
        nextClusterName = 'C-'+String.valueof(nextExternalClusterId);
        lstNextClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Name =: nextClusterName AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        System.debug('@#$lstNextClusterId: '+lstNextClusterId.size());
        if(lstNextClusterId.size() == 0) {
            System.debug('@#$lstNextClusterId11111: '+lstNextClusterId.size());
            Integer CountCluster = lstNextClusterId.size();     //NOPMD
            while(CountCluster < 1) {
                if(navigateTo == 'Next') {
                    nextExternalClusterId = nextExternalClusterId + 1;
                    if(nextExternalClusterId > maxClusterIdVal) { 
                        break;
                    }
                }
                else {
                    nextExternalClusterId = nextExternalClusterId - 1;
                    if(nextExternalClusterId < 1) {
                        break;
                    }                   
                }
                nextClusterName = 'C-'+String.valueof(nextExternalClusterId);
                lstNextClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Name =: nextClusterName AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]; // NOPMD
                CountCluster = lstNextClusterId.size();      
                  
            }
        }
        
        if(lstNextClusterId.Size() > 0 && lstNextClusterId[0].SmartDD__Total_Child_Records__c != null && lstNextClusterId[0].SmartDD__Total_Child_Records__c > 1) { 
            return lstNextClusterId[0].Id;
        }
        else {
        
            Integer count = 0;
            if(lstNextClusterId.size() > 0) {
                count = Integer.valueof(lstNextClusterId[0].SmartDD__Total_Child_Records__c);
            }
            Map<Integer, SmartDD__Cluster__c> mapClusterRecords = new Map<Integer, SmartDD__Cluster__c>();
            
            List<SmartDD__Cluster__c> lstClusterRecords = new List<SmartDD__Cluster__c>([SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
            
            for(SmartDD__Cluster__c objClusters : lstClusterRecords) {
                String strClusterName = objClusters.Name;
                mapClusterRecords.put(Integer.valueof(strClusterName.split('-',2)[1]), objClusters);
            }
            System.debug('@#$mapClusterRecords: '+mapClusterRecords);
            SmartDD__Cluster__c objClusterrec = new SmartDD__Cluster__c();
            while (count < 2) {
                if(navigateTo == 'Next') {
                    nextExternalClusterId = nextExternalClusterId + 1;
                    if(nextExternalClusterId > maxClusterIdVal) {
                        break;
                    }                   
                }
                else {
                    nextExternalClusterId = nextExternalClusterId - 1;
                    if(nextExternalClusterId < 1) {break;
                    }                   
                }
                
                System.debug('@#$nextExternalClusterId: '+nextExternalClusterId);
                if(mapClusterRecords.containsKey(nextExternalClusterId) == true) {
                    objClusterrec = mapClusterRecords.get(nextExternalClusterId);
                    count = Integer.valueof(objClusterrec.SmartDD__Total_Child_Records__c);
                }
            }
            return objClusterrec.Id;
        }
    }
    
    @AuraEnabled
    public static Boolean postClusterChildRecs(String clusterChildRecIds, String clusterId, Integer clusterNo, Integer ClusterTotal, String strObjectName) {  // NOPMD
    
        /* List of Selected Child Records for selected cluster */
        List<String> lstClusterChildRecIds = new List<String>();
        lstClusterChildRecIds = clusterChildRecIds.split(',');
        //String strObjectName = 'Lead';
        
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        /*if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        }*/
        
        system.debug('@#$clusterId: '+clusterId);
        system.debug('@#$clusterNo: '+clusterNo);
        system.debug('@#$ClusterTotal: '+ClusterTotal);
        system.debug('@#$lstClusterChildRecIds: '+lstClusterChildRecIds);
        system.debug('@#$clusterChildRecIds: '+clusterChildRecIds);
        /* To fetch the OrganisationId and UserId */
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c, SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);

        // Organization Id
        String orgId = lstAuthorizedUser[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstAuthorizedUser[0].SmartDD__UserId__c;
        
        /* List to store external Ids of selected child records */
        List<SmartDD__Child_Cluster_Record__c> lstChildRecExternalIds = new List<SmartDD__Child_Cluster_Record__c>();
        if(!String.isBlank(clusterChildRecIds)) {
            system.debug('@#$lstClusterChildRecIds181: '+lstClusterChildRecIds);
            system.debug('@#$lstClusterChildRecIds181_SIze: '+lstClusterChildRecIds.Size());
            lstChildRecExternalIds = [SELECT SmartDD__Cluster_Record_External_Id__c,SmartDD__Cluster_Object_Id__c,SmartDD__Object_Name__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Object_Id__c IN: lstClusterChildRecIds AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        }
        system.debug('@#$111lstChildRecExternalIds: '+lstChildRecExternalIds);
        system.debug('@#$111lstChildRecExternalIds_Size: '+lstChildRecExternalIds.size());
        
        List<SmartDD__Child_Cluster_Record__c> lstTrainingRecIds = new List<SmartDD__Child_Cluster_Record__c>();
        if(!String.isBlank(clusterChildRecIds)) {
            system.debug('@#$lstClusterChildRecIds111: '+lstClusterChildRecIds);
            lstTrainingRecIds = [SELECT SmartDD__Cluster_Record_External_Id__c, SmartDD__Cluster_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: clusterId AND SmartDD__Cluster_Object_Id__c NOT IN : lstClusterChildRecIds AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
            system.debug('@#$lstTrainingRecIds: '+lstTrainingRecIds);
        } else {
            system.debug('@#$lstClusterChildRecIds222: '+lstClusterChildRecIds);
            lstTrainingRecIds = [SELECT SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: clusterId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        }
        
        /* List stores the external Id of selected cluster Ids */
        List<SmartDD__Cluster__c> lstClusterId = new List<SmartDD__Cluster__c>();
        lstClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Id =: clusterId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        if(lstClusterId.size() > 0 && lstClusterId[0].SmartDD__Total_Child_Records__c > 1 && lstClusterId[0].SmartDD__Cluster_Review_Status__c == 'Not Reviewed') {
            /* String to store json request to be sent to java side for training file */
            String JSONClusterDetails = '';     //NOPMD
            Boolean isMannual = false;
            String strCheckedRecId = '';
            JSONClusterDetails += '{';
            JSONClusterDetails  += '"organisationid":"' + orgId + '",';
            JSONClusterDetails  += '"userid":"' + userId + '",';
            JSONClusterDetails += '"clusterid":"' + lstClusterId[0].SmartDD__External_Cluster_Id__c + '",';
            if(lstClusterId[0].SmartDD__External_Cluster_Id__c == null) {
                isMannual = true;JSONClusterDetails  += '"ismanualcluster":"true",';
            }
            else {
                JSONClusterDetails  += '"ismanualcluster":"false",';
            }
            
            if(!String.isBlank(clusterChildRecIds)) {
                JSONClusterDetails += '"checkedrecordids":[';
                for(SmartDD__Child_Cluster_Record__c objChildRecs: lstChildRecExternalIds){
                    if(strCheckedRecId == '') {
                        strCheckedRecId = objChildRecs.SmartDD__Cluster_Record_External_Id__c;
                    }
                    JSONClusterDetails += '"' + objChildRecs.SmartDD__Cluster_Record_External_Id__c + '",';
                }
                JSONClusterDetails = JSONClusterDetails.removeEnd(',');
                JSONClusterDetails += '],';
            }
            
            Integer cnt = 1;
            JSONClusterDetails += '"trainingfilerecordids":[';
            if(strCheckedRecId != '') {
                JSONClusterDetails += '"' + strCheckedRecId + '",';
            }
            if(!String.isBlank(clusterChildRecIds) && lstClusterId[0].SmartDD__Total_Child_Records__c != lstChildRecExternalIds.Size()) {
                system.debug('@#$%666666666666: '+lstClusterId[0].SmartDD__Total_Child_Records__c);
                for(SmartDD__Child_Cluster_Record__c objChildRecs: lstTrainingRecIds) {
                    if(objChildRecs.SmartDD__Cluster_Record_External_Id__c != strCheckedRecId) {
                        if(cnt <= 1) {  //NOPMD
                            JSONClusterDetails += '"' + objChildRecs.SmartDD__Cluster_Record_External_Id__c + '",';
                        } else {
                            break;    
                        }
                        cnt++;
                    }
                }
            }
            else {
                system.debug('@#$%555555555555555: '+lstTrainingRecIds);
                Integer leastCount = 1;
                if(strCheckedRecId == '') {
                    leastCount = 2;
                }
                
                if(lstTrainingRecIds.Size() < 1) { 
                    lstTrainingRecIds = lstChildRecExternalIds;    
                } 
                for(SmartDD__Child_Cluster_Record__c objChildRecs: lstTrainingRecIds) {
                    if(objChildRecs.SmartDD__Cluster_Record_External_Id__c != strCheckedRecId) {
                        if(cnt <= leastCount) {JSONClusterDetails += '"' + objChildRecs.SmartDD__Cluster_Record_External_Id__c + '",';
                        } else {
                            break;    
                        }
                        cnt++;
                    }
                }                                
            }
            JSONClusterDetails = JSONClusterDetails.removeEnd(',');
            JSONClusterDetails += '],';
            
            system.debug('@#$clusterChildRecIds: '+ clusterChildRecIds);
            List<SmartDD__Child_Cluster_Record__c> lstManulaChildRecIds = new List<SmartDD__Child_Cluster_Record__c>();
            lstManulaChildRecIds = [SELECT SmartDD__Cluster_Record_External_Id__c,SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: clusterId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]; 
            
            if(isMannual == true) {
                JSONClusterDetails += '"mannualclusterrecordids":[';
                for(SmartDD__Child_Cluster_Record__c objChildRecs: lstManulaChildRecIds){
                    JSONClusterDetails += '"' + objChildRecs.SmartDD__Cluster_Record_External_Id__c + '",';
                }
                JSONClusterDetails = JSONClusterDetails.removeEnd(',');
                JSONClusterDetails += '],';
            }
            JSONClusterDetails  += '"objectName":"' + strObjectName + '"';
            JSONClusterDetails = JSONClusterDetails.removeEnd(',');
            
            JSONClusterDetails += '}';
            system.debug('@#$%JSONClusterDetails: '+JSONClusterDetails);
            system.debug('@#$%lstChildRecExternalIds: '+lstChildRecExternalIds.Size());
            system.debug('@#$%Total_Child_Records__c: '+lstClusterId[0].SmartDD__Total_Child_Records__c);
            system.debug('@#$%isMannual: '+isMannual);
            
            String returnValue = httpClusterJSONRequest(System.Label.SFImportAPI+'/cluster/save', JSONClusterDetails, isMannual, strNewMasterClusterId);
            String isSuccess = '';
            String externalClusterId = '';
            system.debug('@#$%returnValue  : '+returnValue );
            if(isMannual == false) {
                isSuccess = returnValue;
            }
            else {
                List<String> lstReturnVal = returnValue.Split('@#');
                system.debug('@#$%lstReturnVal : '+lstReturnVal );
                system.debug('@#$%JSONClusterDetails: '+lstReturnVal[0] + '@#2: '+ lstReturnVal[1]);
                isSuccess = lstReturnVal[0]; externalClusterId = lstReturnVal[1];
            }
            
            
            if(isSuccess == '1') {
              /* To delete the list of records selected in the cluster detail page */
                if(!String.isBlank(clusterChildRecIds) && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isDeletable()) { 
                    delete lstChildRecExternalIds;  
                }
                for(SmartDD__Cluster__c objCluster : lstClusterId) {
                    objCluster.SmartDD__Cluster_Review_Status__c = 'Reviewed';
                    if(externalClusterId != '' && isMannual == true) {
                        objCluster.SmartDD__External_Cluster_Id__c = Decimal.valueof(externalClusterId);
                    }
                }
                if(lstClusterId.size() > 0  && Schema.sObjectType.SmartDD__Cluster__c.isUpdateable()) {update lstClusterId;
                }
                
                // Setting Up Debug Log
                List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Distinct_Cluster_Counter__c, SmartDD__Total_Reviewed_Records__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
                if(lstDebugLog.size() > 0) {
                    if(lstDebugLog[0].SmartDD__Total_Reviewed_Records__c != null) { //NOPMD
                        lstDebugLog[0].SmartDD__Total_Reviewed_Records__c = lstDebugLog[0].SmartDD__Total_Reviewed_Records__c + 1;
                    } else {
                        lstDebugLog[0].SmartDD__Total_Reviewed_Records__c = 1;
                    }
                    if(lstChildRecExternalIds.size() > 0) { //NOPMD
                        if(lstDebugLog[0].SmartDD__Distinct_Cluster_Counter__c != null) {
                            lstDebugLog[0].SmartDD__Distinct_Cluster_Counter__c = lstDebugLog[0].SmartDD__Distinct_Cluster_Counter__c + 1;
                        } else {
                            lstDebugLog[0].SmartDD__Distinct_Cluster_Counter__c = 1;
                        }
                    }
                    if(lstDebugLog.size() > 0  && Schema.sObjectType.SmartDD__Cluster__c.isUpdateable()) {update lstDebugLog; } //NOPMD
                }
            }
        }
        
        List<SmartDD__Cluster__c> lstNotReviewedCluster = new List<SmartDD__Cluster__c>();
        lstNotReviewedCluster = [SELECT Id, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE SmartDD__Cluster_Review_Status__c = 'Not Reviewed' AND SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        System.debug('@#$%lstNotReviewedCluster: '+ lstNotReviewedCluster.size());
        if(lstNotReviewedCluster.size() > 0) {
            return true;
        }
        else {
            return false;
        }
    }
    
    @AuraEnabled
    public static String autoReviewAllClusters(String strObjectName) {  //NOPMD
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';Integer totalClusters = 0;
        system.debug('@#$strObjectName: '+strObjectName);
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjectName);
        system.debug('@#$objMasterClusterId: '+objMasterClusterId.SmartDD__New_Master_Cluster_Id__c);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;totalClusters = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        /*if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        }*/
        
        //Setting Up the Logs
        List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Distinct_Cluster_Counter__c, SmartDD__Auto_Reviewed_Record_Counts__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
        Integer totalAutoReviewedClusters = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Cluster_Review_Status__c = \'Not Reviewed\' AND SmartDD__Total_Child_Records__c > 1 WITH USER_MODE');
        if(lstDebugLog.size() > 0) {
            lstDebugLog[0].SmartDD__Auto_Reviewed_Record_Counts__c = totalAutoReviewedClusters;
        }
        if(Schema.sObjectType.SmartDD__Dedupe_Log__c.fields.SmartDD__Auto_Reviewed_Record_Counts__c.isUpdateable()) {
          update lstDebugLog;
          }
        String strBatchProcessId = '';
        List<SmartDD__Cluster__c> lstCLusterUpdate = new List<SmartDD__Cluster__c>();
        lstCLusterUpdate = [SELECT Id, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Cluster_Review_Status__c = 'Not Reviewed' WITH USER_MODE LIMIT 15000];
        if(lstCLusterUpdate.size() > 10000) {
            batchAutoReviewAllCluster autoReviewBatch = new batchAutoReviewAllCluster(strNewMasterClusterId);
            Id BatchProcessId = Database.executeBatch(autoReviewBatch,200);     //NOPMD
            strBatchProcessId = string.valueOf(BatchProcessId);
            /**Update auto review batchId in custom setting*/
            SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(strObjectName);
            if(Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isCreateable() 
            && Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isAccessible()
            && Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isUpdateable())
            {
                manageClusterBatch.SmartDD__Batch_Id__c = strBatchProcessId;
            }
            if(Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.isCreateable() && 
               Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.isAccessible() &&
               Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.isUpdateable())
                {
                 upsert manageClusterBatch;
                }
           
        }
        else {
            for(SmartDD__Cluster__c objClusterUpdate :lstCLusterUpdate) {
                objClusterUpdate.SmartDD__Cluster_Review_Status__c = 'Auto Reviewed';
            }
            if(lstCLusterUpdate.size() > 0) {
                SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstCLusterUpdate); 
                update decision.getRecords();
            }        
        }        
        return strBatchProcessId;
    }
    
    //To get batch status 
    @AuraEnabled
    public static AsyncApexJobWrapper batchStatus(Id BatchProcessId, String strObjectName) {        //NOPMD
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper();  
        if(BatchProcessId != null || BatchProcessId != ''){
            objApexJob.lstAsyncApexJob = [SELECT Status, JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE]; objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems; objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed;objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status;
        }        
        if(objApexJob.JobItemStatus == 'Completed') {
            SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(strObjectName);
            if(Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isCreateable() 
                && Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isAccessible()
                && Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isUpdateable())
                {
                    manageClusterBatch.SmartDD__Batch_Id__c = '';
                }
            if(Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.isCreateable() && 
               Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.isAccessible() &&
               Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.isUpdateable())
            {
                  upsert manageClusterBatch;
            }}      
        return objApexJob;
    }
    
    @AuraEnabled
    public static Boolean checkClusterStat() {
        List<SmartDD__Cluster__c> lstCLusterUpdate = new List<SmartDD__Cluster__c>();
        lstCLusterUpdate = [SELECT Id, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE SmartDD__Cluster_Review_Status__c = 'Not Reviewed' AND SmartDD__Total_Child_Records__c > 1 WITH USER_MODE];
        system.debug('@#$lstCLusterUpdate: '+lstCLusterUpdate.size());
        if(lstCLusterUpdate.size() > 0) {
            return true;
        }
        else {
            return false;
        }
    }
    
    @AuraEnabled
    public static Boolean removeIgnoreGroup(String ignoreGroupId, String strObjectName) {   // NOPMD
       String strNewMasterClusterId = '';
       Integer totalClusters = 0;
       SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjectName);
       if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
           strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
           totalClusters = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
       }
       /*if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
           strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
       }*/
       List<SmartDD__Cluster__c> lstAllClusterId = new List<SmartDD__Cluster__c>([SELECT Id FROM SmartDD__Cluster__c WHERE Id =:ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
       list<SmartDD__Child_Cluster_Record__c> lstNewChildClusterRec = new List<SmartDD__Child_Cluster_Record__c>();
       list<SmartDD__Cluster__c> lstNewClusterRec = new List<SmartDD__Cluster__c>();
       List<SmartDD__Child_Cluster_Record__c> IgnoreGrouplst = [SELECT Id, Name, SmartDD__Cluster_Id__c, SmartDD__MannualCluster__c, SmartDD__Cluster_Record_External_Id__c, SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];//NOPMD
       Set<Decimal> strExternalIds = new Set<Decimal>();
       for(SmartDD__Child_Cluster_Record__c clusterRec : IgnoreGrouplst ){
           SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
           objCluster.SmartDD__External_Cluster_Id__c = Decimal.valueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c);objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId; objCluster.SmartDD__Object_Name__c = strObjectName;
           //objCluster.All_Cluster_Record__c = lstAllClusterId[0].All_Cluster_Record__c;
           strExternalIds.add(Decimal.valueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c));lstNewClusterRec.add(objCluster);  
       }
        
       Boolean  ExternalClusterId = Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isAccessible();   //NOPMD
       if(lstNewClusterRec.size() > 0 && ExternalClusterId && Schema.sObjectType.SmartDD__Cluster__c.isCreateable()){
           SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstNewClusterRec); 
           Insert decision.getRecords();
       }
       
       List<SmartDD__Cluster__c> lstDeleteCluster = [SELECT Id FROM SmartDD__Cluster__c WHERE Id =: ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        
       Boolean ClusterDeleteCheck = SmartDD__Cluster__c.sObjectType.getDescribe().isDeletable();    // NOPMD
       if(lstDeleteCluster.size() > 0 && ClusterDeleteCheck &&  Schema.sObjectType.SmartDD__Cluster__c.isDeletable()){
           Delete lstDeleteCluster;
       }
       
       List<SmartDD__Cluster__c> lstNewCluster = [SELECT Id, Name, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__External_Cluster_Id__c IN:strExternalIds AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
       for(SmartDD__Cluster__c objnewCluster : lstNewCluster) {
           for(SmartDD__Child_Cluster_Record__c clusterRec : IgnoreGrouplst ){
               if(objnewCluster.SmartDD__External_Cluster_Id__c == Decimal.ValueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c)) {
                   SmartDD__Child_Cluster_Record__c objChildCluster = new SmartDD__Child_Cluster_Record__c();
                   objChildCluster.SmartDD__MannualCluster__c = clusterRec.SmartDD__MannualCluster__c;
                   objChildCluster.SmartDD__Cluster_Record_External_Id__c = clusterRec.SmartDD__Cluster_Record_External_Id__c;
                   objChildCluster.SmartDD__Cluster_Object_Id__c = clusterRec.SmartDD__Cluster_Object_Id__c;
                   objChildCluster.SmartDD__Cluster_Id__c = objnewCluster.Id;
                   objChildCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
                   objChildCluster.SmartDD__Object_Name__c = strObjectName;
                   lstNewChildClusterRec.add(objChildCluster);
                   objnewCluster.SmartDD__External_Cluster_Id__c = null;
               }
           }
       }
       
       Boolean MannualCluster = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__MannualCluster__c.isCreateable();       // NOPMD
       Boolean ClusterRecordExternal = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isAccessible();  // NOPMD
       //Boolean ClusterLeadId = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Object_Id__c.isCreateable();
      // Boolean ClusterId = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isCreateable();
        
       if(lstNewChildClusterRec.size() > 0 && MannualCluster && ClusterRecordExternal  || Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isCreateable() ){
           SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstNewChildClusterRec); 
           Insert decision.getRecords();
       }
       if(lstNewCluster.size() > 0 && Schema.sObjectType.SmartDD__Cluster__c.isUpdateable()){
           SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstNewCluster); 
           Update decision.getRecords();
       }
       List<SmartDD__Cluster__c> lstNotReviewedCluster = new List<SmartDD__Cluster__c>();
       lstNotReviewedCluster = [SELECT Id, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE SmartDD__Cluster_Review_Status__c = 'Not Reviewed' AND SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
       System.debug('@#$%lstNotReviewedCluster: '+ lstNotReviewedCluster.size());
       if(lstNotReviewedCluster.size() > 0) {
           return true;
       }
       else {
           return false;
       }
    }
    
    /******************************************************
    Http Request Body
    ******************************************************/
    public static string httpClusterJSONRequest(String strAWSEndpointLead, string strBody, Boolean isMannual, String strNewMasterClusterId) {       //NOPMD  
        string strResponseBody='';
        string strResponseStatus=''; 
        string strReturnValue='';   
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(60000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpointLead);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes: '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: '+jsonString);
            system.debug('@@#$objSyncDataStatus: '+objSyncDataStatus);
            System.debug('@@objSyncDataStatus: '+ objSyncDataStatus.IsSuccess);
            List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Distinct_Cluster_Counter__c, SmartDD__Total_Reviewed_Records__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId  AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
            if(lstDebugLog.Size() > 0) {
                lstDebugLog[0].SmartDD__Training_File_Records_Count__c = Integer.ValueOf(objSyncDataStatus.totalTrainingRecords);
                update lstDebugLog;
            }
            if(isMannual == false) {
               return objSyncDataStatus.isSuccess;
            }
            else {
                strReturnValue = objSyncDataStatus.IsSuccess + '@#' + objSyncDataStatus.strClusterId; return strReturnValue;
            }
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static SmartDD__Manage_Cluster_Batch_Id__c getReviewBatchId(String strObjectName){
        SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(strObjectName);
        system.debug('@#$manageClusterBatch : '+manageClusterBatch.SmartDD__Batch_Id__c);        
        return manageClusterBatch;
    }    
    @AuraEnabled
    public static SmartDD__ReDe_Dupe_Configuration__c getDeDupeConfiguration(){
        SmartDD__ReDe_Dupe_Configuration__c dedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        return dedupeconfig;
    }

    /** Get Customsetting field Clusters_Completed_Stat__c value. */
    @AuraEnabled
    public static SmartDD__ReDe_Dupe_Configuration__c getClustersCompletedStat(){
        system.debug('dedupeconfig...');
        SmartDD__ReDe_Dupe_Configuration__c dedupeconfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');  
        system.debug('dedupeconfig...'+ dedupeconfig);
        return dedupeconfig;
    }    
       
    /** Update Customsetting field Last_Create_Cluster_Progress__c value.*/
    @AuraEnabled
    public static SmartDD__ReDe_Dupe_Configuration__c updateCreateClusterProgress(Integer lastCreateClusterProgress, Integer clusterEstimatedTime){
        SmartDD__ReDe_Dupe_Configuration__c dedupeconfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration'); 
        dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
        dedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = lastCreateClusterProgress;
        dedupeConfig.SmartDD__Cluster_Estimated_Time__c = clusterEstimatedTime;
     
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isAccessible() || Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isUpdateable() &&
          (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable())||
          (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isUpdateable())) {
            update dedupeConfig;
        }                 
        return dedupeConfig;
    }
    @AuraEnabled 
    public static string CheckApiStatus() {                //NOPMD     
        
        SmartDD__StartDedupeStatus__c startdedupedata = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');String apistatus = startdedupedata.SmartDD__IsSuccess__c; 
        if( Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__StartDedupeBatchId__c.isAccessible()
        && Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__StartDedupeBatchId__c.isCreateable()
        && Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__StartDedupeBatchId__c.isUpdateable()){
            startdedupedata.SmartDD__StartDedupeBatchId__c = '' ;
        }            
        if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.isAccessible()
        && Schema.sObjectType.SmartDD__StartDedupeStatus__c.isCreateable()
        && Schema.sObjectType.SmartDD__StartDedupeStatus__c.isUpdateable()){
            upsert startdedupedata;
        }       
        system.debug('@@apistatus'+apistatus);
        return apistatus;       
    }
    /******************************************************
     wrapper class
    ******************************************************/
    public class wrpObjectFieldsList {//NOPMD
        @AuraEnabled public String strObjectName {get;set;}//NOPMD
        @AuraEnabled public List<String> objectFieldsList {get;set;}//NOPMD
        @AuraEnabled public List<wrpFields> FieldsList {get;set;}//NOPMD
        
        public wrpObjectFieldsList(){
            strObjectName = '';
            objectFieldsList = new List<String>();
            FieldsList = new List<wrpFields>();
        }
    }
    public class wrpFields {//NOPMD
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldApiName {get;set;}
        @AuraEnabled public String fieldTypeName {get;set;}
        @AuraEnabled public Boolean isSelected {get;set;}
        
        public wrpFields(){
            fieldName = '';
            fieldApiName ='';
            fieldTypeName = '';
            isSelected = false;
        }  
    }
    public class AsyncApexJobWrapper{
        @AuraEnabled public Integer TotalJobItems{get;set;}//NOPMD
        @AuraEnabled public String JobItemStatus{get;set;}//NOPMD
        @AuraEnabled public Integer JobItemsProcessed{get;set;}//NOPMD
        @AuraEnabled public String ClustersCompletedStat {get;set;}//NOPMD
        @AuraEnabled public String startDedupeBatchId {get;set;}    //NOPMD
        @AuraEnabled public Decimal LastCreateClusterProgress{get;set;}     //NOPMD
        
        @AuraEnabled public List<AsyncApexJob> lstAsyncApexJob{get;set;}
    }
   
}