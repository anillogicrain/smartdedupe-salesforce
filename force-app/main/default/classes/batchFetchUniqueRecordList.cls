global with sharing class batchFetchUniqueRecordList implements Database.Batchable<sObject>, Database.Stateful {
    
    public String fieldsToGetPrm;
    public String ObjectNamePrm;
    public String strNewMasterClusterIdPrm;
    public String strQuery;
    public Map<Id, SObject> mapUniqueLeadRec;
    Set<Id> setMergeClusterId = new Set<Id>();
    global batchFetchUniqueRecordList(String query, String fieldstoget, String ObjectName, String strNewMasterClusterId) {
        fieldsToGetPrm = fieldstoget; 
        ObjectNamePrm = ObjectName;
        strNewMasterClusterIdPrm = strNewMasterClusterId;
        if(Test.isRunningTest()){
            fieldsToGetPrm = 'FirstName,LastName,Email,Title,Company';
            ObjectNamePrm = 'Lead';
        }
        strQuery = query;
        mapUniqueLeadRec = New map<Id, SObject>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //strQuery = 'SELECT Id, Name, External_Cluster_Id__c, Total_Child_Records__c FROM Cluster__c WHERE Total_Child_Records__c > 1 AND Master_Cluster_Record_Id__c =\''+ strNewMasterClusterIdPrm + '\' WITH USER_MODE ORDER BY External_Cluster_Id__c ASC';                                      
        return Database.getQueryLocator(strQuery);                                     
    }
    global void execute(Database.BatchableContext bc, List<SmartDD__Cluster__c> lstClusters) {
        for(SmartDD__Cluster__c objCluster : lstClusters) {
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
            Integer intLeastConfidenceScore = 0;
            List<SmartDD__ManageRule_Master_Record__c> lstActiveMergeRule = new List<SmartDD__ManageRule_Master_Record__c>();
            List<SmartDD__ManageRule_Master_Record__c> lstTotalMergeRule = new List<SmartDD__ManageRule_Master_Record__c>();
            setMergeClusterId.add(objCluster.Id);
            String strChildRecIds = '';
            List<SmartDD__Child_Cluster_Record__c> lstClusterRecs = new List<SmartDD__Child_Cluster_Record__c>([SELECT Id, SmartDD__Cluster_Object_Id__c, SmartDD__Cluster_Record_External_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: objCluster.Id AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterIdPrm WITH USER_MODE]);
            for(SmartDD__Child_Cluster_Record__c strClusterRecords : lstClusterRecs) {
                setClusterRecId.add(strClusterRecords.SmartDD__Cluster_Object_Id__c);strChildRecIds += strClusterRecords.SmartDD__Cluster_Object_Id__c + ',';
            }
            strChildRecIds = strChildRecIds.removeEnd(',');
            
            lightningTableWrapper objTableWrapper = new lightningTableWrapper();
            Set<String> setFieldsToGet = new Set<String>(fieldsToGetPrm.split(','));
            queryString += 'Select Id, '+ String.escapeSingleQuotes(fieldsToGetPrm)+
                ' from '+ String.escapeSingleQuotes(ObjectNamePrm) +
                ' WHERE Id In : setClusterRecId ';
            queryStringTotal += 'Select Count(Id) from '+ String.escapeSingleQuotes(ObjectNamePrm) +
                ' WHERE Id In : setClusterRecId ';  
             lstTotalMergeRule = [SELECT Id, SmartDD__Merge_Rule_Name__c, SmartDD__Master_Order_By__c, SmartDD__Least_Confidence_Score__c, SmartDD__Default_Override_Master_Record__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Master_Popup_Field_Values__c, SmartDD__Master_Record_Type__c, SmartDD__Object_Field_API_Name__c, SmartDD__Priority__c, SmartDD__Status__c FROM SmartDD__ManageRule_Master_Record__c WHERE SmartDD__Object_Name__c =: ObjectNamePrm WITH USER_MODE];    
            List<sObject> lstMasterRecordQuery = new List<sObject>();
            Decimal intCount = 1;
            while(strMergeRuleMasterRec == '' && intCount <= lstTotalMergeRule.Size()) {
                tempQueryString = queryString;
                lstActiveMergeRule = [SELECT Id, SmartDD__Merge_Rule_Name__c, SmartDD__Least_Confidence_Score__c, SmartDD__Master_Order_By__c, SmartDD__Default_Override_Master_Record__c, SmartDD__Default_Field_Value_Selection_Priority__c, SmartDD__Master_Popup_Field_Values__c, SmartDD__Master_Record_Type__c, SmartDD__Object_Field_API_Name__c, SmartDD__Priority__c, SmartDD__Status__c FROM SmartDD__ManageRule_Master_Record__c WHERE SmartDD__Object_Name__c =: ObjectNamePrm AND SmartDD__Priority__c =: intCount WITH USER_MODE];
                if(lstActiveMergeRule.Size() > 0) {
                    if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Oldest Modified Date') {
                        strOrderBy = 'LastModifiedDate ASC ';  
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Newest Modified Date') {
                        strOrderBy = 'LastModifiedDate DESC ';
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Oldest Created Date') {
                        strOrderBy = 'CreatedDate ASC ';
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Order_By__c == 'Newest Created Date') {
                        strOrderBy = 'CreatedDate DESC ';
                    } else {
                        strOrderBy = '';        
                    }
                    if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'First Record' /*&& lstActiveMergeRule[0].SmartDD__Least_Confidence_Score__c <= objCluster.SmartDD__Confidence_Score__c*/) {
                        if(strOrderBy != '') {
                            tempQueryString += 'WITH USER_MODE ORDER BY '+ strOrderBy;
                        }
                        tempQueryString += ' Limit 1';
                        lstMasterRecordQuery = database.query(tempQueryString);
                        if(lstMasterRecordQuery.size() > 0){strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;}                                                
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Most notes, attachments, activities, etc.' /*&& lstActiveMergeRule[0].SmartDD__Least_Confidence_Score__c <= objCluster.SmartDD__Confidence_Score__c*/) {
                        Integer intHighCount = 0 ;
                        Map<String,Integer> mapTotalCount = new Map<String,Integer>();
                        List<AggregateResult> lstAggregateAttachment = new List<AggregateResult>();
                        lstAggregateAttachment = [SELECT COUNT(Id) countParent, ParentId FROM Attachment WITH USER_MODE GROUP BY ParentId LIMIT 200];
                        for(AggregateResult objRslt: lstAggregateAttachment) {
                            mapTotalCount.put((string)objRslt.get('ParentId'),(integer)objRslt.get('countParent'));
                        }
                        
                        List<AggregateResult> lstAggregateNotes = new List<AggregateResult>();
                        lstAggregateNotes = [SELECT COUNT(Id) countParent, ParentId FROM Note WITH USER_MODE GROUP BY ParentId LIMIT 200];
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
                                if(mapTotalCount.containsKey(objClusterRec.SmartDD__Cluster_Object_Id__c)) {
                                    if(mapTotalCount.get(objClusterRec.SmartDD__Cluster_Object_Id__c) > intHighCount) {
                                        intHighCount = mapTotalCount.get(objClusterRec.SmartDD__Cluster_Object_Id__c);
                                        strMergeRuleMasterRec = objClusterRec.SmartDD__Cluster_Object_Id__c;
                                    }
                                }
                            }
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Record with field value not on specified ignore list' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        List<String> lstPopFieldVals = new List<String>(); 
                        String masterPopVal = lstActiveMergeRule[0].SmartDD__Master_Popup_Field_Values__c;
                        if(masterPopVal != null && masterPopVal != '') {
                            lstPopFieldVals = masterPopVal.split(',');
                            String strPopQueryVal = '';
                            for(String strPopField : lstPopFieldVals) {
                                strPopQueryVal += '\'' + strPopField + '\',';
                            }
                            strPopQueryVal.removeEnd(',');
                            
                            tempQueryString += ' AND ' + lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' NOT IN(' + strPopQueryVal + ')';
                        }
                        } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Newest by the given date field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        if(strOrderBy != '') {
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC, ' + strOrderBy + ' Limit 1'; 
                        }
                        else{
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC Limit 1'; 
                        }
                        lstMasterRecordQuery = database.query(tempQueryString);
                        if(lstMasterRecordQuery.size() > 0) {
                            strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Oldest by the given date field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        if(strOrderBy != '') {
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC, ' + strOrderBy + ' Limit 1'; 
                        }
                        else{
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC Limit 1'; 
                        }
                        lstMasterRecordQuery = database.query(tempQueryString);
                        if(lstMasterRecordQuery.size() > 0) {
                            strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Lowest value in the user-defined field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        if(strOrderBy != '') {
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC, ' + strOrderBy + ' Limit 1'; 
                        }
                        else {
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' +   ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' ASC Limit 1'; 
                        }
                        
                        lstMasterRecordQuery = database.query(tempQueryString);
                        if(lstMasterRecordQuery.size() > 0) {
                            strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Highest value in the user-defined field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        if(strOrderBy != '') {
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC, ' + strOrderBy + ' Limit 1'; 
                        }
                        else {
                            tempQueryString += ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' != null' + ' AND '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c  +' > 0' + ' WITH USER_MODE ORDER BY '+ lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' DESC Limit 1'; 
                        }
                        lstMasterRecordQuery = database.query(tempQueryString);
                        if(lstMasterRecordQuery.size() > 0) {
                            strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'First record with a value in the user-defined field' && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        tempQueryString += ' AND ' + lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + ' != null';
                        if(strOrderBy != '') {
                            tempQueryString += ' WITH USER_MODE ORDER BY ' + strOrderBy;
                        }
                        tempQueryString += ' Limit 1';
                        lstMasterRecordQuery = database.query(tempQueryString);
                        if(lstMasterRecordQuery.size() > 0) {
                            strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;  
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Master_Record_Type__c == 'Most Complete Record' /*&& lstActiveMergeRule[0].Least_Confidence_Score__c <= objCluster.Confidence_Score__c*/) {
                        if(strOrderBy != '') {
                            tempQueryString += ' WITH USER_MODE ORDER BY '+ strOrderBy;
                        }
                        map<string, integer> mapcnt = new map<string,integer>();
                        string strMostCompletedVal = '';
                        integer intHighCnt = 0;
                        for(sObject obj : database.query(tempQueryString)) {
                            integer intCnt = 0;
                            for(string strkey : fieldsToGetPrm.split(',')) {
                                if(strkey == 'Owner.Name' || strkey == 'Account.Name') {
                                    continue;
                                }
                                else {
                                    if(obj.get(strkey) != null) {
                                        intCnt += 1;
                                    }
                                }
                            }
                            if(intCnt > 0) {
                                if(intCnt > intHighCnt) {
                                    intHighCnt = intCnt; strMostCompletedVal = string.valueof(obj.get('id'));
                                }
                                mapcnt.put(string.valueof(obj.get('id')),intcnt);
                            }
                        }
                        strMergeRuleMasterRec = strMostCompletedVal;
                        
                    }
                }
                intCount = intCount + 1;
            }
            // Check if the Master record is not selected, then delete the cluster instead.
            if(strMergeRuleMasterRec != '') {
                
                sObject sObj = Schema.getGlobalDescribe().get(ObjectNamePrm).newSObject();
                /* *******************Field Value Selection MasterRecords Rules Functonality*********************** */
                fieldValQueryString = queryString;
                intLeastConfidenceScore = (Integer)lstActiveMergeRule[0].SmartDD__Least_Confidence_Score__c;
                
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
                            fieldValQueryString += ' Limit 1'; 
                        }
                        lstMasterRecordQuery = database.query(fieldValQueryString);
                        if(lstMasterRecordQuery.size() > 0) {
                            strMergeRuleMasterRec = lstMasterRecordQuery[0].Id;
                        }
                    } else if(lstActiveMergeRule[0].SmartDD__Default_Override_Master_Record__c == 'Override Master When Blank') {
                        getMasterQueryString += 'Select Id, '+ String.escapeSingleQuotes(fieldsToGetPrm) + ' from '+ String.escapeSingleQuotes(ObjectNamePrm) + ' WHERE Id =: strMergeRuleMasterRec WITH USER_MODE';
                        
                        List<sObject> lstSObjMasterRec = new List<sObject>();  lstSObjMasterRec = database.query(getMasterQueryString);
                        
                        for(sObject obj : lstSObjMasterRec) {
                            integer intvalCount = 0;
                            for(string strkey : fieldsToGetPrm.split(',')) {
                                
                                if(strkey == 'Owner.Name' || strkey == 'Account.Name') {
                                    continue;
                                }
                                else {
                                    SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectNamePrm).newInstance())).getSObjectType();
                                    DescribeSObjectResult d = r.getDescribe();String fieldType = String.valueOf(d.fields.getMap().get(strkey).getDescribe().getType());
                                    
                                    if(obj.get(strkey) == null && fieldType != 'date'  && fieldType != 'datetime' && fieldType != 'reference') {
                                        intvalCount += 1;strBlankFieldAPIName += strkey + ', ' ;
                                    }
                                }
                                
                            }
                        }
                        strBlankFieldAPIName.removeEnd(', ');
                        
                        
                        
                        List<sObject> lstReplaceMasterRec =  New List<sObject>();
                        string getReplaceQueryStr = ''; 
                        getReplaceQueryStr += 'Select Id, '+ String.escapeSingleQuotes(fieldsToGetPrm)+' from '+ String.escapeSingleQuotes(ObjectNamePrm) +' WHERE Id In : setClusterRecId AND Id !=: strMergeRuleMasterRec WITH USER_MODE';
                        
                        if(strSpecificValOrderBy != '') {
                            getReplaceQueryStr += ' ORDER BY '+ strSpecificValOrderBy + ' Limit 1'; 
                        }
                        else{
                            getReplaceQueryStr += ' Limit 1'; 
                        }           
                        lstReplaceMasterRec = database.query(getReplaceQueryStr); 
                        
                        sObj.Id = null;
                        if(lstSObjMasterRec.Size() > 0 && strBlankFieldAPIName != '') {
                            sObj.Id = lstSObjMasterRec[0].Id;
                        
                            for(string KeyVal :  strBlankFieldAPIName.split(', ')) {
                                sObj.put(KeyVal,lstReplaceMasterRec[0].get(KeyVal));
                            }
                            mapUniqueLeadRec.put(sObj.Id, sObj);
                        }
                       
                        if(lstSObjMasterRec.size() > 0) {
                            strMergeRuleMasterRec = lstSObjMasterRec[0].Id;
                        }
                        
                    }
                    
                    
                }
                
                /* *******************Specific Field Values MasterRecords Rules Functonality*********************** */
                string tempNotesSpecific = '';
                string tempNotesOverrideType = '';
                List<sObject> lstMasterRecordDetails =  New List<sObject>();
                string strMasterRecordDetails = ''; 
                strMasterRecordDetails += 'Select Id, '+ String.escapeSingleQuotes(fieldsToGetPrm)+' from '+ String.escapeSingleQuotes(ObjectNamePrm) +' WHERE Id =: strMergeRuleMasterRec WITH USER_MODE';
                lstMasterRecordDetails = database.query(strMasterRecordDetails);  
                if(lstActiveMergeRule.size() > 0) {
                    List<SmartDD__ManageRule_Specific_FieldVal__c> lstOfSpecificFielsVal = [SELECT SmartDD__Specific_Rule_Name__c, SmartDD__Specific_Popup_Field_Values__c, SmartDD__Specific_Master_Override_Type__c, SmartDD__Specific_Field_Name__c, SmartDD__Master_Record_Criteria_Name__c, Id, Name FROM SmartDD__ManageRule_Specific_FieldVal__c WHERE SmartDD__Master_Record_Criteria_Name__c =:lstActiveMergeRule[0].Id WITH USER_MODE];
                    string getSpecificMasterQueryString = ''; 
                    string strBlankFieldName = '';
                    Map<String,String> MapOfString = new Map<String,String>();
                    Map<String,String> MapOfPopUpValues = new Map<String,String>();
                    
                    getSpecificMasterQueryString  += 'Select Id, '+ String.escapeSingleQuotes(fieldsToGetPrm) +' from '+ String.escapeSingleQuotes(ObjectNamePrm) + ' WHERE Id =: strMergeRuleMasterRec WITH USER_MODE';
                    
                    
                    
                    List<sObject> lstSObjectMasterRec = new List<sObject>();
                    lstSObjectMasterRec = database.query(getSpecificMasterQueryString);
                    List<sObject> lstSpecificValReplaceMasterRec =  New List<sObject>();
                    List<sObject> lstSpecificDateValReplaceMasterRec =  New List<sObject>();
                    
                    string getReplaceSpecificQueryString = ''; 
                    
                    getReplaceSpecificQueryString += 'Select Id, '+ String.escapeSingleQuotes(fieldsToGetPrm)+' from '+ String.escapeSingleQuotes(ObjectNamePrm) +' WHERE Id In : setClusterRecId AND Id !=: strMergeRuleMasterRec WITH USER_MODE';
                    
                    //Lead objLead = new Lead();
                    lstSpecificValReplaceMasterRec = database.query(getReplaceSpecificQueryString); 
                    string strSpecificValueOrderBy = '';
                    String specifciFieldValQueryString = '';
                    string fieldSpecificValue ;
                    specifciFieldValQueryString  = queryString ;
                    Integer cntCheck = 0;
                    
                    if(lstSObjectMasterRec.Size() > 0) {
                        for(SmartDD__ManageRule_Specific_FieldVal__c MSFValue : lstOfSpecificFielsVal) {
                            cntCheck = cntCheck + 1;
                            if(MSFValue.SmartDD__Specific_Master_Override_Type__c == 'Override Master When Blank') {
                               
                                
                                for(sObject obj : lstSObjectMasterRec) {
                                    if(MSFValue.SmartDD__Specific_Field_Name__c == 'Owner.Name' || MSFValue.SmartDD__Specific_Field_Name__c == 'Account.Name') {
                                        continue;
                                    }
                                    else {
                                        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectNamePrm).newInstance())).getSObjectType();
                                        DescribeSObjectResult d = r.getDescribe();
                                        if(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c) != null) {
                                            String fieldType = String.valueOf(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c).getDescribe().getType());
                                            if(MSFValue.SmartDD__Specific_Field_Name__c != null && fieldType != 'date'  && fieldType != 'datetime' && fieldType != 'reference') {
                                                MapOfString.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Rule_Name__c);
                                                MapOfPopUpValues.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Popup_Field_Values__c);
                                               
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            else if(MSFValue.SmartDD__Specific_Master_Override_Type__c == 'Always Override Master') {
                                
                                for(sObject obj : lstSObjectMasterRec) {
                                    if(MSFValue.SmartDD__Specific_Field_Name__c == 'Owner.Name' || MSFValue.SmartDD__Specific_Field_Name__c == 'Account.Name') {
                                        continue;
                                    }
                                    else {
                                        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectNamePrm).newInstance())).getSObjectType();
                                        DescribeSObjectResult d = r.getDescribe();
                                        if(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c) != null) {
                                            String fieldType = String.valueOf(d.fields.getMap().get(MSFValue.SmartDD__Specific_Field_Name__c).getDescribe().getType());
                                            if(fieldType != 'date'  && fieldType != 'datetime' && fieldType != 'reference') {
                                                MapOfString.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Rule_Name__c);
                                                MapOfPopUpValues.put(MSFValue.SmartDD__Specific_Field_Name__c,MSFValue.SmartDD__Specific_Popup_Field_Values__c);
                                               
                                            }
                                        }
                                    }
                                }
                            }
                            tempNotesOverrideType = MSFValue.SmartDD__Specific_Master_Override_Type__c;
                        }
                        
                        sObj.Id = lstSObjectMasterRec[0].Id;
                        Map<String,Integer> MapCommonVal = new Map<String,Integer>();
                        Map<String,String> MapCommonFieldsVal = new Map<String,String>();
                        for(String SpecicficRulestr : MapOfString.keySet()) {
                            if(MapOfString.get(SpecicficRulestr) == 'Most Common') {
                                for(Sobject objLeadRec: lstSpecificValReplaceMasterRec) {
                                    
    
                                    if(setFieldsToGet.contains(SpecicficRulestr) && objLeadRec.get(SpecicficRulestr) != null){
                                        if(!MapCommonVal.containsKey(String.ValueOf(objLeadRec.get(SpecicficRulestr)))) {
                                            Integer cnt =1;
                                            MapCommonVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), cnt);
                                            MapCommonFieldsVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), SpecicficRulestr);
                                        }else{
                                            Integer cnt = MapCommonVal.get(String.ValueOf(objLeadRec.get(SpecicficRulestr)));
                                            MapCommonVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), cnt+1);
                                            MapCommonFieldsVal.put(String.ValueOf(objLeadRec.get(SpecicficRulestr)), SpecicficRulestr);
                                        }
                                    }
                                }
                                Integer lowCont = 0;
                                fieldSpecificValue = '';
                                if(MapCommonVal.Keyset() != null) {
                                    for(string stringSpecificVal : MapCommonVal.Keyset()) {
                                        if(MapCommonVal.get(stringSpecificVal) >= lowCont) {
                                            lowCont = MapCommonVal.get(stringSpecificVal );
                                            fieldSpecificValue = stringSpecificVal;
                                        }
                                    }
                                }
                                
                                
                                if(fieldSpecificValue != null && fieldSpecificValue != '' && MapCommonFieldsVal.get(fieldSpecificValue) != null){
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ MapCommonFieldsVal.get(fieldSpecificValue);
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ MapCommonFieldsVal.get(fieldSpecificValue)+'</b> from <u>'+lstMasterRecordDetails[0].get(MapCommonFieldsVal.get(fieldSpecificValue))+'</u> to <u>'+fieldSpecificValue+'.</u><br/><br/>';
                                    sObj.put(MapCommonFieldsVal.get(fieldSpecificValue),fieldSpecificValue);
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Newest (ordered by MODIFIED date)') {
                                
                                strSpecificValueOrderBy = '';
                                strSpecificValueOrderBy = 'LastModifiedDate DESC ';  
                                
                                specifciFieldValQueryString  = queryString ;
                                if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                                    specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                                }
                                
                                lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString);
                                if(lstSpecificDateValReplaceMasterRec.size() > 0) {
                                   
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                    if(setFieldsToGet.contains(SpecicficRulestr)) {
                                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)+'.</u><br/><br/>';
                                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                                    }
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Oldest (ordered by CREATE date)') {
                                
                                strSpecificValueOrderBy = '';
                                strSpecificValueOrderBy = 'CreatedDate ASC ';  
                                
                                specifciFieldValQueryString  = queryString ;
                                if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                                    specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                                }
                                
                                lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString);
                                if(lstSpecificDateValReplaceMasterRec.size() > 0) {
                                   
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                    if(setFieldsToGet.contains(SpecicficRulestr)) {
                                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)+'.</u><br/><br/>';
                                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                                    }
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Newest (ordered by CREATE date)') {
                                
                                strSpecificValueOrderBy = '';
                                strSpecificValueOrderBy = 'CreatedDate DESC ';  
                                
                                specifciFieldValQueryString  = queryString ;
                                if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                                    specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                                }
                                
                                lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString);
                                if(lstSpecificDateValReplaceMasterRec.size() > 0) {
                                   
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                    if(setFieldsToGet.contains(SpecicficRulestr)) {
                                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)+'.</u><br/><br/>';
                                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                                    }
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Oldest (ordered by MODIFIED date)') {
                                
                                strSpecificValueOrderBy = '';
                                strSpecificValueOrderBy = 'LastModifiedDate ASC ';  
                                
                                specifciFieldValQueryString  = queryString ;
                                if(strSpecificValueOrderBy != '' && strSpecificValueOrderBy != NULL) {
                                    specifciFieldValQueryString += ' ORDER BY '+ strSpecificValueOrderBy + ' Limit 1'; 
                                }
                                lstSpecificDateValReplaceMasterRec = database.query(specifciFieldValQueryString);
                                if(lstSpecificDateValReplaceMasterRec.size() > 0) {
                                    
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                    if(setFieldsToGet.contains(SpecicficRulestr)) {
                                        tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr)+'.</u><br/><br/>';
                                        sObj.put(SpecicficRulestr,lstSpecificDateValReplaceMasterRec[0].get(SpecicficRulestr));
                                    }
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Ignore all values: update to blank or to given value') {
                                
                                string populateValue = '';
                                
                                if(MapOfPopUpValues.containsKey(SpecicficRulestr) && MapOfPopUpValues.get(SpecicficRulestr) != null && MapOfPopUpValues.get(SpecicficRulestr) != '') {
                                    populateValue = MapOfPopUpValues.get(SpecicficRulestr);
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                    sObj.put(SpecicficRulestr,populateValue);
                                } else {
                                    tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                    sObj.put(SpecicficRulestr,'-');
                                }
                                tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                if(setFieldsToGet.contains(SpecicficRulestr)){
                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+populateValue+'.</u><br/><br/>';
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Override Master Value with value not on ignore list') {
                                string populateValue = '';
                                list<string> lstPopUpVal = new list<string>();
                                
                                if(MapOfPopUpValues.containsKey(SpecicficRulestr) && MapOfPopUpValues.get(SpecicficRulestr) != null && MapOfPopUpValues.get(SpecicficRulestr) != '') {
                                    populateValue = MapOfPopUpValues.get(SpecicficRulestr);
                                    lstPopUpVal = populateValue.split(',');
                                    for(sobject objClucterRecs : lstSpecificValReplaceMasterRec){
                                        integer popCount = 0;
                                        for(string pstr : lstPopUpVal){
                                            if(setFieldsToGet.contains(SpecicficRulestr) && objClucterRecs.get(SpecicficRulestr) == pstr){
                                                popCount = popCount + 1;
                                            }
                                        }    
                                        if(setFieldsToGet.contains(SpecicficRulestr) && popCount == 0 && objClucterRecs.get(SpecicficRulestr) != null && objClucterRecs.get(SpecicficRulestr) != ''){
                                           
                                            tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                            tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                            tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                            if(setFieldsToGet.contains(SpecicficRulestr)) {
                                                tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+objClucterRecs.get(SpecicficRulestr)+'.</u><br/><br/>';
                                                sObj.put(SpecicficRulestr,objClucterRecs.get(SpecicficRulestr));
                                            }
                                            break;
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
                                            if(setFieldsToGet.contains(SpecicficRulestr) && popVal == objClucterRecs.get(SpecicficRulestr)) {
                                              
                                                tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                                tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                                tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                                if(setFieldsToGet.contains(SpecicficRulestr)) {
                                                    tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+objClucterRecs.get(SpecicficRulestr)+'.</u><br/><br/>';
                                                    sObj.put(SpecicficRulestr,objClucterRecs.get(SpecicficRulestr));
                                                }
                                                popCount = popCount + 1;
                                                break;
                                            }
                                        }
                                        if(popCount > 0){
                                            break;
                                        }
                                    } 
                                }
                            } else if(MapOfString.get(SpecicficRulestr) == 'Field with max characters') {
                                String strFieldVal = '';
                                Integer highestValCount = 0;
                                
                                for(sobject objClucterRecs : lstSpecificValReplaceMasterRec) {
                                    if(setFieldsToGet.contains(SpecicficRulestr)) {
                                        strFieldVal = String.ValueOf(objClucterRecs.get(SpecicficRulestr));
                                        if(strFieldVal != null && strFieldVal.length() > highestValCount) {
                                            highestValCount = strFieldVal.length();
                                           
                                            tempNotesSpecific += '&nbsp;&nbsp;<b>Specific field name:</b> '+ SpecicficRulestr;
                                            tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Specific Field Value Rule:</b> '+ MapOfString.get(SpecicficRulestr);
                                            tempNotesSpecific += ',<br/>&nbsp;&nbsp;<b>Override type:</b> '+ tempNotesOverrideType;
                                            if(setFieldsToGet.contains(SpecicficRulestr)) {
                                                tempNotesSpecific += ',<br/>&nbsp;&nbsp;Changed <b>'+ SpecicficRulestr+'</b> from <u>'+lstMasterRecordDetails[0].get(SpecicficRulestr)+'</u> to <u>'+objClucterRecs.get(SpecicficRulestr)+'.</u><br/><br/>';
                                                sObj.put(SpecicficRulestr,objClucterRecs.get(SpecicficRulestr));
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
                
                String strNotesBody = '';
                strNotesBody += lstClusterRecs.Size()+ ' records were merged automatically by auto-merge with the confidence level of '+Integer.valueOf(objCluster.Confidence_Score__c)+'.';
                
                strNotesBody += '<br/><b>The master record id is:</b> '+sObj.Id+' <b>and the child record ids are:</b> '+ '<br/>';
                Integer Count = 1;
                for(SmartDD__Child_Cluster_Record__c childRecs : lstClusterRecs) {
                    if(childRecs.Id != sObj.Id) {
                        strNotesBody += Count+'. '+ childRecs.Id+ '<br/>';
                        Count = Count + 1;
                    }
                }
                strNotesBody += '<br/><b>We use the master record rule: </b>'+lstActiveMergeRule[0].SmartDD__Master_Record_Type__c;
                if(intLeastConfidenceScore != 0) {
                    strNotesBody += ' <b>with minimum confidence level of: </b>'+ intLeastConfidenceScore; 
                }
                if(lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != null && lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c != '') {
                    strNotesBody += '<b> ' + lstActiveMergeRule[0].SmartDD__Object_Field_API_Name__c + '</b>';
                }
                if(tempNotesSpecific != '') {
                    strNotesBody += '<br/><br/><b>Following is the specific rule descriptions: </b><br/>';
                    strNotesBody += tempNotesSpecific;
                }
                SmartDD__TempDedupeNote__c masterRecTempNotes = new SmartDD__TempDedupeNote__c();
                string ObjectLabel = ObjectNamePrm.removeEnd('__c');
                String objFldParentId = 'SmartDD__'+ObjectLabel+'ParentId__c';
                masterRecTempNotes.put(objFldParentId,sObj.Id); 
                masterRecTempNotes.SmartDD__Title__c = 'Note_'+String.valueof(Datetime.now());
                masterRecTempNotes.SmartDD__Body__c = strNotesBody; 
                masterRecTempNotes.SmartDD__MergeType__c = 'Auto';
                masterRecTempNotes.SmartDD__Object_Name__c = ObjectNamePrm;
                
                Boolean Title = Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__Title__c.isCreateable();
                Boolean Body = Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__Body__c.isCreateable();
                Boolean MergeType = Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__MergeType__c.isCreateable();
                Boolean ObjectName = Schema.sObjectType.SmartDD__TempDedupeNote__c.fields.SmartDD__Object_Name__c.isCreateable();
                
                if (Title && Body && MergeType && ObjectName){
                    insert masterRecTempNotes;
                }
                
                List<sObject> lstSObjIsMerged = new List<sObject>();//+
                sObject sObjIsMerged = Schema.getGlobalDescribe().get(ObjectNamePrm).newSObject();
                
                if(sObj.Id != null) {
                    // Storing the stringified master record to temp object to be merged in unique record page on click of save button
                    List<SmartDD__MergedRecordBackup__c>  lstObjMergedBackup = new List<SmartDD__MergedRecordBackup__c>(); //+
                    SmartDD__MergedRecordBackup__c objMergedBackup = new SmartDD__MergedRecordBackup__c();
                    objMergedBackup.SmartDD__Obj_Record_Id__c = sObj.Id;
                    objMergedBackup.SmartDD__StringifiedJsonRecord__c = JSON.serialize(sObj); //String.ValueOf(sObj);
                    objMergedBackup.SmartDD__Obj_ChildRecird_Id__c = strChildRecIds;
                    lstObjMergedBackup.add(objMergedBackup);
                    
                    if(lstObjMergedBackup.size() > 0 && Schema.sObjectType.SmartDD__MergedRecordBackup__c.isCreateable() ) {
                        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.CREATABLE, lstObjMergedBackup);     
                        Insert decision.getRecords();
                    } 
                    
                    sObjIsMerged.Id = sObj.Id;
                    sObjIsMerged.put('SmartDD__IsMerged__c',true);
                    sObjIsMerged.put('SmartDD__TempDedupeNotes__c',masterRecTempNotes.Id);
                    lstSObjIsMerged.add(sObjIsMerged);
                    if(lstSObjIsMerged.size() > 0 ) {
                        SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstSObjIsMerged);     
                        Update decision.getRecords();
                    }                    
                   
                }
                
                mapUniqueLeadRec.put(sObj.Id, sObj);
                
                List<SmartDD__Child_Cluster_Record__c> lstSelectedClusterChildRec = new List<SmartDD__Child_Cluster_Record__c>([Select Id, SmartDD__Cluster_Id__c, SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: objCluster.Id AND SmartDD__Cluster_Object_Id__c !=: strMergeRuleMasterRec AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterIdPrm WITH USER_MODE]);
                if(lstSelectedClusterChildRec.size() > 0)
                {
                   if(SmartDD__Child_Cluster_Record__c.sObjectType.getDescribe().isDeletable()) {
                    delete lstSelectedClusterChildRec;
                }
                }
            } else {
                List<SmartDD__Cluster__c> lstDeleteCluster = new List<SmartDD__Cluster__c>();
                lstDeleteCluster.add(objCluster);
                removeIgnoreGroup(objCluster.Id,ObjectNamePrm);
                
            }                                                                                      
        }
    }
    global void finish(Database.BatchableContext bc) {
        // Delete clusters with no child records.
        List<SmartDD__Cluster__c> lstDeleteBlankCluster = new List<SmartDD__Cluster__c>();
        lstDeleteBlankCluster = [SELECT Id FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterIdPrm AND SmartDD__Total_Child_Records__c < 1 WITH USER_MODE Limit 10000]; 
        Boolean clusterDeleteCheck = SmartDD__Cluster__c.sObjectType.getDescribe().isDeletable();
        if(lstDeleteBlankCluster.size() > 0 && clusterDeleteCheck) {
            delete lstDeleteBlankCluster;
        } 
    }
    public static void removeIgnoreGroup(string ignoreGroupId, String strObjectName) {
        /*fetch new Master Cluster Id From Custom Setting Manage Master Cluster Id*/
        String strNewMasterClusterId = '';
        Integer totalClusters = 0;
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = SmartDD__Manage_Master_Cluster_Id__c.getValues(strObjectName);
        if(objMasterClusterId.SmartDD__New_Master_Cluster_Id__c != null) {
           strNewMasterClusterId = objMasterClusterId.New_Master_Cluster_Id__c;
           totalClusters = Database.countQuery('SELECT count() FROM SmartDD__Cluster__c WHERE SmartDD__Master_Cluster_Record_Id__c =\''+strNewMasterClusterId+'\' WITH USER_MODE');
        }
        if(totalClusters == 0 && objMasterClusterId.SmartDD__Old_Master_Cluster_Id__c != null ) {
           strNewMasterClusterId = objMasterClusterId.SmartDD__Old_Master_Cluster_Id__c;
        }
        
        List<SmartDD__Cluster__c> lstAllClusterId = new List<SmartDD__Cluster__c>([SELECT Id FROM SmartDD__Cluster__c WHERE Id =:ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE]);  
        list<SmartDD__Child_Cluster_Record__c> lstNewChildClusterRec = new List<SmartDD__Child_Cluster_Record__c>();
        list<SmartDD__Cluster__c> lstNewClusterRec = new List<SmartDD__Cluster__c>();
        List<SmartDD__Child_Cluster_Record__c> IgnoreGrouplst = [SELECT Id, Name, SmartDD__Cluster_Id__c, SmartDD__MannualCluster__c,SmartDD__Cluster_Record_External_Id__c, SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        Set<Decimal> strExternalIds = new Set<Decimal>();
        for(SmartDD__Child_Cluster_Record__c clusterRec : IgnoreGrouplst ){
            SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
            objCluster.SmartDD__External_Cluster_Id__c = Decimal.valueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c);objCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;objCluster.SmartDD__Object_Name__c = strObjectName;
            
            strExternalIds.add(Decimal.valueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c));
            lstNewClusterRec.add(objCluster);  
        }
        
      
        if(lstNewClusterRec.size() > 0){
             if(Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isCreateable() &&  Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__Master_Cluster_Record_Id__c.isCreateable()){
                Insert lstNewClusterRec;
            }
        }
        
        List<SmartDD__Cluster__c> lstDeleteCluster = [SELECT Id FROM SmartDD__Cluster__c WHERE Id =: ignoreGroupId AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
       
        if(lstDeleteCluster.size() > 0 && SmartDD__Cluster__c.sObjectType.getDescribe().isDeletable()){
           Delete lstDeleteCluster;
        }
        
        List<SmartDD__Cluster__c> lstNewCluster = [SELECT Id, Name, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c, SmartDD__External_Cluster_Id__c FROM SmartDD__Cluster__c WHERE SmartDD__External_Cluster_Id__c IN:strExternalIds AND SmartDD__Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
        for(SmartDD__Cluster__c objnewCluster : lstNewCluster) {
            for(SmartDD__Child_Cluster_Record__c clusterRec : IgnoreGrouplst ){
                if(objnewCluster.SmartDD__External_Cluster_Id__c == Decimal.ValueOf(clusterRec.SmartDD__Cluster_Record_External_Id__c)) {
                    SmartDD__Child_Cluster_Record__c objChildCluster = new SmartDD__Child_Cluster_Record__c(); objChildCluster.SmartDD__MannualCluster__c = clusterRec.SmartDD__MannualCluster__c;
                    objChildCluster.SmartDD__Cluster_Record_External_Id__c = clusterRec.SmartDD__Cluster_Record_External_Id__c;objChildCluster.SmartDD__Cluster_Object_Id__c = clusterRec.SmartDD__Cluster_Object_Id__c; objChildCluster.SmartDD__Cluster_Id__c = objnewCluster.Id;objChildCluster.SmartDD__Master_Cluster_Record_Id__c = strNewMasterClusterId;objChildCluster.SmartDD__Object_Name__c = strObjectName;
                    lstNewChildClusterRec.add(objChildCluster);
                    if(Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__External_Cluster_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Cluster__c.fields.SmartDD__Cluster_Review_Status__c.isCreateable())
                    {
                        objnewCluster.SmartDD__External_Cluster_Id__c = null;objnewCluster.SmartDD__Cluster_Review_Status__c = 'Auto Reviewed';
                    }
                   
                }
            }
        }
        
       
        if(lstNewChildClusterRec.size() > 0){
            if(Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__MannualCluster__c.isCreateable() &&  Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Record_External_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Object_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Cluster_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Master_Cluster_Record_Id__c.isCreateable() && Schema.sObjectType.SmartDD__Child_Cluster_Record__c.fields.SmartDD__Object_Name__c.isCreateable()){
                    Insert lstNewChildClusterRec;
            }
        } 
        
       
        if(lstNewCluster.size() > 0){
            Update lstNewCluster;
        }
    }
}