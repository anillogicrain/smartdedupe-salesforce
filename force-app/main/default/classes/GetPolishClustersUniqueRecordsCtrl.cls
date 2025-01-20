/********************************************************************************************
* NAME         : GetPolishClustersUniqueRecordsCtrl
* DESCRIPTION  : This class is use to get the Polist clusters unique records.
* 
* @AUTHOR: dev team
* @DATE: 05/16/2019
*
*
* MODIFICATION LOG:
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
dev team                        05/16/2019                            -
********************************************************************************************/
global with sharing class GetPolishClustersUniqueRecordsCtrl { //NOPMD
   
    
    @AuraEnabled 
    public static string getDedupeStatus(String dedupeObjectName){
        system.debug('objectName' + dedupeObjectName);
        String singleCluster = '';
        String strProcessType = '';
        SmartDD__De_Dupe_Configuration__c dedupeExtStat = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');              
        SmartDD__ReDe_Dupe_Configuration__c reDedupeExtStat = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(dedupeObjectName);
        if(objMasterClusterId != null){
            strProcessType = objMasterClusterId.SmartDD__Process_Type__c;
             system.debug('strProcessType' + strProcessType);
        }
       
        if(objMasterClusterId != null && strProcessType == 'Dedupe'){
            system.debug('In IF');
            singleCluster = dedupeExtStat.SmartDD__Single_Clusters_Completed_Stat__c;
        }else if(objMasterClusterId != null && strProcessType == 'ReDedupe') {
            singleCluster = reDedupeExtStat.SmartDD__Single_Clusters_Completed_Stat__c;
        }       
        system.debug('##singleCluster' + singleCluster);   
        return singleCluster;
    }
     /**********************************************************************************************
Purpose:  create new cluster and selected child records
**********************************************************************************************/  
    @AuraEnabled
    public static string CreateClusterRec(String clusterChildRecIds, String objectName){ //NOPMD
        /*fetch new Master Cluster Id*/
        system.debug('###clusterChildRecIds' +clusterChildRecIds);
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(ObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
           // strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        //} 
        List<String> lstClusterChildRecIds = new List<String>();
        lstClusterChildRecIds = clusterChildRecIds.split(',');
        List<SmartDD__Child_Cluster_Record__c> lstChildReIds = new List<SmartDD__Child_Cluster_Record__c>();
        List<SmartDD__Child_Cluster_Record__c> updatelstChildReIds = new List<SmartDD__Child_Cluster_Record__c>();
        if(!String.isBlank(clusterChildRecIds)) {
            lstChildReIds = [SELECT SmartDD__Cluster_Record_External_Id__c, SmartDD__Cluster_Id__c, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Id__r.SmartDD__External_Cluster_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Object_Id__c IN : lstClusterChildRecIds AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        }
        System.debug('lstClusterChildRecIds......................'+lstClusterChildRecIds);
        System.debug('strNewMasterClusterId......................'+strNewMasterClusterId);
        System.debug('lstChildReIds.size()......................'+lstChildReIds.size());
        List<SmartDD__Cluster__c> lstParentClusterRecs = new List<SmartDD__Cluster__c>();  
        lstParentClusterRecs = [Select ID, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>();
        Id clusterId = null;
        
        SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
        //System.debug('lstParentClusterRecs.size()......................'+lstParentClusterRecs.size());
        //System.debug('strNewMasterClusterId......................'+strNewMasterClusterId);
        if(lstParentClusterRecs.size() > 0) {
            //objCluster.All_Cluster_Record__c = lstParentClusterRecs[0].All_Cluster_Record__c;
            objCluster.SmartDD__Object_Name__c = objectName;
            objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
            objCluster.SmartDD__Cluster_Review_Status__c = 'Auto Reviewed';
            
            lstClusters.add(objCluster);
        }
        if(lstClusters.size() > 0 ){
            clusterId = lstClusters[0].id;
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstClusters); 
            system.debug('86 desion-->'+ decision.getRecords());
            lstClusters = decision.getRecords(); //NOPMD
            Insert decision.getRecords();
            system.debug('88 desion-->'+ decision.getRecords()[0] + ' :: > ' + lstClusters[0].id );
        }
        System.debug('lstClusters[0].Id.................................'+lstClusters[0].Id);
        for(SmartDD__Child_Cluster_Record__c childcluster : lstChildReIds){
            SmartDD__Child_Cluster_Record__c objNewChldCluster = new SmartDD__Child_Cluster_Record__c();
            objNewChldCluster.SmartDD__Cluster_Id__c = lstClusters[0].Id;
            objNewChldCluster.SmartDD__Object_Name__c = objectName;
            objNewChldCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;
            objNewChldCluster.SmartDD__Cluster_Object_Id__c = childcluster.SmartDD__Cluster_Object_Id__c;
            objNewChldCluster.SmartDD__MannualCluster__c = true;
            objNewChldCluster.SmartDD__Cluster_Record_External_Id__c = childcluster.SmartDD__Cluster_Record_External_Id__c;
            updatelstChildReIds.add(objNewChldCluster);
        }
       
        
        if(updatelstChildReIds.size() > 0 ){
            if(Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isDeletable()){
                delete lstChildReIds; //NOPMD
            }            
            System.debug('108 updatelstChildReIds......................'+Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isUpdateable());
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPSERTABLE, updatelstChildReIds); 
            System.debug('110 updatelstChildReIds......................'+decision.getRecords());
            System.debug('111 updatelstChildReIds......................'+decision.getRemovedFields());    
              
            upsert decision.getRecords(); //NOPMD
        }
        System.debug('updatelstChildReIds.size()......................'+updatelstChildReIds.size());
        
        /* To fetch the OrganisationId and UserId */
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c,SmartDD__Username__c,SmartDD__Email__c, SmartDD__Last_Name__c, SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        // Organization Id
        String orgId = lstAuthorizedUser[0].SmartDD__Organization_Id__c;
        // User Id
        String userId = lstAuthorizedUser[0].SmartDD__UserId__c;
        
        /* String to store json request to be sent to java side for training file */
        String JSONClusterDetails = ''; //NOPMD
        Boolean isMannual = true;
        String strCheckedRecId = '';
        if(updatelstChildReIds.size() > 0){
            JSONClusterDetails += '{';
            JSONClusterDetails  += '"organisationid":"' + orgId + '",';
            JSONClusterDetails  += '"userid":"' + userId + '",';
            JSONClusterDetails += '"clusterid":"' + updatelstChildReIds[0].SmartDD__Cluster_Id__r.SmartDD__External_Cluster_Id__c + '",';
            JSONClusterDetails  += '"ismanualcluster":"true",';
            // To save distinct records
            JSONClusterDetails += '"checkedrecordids":[';
            JSONClusterDetails += '],'; 
        }
        // To save matched records
        Integer cnt = 1;
        JSONClusterDetails += '"trainingfilerecordids":[';
        for(SmartDD__Child_Cluster_Record__c objChildRecs: updatelstChildReIds) {
            if(objChildRecs.SmartDD__Cluster_Record_External_Id__c != strCheckedRecId) {
                if(cnt <= 2) {
                    JSONClusterDetails += '"' + objChildRecs.SmartDD__Cluster_Record_External_Id__c + '",';
                } else {
                    break;    
                }
                cnt++;
            }
        }
        JSONClusterDetails = JSONClusterDetails.removeEnd(',');
        JSONClusterDetails += '],';
        Integer count = 1;
        JSONClusterDetails += '"mannualclusterrecordids":[';
        for(SmartDD__Child_Cluster_Record__c objChildRecs: updatelstChildReIds) {
            if(objChildRecs.SmartDD__Cluster_Record_External_Id__c != strCheckedRecId) {
                if(count <= 2) {
                    JSONClusterDetails += '"' + objChildRecs.SmartDD__Cluster_Record_External_Id__c + '",';
                } else {
                    break;    
                }
                count++;
            }
        }
        JSONClusterDetails = JSONClusterDetails.removeEnd(',');
        JSONClusterDetails += '],';
        JSONClusterDetails += '"objectName":"' + objectName + '"';
        JSONClusterDetails = JSONClusterDetails.removeEnd(',');
        JSONClusterDetails += '}';
        System.debug('updatelstChildReIds[0].SmartDD__Cluster_Id__c......................'+updatelstChildReIds[0]);
        httpClusterJSONRequest(System.Label.SFImportAPI+'/cluster/save', JSONClusterDetails, isMannual, updatelstChildReIds[0].SmartDD__Cluster_Id__c);
        
        return null;
    }
    
    
    /******************************************************
Http Request Body
******************************************************/
    @Future(callout=true)
    public static void httpClusterJSONRequest(String strAWSEndpointLead, string strBody, Boolean isMannual, String sfClusterId) { //NOPMD
        system.debug('strAWSEndpointLead'+strAWSEndpointLead);
        system.debug('strBody'+strBody);
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
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('objSyncDataStatus'+objSyncDataStatus);
            
            // Update the External cluster Id in Cluster table.
            SmartDD__Cluster__c objUpdateClusters = new SmartDD__Cluster__c();
            objUpdateClusters = [SELECT Id, SmartDD__Object_Name__c,SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE Id =: sfClusterId WITH USER_MODE];
            objUpdateClusters.SmartDD__External_Cluster_Id__c = Decimal.valueof(objSyncDataStatus.strClusterId);
            update objUpdateClusters; //NOPMD
            
            
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
        
        
    }
    
    @AuraEnabled
    public static lightningTableWrapper getClusterDetails(String fieldstoget, String ObjectName, String sortField, boolean isAsc,decimal pageNumber, Integer pageSize,String searchKey,String navigation,String firstLimitVal,String lastLimitVal) { //NOPMD
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        List<SmartDD__All_CLuster_Record__c> totalClusters = new List<SmartDD__All_CLuster_Record__c>();
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(ObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = database.query('SELECT Id FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE ORDER BY CreatedDate ASC LIMIT 5');
        }
        
        system.debug('@@strNewMasterClusterId: '+strNewMasterClusterId);
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        String queryString = '';
        String queryStringTotal = '';
        String searchQuery = '';
        String searchQueryTotal = '';
        String strFirstReturnVal = '';
        String strLastReturnVal = '';
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
            SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = SmartDD__Unique_Lead_Page_Size__c.getValues('Unique Lead Page Size');
            pageSize = integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);
            offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(perPageRecordSize.SmartDD__Per_Page_Record__c);
        }
        System.debug('String.escapeSingleQuotes(fieldstoget)@@@ ' + String.escapeSingleQuotes(fieldstoget));
        
        
        List<SmartDD__Cluster__c> lstParentClusterRecs = new List<SmartDD__Cluster__c>([SELECT Id, Name, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        
        Set<Id> setClusterRecId = new Set<Id>();
        System.debug('fieldstoget = '+fieldstoget);
        System.debug('ObjectName ='+ObjectName);
        
        Integer intTotalObjRecs = 0;
        String strQueryGetTotalRecs = 'SELECT count() FROM SmartDD__Child_Cluster_Record__c where SmartDD__MannualCluster__c != true AND SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        intTotalObjRecs = Database.countQuery(strQueryGetTotalRecs);
        
        List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>();
        if(intTotalObjRecs > 20000) {
            lstClusterRecs = [SELECT Id, SmartDD__Cluster_Object_Id__c,SmartDD__MannualCluster__c, SmartDD__Cluster_Record_External_Id__c,CreatedDate FROM SmartDD__Child_Cluster_Record__c where SmartDD__MannualCluster__c != true AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE ORDER BY CreatedDate LIMIT : pageSize];
            strFirstReturnVal = string.valueOf(lstClusterRecs[0].CreatedDate);
            Integer intOffsetVal = pageSize - 1;
            strLastReturnVal = string.valueOf(lstClusterRecs[intOffsetVal].CreatedDate);
        } else {
            lstClusterRecs = [SELECT Id, SmartDD__Cluster_Object_Id__c,SmartDD__MannualCluster__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c where SmartDD__MannualCluster__c != true AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        }
        
        for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
            setClusterRecId.add(strClusterRecords.SmartDD__Cluster_Object_Id__c);
        }
        if(fieldstoget.contains('SmartDD__SmartDD__IsMerged__c')) {
            queryString += 'Select Id, (SELECT SmartDD__Body__c, SmartDD__MergeType__c FROM SmartDD__TempDedupeNotes__r WHERE SmartDD__Object_Name__c =: ObjectName), '+ String.escapeSingleQuotes(fieldstoget)+' from '+ String.escapeSingleQuotes(ObjectName) +' WHERE Id In : setClusterRecId ';
        } else {
            queryString += 'Select Id, SmartDD__IsMerged__c, (SELECT SmartDD__Body__c, SmartDD__MergeType__c FROM SmartDD__TempDedupeNotes__r WHERE SmartDD__Object_Name__c =: ObjectName), '+ String.escapeSingleQuotes(fieldstoget)+
                ' from '+ String.escapeSingleQuotes(ObjectName) +' WHERE Id In : setClusterRecId ';
        }
        //queryString += ' AND IsMerged__c = true ';
        
        String queryRecWithNotes = 'Select Count(Id) from '+ String.escapeSingleQuotes(ObjectName) + ' WHERE Id In : setClusterRecId  AND SmartDD__IsMerged__c = true WITH USER_MODE';
        
        queryStringTotal += 'Select Count(Id) from SmartDD__Child_Cluster_Record__c where SmartDD__MannualCluster__c != true AND SmartDD__Master_Cluster_Record_Id__c =\''+ strNewMasterClusterId+'\' WITH USER_MODE';   
        if(flagSearchFilter == true){
            searchQuery += 'FIND \'' + string.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(ObjectName) + ' ( SmartDD__IsMerged__c, SmartDD__TempDedupeNotes__r.SmartDD__MergeType__c, TempDedupeNotes__r.SmartDD__Body__c, ' + String.escapeSingleQuotes(fieldstoget);
            searchQueryTotal = 'FIND \'' + string.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(ObjectName) + ' (Id';
            
            searchQuery += ' WHERE Id In : setClusterRecId';
            searchQueryTotal += ' WHERE Id In : setClusterRecId)';
        }

        system.debug('sortField++++>'+sortField);
        if(ObjectName == 'Lead' || ObjectName == 'Contact') {
            if (sortField != '' && sortField != null) {
                if(sortField == 'FirstName') {
                    queryString += ' order by FirstName';
                    // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
                    if (isAsc) { //NOPMD
                        queryString += ' DESC NULLS LAST';
                    }
                    else { 
                        queryString += ' ASC';
                    }
                    queryString += ' ,LastName';
                } else if (sortField == 'LastName') {
                    queryString += ' order by LastName';
                    // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
                    if (isAsc) { //NOPMD
                        queryString += ' DESC NULLS LAST'; 
                    } 
                    else {
                        queryString += ' ASC';
                    }
                    queryString += ' ,FirstName';
                }  else{
                    queryString += ' WITH USER_MODE order by ' + sortField;
                    // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
                    if (isAsc) {
                        queryString += ' DESC NULLS LAST';
                    } else {
                        queryString += ' ASC';
                    }
                }
                system.debug('queryString++++>'+queryString);
                
            }  else {
                queryString += ' WITH USER_MODE order by LastName, FirstName';
            }
        } else{
            if (sortField != '' && sortField != null) {
                queryString += ' order by ' + sortField;
                // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
                if (isAsc) {
                    queryString += ' DESC NULLS LAST';
                } else {
                    queryString += ' ASC';
                }
            }
        }
        if(intTotalObjRecs <= 20000) {
            queryString += ' Limit '+ pageSize + ' Offset '+offset;
            if(flagSearchFilter == true) {
               searchQuery += ' Limit '+ pageSize + ' Offset '+offset;
            }
        }  
        if(searchQuery != '') {
            searchQuery += ')';
        }
        System.debug('queryString @@@ ' + queryString);
        System.debug('queryStringTotal @@@ ' + queryStringTotal);
        System.debug('searchQuery @@@..................................' + searchQuery);
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
            //List<sObject> sObjectTotalRecWithNotes = database.query(queryRecWithNotes);
            objTableWrapper.total = Integer.valueOf(objTableWrapper.sObjectTotalRecords[0].get('expr0'));
            objTableWrapper.FirstReturnValue = strFirstReturnVal;
            objTableWrapper.LastReturnValue = strLastReturnVal;
            
        }
        SmartDD__Filter_Data__c  filterRecs = SmartDD__Filter_Data__c.getInstance(ObjectName);
        if(filterRecs != null) {
            objTableWrapper.blnUniqueRecordSaved = filterRecs.SmartDD__Unique_Cluster_Saved__c;
        }
        objTableWrapper.clusterList = lstParentClusterRecs;
        
        return objTableWrapper;
    }
    
      
    /*******************************************************
Purpose: fetch all fields from Review and Polish Columns
*******************************************************/
    @AuraEnabled
    public static List<wrpObjectFieldsList> fetchReviewClusterColumns(String filterObjName) {
        system.debug('@#$%filterObjName: '+filterObjName);
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        List<String> lstColmnAPIName = new List<String>();
        SObjectType SObjectType = Schema.getGlobalDescribe().get(filterObjName); //NOPMD
        Map<String, Schema.SObjectField> MapOfLead = SObjectType.getDescribe().fields.getMap(); //NOPMD
        wrpObjectFieldsList objwrp = new wrpObjectFieldsList();
        
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c>([SELECT Id, SmartDD__Object_Name__c, SmartDD__Review_Polish_Display_Columns__c 
                                                                               FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c =: filterObjName WITH USER_MODE]);
        
        if(lstObjectColumns.Size() > 0){
            lstColmnAPIName = lstObjectColumns[0].SmartDD__Review_Polish_Display_Columns__c.split(',');
            
            for(String objDedupeFilter : lstColmnAPIName){
                if(objDedupeFilter != null && objDedupeFilter != ''){
                    String fieldLabelName = '';
                    if(objDedupeFilter == 'Owner.Name'){
                        fieldLabelName = 'Owner Name';
                    }else if(objDedupeFilter == 'Account.Name'){
                        fieldLabelName = 'Account Name';
                    } else{
                        fieldLabelName = String.valueOf(MapOfLead.get(objDedupeFilter).getDescribe().getLabel());
                    }
                    wrpFields objField = new wrpFields();
                    objField.fieldName = fieldLabelName;
                    objField.fieldApiName = objDedupeFilter;
                    System.debug('objField.fieldApiName ='+objField.fieldApiName);
                    objwrp.FieldsList.add(objField);
                }
            }
        }
        newWrpList.add(objwrp);
        system.debug('@#$%newWrpList: '+newWrpList);
        return newWrpList;
    }
    /**********************************************************************************************
Purpose: Update Per Page Record Size Custom Setting.
**********************************************************************************************/
    @AuraEnabled
    public static Void UpdatePerPageRecordSize(Integer recordSizeParam){ //NOPMD
        SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = SmartDD__Unique_Lead_Page_Size__c.getValues('Unique Lead Page Size');
        perPageRecordSize.SmartDD__Per_Page_Record__c = recordSizeParam;
        upsert perPageRecordSize; //NOPMD
    }
    @AuraEnabled
    public static SmartDD__Unique_Lead_Page_Size__c GetPerPageRecordSize() { //NOPMD
        SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = SmartDD__Unique_Lead_Page_Size__c.getValues('Unique Lead Page Size');
        return perPageRecordSize;
    }
    @AuraEnabled
    public static SmartDD__Filter_Data__c GetFilterRecordSize(String strObjectName) { //NOPMD
        SmartDD__Filter_Data__c filterRecords = SmartDD__Filter_Data__c.getValues(strObjectName);
        
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        System.debug('@#$strObjectName: '+strObjectName);
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjectName);
        System.debug('@#$objMasterClusterId: '+objMasterClusterId);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            //strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        //}
        // Setting Up Debug Log
        List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Total_Records_Operated__c, SmartDD__Total_Records_Deleted__c, SmartDD__Total_Records_Updated__c, SmartDD__Requested_On_Object__c,SmartDD__Type_Of_Request__c, SmartDD__Is_Final_Data_Saved__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
        if(lstDebugLog.Size() > 0 && filterRecords != null) {
            lstDebugLog[0].SmartDD__Total_Records_Deleted__c = filterRecords.SmartDD__Deleted_Records__c;
            lstDebugLog[0].SmartDD__Total_Records_Updated__c = filterRecords.SmartDD__Updated_Records__c;
            
            SObjectAccessDecision decisionLstDebugLog = Security.stripInaccessible( AccessType.UPDATABLE, lstDebugLog); 
            Update decisionLstDebugLog.getRecords(); //NOPMD
            
            if(lstDebugLog[0].SmartDD__Is_Final_Data_Saved__c != false) {
                List<SmartDD__Dedupe_SaveYourData_Log__c> lstSaveYourDataLog = new List<SmartDD__Dedupe_SaveYourData_Log__c>();
                for(Integer i=1; i<=2; i++) {
                    SmartDD__Dedupe_SaveYourData_Log__c objSaveYourDataLog = new SmartDD__Dedupe_SaveYourData_Log__c();
                    objSaveYourDataLog.SmartDD__Dedupe_Log__c = lstDebugLog[0].Id;
                    objSaveYourDataLog.SmartDD__Requested_On_Object__c = lstDebugLog[0].SmartDD__Requested_On_Object__c;
                    objSaveYourDataLog.SmartDD__Type_Of_Request__c = lstDebugLog[0].SmartDD__Type_Of_Request__c;
                    if(i == 1) {
                        objSaveYourDataLog.SmartDD__Save_Record_Status__c = 'Total Records Deleted';
                        objSaveYourDataLog.SmartDD__Records_Operated__c = lstDebugLog[0].SmartDD__Total_Records_Deleted__c;
                    } else {
                        objSaveYourDataLog.SmartDD__Save_Record_Status__c = 'Total Records Updated';
                        objSaveYourDataLog.SmartDD__Records_Operated__c = lstDebugLog[0].SmartDD__Total_Records_Updated__c;
                    }
                    lstSaveYourDataLog.add(objSaveYourDataLog);
                }if(lstSaveYourDataLog.Size() > 0) {
                    SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstSaveYourDataLog); 
                    Insert decision.getRecords(); //NOPMD
                }
            }
        }
        return filterRecords;
    }
    
    /**********************************************************************************************
    Delete all duplicate records from lead 
    **********************************************************************************************/
    @AuraEnabled
    public static Id MergeAttachments(String ObjectName){ //NOPMD
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        string BatchProcessId = ''; //NOPMD
        string BatchAttachProcessId = ''; //NOPMD
        //string batchQuery = '';
        Set<Id> setMasterRecordId = new Set<Id>();
        String strMergedRecIds = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(ObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
           // strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        //}
        
        /*System.debug('@@ObjectName====' +ObjectName);
        List<Child_Cluster_Record__c> lstClusterRecs = new List<Child_Cluster_Record__c>([SELECT Id, Cluster_Object_Id__c, Cluster_Record_External_Id__c FROM Child_Cluster_Record__c WHERE Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        for(Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
            setMasterRecordId.add(strClusterRecords.Cluster_Object_Id__c);
            strMergedRecIds += '\'' + strClusterRecords.Cluster_Object_Id__c + '\',';
        }
        strMergedRecIds = strMergedRecIds.removeEnd(',');
        System.debug('@@setMasterRecordId: '+setMasterRecordId);*/
        //batchQuery = 'SELECT Id, Cluster_Object_Id__c, Cluster_Record_External_Id__c FROM Child_Cluster_Record__c WHERE Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE';
        // Batch Class to merge all the attachments
        batchMergeAttachments mergeAttachmentRecords = New batchMergeAttachments(strNewMasterClusterId,ObjectName);
        BatchAttachProcessId = Database.executeBatch(mergeAttachmentRecords,50);
        System.debug('@@BatchAttachProcessId : '+BatchAttachProcessId );
        return BatchAttachProcessId;
    }
    
    //To get batch status 
    @AuraEnabled
    public static AsyncApexJobWrapper batchStatus(Id BatchProcessId) { //NOPMD
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper();  
        if(BatchProcessId != null || BatchProcessId != ''){
            objApexJob.lstAsyncApexJob = [SELECT Status, JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE];
            objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems; 
            objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed; 
            objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status;
        }        
        return objApexJob;
    }
    
    /**********************************************************************************************
    Delete all duplicate records from lead 
    **********************************************************************************************/
    @AuraEnabled
    public static String DeleteDuplicateData(String ObjectName) { //NOPMD
        SmartDD__Filter_Data__c cs = SmartDD__Filter_Data__c.getInstance(ObjectName);
        SmartDD__Filter_Data__c csNew = new SmartDD__Filter_Data__c();
        String queryConditions = '';
        String queryString = '';
        string filterId = '';
        if(cs != null) {
            filterId = cs.SmartDD__Filter_Id__c;
        }
        
        Set<Id> duplicaterecodId = new Set<ID>();
        Set<Id> setMasterRecordId = new Set<Id>();
        string BatchProcessId = ''; //NOPMD
        Map<Id,Id> mapofclusterId = new Map<Id,Id>();
        List<SObject> lstOfDeletePolishedRecords =new List<SObject>();
        List<SmartDD__MergedRecordBackup__c> lstMergedRec = new List<SmartDD__MergedRecordBackup__c>();
        List<Sobject> sObjMasterUpdate = new List<SObject>();
        
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(ObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
            //strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
       // }
        
        System.debug('@@ObjectName====' +ObjectName);
        //List<Cluster__c> lstAllClusterRecs = new List<Cluster__c>([SELECT Id FROM Cluster__c WHERE Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        Integer intTotalClusterRecs = 0;
        String strQueryGetTotalClusterRecs = 'SELECT count() FROM SmartDD__Child_Cluster_Record__c where SmartDD__Master_Cluster_Record_Id__c = \''+strNewMasterClusterId+'\' WITH USER_MODE';
        intTotalClusterRecs = Database.countQuery(strQueryGetTotalClusterRecs);
        
        /*List<Child_Cluster_Record__c> lstClusterRecs = new List<Child_Cluster_Record__c>([SELECT Id, Cluster_Object_Id__c, Cluster_Record_External_Id__c FROM Child_Cluster_Record__c WHERE Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        
        for(Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
            mapofclusterId.put(strClusterRecords.Cluster_Object_Id__c,strClusterRecords.Cluster_Object_Id__c);
            //setMasterRecordId.add(strClusterRecords.Cluster_Object_Id__c);
        }*/
        if(cs != null) {
            cs.SmartDD__Updated_Records__c = intTotalClusterRecs; //lstClusterRecs.size();
        } else {
            csNew.SmartDD__Updated_Records__c = intTotalClusterRecs; //lstClusterRecs.size();
        }
        
        if(!String.IsBlank(filterId)){
            queryConditions = getQueryConditionString(filterId,ObjectName);
            system.debug('IN IF queryConditions  @@@ ' +queryConditions); 
        }
        
        queryString += 'Select Id from '+ String.escapeSingleQuotes(ObjectName);
        if(!String.IsBlank(queryConditions)){
            queryString += ' where '+ queryConditions;
        } 
        queryString += ' WITH USER_MODE LIMIT 30000';
        system.debug('queryString222 @@@ ' + queryString );
        List<sObject> lstOfDedupeObject = DataBase.query(queryString);
        
        //List<TempDeleteRecord__c> lstDelRecordIds = new List<TempDeleteRecord__c >(['Select Record_Ids__c from TempDeleteRecord__c where Object_Name__c =: ObjectName WITH USER_MODE LIMIT 30000']);
        
        /*List<TempDedupeNote__c> lstTempNotes = new List<TempDedupeNote__c>();
        List<Note> lstNote = new List<Note>();
        Integer countNotes = 0;*/
        string ObjectLabel = ObjectName.removeEnd('__c'); //NOPMD
        String strDedupedParentId = 'SmartDD__'+ObjectLabel+'ParentId__c';
        /*String strQueryTempNotes = 'SELECT Id, Name, '+ strDedupedParentId +', Body__c, MergeType__c, Title__c FROM TempDedupeNote__c WITH USER_MODE';
        
        lstTempNotes = DataBase.query(strQueryTempNotes);
        for(TempDedupeNote__c objTempNotes : lstTempNotes){
            Id dedupedParentId = (Id)objTempNotes.get(strDedupedParentId);
            if(mapofclusterId.containsKey(dedupedParentId)) {
                Note masterRecNotes = new Note();
                masterRecNotes.ParentId = dedupedParentId;
                masterRecNotes.Title = objTempNotes.Title__c;
                masterRecNotes.Body = objTempNotes.Body__c;
                lstNote.add(masterRecNotes);
                countNotes = countNotes  + 1;
            }
        }
        insert lstNote;
        delete lstTempNotes;*/
        batchDeleteTempNotes objDeleteTempNotes = new batchDeleteTempNotes(strDedupedParentId, strNewMasterClusterId);
        database.executebatch(objDeleteTempNotes,1000);
        
        if(lstOfDedupeObject.Size() > 10000) {
            String tempDuplicateRecordQuery = 'Select Id from '+ String.escapeSingleQuotes(ObjectName);
            if(!String.IsBlank(queryConditions)){
                tempDuplicateRecordQuery += ' where '+ queryConditions + ' WITH USER_MODE';
            } 
            batchUniqueRecordsDelete deleteBatchRecords = New batchUniqueRecordsDelete(tempDuplicateRecordQuery, strNewMasterClusterId, ObjectName);
            BatchProcessId = Database.executeBatch(deleteBatchRecords,200);
        } else{
            List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
            
            for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
                mapofclusterId.put(strClusterRecords.SmartDD__Cluster_Object_Id__c,strClusterRecords.SmartDD__Cluster_Object_Id__c);
                //setMasterRecordId.add(strClusterRecords.Cluster_Object_Id__c);
            }
            
            for(sObject objRecord : lstOfDedupeObject){
                if(!mapofclusterId.containsKey(objRecord.id)){
                    duplicaterecodId.add(objRecord.id);
                }
            }
            string strDelquery = 'Select Id  from ' + String.escapeSingleQuotes(ObjectName) + ' where Id IN : duplicaterecodId WITH USER_MODE';
            lstOfDeletePolishedRecords = DataBase.query(strDelquery);
            system.debug('lstOfDeleteLead!!!' + lstOfDeletePolishedRecords);
            system.debug('lstOfDeleteLead111!!!' + lstOfDeletePolishedRecords.size());
            if(cs != null) {
                cs.SmartDD__Unique_Cluster_Saved__c = true;
                cs.SmartDD__Deleted_Records__c = lstOfDeletePolishedRecords.size();
                upsert cs; //NOPMD
            } else {
                csNew.SmartDD__Unique_Cluster_Saved__c = true;
                csNew.SmartDD__Deleted_Records__c = lstOfDeletePolishedRecords.size();
                upsert csNew; //NOPMD
            }
            
            delete lstOfDeletePolishedRecords; //NOPMD
        }
        //delete lstAllClusterRecs ;
        if(cs != null) {
            cs.name = ObjectName;
            cs.SmartDD__Object_Name__c = ObjectName;
            cs.SmartDD__Filter_Id__c = '';
            upsert cs; //NOPMD
        } else {
            csNew.name = ObjectName;
            csNew.SmartDD__Object_Name__c = ObjectName;
            csNew.SmartDD__Filter_Id__c = '';
            upsert csNew; //NOPMD
        }
        
        /*lstMergedRec = [SELECT Id, Obj_Record_Id__c, Obj_ChildRecird_Id__c, StringifiedJsonRecord__c FROM MergedRecordBackup__c WHERE Obj_Record_Id__c IN : setMasterRecordId WITH USER_MODE];
        sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject();
        for(MergedRecordBackup__c objMergedRec : lstMergedRec) {
            sObj = (SObject)JSON.deserialize(objMergedRec.StringifiedJsonRecord__c, Sobject.class);
            sObj.Id = objMergedRec.Obj_Record_Id__c;
            sObjMasterUpdate.add(sObj);
        }
        update sObjMasterUpdate;*/
        
        // Setting Up Debug Log
        List<SmartDD__Dedupe_Log__c> lstDebugLog = new List<SmartDD__Dedupe_Log__c>([SELECT Id, SmartDD__Is_Final_Data_Saved__c FROM SmartDD__Dedupe_Log__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId AND SmartDD__Type_Of_Request__c = 'Cluster List Request' WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]);
        if(lstDebugLog.Size() > 0) {
            lstDebugLog[0].SmartDD__Is_Final_Data_Saved__c = true;
            Update lstDebugLog; //NOPMD
        }
        
        return BatchProcessId ;
        //return null; 
    }
    /**********************************************************************************************
Purpose:  fetch filter criterias and filter logic 
**********************************************************************************************/
    public static String getQueryConditionString(String filterId, String ObjectName) { //NOPMD
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c,SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filterId WITH USER_MODE];
        
        Map<Integer,String> tempMap = fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r,ObjectName);
        String strQueryConditions = '';
        String strlogic = objFilter.SmartDD__FilterLogic__c;
        strQueryConditions += fnGetCriteriaString(strlogic,tempMap);
        return strQueryConditions;
    } 
    
    /**********************************************************************************************
Purpose: Update custom setting value with object name deduped.
**********************************************************************************************/
    @AuraEnabled
    public static void updateDedupeObjectName(String selectedObjectname) {
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__DeDupe_Object_Name__c = selectedObjectname;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            update dedupeConfig; //NOPMD
        }
        
        SmartDD__ReDe_Dupe_Configuration__c rededupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        rededupeConfig.SmartDD__ReDeduped_Object_Name__c = selectedObjectname;
        rededupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
        rededupeConfig.SmartDD__Single_Clusters_Completed_Stat__c = 'Pending';
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable() || Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isAccessible() || Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isUpdateable()) {
            update rededupeConfig;
        }
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRec = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRec.SmartDD__Object_Name__c = selectedObjectname;      
       // if(Schema.sObjectType.SmartDD__Master_Cluster_Record__c.isCreateable()) {
            insert objMasterClusterRec; //NOPMD
        //}
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
            objMasterClusterId.SmartDD__Process_Type__c = 'Rededupe';
           
        }
        
       // if(Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.isCreateable()) {
            update objMasterClusterId; //NOPMD
        //}
        
        List<SmartDD__TempDedupeNote__c> lstTempDedupeNote = new List<SmartDD__TempDedupeNote__c>([SELECT Id, SmartDD__LeadParentId__c, SmartDD__Object_Name__c FROM SmartDD__TempDedupeNote__c WHERE SmartDD__Object_Name__c =: selectedObjectname WITH USER_MODE LIMIT 20000]);
        Set<Id> setTempDedupeNote = new Set<Id>();
        for(SmartDD__TempDedupeNote__c objTempNotes: lstTempDedupeNote) {
            setTempDedupeNote.add(objTempNotes.SmartDD__LeadParentId__c);
        }
        system.debug('@#$setTempDedupeNote: '+setTempDedupeNote);
        // To reset the IsMerged__c value of SObject records.
        List<sObject> lstSObjMergeQuery = new List<sObject>();
        String strMergedRecords = 'SELECT Id, SmartDD__IsMerged__c FROM '+ String.escapeSingleQuotes(selectedObjectname) +' WHERE SmartDD__IsMerged__c = true WITH USER_MODE' ;
        lstSObjMergeQuery = database.query(strMergedRecords);
        for(sObject objMerged: lstSObjMergeQuery) {
            if(!setTempDedupeNote.contains(objMerged.Id)) {
                objMerged.put('SmartDD__IsMerged__c',false);
            }
        }
        update lstSObjMergeQuery; //NOPMD
        
        /** Check total training record is greater then 20 */             
        String JSONFieldFilterStr = ''; //NOPMD
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                              SmartDD__Last_Name__c,   SmartDD__First_Name__c
                                                                                              FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        
        SmartDD__ReDe_Dupe_Configuration__c dedupeConfigs = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
       Id configId;
       if(lstAuthorizedUser.size() > 0) {
        configId = lstAuthorizedUser[0].Id;
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"Object Name":"' + selectedObjectname + '",';
            JSONFieldFilterStr += '"Organization Id":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"Field Name":"' + +'",';
            JSONFieldFilterStr += '"Filter Records":"' + dedupeConfigs.SmartDD__Total_Records_ReDeduped__c + '"';
            JSONFieldFilterStr += '}';
        }    
        system.debug('JSONFieldFilterStr ****'+JSONFieldFilterStr);
        //Call StartDedupe API here.
        httpCreateClusterJSONRequest(System.Label.SFImportAPI+'/lead/startDedupes', JSONFieldFilterStr,configId);
    }     

    @future(callout=true)
    public static void httpCreateClusterJSONRequest(String strAWSEndpointLead, string strBody,  Id configId) {   
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
            update objDedupeConfing;    //NOPMD
             system.debug('@@ objDedupeConfing' + objDedupeConfing);    
            }
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
    }
    
    /** Update Customsetting field Last_Create_Cluster_Progress__c and Clusters_Completed_Stat__c value.*/
    @AuraEnabled
    Public static SmartDD__ReDe_Dupe_Configuration__c updateLastCreateCluster(){
        SmartDD__ReDe_Dupe_Configuration__c dedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable()
           && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable()
           && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isUpdateable()){
               dedupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
               dedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
               dedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
               dedupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
           }
        
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isAccessible()
        && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isUpdateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isAccessible() || Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isUpdateable())
           {
               update dedupeConfig;
           }        
           return dedupeConfig;
           }
    
    /** Update ProcessStatus from java side.*/
    @AuraEnabled
    Public static String updateprocessStatus(String objectName){
        //Call StartDedupe API here.
        String JSONFieldFilterStr = ''; //NOPMD
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,
                                                                                              SmartDD__Last_Name__c,   SmartDD__First_Name__c FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
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
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@Json ClusterStatus jsonString:....................................... '+jsonString);
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
    }
    
    @AuraEnabled
    Public static SmartDD__ReDe_Dupe_Configuration__c getDeDupeConfiguration(){
        SmartDD__ReDe_Dupe_Configuration__c dedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        System.debug('dedupeConfig...>>'+dedupeConfig);
        return dedupeconfig;
    }
    
    /** Get Customsetting field Clusters_Completed_Stat__c value. */
    @AuraEnabled
    Public static SmartDD__ReDe_Dupe_Configuration__c getClustersCompletedStat(){
        system.debug('dedupeconfig11..................................................................>>');
        SmartDD__ReDe_Dupe_Configuration__c dedupeconfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');  
        system.debug('dedupeconfig22..................................................................>>'+dedupeconfig);
        return dedupeconfig;
    }
    
  @AuraEnabled
    Public static SmartDD__ReDe_Dupe_Configuration__c updateCreateClusterProgress(Integer lastCreateClusterProgress, Integer clusterEstimatedTime){
        SmartDD__ReDe_Dupe_Configuration__c dedupeconfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration'); 
        dedupeConfig.SmartDD__Last_Create_Cluster_Progress__c = lastCreateClusterProgress;
        dedupeConfig.SmartDD__Cluster_Estimated_Time__c = clusterEstimatedTime;
      
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable()||
            Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isUpdateable()||
          Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isUpdateable())
           {
            update dedupeConfig;
             system.debug('dedupeconfig33..................................................................>>'+dedupeConfig);
       }                 
        return dedupeConfig;
    }

    /******************************************************
POST Re-Dedupe Unique Record JSON DATA 
******************************************************/
    @AuraEnabled
    public static String postReDedupeRecords(String selectedObjectname) {   //NOPMD     
        String isSuccess  = '' ;
        string userid = '';
        string organizationid = '';
        string BatchProcessId = ''; //NOPMD
        string returnVal = '';
        System.debug('INSIDE............postReDedupeRecords.....................');
        List<SmartDD__Dedupe_Configuration__c> lstAuthorizedUser = new List<SmartDD__Dedupe_Configuration__c> ([SELECT Id, SmartDD__UserId__c, SmartDD__Organization_Id__c, SmartDD__Username__c,SmartDD__Email__c,SmartDD__Last_Name__c,SmartDD__First_Name__c  FROM SmartDD__Dedupe_Configuration__c WITH USER_MODE limit 1]);
        
        /*fetch new Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selectedObjectname);
        if(objMasterClusterId != null){
            if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
                strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
                //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
            }
            //System.debug('@#$totalClusters: '+totalClusters);
            //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
                //strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
            //}
        }
        
        if(lstAuthorizedUser.size() > 0){
            userid = lstAuthorizedUser[0].SmartDD__UserId__c;
            organizationid = lstAuthorizedUser[0].SmartDD__Organization_Id__c; 
        }
        
        String JSONFieldFilterStr = ''; //NOPMD
        SmartDD__Manage_Cluster_Org_Tab_Id__c objOrgTabNameId = SmartDD__Manage_Cluster_Org_Tab_Id__c.getValues('Org Tab Name');
        
        String queryStringTotal = '';        
        queryStringTotal += 'Select SmartDD__Cluster_Object_Id__c from SmartDD__Child_Cluster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE';        
        
        
        String queryStringTotalwrp = '';        
        queryStringTotalwrp += 'Select SmartDD__Cluster_Object_Id__c from SmartDD__Child_Cluster_Record__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE';        
        
        queryStringTotalwrp += ' LIMIT 47000';
        
        system.debug('queryStringTotalwrp ****'+queryStringTotalwrp );    
        system.debug('queryStringTotal..' + queryStringTotal);
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        objTableWrapper.sObjectTotalRecords = database.query(queryStringTotalwrp);
        objTableWrapper.total = objTableWrapper.sObjectTotalRecords.size(); 
        
        if(objTableWrapper.total == 47000){
            batchFetchReDedupeRecord fetchrecord = new batchFetchReDedupeRecord(queryStringTotal,selectedObjectname,userid,organizationid,objOrgTabNameId.SmartDD__TabName__c);  
            BatchProcessId =  Database.executeBatch(fetchrecord,200);
            system.debug('BatchProcessId ****'+BatchProcessId);
            SmartDD__ReDe_Dupe_Configuration__c rededupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
            rededupeConfig.SmartDD__ReDeduped_Object_Name__c = selectedObjectname;
            rededupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = BatchProcessId;
            rededupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Pending';
           
            
            if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable()||  Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__ReDeduped_Object_Name__c.isUpdateable()|| Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable() ||  Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isAccessible()) {
                update rededupeConfig;
            }
        } else {
            Set<String> recordIds = new Set<String>();
            for(sObject objChildRecs : objTableWrapper.sObjectTotalRecords){
                recordIds.add(String.valueof(objChildRecs.get('SmartDD__Cluster_Object_Id__c')));
            }
            List<String> lstRecordIds = new List<String>(recordIds);
            String strRecordIds = String.join(lstRecordIds, '","');
            /*Set<String> recordIds = (new Map<String,SObject>(objTableWrapper.sObjectTotalRecords)).keySet();
            List<String> lstRecordIds = new List<String>(recordIds);
            String strRecordIds = String.join(lstRecordIds, '","');   */         
            
            system.debug('recordIds****'+ recordIds.size());
            JSONFieldFilterStr += '{';
            if(lstAuthorizedUser.size() > 0){
                JSONFieldFilterStr += '"organisationId":"' + lstAuthorizedUser[0].SmartDD__Organization_Id__c + '",';
                JSONFieldFilterStr += '"userId":"' + lstAuthorizedUser[0].SmartDD__UserId__c + '",';
                JSONFieldFilterStr += '"objectName":"' + selectedObjectname + '",';
                JSONFieldFilterStr += '"sfdcTabName":"' + objOrgTabNameId.SmartDD__TabName__c + '",';
                JSONFieldFilterStr += '"recordIds":["';
                JSONFieldFilterStr += strRecordIds.replace('00 Q', '00Q');
                JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
                JSONFieldFilterStr += '"],';
                JSONFieldFilterStr += '"type":"rededupe"';
                JSONFieldFilterStr += '}';
            }
            JSONFieldFilterStr = JSONFieldFilterStr.removeEnd(',');
            system.debug('JSONFieldFilterStr ****'+JSONFieldFilterStr);
            isSuccess = httpReDedupeJSONRequest(System.Label.SFImportAPI+'/dedupe/start', JSONFieldFilterStr);
            system.debug('@#$isSuccess: '+isSuccess);
            //    return isSuccess;
        } 
        SmartDD__De_Dupe_Configuration__c dedupeConfig = SmartDD__De_Dupe_Configuration__c.getValues('DeDupe Configuration');
        dedupeConfig.SmartDD__Dedupe_Started_Stat__c = true;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            upsert dedupeConfig; //NOPMD
        }
        
        returnVal = BatchProcessId +'#'+ isSuccess;
        return returnVal;
    }
    /******************************************************
Http Request Body
******************************************************/
    public static string httpReDedupeJSONRequest(String strAWSEndpoint, string strBody){
        system.debug('@@@strAWSEndpointLead' +strAWSEndpoint);
        system.debug('@@@strBody' +strBody);
        string strResponseBody='';
        string strResponseStatus='';    
        HttpRequest objHTTPRequest = new HttpRequest();
        Http http = new Http();
        
        objHTTPRequest.setTimeout(60000);
        objHTTPRequest.setMethod('POST');
        objHTTPRequest.setHeader('Content-Type', 'application/json');
        objHTTPRequest.setBody(strBody);
        objHTTPRequest.setEndpoint(strAWSEndpoint);        
        try {
            HTTPResponse statusRes = http.send(objHTTPRequest);
            system.debug('@@#$statusRes: '+statusRes);
            String jsonString =  statusRes.getBody();
            JSONSyncData objSyncDataStatus = JSONSyncData.parse(jsonString);
            system.debug('@@#$jsonString: '+jsonString);
            return objSyncDataStatus.isSuccess;
        }
        catch(Exception e) {
            System.debug('@@Statement: '+ e.getMessage());
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static void updateClustersCompSta(Integer recordsReDeduped){
        SmartDD__ReDe_Dupe_Configuration__c dedupeConfig = SmartDD__ReDe_Dupe_Configuration__c.getValues('ReDeDupe Configuration');
        dedupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Pending';
        dedupeConfig.SmartDD__Total_Records_ReDeduped__c = recordsReDeduped;
        system.debug('1060==>'+dedupeConfig+'-->');
        if(Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.isCreateable() || (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isUpdateable())||
          (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Total_Records_ReDeduped__c.isCreateable() && Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Total_Records_ReDeduped__c.isUpdateable())) {
            upsert dedupeConfig;
              system.debug('1063==>'+dedupeConfig+'-->');
        } 
    }
    
    @AuraEnabled
    Public static AsyncApexJobWrapper AsyncApexJobRecords(Id BatchProcessId){ //NOPMD
        
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper(); 
        if(BatchProcessId != null || BatchProcessId != ''){      
            objApexJob.lstAsyncApexJob = [SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE];
            if(objApexJob.lstAsyncApexJob.size() > 0){
                objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems; 
                objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed; 
                objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status;    
            }            
        }
        return objApexJob; 
    }
    @AuraEnabled 
    Public static string CheckApiStatus() {       //NOPMD              
        
        SmartDD__StartDedupeStatus__c startdedupedata = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');            
        String apistatus = startdedupedata.SmartDD__IsSuccess__c; 
        
        startdedupedata.SmartDD__StartDedupeBatchId__c = '' ;            
        if(Schema.sObjectType.SmartDD__StartDedupeStatus__c.isCreateable() || Schema.sObjectType.SmartDD__StartDedupeStatus__c.isUpdateable()){
            upsert startdedupedata; 
        }       
        system.debug('@@apistatus'+apistatus);
        return apistatus;       
    }
    /**********************************************************************************************
Purpose: To bind filter criteria value.
**********************************************************************************************/
    Public static Map<Integer,String> fnBindFilterCriteria(List<SmartDD__Filter_Criteria__c> lstFilterCriteria,String ObjectName){ //NOPMD
        Map<Integer,String> mapAllFilterCriteria = new Map<Integer,String>();
        Integer Count = 0; //NOPMD
        for(SmartDD__Filter_Criteria__c objFilterCriterias: lstFilterCriteria){
            Count++;           
            String filter = '';            
            String strSearchOn = ObjectName;
            Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
            Schema.DescribeSObjectResult objResult = objtype.getDescribe();
            
            if(!String.Isblank(objFilterCriterias.SmartDD__Field__c)){
                String oldOperator = objFilterCriterias.SmartDD__Operator__c;
                String oldField = objFilterCriterias.SmartDD__Field__c;
                string strDynamicField1 = string.valueof(objFilterCriterias.SmartDD__Field__c);
                strDynamicField1 = CreateFieldName(string.valueof(objFilterCriterias.SmartDD__Field__c),strSearchOn,ObjectName);
                objFilterCriterias.SmartDD__Operator__c = fillOperator(objFilterCriterias.SmartDD__Operator__c);
                String strFiled1Val = strDynamicField1;
                String strOperator1Val = objFilterCriterias.SmartDD__Operator__c;
                objFilterCriterias.SmartDD__Operator__c =  oldOperator;
                objFilterCriterias.SmartDD__Field__c =  oldField;
                String strValue1 = objFilterCriterias.SmartDD__Value__c;
                
                if(!string.IsBlank(strOperator1Val)){
                    if(!strFiled1Val.contains('.name') && (!strFiled1Val.contains('__r.name'))){
                        if(objResult.fields.getMap().get(strFiled1Val) != null){ //NOPMD
                            Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get(strFiled1Val).getDescribe();
                            system.debug('@@fldtype1==' +fldtype1);
                            filter = fnGetStringCriteria(strFiled1Val,strOperator1Val,strValue1,fldtype1,null);
                        }
                    }else{
                        filter = fnGetStringCriteria(strFiled1Val,strOperator1Val,strValue1,null,'String');
                    }
                }    
                if(!String.IsBlank(filter)){
                    mapAllFilterCriteria.put(Count,filter);
                }
            }
        }
        return mapAllFilterCriteria;
    }
    
    /**********************************************************************************************
Purpose:  create query string using filterlogic 
**********************************************************************************************/
    public static String fnGetCriteriaString(String filterLogic, Map<Integer, String> filterMap){
        String result = '';
        if(filterLogic == null  || filterLogic == ''){
            for(String strfilter : filterMap.values()) {
                result += strfilter + ' AND ';
            }
            result = result.removeEnd(' AND ');
        }
        else{
            for(String token : tokenizeFilterLogic(filterLogic)){
                if(token == '(' || token == ')' || token.toUpperCase() == 'AND' || token.toUpperCase() == 'OR' || token.toUpperCase() == 'NOT'){
                    result += ' ' + token;
                }else{
                    result += ' ' + filterMap.get(Integer.valueOf(token));
                }
            }
        }
        return result;
    }
    
    /**********************************************************************************************
Purpose: To get Field name based on Field label
**********************************************************************************************/
    Public static String CreateFieldName(String strFieldLabel,String strSearchOn,String ObjectName){ //NOPMD
        String strFieldName = '';
        strSearchOn = ObjectName;
        
        if(Schema.getGlobalDescribe().get(strSearchOn) != null){
            Schema.SObjectType objSchema = Schema.getGlobalDescribe().get(strSearchOn);
            Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
            List<String> lstfieldNames = new List<String>();
            lstfieldNames.addall(fieldMap.keySet());
            
            for(String fieldName: lstfieldNames){
                String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                if(fieldLabel == strFieldLabel){
                    strFieldName = fieldName;
                    break;
                }
            }
        }        
        if(String.Isblank(strFieldName)){
            strFieldName = checkfieldLabel(strFieldLabel,ObjectName);
        }
        return strFieldName;
    }
    
    /**********************************************************************************************
Purpose: To get Operator for filter
**********************************************************************************************/
    Public static String fillOperator(String strOperator){
        if(strOperator == 'equals') strOperator  = '='; //NOPMD
        else if(strOperator == 'not equal to') strOperator = '!='; //NOPMD
        else if(strOperator == 'less than') strOperator = '<'; //NOPMD
        else if(strOperator == 'greater than') strOperator = '>'; //NOPMD
        else if(strOperator == 'less or equal') strOperator = '<='; //NOPMD
        else if(strOperator == 'greater or equal') strOperator = '>='; //NOPMD
        else if(strOperator == 'contains') strOperator = 'Like'; //NOPMD
        else if(strOperator == 'does not contain') strOperator = 'NotLike'; //NOPMD
        else if(strOperator == 'starts with') strOperator = 'startswith'; //NOPMD
        return strOperator;
    }
    
    /**********************************************************************************************
Purpose: To get Criteria string base on field,operater and value.
**********************************************************************************************/
    Public static String fnGetStringCriteria(String strFiledVal,String strOperatorVal,String strValue,Schema.DescribeFieldResult ftype, String strftype){ //NOPMD
        String filterCriteria='';
        if(ftype != null && (ftype.getType() == Schema.DisplayType.Date || ftype.getType() == Schema.DisplayType.DateTime)){
            strValue = setStringToDateFormat(strValue);
        }
        if(strValue == null && strOperatorVal != '!=' && strOperatorVal != 'NotLike'){
            strOperatorVal = '=';
        }
        if(strValue == null && strOperatorVal == 'NotLike'){
            strOperatorVal = '!=';
        }        
        if(strOperatorVal == 'Like'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE) || strftype == 'String'){
                    
                    if(ftype == null || (ftype != null && ftype.getType() != Schema.DisplayType.MULTIPICKLIST)){
                        string ValueLike = '%'+ fnCheckBlankValue(strValue)+'%'; //NOPMD
                        filterCriteria += String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueLike) + '\'';
                    }else{
                        string ValueLike = fnCheckBlankValue(strValue);filterCriteria += String.escapeSingleQuotes(strFiledVal) +' includes (\''+ String.escapeSingleQuotes(ValueLike) + '\')'; //NOPMD
                    }
                }
        }else if(strOperatorVal == 'NotLike'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE ) || strftype == 'String'){
                    
                    if(ftype == null || (ftype != null && ftype.getType() != Schema.DisplayType.MULTIPICKLIST)){
                        string ValueNotLike =  '%'+fnCheckBlankValue(strValue)+'%'; //NOPMD
                        filterCriteria += '(Not '+ String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueNotLike) +'\')';
                    }else{
                        string ValueNotLike =  fnCheckBlankValue(strValue);filterCriteria += String.escapeSingleQuotes(strFiledVal) +' EXCLUDES (\''+ String.escapeSingleQuotes(ValueNotLike ) + '\')'; //NOPMD
                    }
                }
        }else if(strOperatorVal == 'startswith'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE 
                && ftype.getType() != Schema.DisplayType.MULTIPICKLIST) || strftype == 'String'){
                    
                    string ValueSW =  fnCheckBlankValue(strValue)+'%'; //NOPMD
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueSW) + '\'';
                }
        }else if(strOperatorVal == '='){
            if(String.isBlank(strValue)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' null';
            }else{
                string Value =  strValue.trim(); //NOPMD
                if(ftype != null && (ftype.getType() == Schema.DisplayType.BOOLEAN || ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER 
                                     || ftype.getType() == Schema.DisplayType.DOUBLE)){
                                         
                                         filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                                         if(!String.isBlank(Value)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                         }else{
                                             filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                         }
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                         if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                         }else{
                                             filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                         }
                                     }else{
                                         filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                                     }
            }
        }else if(strOperatorVal == '!='){
            if(String.isBlank(strValue)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' null';
            }else{
                string Value =  strValue.trim(); //NOPMD
                if(ftype != null && (ftype.getType() == Schema.DisplayType.BOOLEAN || ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER 
                                     || ftype.getType() == Schema.DisplayType.DOUBLE)){
                                         
                                         filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                                         if(!String.isBlank(Value)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                         }else{
                                             filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                         }
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                         if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                         }else{
                                             filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                         }
                                     }else{
                                         filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                                     }
            }
        }else if(strOperatorVal == '<'){
            string Value = fnCheckBlankValue(strValue); //NOPMD
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY
                                 || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                                     filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                                     if(!String.isBlank(Value)){filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                     }
                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                     if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                     }
                                 }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                                     filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                                 }
        }
        else if(strOperatorVal == '>'){
            string Value = fnCheckBlankValue(strValue); //NOPMD
            
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                if(!String.isBlank(Value)){filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){ filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }
        else if(strOperatorVal == '<='){
            string Value = fnCheckBlankValue(strValue); //NOPMD
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                if(!String.isBlank(Value)){filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){ filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }
        else if(strOperatorVal == '>='){
            string Value = fnCheckBlankValue(strValue); //NOPMD
            if(ftype != null && (ftype.getType() == Schema.DisplayType.CURRENCY || ftype.getType() == Schema.DisplayType.INTEGER || ftype.getType() == Schema.DisplayType.DOUBLE)){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.Date){
                if(!String.isBlank(Value)){filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }else{
            string Value =  strValue.trim();filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\''; //NOPMD
        }
        return filterCriteria;
    }   
    
    /**********************************************************************************************
Purpose: To get single token from Filter Logic
**********************************************************************************************/
    private static String[] tokenizeFilterLogic(String filterLogic){ //NOPMD
        if(String.IsBlank(filterLogic)){
            return new String[] {};
                }
        else{
            List<String> result = new List<String>();
            String buffer = '';
            for(Integer i=0; i<filterLogic.length(); i++){
                String subStr = filterLogic.substring(i,i+1);
                
                if(subStr == '('){
                    if(!String.IsBlank(buffer.trim())){
                        result.add(buffer.trim());
                        buffer = '';
                    }
                    result.add('(');
                }else if(subStr == ')'){
                    if(!String.IsBlank(buffer.trim())){
                        result.add(buffer.trim());
                        buffer = '';
                    }
                    result.add(')');
                }else if(subStr == ' '){
                    if( String.IsBlank(buffer.trim())){
                        buffer += subStr;
                    }else{
                        result.add(buffer.trim());
                        buffer = '';
                    }
                }else{
                    buffer += subStr;
                }
            }
            
            if(!String.IsBlank( buffer.trim())){
                result.add(buffer.trim());
            }
            return result;
        }
    }   
    
    /********************************************************************
Purpose : get the label of particular field.
********************************************************************/
    public static String checkfieldLabel(String strFiledLabel,String ObjectName){ //NOPMD
        String fieldLabel = '';
        if(!String.Isblank(strFiledLabel)){
            Schema.SObjectType objtype = Schema.getGlobalDescribe().get(ObjectName);
            Schema.DescribeSObjectResult objResult = objtype.getDescribe();
            string strfvalue = strFiledLabel.replace(' Name','Id');
            
            if(!String.Isblank(strfvalue) && objResult.fields.getMap().get(strfvalue) != null && objResult.fields.getMap().get(strfvalue).getDescribe() != null){
                fieldLabel = strfvalue.replace('Id','.name');
            }
            else{
                if(strfvalue.contains(' ')){
                    strfvalue = strfvalue.replace(' ','_');
                }
                fieldLabel = strfvalue.replace('Id','__r.name');
            }
        }
        return fieldLabel;
    }
    
    /**********************************************************************************************
Purpose: To get date format for SOQL.
**********************************************************************************************/
    public static String setStringToDateFormat(String myDate){
        if(!String.isBlank(myDate) && myDate.contains('/')){
            String[] strDate = myDate.split('/');
            return strDate[2]+'-'+strDate[0]+'-'+strDate[1];
        }else{
            return null;
        }
    } 
    
    /**********************************************************************************************
Purpose:  Check the value is blank or not.
**********************************************************************************************/     
    public static string fnCheckBlankValue(string strValue){
        if(!string.isblank(strValue)){
            strValue = strValue.trim();
        }
        return strValue;
    }
    
    
    /******************************************************
wrapper class
******************************************************/
    public class wrpObjectFieldsList { //NOPMD
        @AuraEnabled public String strObjectName {get;set;}
        @AuraEnabled public List<String> objectFieldsList {get;set;}
        @AuraEnabled public List<wrpFields> FieldsList {get;set;} //NOPMD
        
        public wrpObjectFieldsList(){
            strObjectName = '';
            objectFieldsList = new List<String>();
            FieldsList = new List<wrpFields>();
        }
    }
    public class wrpFields { //NOPMD
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
        @AuraEnabled public Integer TotalJobItems{get;set;} //NOPMD
        @AuraEnabled public String JobItemStatus{get;set;} //NOPMD
        @AuraEnabled public Integer JobItemsProcessed{get;set;} //NOPMD
        @AuraEnabled public List<AsyncApexJob> lstAsyncApexJob{get;set;}
    }
    public class DedupeStatusWrapper{
        @AuraEnabled public String Status{get;set;} //NOPMD
        @AuraEnabled public String ProcessType{get;set;} //NOPMD
    }
    
}