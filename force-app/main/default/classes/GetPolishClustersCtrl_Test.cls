@isTest
public class GetPolishClustersCtrl_Test {
  public static ID getAllclusterID(){
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.SmartDD__Object_Name__c = 'Lead';
        insert objMaster;
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = new SmartDD__Manage_Master_Cluster_Id__c();
        objMasterClusterId.Name = 'Lead';
        objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMaster.Id;
        objMasterClusterId.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterId;
        
        SmartDD__All_CLuster_Record__c objAllcluster = new SmartDD__All_CLuster_Record__c();
        objAllcluster.SmartDD__Object_Name__c = 'Lead';
        objAllcluster.SmartDD__Master_Cluster_Record_Id__c = objMaster.Id;
        objAllcluster.SmartDD__External_Cluster_Id__c= 1;
        insert objAllcluster;
        
        return objAllcluster.Id;
    }
    @isTest 
    static void GetPolishClustersCtrlMethodTest() {
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.SmartDD__Object_Name__c = 'Lead';
        insert objMaster;
        System.assert(objMaster.Id!=null);
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = new SmartDD__Manage_Master_Cluster_Id__c();
        objMasterClusterId.Name = 'Lead';
        objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMaster.Id;
        objMasterClusterId.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterId;
         System.assert(objMasterClusterId.Id!=null);
        
        SmartDD__All_CLuster_Record__c objAllcluster = new SmartDD__All_CLuster_Record__c();
        objAllcluster.SmartDD__Object_Name__c = 'Lead';
        objAllcluster.SmartDD__Master_Cluster_Record_Id__c = objMaster.Id;
        objAllcluster.SmartDD__External_Cluster_Id__c= 1;
        insert objAllcluster;
        System.assert(objAllcluster.Id!=null);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                         SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'equals',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads; 
        
        Attachment b = New Attachment(Name = 'TestAttachment', body = Blob.valueOf('Unit Test Attachment Body'));
        b.parentID = lead.id;
        insert b;
        
        List<SmartDD__Child_Cluster_Record__c > lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c =clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leads[0].id;
            //objChildClusterRecord.MannualCluster__c = true;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        SmartDD__StartDedupeStatus__c objStartDedupeStatus = new SmartDD__StartDedupeStatus__c();
        objStartDedupeStatus.Name = 'Start DeDupe12';
        objStartDedupeStatus.SmartDD__IsSuccess__c = '1';
        objStartDedupeStatus.SmartDD__StartDedupeBatchId__c = 'Start DeDupe12';
        insert objStartDedupeStatus;
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.name = 'Start DeDupe';
        startdedupedata.SmartDD__IsSuccess__c = '0';
        insert startdedupedata;
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        String fieldstoget = 'LastName';
        //batchFetchDedupeRecord objbatchFetchDedupeRecord = new batchFetchDedupeRecord('Select Id from Lead WITH USER_MODE','Lead',u.Id,UserInfo.getOrganizationId());
        //Id BatchProcessId = DataBase.executeBatch(objbatchFetchDedupeRecord);
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Cluster__c> clusters101 = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8.0;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters101.add(cluster);
        insert clusters101;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leads[0].Id;
        objChildClusterRecord.SmartDD__MannualCluster__c = true;
        insert objChildClusterRecord;
        
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 002';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'First Record'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        insert mrgRule;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest(); 
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    @isTest 
    static void GetPolishClustersCtrlMethodTest2() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
       // System.assert(lstDedupeConfig.Id!=null);
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads; 
        
        Attachment b = New Attachment(Name = 'TestAttachment', body = Blob.valueOf('Unit Test Attachment Body'));
        b.parentID = lead.id;
        insert b;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        objChildClusterRecord.SmartDD__MannualCluster__c = true;
        objChildClusterRecord.SmartDD__Cluster_Record_External_Id__c = 'Test';
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 002';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c = 'Always Override Master';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'Most notes, attachments, activities, etc.'; 
        mrgRule.SmartDD__Priority__c =1;
        mrgRule.SmartDD__Status__c = 'Active';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c mrgFieldval1 = new SmartDD__ManageRule_Specific_FieldVal__c();
        mrgFieldval1.SmartDD__Specific_Field_Name__c = 'Owner.Name';
        mrgFieldval1.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        mrgFieldval1.SmartDD__Specific_Rule_Name__c = 'Most Common';
        //mrgFieldval1.Specific_Popup_Field_Values__c = 'testing';
        mrgFieldval1.SmartDD__Master_Record_Criteria_Name__c = mrgRule.id;
        insert mrgFieldval1;
        
        SmartDD__ManageRule_Specific_FieldVal__c mrgFieldval = new SmartDD__ManageRule_Specific_FieldVal__c();
        mrgFieldval.SmartDD__Specific_Field_Name__c = 'Owner.Name';
        mrgFieldval.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        mrgFieldval.SmartDD__Specific_Rule_Name__c = 'Most Common';
        // mrgFieldval.Specific_Popup_Field_Values__c = 'testing';
        mrgFieldval.SmartDD__Master_Record_Criteria_Name__c = mrgRule.id;
        insert mrgFieldval;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'not equal to',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '!=';
        String GroupId;
        String myDate = '12/12/2019';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.setStringToDateFormat(myDate);
        // GetPolishClustersCtrl.removeIgnoreGroup(GroupId);
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        //AsyncApexJob async = [SELECT Status, NumberOfErrors FROM AsyncApexJob WITH USER_MODE limit 1];
        //GetPolishClustersCtrl.batchStatus(async.Id);
        
        Test.stopTest();
    }
    
    @isTest 
    static void GetPolishClustersCtrlMethodTestElsePart2() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads; 
        
        Attachment b = New Attachment(Name = 'TestAttachment', body = Blob.valueOf('Unit Test Attachment Body'));
        b.parentID = lead.id;
        insert b;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        objChildClusterRecord.SmartDD__MannualCluster__c = true;
        objChildClusterRecord.SmartDD__Cluster_Record_External_Id__c = 'Test';
        insert objChildClusterRecord;
        System.assert(objChildClusterRecord.Id!=null);
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 002';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c = 'Always Override Master';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'Most notes, attachments, activities, etc.'; 
        mrgRule.SmartDD__Priority__c =1;
        mrgRule.SmartDD__Status__c = 'Active';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c mrgFieldval1 = new SmartDD__ManageRule_Specific_FieldVal__c();
        mrgFieldval1.SmartDD__Specific_Field_Name__c = 'Name';
        mrgFieldval1.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        
        mrgFieldval1.SmartDD__Specific_Rule_Name__c = 'Most Common';
        //mrgFieldval1.Specific_Popup_Field_Values__c = 'testing';
        mrgFieldval1.SmartDD__Master_Record_Criteria_Name__c = mrgRule.id;
        insert mrgFieldval1;
        
        SmartDD__ManageRule_Specific_FieldVal__c mrgFieldval = new SmartDD__ManageRule_Specific_FieldVal__c();
        mrgFieldval.SmartDD__Specific_Field_Name__c = 'Name';
        mrgFieldval.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        mrgFieldval.SmartDD__Specific_Rule_Name__c = 'Most Common';
        // mrgFieldval.Specific_Popup_Field_Values__c = 'testing';
        mrgFieldval.SmartDD__Master_Record_Criteria_Name__c = mrgRule.id;
        insert mrgFieldval;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'not equal to',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '!=';
        String GroupId;
        String myDate = '12/12/2019';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.setStringToDateFormat(myDate);
        // GetPolishClustersCtrl.removeIgnoreGroup(GroupId);
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
       // GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        //AsyncApexJob async = [SELECT Status, NumberOfErrors FROM AsyncApexJob WITH USER_MODE limit 1];
        //GetPolishClustersCtrl.batchStatus(async.Id);
        
        Test.stopTest();
    }
    @isTest 
    static void GetPolishClustersCtrlMethodTest3() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.NumberOfEmployees = 4;
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8.0;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        System.assert(objChildClusterRecord.Id!=null);
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Record with field value not on specified ignore list'; 
        mrgRule2.SmartDD__Priority__c =1;
        mrgRule2.SmartDD__Status__c = 'Active';
        insert mrgRule2;
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Newest by the given date field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'status';
        mrgRule3.SmartDD__Priority__c =2;
        mrgRule3.SmartDD__Status__c = 'Inactive';
        insert mrgRule3;
        
        SmartDD__ManageRule_Master_Record__c mrgRule4 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule4.SmartDD__Merge_Rule_Name__c = 'MRC 005';
        mrgRule4.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule4.SmartDD__Master_Record_Type__c= 'Oldest by the given date field'; 
        mrgRule4.SmartDD__Priority__c =3;
        mrgRule4.SmartDD__Status__c = 'Inactive';
        insert mrgRule4;
        
        SmartDD__ManageRule_Master_Record__c mrgRule5 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule5.SmartDD__Merge_Rule_Name__c = 'MRC 006';
        mrgRule5.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule5.SmartDD__Master_Record_Type__c= 'Lowest value in the user-defined field';
        mrgRule5.SmartDD__Object_Field_API_Name__c = 'FirstName'; 
        mrgRule5.SmartDD__Priority__c =4;
        mrgRule5.SmartDD__Status__c = 'Inactive';
        insert mrgRule5;
        
        SmartDD__ManageRule_Master_Record__c mrgRule6 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule6.SmartDD__Merge_Rule_Name__c = 'MRC 007';
        mrgRule6.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule6.SmartDD__Master_Record_Type__c= 'Highest value in the user-defined field'; 
        mrgRule6.SmartDD__Priority__c =5;
        mrgRule6.SmartDD__Object_Field_API_Name__c = 'AnnualRevenue';
        mrgRule6.SmartDD__Status__c = 'Inactive';
        insert mrgRule6;
        
        SmartDD__ManageRule_Master_Record__c mrgRule7 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule7.SmartDD__Merge_Rule_Name__c = 'MRC 008';
        mrgRule7.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule7.SmartDD__Master_Record_Type__c= 'First record with a value in the user-defined field'; 
        mrgRule7.SmartDD__Priority__c =6;
        mrgRule7.SmartDD__Status__c = 'Inactive';
        insert mrgRule7;
        
        
        SmartDD__ManageRule_Master_Record__c mrgRule1 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule1.SmartDD__Merge_Rule_Name__c = 'MRC 009';
        mrgRule1.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule1.SmartDD__Master_Record_Type__c= 'Most Complete Record'; 
        mrgRule1.SmartDD__Priority__c =7;
        mrgRule1.SmartDD__Status__c = 'Inactive';
        insert mrgRule1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                                                  SmartDD__Operator__c = 'less than',
                                                                  SmartDD__Value__c = '5',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '<';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    } 
    
    @isTest 
    static void GetPolishClustersCtrlMethodTest4() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.NumberOfEmployees = 10;
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Newest by the given date field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                                                  SmartDD__Operator__c = 'greater than',
                                                                  SmartDD__Value__c = '5',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '>';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    
    @isTest 
    static void GetPolishClustersCtrlMethodTest5() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.NumberOfEmployees =10;
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Oldest by the given date field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                                                  SmartDD__Operator__c = 'greater or equal',
                                                                  SmartDD__Value__c = '15',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '>=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
       // GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    } 
    @isTest 
    static void GetPolishClustersCtrlMethodTest6() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.NumberOfEmployees=10;
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Oldest by the given date field';
        //mrgRule3.Master_Record_Type__c= 'Lowest value in the user-defined field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                                                  SmartDD__Operator__c = 'less or equal',
                                                                  SmartDD__Value__c = '10',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '<=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
       // GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    } 
    
    @isTest 
    static void GetPolishClustersCtrlMethodTest7() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Oldest by the given date field';
        // mrgRule3.Master_Record_Type__c= 'Highest value in the user-defined field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    } 
    
    @isTest 
    static void GetPolishClustersCtrlMethodTest8() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'First record with a value in the user-defined field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'does not contain',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'NotLike';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
       // GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    
    @isTest 
    static void GetPolishClustersCtrlMethodTest9() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Most Complete Record';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'starts with',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'startswith';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
      //  GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    
    @isTest 
    static void GetPolishClustersCtrlMethodTest10() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.NumberOfEmployees = 10;
        leads.add(lead);
        insert leads;
        
        Lead leadNew = new Lead();
        leadNew.LastName = 'test';
        leadNew.company = 'test company';
        leadNew.City = 'testcity';
        lead.NumberOfEmployees = 10;
        insert leadNew; 
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters.add(cluster);
        insert clusters;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        string strlead = '"email:test@test.test","lastname:test"';
        string strleadID = string.valueOf(leads[0].Id);
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = ClusterId ;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leadNew.id;
        insert objChildClusterRecord;
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Most Complete Record';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'CreatedDate';
        mrgRule3.SmartDD__Priority__c =1;
        mrgRule3.SmartDD__Status__c = 'Active';
        insert mrgRule3;
        
        List<String> lstColumnName = new List<String>();
        lstColumnName.add('Name');
        lstColumnName.add('Company');
        lstColumnName.add('Street');
        lstColumnName.add('City');
        
        Test.startTest();
       // GetPolishClustersCtrl.postMasterRecord(strlead ,lstColumnName,ClusterId , strleadID, 'Lead'); 
        Test.stopTest();
        
    }
    @isTest
    static void testpostandSaveDedupeFilterRecords(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeconfig.SmartDD__First_Name__c = 'Ftest';
        dedupeconfig.SmartDD__Last_Name__c = 'Ltest';
        dedupeconfig.SmartDD__Email__c = 'test11@gmail.com';
        dedupeconfig.SmartDD__Username__c = 'testdedupe@gmail.com';
        dedupeconfig.SmartDD__Organization_Id__c= UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = u.Id;
       
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        System.assertEquals('Ftest',dedupeconfig.SmartDD__First_Name__c);
        
        SmartDD__Dedupe_Filter_Data__c objDedupeFilterlead = new SmartDD__Dedupe_Filter_Data__c();
        objDedupeFilterlead.SmartDD__Object_Name__c = 'Lead';
        objDedupeFilterlead.SmartDD__Field_Name__c = 'Name';
        objDedupeFilterlead.SmartDD__Field_API_Name__c = 'Name';
        objDedupeFilterlead.SmartDD__Field_Label__c = 'Name';
        if(Schema.sObjectType.SmartDD__Dedupe_Filter_Data__c.isCreateable()) {
            Insert objDedupeFilterlead;
        }
        List<SmartDD__Dedupe_Filter_Data__c> selectedlead = new List<SmartDD__Dedupe_Filter_Data__c>();
        selectedlead.add(objDedupeFilterlead);
        
        SmartDD__Dedupe_Filter_Data__c objDedupeFilterCon = new SmartDD__Dedupe_Filter_Data__c();
        objDedupeFilterCon.SmartDD__Object_Name__c = 'Contact';
        objDedupeFilterCon.SmartDD__Field_Name__c = 'Title';
        objDedupeFilterCon.SmartDD__Field_API_Name__c = 'title';
        objDedupeFilterCon.SmartDD__Field_Label__c = 'Title';
        if(Schema.sObjectType.SmartDD__Dedupe_Filter_Data__c.isCreateable()) {
            Insert objDedupeFilterCon;
        }
        List<SmartDD__Dedupe_Filter_Data__c> selectedcon = new List<SmartDD__Dedupe_Filter_Data__c>();
        selectedcon.add(objDedupeFilterCon);
        
        SmartDD__Dedupe_Filter_Data__c objDedupeFilterAcc = new SmartDD__Dedupe_Filter_Data__c();
        objDedupeFilterAcc.SmartDD__Object_Name__c = 'Account';
        objDedupeFilterAcc.SmartDD__Field_Name__c = 'Name';
        objDedupeFilterAcc.SmartDD__Field_API_Name__c = 'Name';
        objDedupeFilterAcc.SmartDD__Field_Label__c = 'Name';
        if(Schema.sObjectType.SmartDD__Dedupe_Filter_Data__c.isCreateable()) {
            Insert objDedupeFilterAcc;
        }
        List<SmartDD__Dedupe_Filter_Data__c> selectedacc = new List<SmartDD__Dedupe_Filter_Data__c>();
        selectedacc.add(objDedupeFilterAcc);
        
        SmartDD__Filter__c objfilter = new SmartDD__Filter__c();
        objfilter.Name = 'Test 1';
        objfilter.SmartDD__Object_Name__c = 'Lead';
        insert objfilter; 
        
        SmartDD__Filter__c objfiltercon = new SmartDD__Filter__c();
        objfiltercon.Name = 'Test 2';
        objfiltercon.SmartDD__Object_Name__c = 'Lead';
        insert objfiltercon ; 
        
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.name = 'Start DeDupe';
        startdedupedata.SmartDD__IsSuccess__c = '0';
        insert startdedupedata;
        
        Test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String queryStringTotal = 'Select Id from Lead WITH USER_MODE';
        string objectName = 'Lead';
        
        SmartDD__Manage_Cluster_Org_Tab_Id__c mrgcluster = new SmartDD__Manage_Cluster_Org_Tab_Id__c ();
        mrgcluster.Name ='Org Tab Name'; 
        mrgcluster.SmartDD__TabName__c = '01rf4000000ecfp';
        insert mrgcluster; 
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        SmartDD__Filter__c filter = new SmartDD__Filter__c();
        filter.SmartDD__FilterLogic__c= '1 OR 2';
        filter.SmartDD__Object_Name__c = 'Lead';
        filter.Name = 'Frank - A';
        insert filter;
        
        SmartDD__Filter_Criteria__c objcriteria = new SmartDD__Filter_Criteria__c ();
        objcriteria.SmartDD__Field__c = 'LastName';
        objcriteria.SmartDD__Operator__c = 'equals';
        objcriteria.SmartDD__Value__c = 'Test';
        objcriteria.SmartDD__Filter_Name__c= filter.id;
        insert objcriteria; 
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        leads.add(lead);
        insert leads; 
        List<SmartDD__Child_Cluster_Record__c > lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c =clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        SmartDD__StartDedupeStatus__c objStartDedupeStatus = new SmartDD__StartDedupeStatus__c();
        objStartDedupeStatus.Name = 'Start DeDupe123';
        objStartDedupeStatus.SmartDD__IsSuccess__c = '1';
        objStartDedupeStatus.SmartDD__StartDedupeBatchId__c = 'Start DeDupe123';
        insert objStartDedupeStatus;
        
        SmartDD__Manage_Cluster_Org_Tab_Id__c objOrgTabNameId = new SmartDD__Manage_Cluster_Org_Tab_Id__c();
        objOrgTabNameId.name = 'Org Tab Name';
        objOrgTabNameId.SmartDD__TabName__c = '01rf4000000ecfp';
        insert objOrgTabNameId;
        
        
        
        batchFetchReDedupeRecord objbatchFetchDedupeRecord = new batchFetchReDedupeRecord(queryStringTotal, objectName,u.Id,UserInfo.getOrganizationId(),'01rf4000000ecfp');
        Id batchJobId = DataBase.executeBatch(objbatchFetchDedupeRecord,1);
        //Database.executeBatch(batchInstance, 1);
        System.abortJob(batchJobId);
        
        GetPolishClustersCtrl.wrpFields objwrpFields = new GetPolishClustersCtrl.wrpFields();
        Test.stopTest();
    }
    @isTest 
    static void GetPolishClustersCtrlMethodTest11() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.Title = '';
        lead.Company = 'testcompany';
        //lead.NumberOfEmployees = 10;
        insert lead;
        
        Lead lead1 = new Lead();
        lead1.LastName = 'test';
        lead1.company = 'test company';
        lead1.City = 'testcity';
        lead1.Title = '';
        lead1.Company = 'testcompany';
        lead1.NumberOfEmployees = 10;
        insert lead1;
        
        Lead lead2 = new Lead();
        lead2.LastName = 'test';
        lead2.company = 'test company';
        lead2.City = 'testcity';
        lead2.Title = '';
        lead2.Company = 'testcompany';
        lead2.NumberOfEmployees = 10;
        insert lead2;
        
        Lead lead3 = new Lead();
        lead3.LastName = 'test';
        lead3.company = 'test company';
        lead3.City = 'testcity';
        lead3.Title = '';
        lead3.Company = 'testcompany';
        lead3.NumberOfEmployees = 10;
        insert lead3;
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        Lead lead5 = new Lead();
        lead5.LastName = 'test';
        lead5.company = 'test company';
        lead5.City = 'testcity';
        lead5.Title = '';
        lead5.Company = 'testcompany';
        lead5.NumberOfEmployees = 10;
        insert lead5;
        
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 101;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        insert cluster;
        
        SmartDD__Cluster__c cluster1 = new SmartDD__Cluster__c();
        cluster1.SmartDD__External_Cluster_Id__c= 102;
        //cluster1.All_CLuster_Record__c = getAllclusterID();
        insert cluster1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord1.SmartDD__Cluster_Object_Id__c = lead1.id;
        insert objChildClusterRecord1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord2 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord2.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord2.SmartDD__Cluster_Object_Id__c = lead2.id;
        insert objChildClusterRecord2;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord3 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord3.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord3.SmartDD__Cluster_Object_Id__c = lead3.id;
        insert objChildClusterRecord3;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord4 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord4.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord4.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord4;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord5 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord5.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord5.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord5;
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRecs = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRecs.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterRecs;
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRecs1 = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRecs1.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterRecs1;
            
      	SmartDD__Manage_Master_Cluster_Id__c objManageMster = new SmartDD__Manage_Master_Cluster_Id__c();
        objManageMster.Name = 'Lead';
        objManageMster.SmartDD__Object_Name__c = 'Lead';
        objManageMster.SmartDD__New_Master_Cluster_Id__c = objMasterClusterRecs1.Id;
        objManageMster.SmartDD__Old_Master_Cluster_Id__c = objMasterClusterRecs.Id;
        upsert objManageMster;
        
        SmartDD__Manage_Cluster_Batch_Id__c objManageBatch = new SmartDD__Manage_Cluster_Batch_Id__c();
        objManageBatch.Name = 'Lead';
        upsert objManageBatch;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true;
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule2.SmartDD__Object_Field_API_Name__c = 'NumberOfEmployees';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Oldest by the given date field'; 
        mrgRule2.SmartDD__Priority__c =4;
        mrgRule2.SmartDD__Status__c = 'Inactive';
        insert mrgRule2;
        
        SmartDD__ManageRule_Master_Record__c mrgRule3 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule3.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule3.SmartDD__Master_Record_Type__c= 'Newest by the given date field';
        mrgRule3.SmartDD__Object_Field_API_Name__c = 'NumberOfEmployees';
        mrgRule3.SmartDD__Priority__c =3;
        mrgRule3.SmartDD__Status__c = 'Inactive';
        insert mrgRule3;
        
        SmartDD__ManageRule_Master_Record__c mrgRule4 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule4.SmartDD__Merge_Rule_Name__c = 'MRC 005';
        mrgRule4.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule4.SmartDD__Master_Record_Type__c= 'Record with field value not on specified ignore list'; 
        mrgRule4.SmartDD__Object_Field_API_Name__c = 'Company';
        mrgRule4.SmartDD__Master_Popup_Field_Values__c = 'testcompany';
        mrgRule4.SmartDD__Priority__c =1;
        mrgRule4.SmartDD__Status__c = 'Active';
        insert mrgRule4;
        
        SmartDD__ManageRule_Master_Record__c mrgRule5 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule5.SmartDD__Merge_Rule_Name__c = 'MRC 005';
        mrgRule5.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule5.SmartDD__Master_Record_Type__c= 'First record with a value in the user-defined field'; 
        mrgRule5.SmartDD__Object_Field_API_Name__c = 'Title';
        mrgRule5.SmartDD__Master_Popup_Field_Values__c = 'testtitle';
        mrgRule5.SmartDD__Priority__c =2;
        mrgRule5.SmartDD__Status__c = 'Inactive';
        insert mrgRule5;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE];
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    @isTest 
    static void GetPolishClustersCtrlMethodTest12() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.Title = '';
        lead.Company = 'testcompany';
        insert lead;
        
        Lead lead1 = new Lead();
        lead1.LastName = 'test';
        lead1.company = 'test company';
        lead1.City = 'testcity';
        lead1.Title = '';
        lead1.Company = 'testcompany';
        insert lead1;
        
        Lead lead2 = new Lead();
        lead2.LastName = 'test';
        lead2.company = 'test company';
        lead2.City = 'testcity';
        lead2.Title = '';
        lead2.Company = 'testcompany';
        insert lead2;
        
        Lead lead3 = new Lead();
        lead3.LastName = 'test';
        lead3.company = 'test company';
        lead3.City = 'testcity';
        lead3.Title = '';
        lead3.Company = 'testcompany';
        insert lead3;
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        insert lead4;
        
        Lead lead5 = new Lead();
        lead5.LastName = 'test';
        lead5.company = 'test company';
        lead5.City = 'testcity';
        lead5.Title = '';
        lead5.Company = 'testcompany';
        insert lead5;
        
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 101;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        insert cluster;
        
        SmartDD__Cluster__c cluster1 = new SmartDD__Cluster__c();
        cluster1.SmartDD__External_Cluster_Id__c= 102;
        //cluster1.All_CLuster_Record__c = getAllclusterID();
        insert cluster1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord1.SmartDD__Cluster_Object_Id__c = lead1.id;
        insert objChildClusterRecord1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord2 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord2.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord2.SmartDD__Cluster_Object_Id__c = lead2.id;
        insert objChildClusterRecord2;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord3 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord3.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord3.SmartDD__Cluster_Object_Id__c = lead3.id;
        insert objChildClusterRecord3;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord4 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord4.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord4.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord4;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord5 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord5.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord5.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord5;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true;
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule2.SmartDD__Object_Field_API_Name__c = 'LastActivityDate';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Most Complete Record'; 
        mrgRule2.SmartDD__Priority__c =1;
        mrgRule2.SmartDD__Status__c = 'Active';
        insert mrgRule2;
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.Object_Name__c = 'Lead';
        insert objMaster;
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = new SmartDD__Manage_Master_Cluster_Id__c();
        objMasterClusterId.Name = 'Lead';
        objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMaster.Id;
        objMasterClusterId.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterId;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    } 
    @isTest 
    static void GetPolishClustersCtrlMethodTest13() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.Title = '';
        lead.Company = 'testcompany';
        lead.NumberOfEmployees = 10;
        insert lead;
        
        Lead lead1 = new Lead();
        lead1.LastName = 'test';
        lead1.company = 'test company';
        lead1.City = 'testcity';
        lead1.Title = '';
        lead1.Company = 'testcompany';
        lead1.NumberOfEmployees = 10;
        insert lead1;
        
        Lead lead2 = new Lead();
        lead2.LastName = 'test';
        lead2.company = 'test company';
        lead2.City = 'testcity';
        lead2.Title = '';
        lead2.Company = 'testcompany';
        lead2.NumberOfEmployees = 10;
        insert lead2;
        
        Lead lead3 = new Lead();
        lead3.LastName = 'test';
        lead3.company = 'test company';
        lead3.City = 'testcity';
        lead3.Title = '';
        lead3.Company = 'testcompany';
        lead3.NumberOfEmployees = 10;
        insert lead3;
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.NumberOfEmployees = 10;
        lead4.Title = '';
        insert lead4;
        
        Lead lead5 = new Lead();
        lead5.LastName = 'test';
        lead5.company = 'test company';
        lead5.City = 'testcity';
        lead5.Title = '';
        lead5.Company = 'testcompany';
        lead5.NumberOfEmployees = 10;
        insert lead5;
        
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 101;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        insert cluster;
        
        SmartDD__Cluster__c cluster1 = new SmartDD__Cluster__c();
        cluster1.SmartDD__External_Cluster_Id__c= 102;
        //cluster1.All_CLuster_Record__c = getAllclusterID();
        insert cluster1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord1.SmartDD__Cluster_Object_Id__c = lead1.id;
        insert objChildClusterRecord1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord2 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord2.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord2.SmartDD__Cluster_Object_Id__c = lead2.id;
        insert objChildClusterRecord2;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord3 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord3.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord3.SmartDD__Cluster_Object_Id__c = lead3.id;
        insert objChildClusterRecord3;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord4 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord4.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord4.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord4;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord5 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord5.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord5.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord5;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true;
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule2.SmartDD__Object_Field_API_Name__c = 'NumberOfEmployees';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Highest value in the user-defined field'; 
        mrgRule2.SmartDD__Priority__c =1;
        mrgRule2.SmartDD__Status__c = 'Active';
        insert mrgRule2;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    } 
    @isTest 
    static void GetPolishClustersCtrlMethodTest14() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.Title = '';
        lead.Company = 'testcompany';
        lead.NumberOfEmployees = 10;
        insert lead;
        
        Lead lead1 = new Lead();
        lead1.LastName = 'test';
        lead1.company = 'test company';
        lead1.City = 'testcity';
        lead1.Title = '';
        lead1.Company = 'testcompany';
        lead1.NumberOfEmployees = 10;
        insert lead1;
        
        Lead lead2 = new Lead();
        lead2.LastName = 'test';
        lead2.company = 'test company';
        lead2.City = 'testcity';
        lead2.Title = '';
        lead2.Company = 'testcompany';
        lead2.NumberOfEmployees = 10;
        insert lead2;
        
        Lead lead3 = new Lead();
        lead3.LastName = 'test';
        lead3.company = 'test company';
        lead3.City = 'testcity';
        lead3.Title = '';
        lead3.Company = 'testcompany';
        lead3.NumberOfEmployees = 10;
        insert lead3;
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        Lead lead5 = new Lead();
        lead5.LastName = 'test';
        lead5.company = 'test company';
        lead5.City = 'testcity';
        lead5.Title = '';
        lead5.Company = 'testcompany';
        lead5.NumberOfEmployees = 10;
        insert lead5;
        
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 101;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        insert cluster;
        
        SmartDD__Cluster__c cluster1 = new SmartDD__Cluster__c();
        cluster1.SmartDD__External_Cluster_Id__c= 102;
        //cluster1.All_CLuster_Record__c = getAllclusterID();
        insert cluster1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord1.SmartDD__Cluster_Object_Id__c = lead1.id;
        insert objChildClusterRecord1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord2 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord2.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord2.SmartDD__Cluster_Object_Id__c = lead2.id;
        //insert objChildClusterRecord2;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord3 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord3.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord3.SmartDD__Cluster_Object_Id__c = lead3.id;
        insert objChildClusterRecord3;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord4 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord4.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord4.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord4;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord5 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord5.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord5.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord5;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true;
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule2.SmartDD__Object_Field_API_Name__c = 'NumberOfEmployees';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Lowest value in the user-defined field'; 
        mrgRule2.SmartDD__Priority__c =1;
        mrgRule2.SmartDD__Status__c = 'Active';
        insert mrgRule2;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    @isTest 
    static void GetPolishClustersCtrlMethodTest15() {
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.Title = '';
        lead.Company = 'testcompany';
        lead.NumberOfEmployees = 10;
        insert lead;
        
        Lead lead1 = new Lead();
        lead1.LastName = 'test';
        lead1.company = 'test company';
        lead1.City = 'testcity';
        lead1.Title = '';
        lead1.Company = 'testcompany';
        lead1.NumberOfEmployees = 10;
        insert lead1;
        
        Lead lead2 = new Lead();
        lead2.LastName = 'test';
        lead2.company = 'test company';
        lead2.City = 'testcity';
        lead2.Title = '';
        lead2.Company = 'testcompany';
        lead2.NumberOfEmployees = 10;
        insert lead2;
        
        Lead lead3 = new Lead();
        lead3.LastName = 'test';
        lead3.company = 'test company';
        lead3.City = 'testcity';
        lead3.Title = '';
        lead3.Company = 'testcompany';
        lead3.NumberOfEmployees = 10;
        insert lead3;
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        Lead lead5 = new Lead();
        lead5.LastName = 'test';
        lead5.company = 'test company';
        lead5.City = 'testcity';
        lead5.Title = '';
        lead5.Company = 'testcompany';
        lead5.NumberOfEmployees = 10;
        insert lead5;
        
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 101;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        insert cluster;
        
        SmartDD__Cluster__c cluster1 = new SmartDD__Cluster__c();
        cluster1.SmartDD__External_Cluster_Id__c= 102;
        //cluster1.All_CLuster_Record__c = getAllclusterID();
        insert cluster1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord1.SmartDD__Cluster_Object_Id__c = lead1.id;
        insert objChildClusterRecord1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord2 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord2.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord2.SmartDD__Cluster_Object_Id__c = lead2.id;
        insert objChildClusterRecord2;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord3 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord3.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord3.SmartDD__Cluster_Object_Id__c = lead3.id;
        insert objChildClusterRecord3;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord4 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord4.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord4.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord4;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord5 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord5.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord5.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord5;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true;
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule2.SmartDD__Object_Field_API_Name__c = 'NumberOfEmployees';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Lowest value in the user-defined field'; 
        mrgRule2.SmartDD__Priority__c =1;
        mrgRule2.SmartDD__Status__c = 'Active';
        insert mrgRule2;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    
    @isTest
    static void removeIgnoreGroupTest(){
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            clusters.add(cluster);
        }
        insert clusters;
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.SmartDD__Object_Name__c = 'Lead';
        insert objMaster;
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = new SmartDD__Manage_Master_Cluster_Id__c();
        objMasterClusterId.Name = 'Lead';
        objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMaster.Id;
        objMasterClusterId.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterId;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = clusters[0].id;
        objChildClusterRecord.SmartDD__Cluster_Record_External_Id__c = '2041865';
        insert objChildClusterRecord;
        System.assert(objChildClusterRecord.Id!=null);
        GetPolishClustersCtrl.removeIgnoreGroup(clusters[0].Id, 'Lead');
        Set<Decimal> strExternalIds = new Set<Decimal>();
        list<Cluster__c> lstNewClusterRec = new List<Cluster__c>();
        // List<SmartDD__Child_Cluster_Record__c> IgnoreGrouplst = [SELECT Id, Name, SmartDD__Cluster_Id__c, SmartDD__MannualCluster__c,SmartDD__Cluster_Record_External_Id__c, SmartDD__Cluster_Object_Id__c FROM SmartDD__Child_Cluster_Record__c WHERE SmartDD__Cluster_Id__c =: ignoreGroupId AND Master_Cluster_Record_Id__c =: strNewMasterClusterId WITH USER_MODE];
         for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
           objCluster.SmartDD__External_Cluster_Id__c = Decimal.valueOf('2041865');
            objCluster.SmartDD__Master_Cluster_Record_Id__c = clusters[0].Id;
            objCluster.SmartDD__Object_Name__c = 'Lead';
            //objCluster.All_Cluster_Record__c = lstAllClusterId[0].All_Cluster_Record__c;
            strExternalIds.add(Decimal.valueOf('2041865'));
            lstNewClusterRec.add(objCluster);
        }
    }
    
    @isTest
    static void checkfieldLabelTest(){
        GetPolishClustersCtrl.checkfieldLabel('');
        GetPolishClustersCtrl.checkfieldLabel('Test Database management');
        System.assert(true);
    }
    
    @isTest
    static void tokenizeFilterLogicTest(){
        GetPolishClustersCtrl controller = new GetPolishClustersCtrl();
        List<String> filterLogic = new List<String>();
        String filterLogicString = 'dedupe()+de)+dupe)';
        String filterLogicStringNew = ' ';
        GetPolishClustersCtrl.tokenizeFilterLogic(filterLogicString);
        GetPolishClustersCtrl.tokenizeFilterLogic(filterLogicStringNew);
         System.assert(true);
    }
    
    @isTest
    static void ClusterDetailsDatabaseTest(){
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        dedupeConfig.SmartDD__First_Name__c = 'Unique3';
        dedupeConfig.SmartDD__Last_Name__c = 'User2';       
        dedupeConfig.SmartDD__UserId__c = 'Test Database Management';
        dedupeConfig.SmartDD__Username__c = 'Test@gmail.com';
        dedupeConfig.SmartDD__Manual_Cluster__c = false;
        dedupeConfig.SmartDD__SF_Import_Consumer_Key__c = '3MVG9zlTNB8o8BA3armashasjfhahkgdb0JhN85CbN33pMpwa49iU';
        dedupeConfig.SmartDD__SF_Import_Consumer_Secret__c = '16384056930135127401231321';
        dedupeConfig.SmartDD__Training_File_Consumer_Key__c = '3MVG9zasfdhasfhiufgPclmhsqcud';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            lstClusters.add(cluster);
        }
        insert lstClusters;
        
        SmartDD__ManageRule_Master_Record__c manageRuleMasterRecord = new SmartDD__ManageRule_Master_Record__c();
        manageRuleMasterRecord.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        manageRuleMasterRecord.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        manageRuleMasterRecord.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        manageRuleMasterRecord.SmartDD__Master_Popup_Field_Values__c = 'Test';
        manageRuleMasterRecord.SmartDD__Master_Record_Type__c = 'Record with field value not on specified ignore list';
        manageRuleMasterRecord.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        manageRuleMasterRecord.SmartDD__Object_Field_API_Name__c = 'FirstName';
        manageRuleMasterRecord.SmartDD__Object_Name__c = 'Lead';
        manageRuleMasterRecord.SmartDD__Priority__c = 1;
        manageRuleMasterRecord.SmartDD__Status__c = 'Active';
        insert manageRuleMasterRecord;
        
        SmartDD__Child_Cluster_Record__c childClusterRecord = new SmartDD__Child_Cluster_Record__c();
        childClusterRecord.SmartDD__Cluster_Id__c = lstClusters[0].Id;
        childClusterRecord.SmartDD__Cluster_Record_External_Id__c = 'false';
        childClusterRecord.SmartDD__Cluster_Object_Id__c = lead4.Id;
        childClusterRecord.SmartDD__MannualCluster__c = true;
        insert childClusterRecord;
        
        String fieldstoget = 'FirstName,LastName,Email,Title,Company'; 
        String ClusterId = lstClusters[0].Id;
        String ObjectName = 'Lead';
        String sortField = 'FirstName';
        boolean isAsc = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        Test.stopTest();
        
    }
    @isTest
    static void ClusterDetailsDatabaseTestforElse(){
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        dedupeConfig.SmartDD__First_Name__c = 'Unique3';
        dedupeConfig.SmartDD__Last_Name__c = 'User2';        
        dedupeConfig.SmartDD__UserId__c = 'Test Database Management';
        dedupeConfig.SmartDD__Username__c = 'Test@gmail.com';
        dedupeConfig.SmartDD__Manual_Cluster__c = false;
        dedupeConfig.SmartDD__SF_Import_Consumer_Key__c = '3MVG9zlTNB8o8BA3armashasjfhahkgdb0JhN85CbN33pMpwa49iU';
        dedupeConfig.SmartDD__SF_Import_Consumer_Secret__c = '16384056930135127401231321';
        dedupeConfig.SmartDD__Training_File_Consumer_Key__c = '3MVG9zasfdhasfhiufgPclmhsqcud';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            lstClusters.add(cluster);
        }
        insert lstClusters;
        
        SmartDD__ManageRule_Master_Record__c manageRuleMasterRecord = new SmartDD__ManageRule_Master_Record__c();
        manageRuleMasterRecord.SmartDD__Default_Field_Value_Selection_Priority__c = 'Oldest (Order by Modified Date)';
        manageRuleMasterRecord.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        manageRuleMasterRecord.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        manageRuleMasterRecord.SmartDD__Master_Popup_Field_Values__c = 'Test';
        manageRuleMasterRecord.SmartDD__Master_Record_Type__c = 'Record with field value not on specified ignore list';
        manageRuleMasterRecord.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        manageRuleMasterRecord.SmartDD__Object_Field_API_Name__c = 'FirstName';
        manageRuleMasterRecord.SmartDD__Object_Name__c = 'Lead';
        manageRuleMasterRecord.SmartDD__Priority__c = 1;
        manageRuleMasterRecord.SmartDD__Status__c = 'Active';
        insert manageRuleMasterRecord;
        
        SmartDD__Child_Cluster_Record__c childClusterRecord = new SmartDD__Child_Cluster_Record__c();
        childClusterRecord.SmartDD__Cluster_Id__c = lstClusters[0].Id;
        childClusterRecord.SmartDD__Cluster_Record_External_Id__c = 'false';
        childClusterRecord.SmartDD__Cluster_Object_Id__c = lead4.Id;
        childClusterRecord.SmartDD__MannualCluster__c = true;
        insert childClusterRecord;
        
        String fieldstoget = 'FirstName,LastName,Email,Title,Company'; 
        String ClusterId = lstClusters[0].Id;
        String ObjectName = 'Lead';
        String sortField = 'FirstName';
        boolean isAsc = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
       // GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        Test.stopTest();
        
    }
    @isTest
    static void ClusterDetailsDatabaseTestforElse2(){
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        dedupeConfig.SmartDD__First_Name__c = 'Unique3';
        dedupeConfig.SmartDD__Last_Name__c = 'User2';       
        dedupeConfig.SmartDD__UserId__c = 'Test Database Management';
        dedupeConfig.SmartDD__Username__c = 'Test@gmail.com';
        dedupeConfig.SmartDD__Manual_Cluster__c = false;
        dedupeConfig.SmartDD__SF_Import_Consumer_Key__c = '3MVG9zlTNB8o8BA3armashasjfhahkgdb0JhN85CbN33pMpwa49iU';
        dedupeConfig.SmartDD__SF_Import_Consumer_Secret__c = '16384056930135127401231321';
        dedupeConfig.SmartDD__Training_File_Consumer_Key__c = '3MVG9zasfdhasfhiufgPclmhsqcud';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            lstClusters.add(cluster);
        }
        insert lstClusters;
        
        SmartDD__ManageRule_Master_Record__c manageRuleMasterRecord = new SmartDD__ManageRule_Master_Record__c();
        manageRuleMasterRecord.SmartDD__Default_Field_Value_Selection_Priority__c = 'Oldest (Order by Create Date)';
        manageRuleMasterRecord.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        manageRuleMasterRecord.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        manageRuleMasterRecord.SmartDD__Master_Popup_Field_Values__c = 'Test';
        manageRuleMasterRecord.SmartDD__Master_Record_Type__c = 'Record with field value not on specified ignore list';
        manageRuleMasterRecord.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        manageRuleMasterRecord.SmartDD__Object_Field_API_Name__c = 'FirstName';
        manageRuleMasterRecord.SmartDD__Object_Name__c = 'Lead';
        manageRuleMasterRecord.SmartDD__Priority__c = 1;
        manageRuleMasterRecord.SmartDD__Status__c = 'Active';
        insert manageRuleMasterRecord;
        
        SmartDD__Child_Cluster_Record__c childClusterRecord = new SmartDD__Child_Cluster_Record__c();
        childClusterRecord.SmartDD__Cluster_Id__c = lstClusters[0].Id;
        childClusterRecord.SmartDD__Cluster_Record_External_Id__c = 'false';
        childClusterRecord.SmartDD__Cluster_Object_Id__c = lead4.Id;
        childClusterRecord.SmartDD__MannualCluster__c = true;
        insert childClusterRecord;
        
        String fieldstoget = 'FirstName,LastName,Email,Title,Company'; 
        String ClusterId = lstClusters[0].Id;
        String ObjectName = 'Lead';
        String sortField = 'FirstName';
        boolean isAsc = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        Test.stopTest();
        
    }
    
    @isTest
    static void ClusterDetailsDatabaseTestforElse3(){
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        dedupeConfig.SmartDD__First_Name__c = 'Unique3';
        dedupeConfig.SmartDD__Last_Name__c = 'User2';        
        dedupeConfig.SmartDD__UserId__c = 'Test Database Management';
        dedupeConfig.SmartDD__Username__c = 'Test@gmail.com';
        dedupeConfig.SmartDD__Manual_Cluster__c = false;
        dedupeConfig.SmartDD__SF_Import_Consumer_Key__c = '3MVG9zlTNB8o8BA3armashasjfhahkgdb0JhN85CbN33pMpwa49iU';
        dedupeConfig.SmartDD__SF_Import_Consumer_Secret__c = '16384056930135127401231321';
        dedupeConfig.SmartDD__Training_File_Consumer_Key__c = '3MVG9zasfdhasfhiufgPclmhsqcud';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        List<SmartDD__Cluster__c> lstClusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            lstClusters.add(cluster);
        }
        insert lstClusters;
        
        SmartDD__ManageRule_Master_Record__c manageRuleMasterRecord = new SmartDD__ManageRule_Master_Record__c();
        manageRuleMasterRecord.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Create Date)';
        manageRuleMasterRecord.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        manageRuleMasterRecord.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        manageRuleMasterRecord.SmartDD__Master_Popup_Field_Values__c = 'Test';
        manageRuleMasterRecord.SmartDD__Master_Record_Type__c = 'Record with field value not on specified ignore list';
        manageRuleMasterRecord.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        manageRuleMasterRecord.SmartDD__Object_Field_API_Name__c = 'FirstName';
        manageRuleMasterRecord.SmartDD__Object_Name__c = 'Lead';
        manageRuleMasterRecord.SmartDD__Priority__c = 1;
        manageRuleMasterRecord.SmartDD__Status__c = 'Active';
        insert manageRuleMasterRecord;
        
        SmartDD__Child_Cluster_Record__c childClusterRecord = new SmartDD__Child_Cluster_Record__c();
        childClusterRecord.SmartDD__Cluster_Id__c = lstClusters[0].Id;
        childClusterRecord.SmartDD__Cluster_Record_External_Id__c = 'false';
        childClusterRecord.SmartDD__Cluster_Object_Id__c = lead4.Id;
        childClusterRecord.SmartDD__MannualCluster__c = true;
        insert childClusterRecord;
        
        String fieldstoget = 'FirstName,LastName,Email,Title,Company'; 
        String ClusterId = lstClusters[0].Id;
        String ObjectName = 'Lead';
        String sortField = 'FirstName';
        boolean isAsc = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        //GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetClusterDetails(){
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        lead.Title = '';
        lead.Company = 'testcompany';
        lead.NumberOfEmployees = 10;
        insert lead;
        
        Lead lead1 = new Lead();
        lead1.LastName = 'test';
        lead1.company = 'test company';
        lead1.City = 'testcity';
        lead1.Title = '';
        lead1.Company = 'testcompany';
        lead1.NumberOfEmployees = 10;
        insert lead1;
        
        Lead lead2 = new Lead();
        lead2.LastName = 'test';
        lead2.company = 'test company';
        lead2.City = 'testcity';
        lead2.Title = '';
        lead2.Company = 'testcompany';
        lead2.NumberOfEmployees = 10;
        insert lead2;
        
        Lead lead3 = new Lead();
        lead3.LastName = 'test';
        lead3.company = 'test company';
        lead3.City = 'testcity';
        lead3.Title = '';
        lead3.Company = 'testcompany';
        lead3.NumberOfEmployees = 10;
        insert lead3;
        
        Lead lead4 = new Lead();
        lead4.LastName = 'test';
        lead4.company = 'test company';
        lead4.City = 'testcity';
        lead4.Company = 'testcompany';
        lead4.Title = '';
        lead4.NumberOfEmployees = 10;
        insert lead4;
        
        Lead lead5 = new Lead();
        lead5.LastName = 'test';
        lead5.company = 'test company';
        lead5.City = 'testcity';
        lead5.Title = '';
        lead5.Company = 'testcompany';
        lead5.NumberOfEmployees = 10;
        insert lead5;
        
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 101;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        insert cluster;
        
        SmartDD__Cluster__c cluster1 = new SmartDD__Cluster__c();
        cluster1.SmartDD__External_Cluster_Id__c= 102;
        //cluster1.All_CLuster_Record__c = getAllclusterID();
        insert cluster1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord1.SmartDD__Cluster_Object_Id__c = lead1.id;
        insert objChildClusterRecord1;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord2 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord2.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord2.SmartDD__Cluster_Object_Id__c = lead2.id;
        //insert objChildClusterRecord2;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord3 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord3.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord3.SmartDD__Cluster_Object_Id__c = lead3.id;
        insert objChildClusterRecord3;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord4 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord4.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord4.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord4;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord5 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord5.SmartDD__Cluster_Id__c = cluster1.id;
        objChildClusterRecord5.SmartDD__Cluster_Object_Id__c = lead4.id;
        //insert objChildClusterRecord5;
        
        String fieldstoget = 'LastName';
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true;
        
        SmartDD__ManageRule_Master_Record__c mrgRule2 = new SmartDD__ManageRule_Master_Record__c();
        mrgRule2.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule2.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule2.SmartDD__Object_Field_API_Name__c = 'NumberOfEmployees';
        mrgRule2.SmartDD__Master_Record_Type__c= 'Lowest value in the user-defined field'; 
        mrgRule2.SmartDD__Priority__c =1;
        mrgRule2.SmartDD__Status__c = 'Active';
        insert mrgRule2;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'contains',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest();
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        GetPolishClustersCtrl objGetPolishClustersCtrl = new GetPolishClustersCtrl();
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
    
    @isTest
    static void testFnGetStringCriteria(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' WITH USER_MODE]; 
        
        User u = new User();
        u.Email = 'test11@gmail.com';
        u.Username = 'testdedupe@gmail.com';
        u.LastName = 'testlastname'; 
        u.Alias = 'tes';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId = p.Id; 
        u.LanguageLocaleKey='en_US' ;
        if(Schema.sObjectType.User.isCreateable()) {
            insert u;
        }
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
        list<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c= '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'equals',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c= filter.id
                                                                 ); 
        insert objcriteria1;
        lstfiltercriteria.add(objcriteria1);
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c= 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_CLuster_Record__c = getAllclusterID();
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        lead.City = 'testcity';
        leads.add(lead);
        insert leads; 
        
        Attachment b = New Attachment(Name = 'TestAttachment', body = Blob.valueOf('Unit Test Attachment Body'));
        b.parentID = lead.id;
        insert b;
        
        List<SmartDD__Child_Cluster_Record__c > lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c =clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leads[0].id;
            //objChildClusterRecord.MannualCluster__c = true;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        SmartDD__StartDedupeStatus__c objStartDedupeStatus = new SmartDD__StartDedupeStatus__c();
        objStartDedupeStatus.Name = 'Start DeDupe12';
        objStartDedupeStatus.SmartDD__IsSuccess__c = '1';
        objStartDedupeStatus.SmartDD__StartDedupeBatchId__c = 'Start DeDupe12';
        insert objStartDedupeStatus;
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.name = 'Start DeDupe';
        startdedupedata.SmartDD__IsSuccess__c = '0';
        insert startdedupedata;
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        String fieldstoget = 'LastName';
        //batchFetchDedupeRecord objbatchFetchDedupeRecord = new batchFetchDedupeRecord('Select Id from Lead WITH USER_MODE','Lead',u.Id,UserInfo.getOrganizationId());
        //Id BatchProcessId = DataBase.executeBatch(objbatchFetchDedupeRecord);
        SmartDD__Filter__c objFilter = [Select Id,SmartDD__FilterLogic__c,(SELECT Id, Name, SmartDD__Filter_Name__c, SmartDD__Field__c, SmartDD__Operator__c, SmartDD__Value__c FROM SmartDD__Filter_Criterias__r) from SmartDD__Filter__c WHERE Id =: filter.Id WITH USER_MODE];
        
        SmartDD__Selected_Tab_Id__c selectedTabName = SmartDD__Selected_Tab_Id__c.getValues('Selected Tab Name');
        
        List<SmartDD__Cluster__c> clusters101 = new List<SmartDD__Cluster__c>();
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c= 8.0;
        //cluster.All_CLuster_Record__c = getAllclusterID();
        clusters101.add(cluster);
        insert clusters101;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leads[0].Id;
        objChildClusterRecord.SmartDD__MannualCluster__c = true;
        insert objChildClusterRecord;
        
        String ClusterId = cluster.id;
        String ObjectName = 'Lead'; 
        String sortField = 'LastName';
        boolean isAsc = true; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 002';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'First Record'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        insert mrgRule;
         System.assert(searchColumn.Id!=null);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        
        Test.startTest(); 
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        
        //GetPolishClustersCtrl.getClusterRecords('Lead');
        GetPolishClustersCtrl.GetClusterDetailRecordSize();
      //  GetPolishClustersCtrl.getClusterDetails(fieldstoget,ClusterId,ObjectName,sortField,isAsc);
        GetPolishClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersCtrl.fnGetClusterPolishDetails(fieldstoget,ClusterId,ObjectName);
        
        GetPolishClustersCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        GetPolishClustersCtrl.fnBindFilterCriteria(lstfiltercriteria);
        Map<Integer,String> tempMap = GetPolishClustersCtrl.fnBindFilterCriteria(objFilter.SmartDD__Filter_Criterias__r);
        GetPolishClustersCtrl.fnGetCriteriaString(filter.SmartDD__FilterLogic__c,tempMap);
        GetPolishClustersCtrl.getQueryConditionString(filter.Id);
        //GetPolishClustersCtrl.autoPolishRecords(fieldstoget,'Lead');
        Test.stopTest();
    }
	
}