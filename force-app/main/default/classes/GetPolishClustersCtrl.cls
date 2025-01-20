// After Resolve TempNotes field issue

/********************************************************************************************
* NAME         : GetPolishClustersCtrl
* DESCRIPTION  : This class is use to get the Polist clusters inserted from java side.
* 
* @AUTHOR: dev team
* @DATE: 04/11/2019
*
*
* MODIFICATION LOG:GetPolishClustersCtrl
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
dev team                        04/10/2019                            -
********************************************************************************************/
global with sharing class GetPolishClustersCtrl { //NOPMD
    public static Map<String,String> mapObjIdRulename {get;set;}
    public static Map<String,String> mapObjIdColumnName {get;set;}
    
    public GetPolishClustersCtrl(){
        Map<String,String> mapObjIdRulename =new Map<String,String>();
        Map<String,String> mapObjIdColumnName=new Map<String,String>();
    }
    
    @AuraEnabled
    public static List<wrpObjectClusterRecs> getClusterRecords(String selObjectName) {
        /*fetch new Master Cluster Id From Custom Setting Manage Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
        //strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        //}
        
        List<wrpObjectClusterRecs> lstWrapperClusters = new List<wrpObjectClusterRecs>();
        wrpObjectClusterRecs objClusters = new wrpObjectClusterRecs();
        
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>([SELECT Id, Name,SmartDD__External_Cluster_Id__c, 
                                                                                         SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c 
                                                                                         WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC]);
        if(lstClusters.Size() > 0) {
            objClusters.lstWrpClusters = lstClusters;
        }
        lstWrapperClusters.add(objClusters);
        return lstWrapperClusters;
    }
    public class wrpObjectClusterRecs { //NOPMD
        @AuraEnabled public List<SmartDD__Cluster__c> lstWrpClusters {get; set;}
        @AuraEnabled public String strSelectedTabName {get; set;}
        public wrpObjectClusterRecs() {
            lstWrpClusters = new List<SmartDD__Cluster__c>();
            strSelectedTabName = '';
        }
    }
    
    @AuraEnabled
    public static void removeIgnoreGroup(string ignoreGroupId, String strObjectName) {  //NOPMD
        /*fetch new Master Cluster Id From Custom Setting Manage Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            totalClusters = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        if(totalClusters == 0 && objMasterClusterId.SmartDD__Old_Master_Cluster_Id__c != null ) {
            strNewMasterClusterId = objMasterClusterId.SmartDD__Old_Master_Cluster_Id__c;
        }
        
        List<SmartDD__Cluster__c> lstAllClusterId = new List<SmartDD__Cluster__c>([SELECT Id FROM SmartDD__Cluster__c WHERE Id =:ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);  
        list<SmartDD__Child_Cluster_Record__c> lstNewChildClusterRec = new List<Child_Cluster_Record__c>();
        list<Cluster__c> lstNewClusterRec = new List<Cluster__c>();
        List<SmartDD__Child_Cluster_Record__c> IgnoreGrouplst = [SELECT Id, Name, SmartDD__Cluster_Id__c, SmartDD__MannualCluster__c,SmartDD__Cluster_Record_External_Id__c, SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: ignoreGroupId AND Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]; //NOPMD
        Set<Decimal> strExternalIds = new Set<Decimal>();
        for(SmartDD__Child_Cluster_Record__c clusterRec : IgnoreGrouplst ){
            SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();objCluster.SmartDD__External_Cluster_Id__c = Decimal.valueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c);
            objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;objCluster.SmartDD__Object_Name__c = strObjectName;
            //objCluster.All_Cluster_Record__c = lstAllClusterId[0].All_Cluster_Record__c;
            strExternalIds.add(Decimal.valueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c));lstNewClusterRec.add(objCluster);  
        }
        
        Boolean  ExternalClusterId = Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isCreateable();  //NOPMD
        if(lstNewClusterRec.size() > 0 && ExternalClusterId &&  Schema.sObjectType.Cluster__c.isCreateable()){
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstNewClusterRec); 
            Insert decision.getRecords();
        }
        
        List<SmartDD__Cluster__c> lstDeleteCluster = [SELECT Id FROM SmartDD__Cluster__c WHERE Id =: ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]; //NOPMD
        //Boolean ClusterDeleteCheck = SmartDD__Cluster__c.sObjectType.getDescribe().isDeletable();   //NOPMD
        if(lstDeleteCluster.size() > 0 && Schema.sObjectType.SmartDD__Cluster__c.isDeletable()){            
            Delete lstDeleteCluster;
        }
        
        List<SmartDD__Cluster__c> lstNewCluster = [SELECT Id, Name, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__External_Cluster_Id__c IN:strExternalIds AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        for(SmartDD__Cluster__c objnewCluster : lstNewCluster) {
            for(SmartDD__Child_Cluster_Record__c clusterRec : IgnoreGrouplst ){
                if(objnewCluster.SmartDD__External_Cluster_Id__c == Decimal.ValueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c)) {
                    SmartDD__Child_Cluster_Record__c objChildCluster = new SmartDD__Child_Cluster_Record__c();objChildCluster.SmartDD__MannualCluster__c = clusterRec.SmartDD__MannualCluster__c;
                    objChildCluster.SmartDD__Cluster_Record_External_Id__c = clusterRec.SmartDD__Cluster_Record_External_Id__c;objChildCluster.SmartDD__Cluster_Object_Id__c = clusterRec.SmartDD__Cluster_Object_Id__c;objChildCluster.SmartDD__Cluster_Id__c = objnewCluster.Id; objChildCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;objChildCluster.SmartDD__Object_Name__c = strObjectName;lstNewChildClusterRec.add(objChildCluster);objnewCluster.SmartDD__External_Cluster_Id__c = null;objnewCluster.SmartDD__Cluster_Review_Status__c = 'Auto Reviewed';
                }
            }
        }
        
        Boolean MannualCluster = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__MannualCluster__c.isCreateable();  //NOPMD
        Boolean ClusterRecordExternal = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isCreateable();   //NOPMD
        Boolean ClusterLeadId = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Object_Id__c.isCreateable();    //NOPMD
        Boolean ClusterId = Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isCreateable();   //NOPMD
        
        if(lstNewChildClusterRec.size() > 0 && MannualCluster && ClusterRecordExternal && ClusterLeadId && ClusterId  &&  Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isCreateable()){
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstNewChildClusterRec); 
            Insert decision.getRecords();
        }
        if(lstNewCluster.size() > 0 &&  Schema.sObjectType.SmartDD__Cluster__c.isUpdateable()){
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstNewCluster); 
            Update decision.getRecords(); //NOPMD
        }
    }
    
    /**********************************************************************************************
Purpose: Get Per Page Record Size Custom Setting.
**********************************************************************************************/
    @AuraEnabled
    public static SmartDD__Cluster_Detail_Page_Size__c GetClusterDetailRecordSize() {   //NOPMD
        SmartDD__Cluster_Detail_Page_Size__c perPageRecordSize =SmartDD__Cluster_Detail_Page_Size__c.getValues('Cluster Detail Page Record Size');
        return perPageRecordSize;
    }
    
    @AuraEnabled
    public static lightningTableWrapper getClusterDetails(String fieldstoget, String ClusterId,String ObjectName, String sortField, boolean isAsc) {      //NOPMD
        Set<Id> setClusterRecId = new Set<Id>();
        String tempQueryString = '';
        String strMergeCondition = '';    
        String strOrderBy = '';
        String strMergeRuleMasterRec = '';
        String strFieldValRuleMasterRec = '';
        String queryString = '';
        String queryStringTotal = '';
        String fieldValQueryString = '';
        String strSpecificValOrderBy = '';
        List<SmartDD__ManageRule_Master_Record__c> lstActiveMergeRule = new List<SmartDD__ManageRule_Master_Record__c>();
        List<SmartDD__ManageRule_Master_Record__c> lstTotalMergeRule = new List<SmartDD__ManageRule_Master_Record__c>();
        
        /*fetch new Master Cluster Id From Custom Setting Manage Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(ObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            //totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
        //   strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        //}
        
        List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Id__r.SmartDD__Confidence_Score__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: ClusterId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
            setClusterRecId.add(strClusterRecords.SmartDD__Cluster_Object_Id__c);
        }
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        
        Set<String> setFieldsToGet = new Set<String>(fieldstoget.split(','));
        
        queryString += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget)+
            ' from '+ String.escapeSingleQuotes(ObjectName) +
            ' WHERE Id In : setClusterRecId ';
        
        queryStringTotal += 'Select Count(Id) from '+ String.escapeSingleQuotes(ObjectName) +
            ' WHERE Id In : setClusterRecId WITH USER_MODE';  
        
        List<sObject> lstMasterRecordQuery = new List<sObject>();
        
        lstTotalMergeRule = [SELECT Id, SmartDD__Merge_Rule_Name__c, SmartDD__Master_Order_By__c, SmartDD__Default_Override_Master_Record__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Master_Popup_Field_Values__c, SmartDD__Master_Record_Type__c, SmartDD__Object_Field_API_Name__c, SmartDD__Priority__c, SmartDD__Status__c FROM SmartDD__ManageRule_Master_Record__c WHERE SmartDD__Object_Name__c =: ObjectName WITH USER_MODE];
        
        Decimal intCount = 1;
        while(strMergeRuleMasterRec == '' && intCount <= lstTotalMergeRule.size()) {
            
            tempQueryString = queryString;
            
            
            lstActiveMergeRule = [SELECT Id, SmartDD__Merge_Rule_Name__c, SmartDD__Least_Confidence_Score__c, SmartDD__Master_Order_By__c, SmartDD__Default_Override_Master_Record__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Master_Popup_Field_Values__c, SmartDD__Master_Record_Type__c, SmartDD__Object_Field_API_Name__c, SmartDD__Priority__c, SmartDD__Status__c FROM SmartDD__ManageRule_Master_Record__c WHERE SmartDD__Object_Name__c =: ObjectName AND SmartDD__Priority__c =: intCount WITH USER_MODE]; //NOPMD
            if(lstActiveMergeRule.size() > 0) {
                if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Oldest Modified Date') {
                    strOrderBy = 'LastModifiedDate ASC ';  
                } else if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Newest Modified Date') {
                    strOrderBy = 'LastModifiedDate DESC ';
                } else if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Oldest Created Date') {
                    strOrderBy = 'CreatedDate ASC';
                } else if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Newest Created Date') {
                    strOrderBy = 'CreatedDate DESC';
                } else {
                    strOrderBy = '';        
                }
                
                if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'First Record') {
                    if(strOrderBy != '') {
                        tempQueryString += ' ORDER BY '+ strOrderBy;
                    }
                    tempQueryString += ' Limit 1';
                    lstMasterRecordQuery = database.query(tempQueryString);     // NOPMD
                    strMergeRuleMasterRec = lstMasterRecordQuery[0].Id; 
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Most notes, attachments, activities, etc.') {
                    Integer intHighCount = 0 ;
                    
                    Map<String,Integer> mapTotalCount = new Map<String,Integer>();
                    List<AggregateResult> lstAggregateAttachment = new List<AggregateResult>();
                    lstAggregateAttachment = [SELECT COUNT(Id) countParent, ParentId FROM Attachment WITH USER_MODE GROUP BY ParentId LIMIT 200 ]; //NOPMD
                    for(AggregateResult objRslt: lstAggregateAttachment) {
                        mapTotalCount.put((string)objRslt.get('ParentId'),(integer)objRslt.get('countParent'));
                    }
                    
                    List<AggregateResult> lstAggregateNotes = new List<AggregateResult>();
                    lstAggregateNotes = [SELECT COUNT(Id) countParent, ParentId FROM Note WITH USER_MODE GROUP BY ParentId LIMIT 200]; //NOPMD
                    for(AggregateResult objRslt: lstAggregateAttachment) {
                        integer count = 0;
                        if(mapTotalCount.containsKey((string)objRslt.get('ParentId'))) {
                            count = (integer)objRslt.get('countParent') + mapTotalCount.get((string)objRslt.get('ParentId'));
                            mapTotalCount.put((string)objRslt.get('ParentId'),count);
                        }
                        else{
                            mapTotalCount.put((string)objRslt.get('ParentId'),(integer)objRslt.get('countParent'));
                        }
                    }
                    if(mapTotalCount.size() > 0) {
                        for(SmartDD__Child_Cluster_Record__c objClusterRec : lstClusterRecs) {
                            if(mapTotalCount.containsKey(objClusterRec.SmartDD__Cluster_Object_Id__c)) { //NOPMD
                                if(mapTotalCount.get(objClusterRec.SmartDD__Cluster_Object_Id__c) > intHighCount) {
                                    intHighCount = mapTotalCount.get(objClusterRec.SmartDD__Cluster_Object_Id__c);
                                    strMergeRuleMasterRec = objClusterRec.SmartDD__Cluster_Object_Id__c;
                                }
                            }
                        }
                    }
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Record with field value not on specified ignore list') {
                    List<String> lstPopFieldVals = new List<String>(); 
                    String masterPopVal = lstActiveMergeRule[0].SmartDD__Master_Popup_Field_Values__c;
                    if(masterPopVal != null && masterPopVal != '' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null) {
                        lstPopFieldVals = masterPopVal.split(',');
                        String strPopQueryVal = '';
                        for(String strPopField : lstPopFieldVals) {
                            strPopQueryVal += '\'' + strPopField + '\',';
                        }
                        strPopQueryVal.removeEnd(',');
                        
                        tempQueryString += ' AND ' + lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' NOT IN(' + strPopQueryVal + ')';
                    }
                    
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Newest by the given date field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null) {
                    if(strOrderBy != '') {
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC, ' + strOrderBy + ' Limit 1'; 
                    }
                    else{
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC Limit 1'; 
                    }
                    lstMasterRecordQuery = database.query(tempQueryString); //NOPMD
                    if(lstMasterRecordQuery.size() > 0) {
                        strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                    }
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Oldest by the given date field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null) {
                    if(strOrderBy != '') {
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC, ' + strOrderBy + ' Limit 1'; 
                    }
                    else{
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC Limit 1'; 
                    }
                    lstMasterRecordQuery = database.query(tempQueryString); //NOPMD
                    if(lstMasterRecordQuery.size() > 0) {
                        strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                    }
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Lowest value in the user-defined field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null) {
                    if(strOrderBy != '') {
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC, ' + strOrderBy + ' Limit 1'; 
                    }
                    else {
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' +   ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC Limit 1'; 
                    }
                    lstMasterRecordQuery = database.query(tempQueryString); //NOPMD
                    if(lstMasterRecordQuery.size() > 0) {
                        strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                    }
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Highest value in the user-defined field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null) {
                    if(strOrderBy != '') {
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC, ' + strOrderBy + ' Limit 1'; 
                    }
                    else {
                        tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC Limit 1'; 
                    }
                    System.debug('Q291--->'+tempQueryString);
                    lstMasterRecordQuery = database.query(tempQueryString); //NOPMD
                    if(lstMasterRecordQuery.size() > 0) {
                        strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                    }
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'First record with a value in the user-defined field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null) {
                    tempQueryString += ' AND ' + lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' != null';
                    if(strOrderBy != '') {
                        tempQueryString += ' ORDER BY ' + strOrderBy;
                    }
                    tempQueryString += ' Limit 1';
                    lstMasterRecordQuery = database.query(tempQueryString); //NOPMD
                    if(lstMasterRecordQuery.size() > 0) {
                        strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;  
                    }
                } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Most Complete Record') {
                    if(strOrderBy != '') {
                        tempQueryString += ' ORDER BY '+ strOrderBy;
                    }
                    map<string, integer> mapcnt = new map<string,integer>();
                    string strMostCompletedVal = '';
                    integer intHighCnt = 0;
                    for(sObject obj : database.query(tempQueryString)) { //NOPMD
                        integer intCnt = 0;
                        for(string strkey : fieldstoget.split(',')) {
                            if(strkey == 'Owner.Name' || strkey == 'Account.Name') {
                                continue;
                            } else {
                                if(obj.get(strkey) != null) {
                                    intCnt += 1;
                                }
                            }
                        }
                        if(intCnt > 0) {
                            if(intCnt > intHighCnt) { //NOPMD
                                intHighCnt = intCnt;
                                strMostCompletedVal = string.valueof(obj.get('id'));
                            }
                            mapcnt.put(string.valueof(obj.get('id')),intcnt);
                        }
                    }
                    strMergeRuleMasterRec = strMostCompletedVal;
                    
                }
            }
            intCount = intCount + 1;
        }
        
        
        
        /* *******************Field Value Selection MasterRecords Rules Functonality*********************** */
        
        List<Sobject> lstSobjectUpdate =  New List<Sobject>(); 
        fieldValQueryString = queryString;
        
        if(lstActiveMergeRule.size() > 0) {
            if(lstActiveMergeRule[0].SmartDD__Default_Field_Value_Selection_Priority__c == 'Oldest (Order by Modified Date)') {
                strSpecificValOrderBy = 'LastModifiedDate ASC ';  
            }else if(lstActiveMergeRule[0].SmartDD__Default_Field_Value_Selection_Priority__c == 'Newest (Order by Modified Date)') {
                strSpecificValOrderBy = 'LastModifiedDate DESC ';  
            }else if(lstActiveMergeRule[0].SmartDD__Default_Field_Value_Selection_Priority__c == 'Oldest (Order by Create Date)') {
                strSpecificValOrderBy = 'CreatedDate ASC ';  
            }else if(lstActiveMergeRule[0].SmartDD__Default_Field_Value_Selection_Priority__c == 'Newest (Order by Create Date)') {
                strSpecificValOrderBy = 'CreatedDate DESC ';  
            } else {
                strSpecificValOrderBy = '';        
            }
            
            string getMasterQueryString = ''; 
            string strBlankFieldAPIName = '';
            if(lstActiveMergeRule[0].SmartDD__Default_Override_Master_Record__c == 'Always Override Master') {
                if(strSpecificValOrderBy != '') {
                    fieldValQueryString += ' ORDER BY '+ strSpecificValOrderBy + ' Limit 1'; 
                }
                else{
                    fieldValQueryString += ' ORDER BY '+ strSpecificValOrderBy + ' Limit 1'; 
                }
                lstMasterRecordQuery = database.query(fieldValQueryString);
                if(lstMasterRecordQuery.size() > 0) {
                    strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                }
            } else if(lstActiveMergeRule[0].SmartDD__Default_Override_Master_Record__c == 'Override Master When Blank') {
                getMasterQueryString += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget) +
                    ' from '+ String.escapeSingleQuotes(ObjectName) +
                    ' WHERE Id =: strMergeRuleMasterRec WITH USER_MODE';
                
                List<sObject> lstSObjMasterRec = new List<sObject>();
                
                lstSObjMasterRec = database.query(getMasterQueryString);
                
                for(sObject obj : lstSObjMasterRec) {
                    integer intvalCount = 0;
                    for(string strkey : fieldstoget.split(',')) {
                        
                        if(strkey == 'Owner.Name' || strkey == 'Account.Name') {
                            continue;
                        }
                        else {
                            SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                            DescribeSObjectResult d = r.getDescribe();
                            String fieldType = String.valueOf(d.fields.getMap().get(strkey).getDescribe().getType());
                            
                            if(obj.get(strkey) == null && fieldType != 'date'  && fieldType != 'datetime' && fieldType != 'reference') {
                                intvalCount += 1;
                                strBlankFieldAPIName += strkey + ', ' ;
                            }
                        }
                        
                    }
                }
                strBlankFieldAPIName.removeEnd(', ');
                
                List<sObject> lstReplaceMasterRec =  New List<sObject>();
                string getReplaceQueryStr = ''; 
                getReplaceQueryStr += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget)+
                    ' from '+ String.escapeSingleQuotes(ObjectName) +
                    ' WHERE Id In : setClusterRecId AND Id !=: strMergeRuleMasterRec WITH USER_MODE';
                
                if(strSpecificValOrderBy != '') {
                    getReplaceQueryStr += ' ORDER BY '+ strSpecificValOrderBy + ' Limit 1'; 
                }
                else{
                    getReplaceQueryStr += ' ORDER BY '+ strSpecificValOrderBy + ' Limit 1'; 
                }                    
                lstReplaceMasterRec = database.query(getReplaceQueryStr);               
                
                // Lead objLead = new Lead();
                sObject sObjSel = Schema.getGlobalDescribe().get(objectName).newSObject();
                if(lstSObjMasterRec.size() > 0 && strBlankFieldAPIName != '' && lstReplaceMasterRec.Size() > 0){
                    sObjSel.Id = lstSObjMasterRec[0].Id;
                    for(string KeyVal :  strBlankFieldAPIName.split(', ')) { //NOPMD
                        sObjSel.put(KeyVal,lstReplaceMasterRec[0].get(KeyVal));
                    }
                    lstSobjectUpdate.add(sObjSel);
                }
                
                if(lstSObjMasterRec.size() > 0) {
                    strMergeRuleMasterRec = lstSObjMasterRec[0].Id;
                }
            }
        }
        
        /* *******************Specific Field Values MasterRecords Rules Functonality*********************** */
        List<Sobject> lstSobjommonFieldUpdate =  New List<Sobject>();
        if(lstActiveMergeRule.size() > 0) {
            List<SmartDD__ManageRule_Specific_FieldVal__c> lstOfSpecificFielsVal = [SELECT SmartDD__Specific_Rule_Name__c, SmartDD__Specific_Popup_Field_Values__c, SmartDD__Specific_Master_Override_Type__c, SmartDD__Specific_Field_Name__c, SmartDD__Master_Record_Criteria_Name__c, Id, Name FROM SmartDD__ManageRule_Specific_FieldVal__c WHERE SmartDD__Master_Record_Criteria_Name__c =:lstActiveMergeRule[0].Id WITH USER_MODE]; //NOPMD
            string getSpecificMasterQueryString = ''; 
            string strBlankFieldName = '';
            Map<String,String> MapOfString = new Map<String,String>(); //NOPMD
            Map<String,String> MapOfPopUpValues = new Map<String,String>(); //NOPMD
            
            getSpecificMasterQueryString  += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget) + ' from '+ String.escapeSingleQuotes(ObjectName) +' WHERE Id =: strMergeRuleMasterRec WITH USER_MODE';
            
            
            List<sObject> lstSObjectMasterRec = new List<sObject>();
            lstSObjectMasterRec = database.query(getSpecificMasterQueryString);
            List<sObject> lstSpecificValReplaceMasterRec =  New List<sObject>();
            List<sObject> lstSpecificDateValReplaceMasterRec =  New List<sObject>();
            
            string getReplaceSpecificQueryString = ''; 
            getReplaceSpecificQueryString += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget)+' from '+ String.escapeSingleQuotes(ObjectName) + ' WHERE Id In : setClusterRecId AND Id !=: strMergeRuleMasterRec WITH USER_MODE';
            
            
            // Lead objLead = new Lead();
            sObject sObj = Schema.getGlobalDescribe().get(objectName).newSObject();
            lstSpecificValReplaceMasterRec = database.query(getReplaceSpecificQueryString); 
            string strSpecificValueOrderBy = '';
            String specifciFieldValQueryString = '';
            string fieldSpecificValue ;
            specifciFieldValQueryString  = queryString ;
            Integer cntCheck = 0;
            
            for(SmartDD__ManageRule_Specific_FieldVal__c MSFValue : lstOfSpecificFielsVal) { //NOPMD
                cntCheck = cntCheck + 1;
                if(MSFValue.SmartDD__Specific_Master_Override_Type__c == 'Override Master When Blank') {
                    
                    for(sObject obj : lstSObjectMasterRec) {
                        if(MSFValue.SmartDD__Specific_Field_Name__c == 'Owner.Name' || MSFValue.SmartDD__Specific_Field_Name__c == 'Account.Name') {
                            continue;
                        } else {
                            SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                            DescribeSObjectResult d = r.getDescribe();
                            if(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c) != null) {
                                String fieldType = String.valueOf(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c).getDescribe().getType());
                                if(MSFValue.SmartDD__Specific_Field_Name__c != null && MSFValue.SmartDD__Specific_Rule_Name__c != null && fieldType != 'date'  && fieldType != 'datetime' && fieldType != 'reference') { //NOPMD
                                    MapOfString.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Rule_Name__c);  MapOfPopUpValues.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Popup_Field_Values__c);
                                }
                            } 
                        }
                        
                    }
                }
                else if(MSFValue.SmartDD__Specific_Master_Override_Type__c == 'Always Override Master') {
                    
                    for(sObject obj : lstSObjectMasterRec) {
                        if(MSFValue.SmartDD__Specific_Field_Name__c == 'Owner.Name' || MSFValue.SmartDD__Specific_Field_Name__c == 'Account.Name') {
                            continue;
                        } else {
                            SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                            DescribeSObjectResult d = r.getDescribe();
                            if(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c) != null) {
                                String fieldType = String.valueOf(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c).getDescribe().getType());
                                if(MSFValue.SmartDD__Specific_Field_Name__c != null && MSFValue.SmartDD__Specific_Rule_Name__c!= null && fieldType != 'date'  && fieldType != 'datetime' && fieldType != 'reference') { //NOPMD
                                    MapOfString.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Rule_Name__c); MapOfPopUpValues.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Popup_Field_Values__c);
                                }
                            }
                        }
                    }
                }
            }
            
            Map<String,String> mapObjIdRulename =new Map<String,String>();
            Map<String,String> mapObjIdColumnName=new Map<String,String>();
            Map<String,Integer> MapCommonVal = new Map<String,Integer>(); //NOPMD
            Map<String,String> MapCommonFieldsVal = new Map<String,String>(); //NOPMD
            for(String SpecicficRulestr : MapOfString.keySet()) { //NOPMD
                if(MapOfString.get(SpecicficRulestr) == 'Most Common') {
                    for(Sobject objLeadRec: lstSpecificValReplaceMasterRec) {
                        if(setFieldsToGet.contains(SpecicficRulestr) && objLeadRec.get(SpecicficRulestr) != null){
                            if(!MapCommonVal.containsKey(String.ValueOf(objLeadRec.get(SpecicficRulestr)))) {//NOPMD
                                Integer cnt =1;
                                MapCommonVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), cnt); MapCommonFieldsVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), SpecicficRulestr);
                            }else {
                                Integer cnt = MapCommonVal.get(String.ValueOf(objLeadRec.get(SpecicficRulestr)));
                                MapCommonVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), cnt+1); MapCommonFieldsVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), SpecicficRulestr);
                            }
                        }
                    }
                    Integer lowCont = 0;
                    fieldSpecificValue = '';
                    if(MapCommonVal.Keyset() != null) {
                        for(string stringSpecificVal : MapCommonVal.Keyset()) {
                            if(MapCommonVal.get(stringSpecificVal) >= lowCont) { //NOPMD
                                lowCont = MapCommonVal.get(stringSpecificVal ); fieldSpecificValue = stringSpecificVal;
                            }
                        }
                    }
                    
                    sObj.Id = lstSObjectMasterRec[0].Id;
                    if(fieldSpecificValue != null && fieldSpecificValue != '' && MapCommonFieldsVal.get(fieldSpecificValue) != null){
                        sObj.put(MapCommonFieldsVal.get(fieldSpecificValue),fieldSpecificValue);
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Newest (ordered by MODIFIED date)') {
                    
                    strSpecificValueOrderBy = '';
                    strSpecificValueOrderBy = 'LastModifiedDate DESC ';  
                    
                    specifciFieldValQueryString  = queryString ;
                    if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                        specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                    }
                    
                    lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString); //NOPMD
                    if(setFieldsToGet.contains(SpecicficRulestr) && lstSpecificDateValReplaceMasterRec.size() > 0) {
                        sObj.Id = lstSObjectMasterRec[0].Id;
                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                        mapObjIdRulename.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),string.valueOf(lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)));
                        mapObjIdColumnName.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),SpecicficRulestr);
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Oldest (ordered by CREATE date)') {
                    
                    strSpecificValueOrderBy = '';
                    strSpecificValueOrderBy = 'CreatedDate ASC ';  
                    
                    specifciFieldValQueryString  = queryString ;
                    if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                        specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                    }
                    
                    lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString); //NOPMD
                    if(setFieldsToGet.contains(SpecicficRulestr) && lstSpecificDateValReplaceMasterRec.size() > 0) {
                        sObj.Id = lstSObjectMasterRec[0].Id;
                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                        mapObjIdRulename.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),string.valueOf(lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)));
                        mapObjIdColumnName.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),SpecicficRulestr);
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Newest (ordered by CREATE date)') {
                    
                    strSpecificValueOrderBy = '';
                    strSpecificValueOrderBy = 'CreatedDate DESC ';  
                    
                    specifciFieldValQueryString  = queryString ;
                    if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                        specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                    }
                    
                    lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString); //NOPMD
                    if(setFieldsToGet.contains(SpecicficRulestr) && lstSpecificDateValReplaceMasterRec.size() > 0) {
                        sObj.Id = lstSObjectMasterRec[0].Id;
                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                        mapObjIdRulename.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),string.valueOf(lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)));
                        mapObjIdColumnName.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),SpecicficRulestr);
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Oldest (ordered by MODIFIED date)') {
                    
                    strSpecificValueOrderBy = '';
                    strSpecificValueOrderBy = 'LastModifiedDate ASC ';  
                    
                    specifciFieldValQueryString  = queryString ;
                    if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                        specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                    }
                    lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString); //NOPMD
                    if(setFieldsToGet.contains(SpecicficRulestr) && lstSpecificDateValReplaceMasterRec.size() > 0) {
                        sObj.Id = lstSObjectMasterRec[0].Id;sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)); mapObjIdRulename.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),string.valueOf(lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)));  mapObjIdColumnName.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),SpecicficRulestr);
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Ignore all values: update to blank or to given value') {
                    sObj.Id = lstSObjectMasterRec[0].Id;
                    string populateValue = '';
                    
                    if(MapOfPopUpValues.containsKey(SpecicficRulestr) && MapOfPopUpValues.get(SpecicficRulestr) != null && MapOfPopUpValues.get(SpecicficRulestr) != '') {
                        populateValue = MapOfPopUpValues.get(SpecicficRulestr);
                        sObj.put(SpecicficRulestr,populateValue);
                    } else {
                        sObj.put(SpecicficRulestr,'-');
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Override Master Value with value not on ignore list') {
                    string populateValue = '';
                    list<string> lstPopUpVal = new list<string>();
                    
                    if(MapOfPopUpValues.containsKey(SpecicficRulestr) && MapOfPopUpValues.get(SpecicficRulestr) != null && MapOfPopUpValues.get(SpecicficRulestr) != '') {
                        populateValue = MapOfPopUpValues.get(SpecicficRulestr);
                        lstPopUpVal = populateValue.split(',');
                        for(sobject objClucterRecs : lstSpecificValReplaceMasterRec){
                            integer popCount = 0;
                            if(setFieldsToGet.contains(SpecicficRulestr)) { //NOPMD
                                for(string pstr : lstPopUpVal){
                                    if(objClucterRecs.get(SpecicficRulestr) == pstr){
                                        popCount = popCount + 1;
                                    }
                                }
                                if(popCount == 0 && objClucterRecs.get(SpecicficRulestr) != null && objClucterRecs.get(SpecicficRulestr) != ''){
                                    sObj.Id = lstSObjectMasterRec[0].Id;
                                    sObj.put(SpecicficRulestr,objClucterRecs.get(SpecicficRulestr));
                                    mapObjIdRulename.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),string.valueOf(lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr))); mapObjIdColumnName.put(string.valueOf(lstSpecificDateValReplaceMasterRec[0].Id),SpecicficRulestr);
                                    break;
                                }
                            }
                        }  
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Prioritized by values') {
                    string populateValue = '';
                    list<string> lstPopUpVal = new list<string>();
                    if(MapOfPopUpValues.containsKey(SpecicficRulestr) && MapOfPopUpValues.get(SpecicficRulestr) != null && MapOfPopUpValues.get(SpecicficRulestr) != '') {
                        populateValue = MapOfPopUpValues.get(SpecicficRulestr);
                        lstPopUpVal = populateValue.split(', ');
                        for(string popVal : lstPopUpVal){
                            integer popCount = 0;
                            for(sobject objClucterRecs : lstSpecificValReplaceMasterRec){
                                if(setFieldsToGet.contains(SpecicficRulestr) && popVal == objClucterRecs.get(SpecicficRulestr)) { //NOPMD
                                    sObj.Id = lstSObjectMasterRec[0].Id;
                                    sObj.put(SpecicficRulestr,objClucterRecs.get(SpecicficRulestr));
                                    if(objClucterRecs.get(SpecicficRulestr) != null) {
                                        mapObjIdRulename.put(string.valueOf(objClucterRecs.Id),string.valueOf(objClucterRecs.get(SpecicficRulestr))); mapObjIdColumnName.put(string.valueOf(objClucterRecs.Id),SpecicficRulestr);
                                    }
                                    popCount = popCount + 1;
                                    break;
                                }
                            }
                            if(popCount > 0){ //NOPMD
                                break;
                            }
                        } 
                    }
                } else if(MapOfString.get(SpecicficRulestr) == 'Field with max characters') {
                    String strFieldVal = '';
                    Integer highestValCount = 0;
                    if(lstSpecificValReplaceMasterRec.size() > 0) {
                        for(sobject objClucterRecs : lstSpecificValReplaceMasterRec) {
                            if(setFieldsToGet.contains(SpecicficRulestr)) { //NOPMD
                                strFieldVal = String.ValueOf(objClucterRecs.get(SpecicficRulestr));
                                if(strFieldVal != null && strFieldVal.length() > highestValCount) {
                                    highestValCount = strFieldVal.length();
                                    sObj.Id = lstSObjectMasterRec[0].Id; sObj.put(SpecicficRulestr,objClucterRecs.get(SpecicficRulestr));
                                    
                                    mapObjIdRulename.put(string.valueOf(objClucterRecs.Id),string.valueOf(MapOfString.get(SpecicficRulestr))); mapObjIdColumnName.put(string.valueOf(objClucterRecs.Id),SpecicficRulestr);
                                    
                                }
                            }
                        }
                    }
                }
            }
            lstSobjommonFieldUpdate.add(sObj);
        }
        
        if (sortField != '' && sortField != null) {
            queryString += ' ORDER BY ' + String.escapeSingleQuotes(sortField);
            // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
            if (isAsc) {
                queryString += ' DESC NULLS LAST';
            } else {
                queryString += ' ASC';
            }
        }    
        
        objTableWrapper.sObjectrecords = database.query(queryString);objTableWrapper.mergeRuleMasterRecords = strMergeRuleMasterRec; objTableWrapper.fieldSelectionMasterRecords = lstSobjectUpdate;objTableWrapper.SpecificeFieldMasterRecords = lstSobjommonFieldUpdate;
        
        if(lstActiveMergeRule.size() > 0){
            objTableWrapper.mergeRuleMasterRecordType = lstActiveMergeRule[0].SmartDD__Master_Record_Type__c; objTableWrapper.leastConfidenceScore = (Integer)lstActiveMergeRule[0].SmartDD__Least_Confidence_Score__c; objTableWrapper.clusterConfidenceScore = (Integer)lstClusterRecs[0].SmartDD__Cluster_Id__r.SmartDD__Confidence_Score__c;
            
            if(lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != ''){
                objTableWrapper.mergeRuleObjectFieldVal = lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c;
            } 
        }
        
        objTableWrapper.sObjectTotalRecords = database.query(queryStringTotal);
        if(objTableWrapper.sObjectTotalRecords.size() > 0){
            objTableWrapper.total = Integer.valueOf(objTableWrapper.sObjectTotalRecords[0].get('expr0'));
        }
        
        return objTableWrapper;
    }
    /*******************************************************
Purpose: fetch all fields from Review and Polish Columns
*******************************************************/
    @AuraEnabled
    public static List<wrpObjectFieldsList> fetchReviewClusterColumns(String filterObjName) {
        List<wrpObjectFieldsList> newWrpList = new List<wrpObjectFieldsList>();
        List<String> lstColmnAPIName = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> MapOfLead = schemaMap.get(filterObjName).getDescribe().fields.getMap(); //NOPMD
        wrpObjectFieldsList objwrp = new wrpObjectFieldsList();
        
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c >([SELECT Id, SmartDD__Object_Name__c, SmartDD__Review_Polish_Display_Columns__c 
                                                                                                           FROM SmartDD__Search_Column__c WHERE SmartDD__Object_Name__c =: filterObjName WITH USER_MODE]);
        
        if(lstObjectColumns.Size() > 0){
            lstColmnAPIName = lstObjectColumns[0].Review_Polish_Display_Columns__c.split(',');
            
            for(String objDedupeFilter : lstColmnAPIName){
                if(objDedupeFilter != null && objDedupeFilter != ''){
                    String fieldLabelName = '';
                    if(objDedupeFilter == 'Owner.Name'){
                        fieldLabelName = 'Owner Name';
                    } else if(objDedupeFilter == 'Account.Name'){
                        fieldLabelName = 'Account Name';
                    } else{
                        fieldLabelName = String.valueOf(MapOfLead.get(objDedupeFilter).getDescribe().getLabel());
                    }
                    wrpFields objField = new wrpFields();
                    objField.fieldName = fieldLabelName;
                    objField.fieldApiName = objDedupeFilter;
                    objwrp.FieldsList.add(objField);
                }
            }
        }
        newWrpList.add(objwrp);
        return newWrpList;
    }
    
    @AuraEnabled
    public static lightningTableWrapper fnGetClusterPolishDetails(String fieldstoget, String MasterRecordId ,String ObjectName) { //NOPMD
        Set<Id> setClusterRecId = new Set<Id>();
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        String queryString = '';
        String queryStringTotal = '';
        
        queryString += 'Select Id, '+ String.escapeSingleQuotes(fieldstoget)+
            ' from '+ String.escapeSingleQuotes(ObjectName) +
            ' WHERE Id  =: MasterRecordId WITH USER_MODE';
        
        queryStringTotal += 'Select Count(Id) from '+ String.escapeSingleQuotes(ObjectName) +
            ' WHERE Id =: MasterRecordId WITH USER_MODE';              
        
        objTableWrapper.sObjectrecords = database.query(queryString);
        objTableWrapper.sObjectTotalRecords = database.query(queryStringTotal);
        objTableWrapper.total = Integer.valueOf(objTableWrapper.sObjectTotalRecords[0].get('expr0'));
        return objTableWrapper;
    }
    
    @AuraEnabled
    public static void postMasterRecord(String masterRecord, List<String> lstColumnName, String clusterId, String masterRecordId, String selObjectName) { //NOPMD
        string tempNotesSpecific = '';
        Set<String> setColumnName = new Set<String>();
        for(String strColumnName: lstColumnName) {
            setColumnName.add(strColumnName);    
        }
        
        //AttachmentDetailsController.getchildrecord();
        List<String> lstMasterRecords = new List<String>();
        
        lstMasterRecords = masterRecord.Split('","');
        
        /*fetch new Master Cluster Id From Custom Setting Manage Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(selObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null && objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != '') {
            strNewMasterClusterId = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            // totalClusters = Database.countQuery('SELECT count() FROM All_CLuster_Record__c WHERE Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        //if(totalClusters == 0 && objMasterClusterId.Old_Master_Cluster_Id__c != null ) {
        //  strNewMasterClusterId = objMasterClusterId.Old_Master_Cluster_Id__c;
        //}
        
        String objectName = selObjectName;
        
        SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        
        String strNotes = '';
        Set<String> setSobjFieldsToGet = new Set<String>();
        String strFieldsToGet = '';
        
        //Lead objLead = new Lead();
        sObject sObj = Schema.getGlobalDescribe().get(objectName).newSObject();
        sObj.put('Id',masterRecordId);
        for(String StrLeadRecs : lstMasterRecords) { //NOPMD
            String strFieldName = '';
            String strFieldValue = '';
            
            List<String> lstLeadKeyName = new List<String>();
            lstLeadKeyName = StrLeadRecs.Split(':');
            
            if(lstLeadKeyName.size() > 0) {
                lstLeadKeyName[0] = lstLeadKeyName[0].replaceAll('"', '');
                lstLeadKeyName[1] = lstLeadKeyName[1].replaceAll('"', '');
                
                if(lstLeadKeyName[0] == 'ownername' || lstLeadKeyName[0] == 'Name' || lstLeadKeyName[0] == 'accountname') {
                    continue;
                }
                
                if(lstLeadKeyName[1] == '-') {
                    lstLeadKeyName[1] = '';
                }    
                
                setSobjFieldsToGet.add(lstLeadKeyName[0]);
                strFieldsToGet += lstLeadKeyName[0] + ',';
                List<sObject> lstMasterRecordDetails =  New List<sObject>();            
                string strMasterRecordDetails = ''; 
                strMasterRecordDetails += 'SELECT '+ String.escapeSingleQuotes(lstLeadKeyName[0])+ ' FROM '+ String.escapeSingleQuotes(objectName) +' WHERE Id =: masterRecordId WITH USER_MODE';
                lstMasterRecordDetails = database.query(strMasterRecordDetails);   //NOPMD
                
                String fieldType = String.valueOf(d.fields.getMap().get(lstLeadKeyName[0]).getDescribe().getType());
                
                if(fieldType == 'int') {
                    if(lstLeadKeyName[1] == '') {
                        lstLeadKeyName[1] = '0';
                    }
                    if(lstMasterRecordDetails[0].get(lstLeadKeyName[0]) != null && lstLeadKeyName[1] != null) {
                        if(setColumnName.contains(lstLeadKeyName[0])) { //NOPMD
                            strNotes += '<br/>&nbsp;&nbsp;Changed <b>'+ lstLeadKeyName[0] +'</b> from <u>'+ lstMasterRecordDetails[0].get(lstLeadKeyName[0]) +'</u> to <u>'+ lstLeadKeyName[1]+'.</u>';
                        }
                    }
                    sObj.put(lstLeadKeyName[0],Integer.valueOf(lstLeadKeyName[1]));
                } else if(fieldType == 'double' || fieldType == 'currency') {
                    if(lstLeadKeyName[1] == '') {
                        lstLeadKeyName[1] = '0';
                    }
                    if(lstMasterRecordDetails[0].get(lstLeadKeyName[0]) != null && lstLeadKeyName[1] != null) {
                        if(setColumnName.contains(lstLeadKeyName[0])) { //NOPMD
                            strNotes += '<br/>&nbsp;&nbsp;Changed <b>'+ lstLeadKeyName[0] +'</b> from <u>'+ lstMasterRecordDetails[0].get(lstLeadKeyName[0]) +'</u> to <u>'+ lstLeadKeyName[1]+'.</u>';
                        }
                    }
                    sObj.put(lstLeadKeyName[0],Decimal.valueOf(lstLeadKeyName[1]));
                } else if(fieldType == 'url' || fieldType == 'textarea' || fieldType == 'string' || fieldType == 'picklist' || fieldType == 'email' || fieldType == 'phone') {
                    if(lstMasterRecordDetails[0].get(lstLeadKeyName[0]) != null && lstLeadKeyName[1] != null) {
                        if(setColumnName.contains(lstLeadKeyName[0])) { //NOPMD
                            strNotes += '<br/>&nbsp;&nbsp;Changed <b>'+ lstLeadKeyName[0] +'</b> from <u>'+ lstMasterRecordDetails[0].get(lstLeadKeyName[0]) +'</u> to <u>'+ string.valueOf(lstLeadKeyName[1])+'.</u>';
                        }
                    }
                    sObj.put(lstLeadKeyName[0],string.valueOf(lstLeadKeyName[1]));
                } else {
                    continue;
                }
            }
        }
        
        List<SmartDD__Child_Cluster_Record__c> lstSelectedMasterrecord = new List<SmartDD__Child_Cluster_Record__c>([Select Id, SmartDD__Cluster_Id__c, SmartDD__MannualCluster__c FROM SmartDD__Child_Cluster_Record__c 
                                                                                                                               WHERE SmartDD__Cluster_Id__c =: clusterId AND SmartDD__Cluster_Object_Id__c =: masterRecordId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        
        for(SmartDD__Child_Cluster_Record__c objChild : lstSelectedMasterrecord) {
            objChild.SmartDD__MannualCluster__c = false;
        }       
        if(lstSelectedMasterrecord.size() > 0 &&  Schema.sObjectType.SmartDD__Child_Cluster_Record__c.isUpdateable()) {
            SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstSelectedMasterrecord); 
            Update decision.getRecords();
        }
        
        
        /*Attachment attachment = new Attachment();
        attachment.ParentId = masterRecordId;
        attachment.name = 'PDF_'+String.valueof(Datetime.now())+'.pdf';
        PageReference pdf = Page.AttachmentDetails;
        pdf.getParameters().put('leadId', masterRecordId);
        pdf.getParameters().put('displayOnly', '1');
        pdf.setRedirect(true);
        try {
        system.debug('@@@Success');
        attachment.Body = pdf.getContent();
        
        }
        catch (VisualForceException e) {
        system.debug('@@@Error');
        attachment.Body = Blob.valueof('There was an error.');
        } 
        attachment.ContentType = 'application/pdf';
        system.debug('@@@attachment body==' +attachment.Body);
        insert attachment;*/
        
        //List<Lead> lstlead=new List<Lead>();
        // Map<String,String> mapObjIdRulename =new Map<String,String>();
        //Map<String,String> mapObjIdColumnName=new Map<String,String>();
        //lstlead = [SELECT Id,Name,FirstName,LastName from Lead where id=: masterRecordId WITH USER_MODE];
        Decimal intCount=1;
        string masterrule;
        string usrDefinedField;
        Integer intLeastConfidenceScore = 0;
        
        List<SmartDD__ManageRule_Master_Record__c> lstActiveMergeRule = new List<SmartDD__ManageRule_Master_Record__c>();
        
        lstActiveMergeRule = [SELECT Id, SmartDD__Merge_Rule_Name__c, SmartDD__Master_Order_By__c, SmartDD__Least_Confidence_Score__c, SmartDD__Default_Override_Master_Record__c, SmartDD__Default_Field_Value_Selection_Priority__c,
                              SmartDD__Master_Popup_Field_Values__c, SmartDD__Master_Record_Type__c, SmartDD__Object_Field_API_Name__c, SmartDD__Priority__c, SmartDD__Status__c 
                              FROM SmartDD__ManageRule_Master_Record__c 
                              WHERE SmartDD__Priority__c =: intCount AND SmartDD__Object_Name__c =: objectName WITH USER_MODE];
        
        if(lstActiveMergeRule.size() > 0){
            masterrule= lstActiveMergeRule[0].SmartDD__Master_Record_Type__c;
            usrDefinedField = lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c;
            intLeastConfidenceScore = (Integer)lstActiveMergeRule[0].SmartDD__Least_Confidence_Score__c;
        }
        
        List<SmartDD__Cluster__c> lstClusterDetails = new List<SmartDD__Cluster__c>([SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Confidence_Score__c FROM SmartDD__Cluster__c WHERE Id =: clusterId WITH USER_MODE]);
        
        List<SmartDD__Child_Cluster_Record__c> lstSelectedClusterChildRec = new List<SmartDD__Child_Cluster_Record__c>([Select Id, SmartDD__Cluster_Id__c, SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c 
                                                                                                                                  WHERE SmartDD__Cluster_Id__c =: clusterId AND SmartDD__Cluster_Object_Id__c !=: masterRecordId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        
        Id currentUserId = UserInfo.getUserId(); 
        List<User> lstCurrentUserInfo = new List<User>([SELECT Id, Username, LastName, FirstName, Name FROM User WHERE Id =: currentUserId WITH USER_MODE]);
        Integer totalRecords = lstSelectedClusterChildRec.Size() + 1;
        String strNotesBody = '';
        strNotesBody += totalRecords + ' records were merged manually by '+lstCurrentUserInfo[0].Name+ ' with the confidence level of '+Integer.valueOf(lstClusterDetails[0].SmartDD__Confidence_Score__c)+'.';
        strNotesBody += '<br/><b>The master record id is:</b> '+masterRecordId+' <b>and the child record ids are: </b>'+ '<br/>';
        Integer Count = 1; //NOPMD
        for(SmartDD__Child_Cluster_Record__c childRecs : lstSelectedClusterChildRec){
            strNotesBody += Count+'. '+ childRecs.Id+ '<br/>';
            Count = Count + 1;
        }
        strNotesBody += '<br/><b>We use the master record rule: </b>'+masterrule+'.';
        if(intLeastConfidenceScore != 0) {
            strNotesBody += ' <b>with minimum confidence level of: </b>'+ intLeastConfidenceScore; 
        }
        if(usrDefinedField != null && usrDefinedField != '') {
            strNotesBody += '<b> ' +usrDefinedField + '</b>';
        }
        
        if(strNotes != '') {
            strNotesBody += '<br/><br/><b>Following is the updated records description:</b>'; 
            strNotesBody += strNotes;
        }
        
        //Merge Attachments
        Set<Id> setClusterRecId = new Set<Id>();
        String strChildRecIds = '';
        for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstSelectedClusterChildRec) {
            setClusterRecId.add(strClusterRecords.SmartDD__Cluster_Object_Id__c);
            strChildRecIds += strClusterRecords.SmartDD__Cluster_Object_Id__c + ',';
        }
        strChildRecIds = strChildRecIds.removeEnd(',');
        /*try {
//sObj.put('IsMerged__c',true);
sObject sObjIsMerged = Schema.getGlobalDescribe().get(objectName).newSObject();
if(sObj.Id != null){
// Storing the stringified master record to temp object to be merged in unique record page on click of save button
MergedRecordBackup__c objMergedBackup = new MergedRecordBackup__c();
objMergedBackup.Obj_Record_Id__c = sObj.Id;
objMergedBackup.StringifiedJsonRecord__c = JSON.serialize(sObj); //String.ValueOf(sObj);
objMergedBackup.Obj_ChildRecird_Id__c = strChildRecIds;
Insert objMergedBackup;
sObjIsMerged.Id = sObj.Id;
sObjIsMerged.put('IsMerged__c',true); 
update sObjIsMerged;
//update sObj; 
}
}
catch(DmlException e) {
System.debug('@@Statement: '+ e.getMessage());
}*/
        
        /*List<Attachment> lstChildAttachmentsOld = new List<Attachment>([SELECT Id,Name,ParentId,ContentType,BodyLength,Body,OwnerId,Description FROM Attachment WHERE ParentId IN : setClusterRecId WITH USER_MODE]);
List<Attachment> lstChildAttachmentsNew = new List<Attachment>();
if(lstChildAttachmentsOld.Size() > 0) {
for(Attachment objOldAttachments: lstChildAttachmentsOld) {
Attachment objAttachmentNew = new Attachment();
objAttachmentNew.Name = objOldAttachments.Name;
objAttachmentNew.ParentId = masterRecordId;
objAttachmentNew.ContentType = objOldAttachments.ContentType;
//objAttachmentNew.BodyLength = objOldAttachments.BodyLength;
objAttachmentNew.Body = objOldAttachments.Body;
objAttachmentNew.OwnerId = objOldAttachments.OwnerId ;
objAttachmentNew.Description = objOldAttachments.Description; 
lstChildAttachmentsNew.add(objAttachmentNew);
}
Insert lstChildAttachmentsNew;
Delete lstChildAttachmentsOld;
}*/
        
        // Set specific field values
        List<sObject> lstSobjMasterRecords =  New List<sObject>(); 
        List<SmartDD__ManageRule_Specific_FieldVal__c> lstSpecifMergeRule = new List<SmartDD__ManageRule_Specific_FieldVal__c>();
        if(lstActiveMergeRule.Size() > 0) {
            lstSpecifMergeRule = [SELECT Id, Name, SmartDD__Master_Record_Criteria_Name__c, SmartDD__Specific_Field_Name__c, 
                                  SmartDD__Specific_Master_Override_Type__c, SmartDD__Specific_Popup_Field_Values__c, SmartDD__Specific_Rule_Name__c 
                                  FROM SmartDD__ManageRule_Specific_FieldVal__c 
                                  WHERE SmartDD__Master_Record_Criteria_Name__c =: lstActiveMergeRule[0].Id WITH USER_MODE];
            
            strFieldsToGet = strFieldsToGet.removeEnd(',');
            String strSobjMasterRecord  = '';
            strSobjMasterRecord += 'SELECT '+ String.escapeSingleQuotes(strFieldsToGet)+
                ' From '+ String.escapeSingleQuotes(objectName) +' WHERE Id =: masterRecordId WITH USER_MODE';
            lstSobjMasterRecords = database.query(strSobjMasterRecord);
        }
        if(lstSpecifMergeRule.Size() > 0 && lstSobjMasterRecords.size() > 0) {
            for(SmartDD__ManageRule_Specific_FieldVal__c objSpecificFieldValue: lstSpecifMergeRule) {
                for(String StrObjRecs : lstMasterRecords) { //NOPMD
                    
                    List<String> lstObjKeyName = new List<String>();
                    lstObjKeyName = StrObjRecs.Split(':');
                    
                    if(lstObjKeyName.size() > 0) {
                        lstObjKeyName[0] = lstObjKeyName[0].replaceAll('"', '');
                        lstObjKeyName[1] = lstObjKeyName[1].replaceAll('"', '');
                    }
                    if(setSobjFieldsToGet.contains(objSpecificFieldValue.SmartDD__Specific_Field_Name__c) && lstObjKeyName[0] == objSpecificFieldValue.SmartDD__Specific_Field_Name__c) { 
                        tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ objSpecificFieldValue.SmartDD__Specific_Field_Name__c;
                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ objSpecificFieldValue.SmartDD__Specific_Rule_Name__c;
                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ objSpecificFieldValue.SmartDD__Specific_Master_Override_Type__c;
                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ objSpecificFieldValue.SmartDD__Specific_Field_Name__c+'</b> from <u>'+lstSobjMasterRecords[0].get(objSpecificFieldValue.SmartDD__Specific_Field_Name__c)+'</u> to <u>'+string.valueOf(lstObjKeyName[1])+'.</u><br/><br/>';
                        break;
                    }
                }
                
            }
            if(tempNotesSpecific != '') {
                strNotesBody += '<br/><br/><b>Following is the specific rule descriptions: </b><br/>';
                strNotesBody += tempNotesSpecific;
            }
        }
        
        SmartDD__TempDedupeNote__c masterRecTempNotes = new SmartDD__TempDedupeNote__c();
        
        string ObjectLabel = ObjectName.removeEnd('__c'); //NOPMD
        String objFldParentId = 'SmartDD__'+ObjectLabel+'ParentId__c';
        masterRecTempNotes.put(objFldParentId,masterRecordId);
        masterRecTempNotes.SmartDD__Title__c = 'Note_'+String.valueof(Datetime.now());
        masterRecTempNotes.SmartDD__Body__c = strNotesBody;
        masterRecTempNotes.SmartDD__MergeType__c = 'Manual';
        masterRecTempNotes.SmartDD__Object_Name__c = ObjectName;
        if(Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__Title__c.isCreateable() && Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__Body__c.isCreateable() && 
           Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__MergeType__c.isCreateable() && Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__Object_Name__c.isCreateable())
        {
            insert masterRecTempNotes;            
        }
        
        
        try {
            //sObj.put('IsMerged__c',true);
            sObject sObjIsMerged = Schema.getGlobalDescribe().get(objectName).newSObject();
            if(sObj.Id != null){
                // Storing the stringified master record to temp object to be merged in unique record page on click of save button
                SmartDD__MergedRecordBackup__c objMergedBackup = new SmartDD__MergedRecordBackup__c();
                objMergedBackup.SmartDD__Obj_Record_Id__c = sObj.Id;
                objMergedBackup.SmartDD__StringifiedJsonRecord__c = JSON.serialize(sObj); //String.ValueOf(sObj);
                objMergedBackup.SmartDD__Obj_ChildRecird_Id__c = strChildRecIds;
                
                if(Schema.sObjectType.SmartDD__MergedRecordBackup__c.fields.SmartDD__Obj_Record_Id__c.isCreateable() && Schema.sObjectType.SmartDD__MergedRecordBackup__c.fields.SmartDD__StringifiedJsonRecord__c.isCreateable() && Schema.sObjectType.SmartDD__MergedRecordBackup__c.fields.SmartDD__Obj_ChildRecird_Id__c.isCreateable())
                {
                    Insert objMergedBackup;
                }
                
                /*if(Schema.sObjectType.Account.fields.Id.isAccessible() || Schema.sObjectType.Lead.fields.Id.isAccessible() || Schema.sObjectType.Contact.fields.Id.isAccessible() )               
                {
                    Account objactid = new Account();
                	objactid = [select id from Account where id =: sObj.id WITH USER_MODE];
                     sObjIsMerged.id = objactid.Id;
                }
                //sObjIsMerged.id = sObj.Id;*/
                
                if(Schema.sObjectType.Account.fields.SmartDD__IsMerged__c.isUpdateable() 
                || Schema.sObjectType.Lead.fields.SmartDD__IsMerged__c.isUpdateable() 
                || Schema.sObjectType.Contact.fields.SmartDD__IsMerged__c.isUpdateable()){
                	sObjIsMerged.put('SmartDD__IsMerged__c',true); 
                }
                if(Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.Id.isAccessible()){
                	sObjIsMerged.put('SmartDD__TempDedupeNotes__c',masterRecTempNotes.Id);
                }
                if(objectName == 'Account'){  
                    Account objactid = new Account();
                	objactid = [select id from Account where id =: sObj.id ];
                    objactid.put('SmartDD__IsMerged__c',true); 
                    objactid.put('SmartDD__TempDedupeNotes__c',masterRecTempNotes.Id);
                    if(Schema.sObjectType.Account.isUpdateable() || Account.sObjectType.getDescribe().isUpdateable()){
                        update objactid;
                    }
                }
                else if(objectName == 'Lead'){
                    Lead objLeadid = new Lead();
                	objLeadid = [select id from Lead where id =: sObj.id];
                    objLeadid.put('SmartDD__IsMerged__c',true); 
                    objLeadid.put('SmartDD__TempDedupeNotes__c',masterRecTempNotes.Id);
                    if(Schema.sObjectType.Lead.isUpdateable() || Lead.sObjectType.getDescribe().isUpdateable()){
                        update objLeadid;
                    }
                }
                else if(objectName == 'Contact'){
                    Contact objcnctid = new Contact();
                	objcnctid = [select id from Contact where id =: sObj.id ];
                    objcnctid.put('SmartDD__IsMerged__c',true); 
                    objcnctid.put('SmartDD__TempDedupeNotes__c',masterRecTempNotes.Id);
                   if(Schema.sObjectType.Contact.isUpdateable() || Contact.sObjectType.getDescribe().isUpdateable()){
                        update objcnctid;
                    }
                }
                //update sObj; 
            }
        }
        catch(DmlException e) {
            System.debug('@@Statement: '+ e.getMessage());
        }
        
        List<SmartDD__Cluster__c> lstMasterClusterRecs = new List<SmartDD__Cluster__c>([SELECT Id, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE Id =: clusterId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);
        
        // List<Child_Cluster_Record__c> lstSelectedClusterChildRec = new List<Child_Cluster_Record__c>([Select Id, Cluster_Id__c FROM Child_Cluster_Record__c 
        //                                                                                         WHERE Cluster_Id__c =: clusterId AND Cluster_Object_Id__c !=: masterRecordId WITH USER_MODE]);
        if(lstSelectedClusterChildRec.size() > 0) {
            if (SmartDD__Child_Cluster_Record__c.sObjectType.getDescribe().isDeletable()) {
                delete lstSelectedClusterChildRec;
            }
        }
    }
    
    @AuraEnabled
    public static String autoPolishRecords(String fieldstoget,String ObjectName) {  //NOPMD
        String strQuery = '';
        /*fetch new Master Cluster Id From Custom Setting Manage Master Cluster Id*/
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
        
        strQuery = 'SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 AND SmartDD__Total_Child_Records__c < 100 AND SmartDD__Master_Cluster_Record_Id__c =\''+ strNewMasterClusterId + '\' WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        batchFetchUniqueRecordList uniqueRecordsBatch = new batchFetchUniqueRecordList(strQuery,fieldstoget,ObjectName,strNewMasterClusterId);
        Id BatchProcessId  = Database.executeBatch(uniqueRecordsBatch,10);      //NOPMD          
        /**Update auto merge batchId in custom setting*/
        SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(ObjectName);
        manageClusterBatch.SmartDD__Batch_Id__c = BatchProcessId;
        upsert manageClusterBatch;//NOPMD
        
        return BatchProcessId;
    }
    
    @AuraEnabled
    public static SmartDD__Manage_Cluster_Batch_Id__c getBatchId(String strObjectName){
        SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(strObjectName);        
        return manageClusterBatch;
    }
    
    //To get batch status 
    @AuraEnabled
    public static AsyncApexJobWrapper batchStatus(Id BatchProcessId, String strObjectName) { //NOPMD
        AsyncApexJobWrapper objApexJob = new AsyncApexJobWrapper();  
        if(BatchProcessId != null || BatchProcessId != ''){
            objApexJob.lstAsyncApexJob = [SELECT Status, JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, ParentJobId FROM AsyncApexJob WHERE Id =: BatchProcessId WITH USER_MODE];
            objApexJob.TotalJobItems = objApexJob.lstAsyncApexJob[0].TotalJobItems; 
            objApexJob.JobItemsProcessed = objApexJob.lstAsyncApexJob[0].JobItemsProcessed; 
            objApexJob.JobItemStatus = objApexJob.lstAsyncApexJob[0].Status;
        }        
        if(objApexJob.JobItemStatus == 'Completed') {
            SmartDD__Manage_Cluster_Batch_Id__c manageClusterBatch = SmartDD__Manage_Cluster_Batch_Id__c.getValues(strObjectName);
            manageClusterBatch.SmartDD__Batch_Id__c = '';
            if(Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isUpdateable()) {
                upsert manageClusterBatch;        	 }
            
        }      
        return objApexJob;
    }
    
    /**********************************************************************************************
Purpose:  fetch filter criterias and filter logic 
**********************************************************************************************/
    public static String getQueryConditionString(String filterId) {
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r ) from SmartDD__Filter__c WHERE Id =: filterId  WITH USER_MODE];
        
        Map<Integer,String> tempMap = fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        String strQueryConditions = '';
        String strlogic = objFilter.SmartDD__FilterLogic__c;
        strQueryConditions += fnGetCriteriaString(strlogic,tempMap);
        return strQueryConditions;
    } 
    
    /**********************************************************************************************
Purpose: To bind filter criteria value.
**********************************************************************************************/
    Public static Map<Integer,String> fnBindFilterCriteria(List<SmartDD__Filter_Criteria__c> lstFilterCriteria){ //NOPMD
        Map<Integer,String> mapAllFilterCriteria = new Map<Integer,String>();
        Integer Count = 0; //NOPMD
        for(SmartDD__Filter_Criteria__c objFilterCriterias: lstFilterCriteria){
            Count++;           
            String filter = '';            
            String strSearchOn = 'Lead';
            Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
            Schema.DescribeSObjectResult objResult = objtype.getDescribe();
            
            if(!String.Isblank(objFilterCriterias.SmartDD__Field__c)){
                String oldOperator = objFilterCriterias.SmartDD__Operator__c;
                String oldField = objFilterCriterias.SmartDD__Field__c;
                string strDynamicField1 = string.valueof(objFilterCriterias.SmartDD__Field__c);
                strDynamicField1 = CreateFieldName(string.valueof(objFilterCriterias.SmartDD__Field__c),strSearchOn);
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
    Public static String CreateFieldName(String strFieldLabel,String strSearchOn){ //NOPMD
        String strFieldName = '';
        strSearchOn = 'Lead';
        
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
            strFieldName = checkfieldLabel(strFieldLabel);
        }
        return strFieldName;
    }
    
    /**********************************************************************************************
Purpose: To get Operator for filter
**********************************************************************************************/
    Public static String fillOperator(String strOperator){
        if(strOperator == 'equals') strOperator  = '='; //NOPMD
        else if(strOperator == 'not equal to') strOperator = '!=';//NOPMD
        else if(strOperator == 'less than') strOperator = '<';//NOPMD
        else if(strOperator == 'greater than') strOperator = '>';//NOPMD
        else if(strOperator == 'less or equal') strOperator = '<=';//NOPMD
        else if(strOperator == 'greater or equal') strOperator = '>=';//NOPMD
        else if(strOperator == 'contains') strOperator = 'Like';//NOPMD
        else if(strOperator == 'does not contain') strOperator = 'NotLike';//NOPMD
        else if(strOperator == 'starts with') strOperator = 'startswith';//NOPMD
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
                        string ValueLike = '%'+ fnCheckBlankValue(strValue)+'%';//NOPMD
                        filterCriteria += String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueLike) + '\'';
                    }else{
                        string ValueLike = fnCheckBlankValue(strValue);//NOPMD
                        filterCriteria += String.escapeSingleQuotes(strFiledVal) +' includes (\''+ String.escapeSingleQuotes(ValueLike) + '\')';
                    }
                }
        }else if(strOperatorVal == 'NotLike'){
            if((ftype != null && ftype.getType() != Schema.DisplayType.Date && ftype.getType() != Schema.DisplayType.DateTime && ftype.getType() != Schema.DisplayType.BOOLEAN 
                && ftype.getType() != Schema.DisplayType.CURRENCY && ftype.getType() != Schema.DisplayType.INTEGER && ftype.getType() != Schema.DisplayType.DOUBLE ) || strftype == 'String'){
                    
                    if(ftype == null || (ftype != null && ftype.getType() != Schema.DisplayType.MULTIPICKLIST)){
                        string ValueNotLike =  '%'+fnCheckBlankValue(strValue)+'%'; //NOPMD
                        filterCriteria += '(Not '+ String.escapeSingleQuotes(strFiledVal) +' Like \''+ String.escapeSingleQuotes(ValueNotLike) +'\')';
                    }else{
                        string ValueNotLike =  fnCheckBlankValue(strValue); //NOPMD
                        filterCriteria += String.escapeSingleQuotes(strFiledVal) +' EXCLUDES (\''+ String.escapeSingleQuotes(ValueNotLike ) + '\')';
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
                                         if(!String.isBlank(Value)){
                                             filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                         }else{
                                             filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                         }
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                         if(!String.isBlank(Value)){
                                             filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
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
                                         if(!String.isBlank(Value)){
                                             filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                         }else{
                                             filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' null';
                                         }
                                     }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                         if(!String.isBlank(Value)){
                                             filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
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
                                     if(!String.isBlank(Value)){
                                         filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                                     }
                                 }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                                     if(!String.isBlank(Value)){
                                         filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
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
                if(!String.isBlank(Value)){
                    filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){
                    filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
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
                if(!String.isBlank(Value)){
                    filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){
                    filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
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
                if(!String.isBlank(Value)){
                    filterCriteria +=  String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.DateTime){
                if(!String.isBlank(Value)){
                    filterCriteria += ' day_only('+String.escapeSingleQuotes(strFiledVal) +') '+ String.escapeSingleQuotes(strOperatorVal) + ' ' + String.escapeSingleQuotes(Value);
                }
            }else if(ftype != null && ftype.getType() == Schema.DisplayType.STRING){
                if(!String.isBlank(Value)){
                    filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
                }
            }else if(ftype != null && ftype.getType() != Schema.DisplayType.BOOLEAN && ftype.getType() != Schema.DisplayType.MULTIPICKLIST){
                filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
            }
        }else{
            string Value =  strValue.trim(); //NOPMD
            filterCriteria += String.escapeSingleQuotes(strFiledVal) +' '+ String.escapeSingleQuotes(strOperatorVal) +' \''+ String.escapeSingleQuotes(Value) + '\'';
        }
        return filterCriteria;
    }
    
    /**********************************************************************************************
Purpose: To get single token from Filter Logic
**********************************************************************************************/
    @TestVisible private static String[] tokenizeFilterLogic(String filterLogic){ //NOPMD
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
    public static String checkfieldLabel(String strFiledLabel){
        String fieldLabel = '';
        if(!String.Isblank(strFiledLabel)){
            Schema.SObjectType objtype = Schema.getGlobalDescribe().get('Lead');
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
        } else{
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
    
    public class AsyncApexJobWrapper{
        @AuraEnabled public Integer TotalJobItems{get;set;} //NOPMD
        @AuraEnabled public String JobItemStatus{get;set;} //NOPMD
        @AuraEnabled public Integer JobItemsProcessed{get;set;} //NOPMD
        @AuraEnabled public List<AsyncApexJob> lstAsyncApexJob{get;set;}
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
    
    
}