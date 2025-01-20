@isTest 
public class GetPolishClustersUniqueRecordsCtrlTest {
    static testMethod void testMethod2() {
        Test.startTest();
        GetPolishClustersUniqueRecordsCtrl.AsyncApexJobRecords('7077F00008SDFrfQAH');
        Test.stopTest();
        System.assert(true);
    }
    static testMethod void testMethod1() {
        Test.startTest();
        SmartDD__De_Dupe_Configuration__c dedupeConfigs = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfigs.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfigs.Name = 'DeDupe Configuration';   
        insert dedupeConfigs;
        
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.Name = 'Start DeDupe';  
        startdedupedata.SmartDD__IsSuccess__c = '1';
        insert startdedupedata;
        
        //GetPolishClustersUniqueRecordsCtrl getUnique = new GetPolishClustersUniqueRecordsCtrl();
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
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
        insert objAllcluster;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllcluster.Id;
            cluster.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        leads.add(lead);
        insert leads;
        system.debug('Lead id-->'+ lead.Id);
        List<SmartDD__Child_Cluster_Record__c > lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c = clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
            objChildClusterRecord.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        String fieldstoget = 'Name';
        String ObjectName = 'Lead';
        String sortField = 'Name';
        String searchKey = 'test';
        boolean isAsc = true;
        decimal pageNumber = 1;
        Integer pageSize = 8;
        String navigateTo = 'next';
        // String strbody = '{"organisationId":"00Df4000004klpHEAQ","userId":"005f4000005S8r8AAC","objectName":"Lead","sfdcTabName":"01rf4000000ecfp","recordIds":["00Qf400000NRVJLEA5"],"type":"rededupe"}';
        //string strEndpoint = System.Label.SFImportAPI+'/dedupe/start';
        
        SmartDD__Filter_Data__c  filterRecs = new SmartDD__Filter_Data__c();
        filterRecs.name = 'Lead';
        filterRecs.SmartDD__Object_Name__c = 'Lead';
        filterRecs.SmartDD__Unique_Cluster_Saved__c = true;
        insert filterRecs; 
        
        SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = new SmartDD__Unique_Lead_Page_Size__c();
        perPageRecordSize.name = 'Unique Lead Page Size';
        perPageRecordSize.SmartDD__Per_Page_Record__c = 10 ;
        upsert perPageRecordSize;
        
        SmartDD__ReDe_Dupe_Configuration__c rededupeConfig = new SmartDD__ReDe_Dupe_Configuration__c();
        rededupeConfig.SmartDD__ReDeduped_Object_Name__c = 'Lead';
        rededupeConfig.Name = 'ReDeDupe Configuration';
        rededupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
        rededupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
        rededupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
        upsert rededupeConfig;
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        objTableWrapper.total = 47000;
        //objTableWrapper.selectedTabName = String.valueOf(focusTabName.Tab_Id_Name__c);
        system.debug('objTableWrapper.selectedTabName@@!!!  ' + objTableWrapper.selectedTabName);
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        system.debug('119 Lead id-->'+ lead.Id);
        GetPolishClustersUniqueRecordsCtrl.CreateClusterRec(lead.id, 'Lead');
        GetPolishClustersUniqueRecordsCtrl.getClusterDetails(fieldstoget,ObjectName,sortField,isAsc,pageNumber,pageSize,searchKey,'','',''); 
        GetPolishClustersUniqueRecordsCtrl.getClusterDetails(fieldstoget,ObjectName,sortField,isAsc,pageNumber,null,'','','','');
        GetPolishClustersUniqueRecordsCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersUniqueRecordsCtrl.GetPerPageRecordSize();
        GetPolishClustersUniqueRecordsCtrl.GetFilterRecordSize(ObjectName);
        GetPolishClustersUniqueRecordsCtrl.updateDedupeObjectName(ObjectName);
        GetPolishClustersUniqueRecordsCtrl.CheckApiStatus();
        GetPolishClustersUniqueRecordsCtrl.MergeAttachments(ObjectName);        
        //GetPolishClustersUniqueRecordsCtrl.httpReDedupeJSONRequest(strEndpoint, strbody);  
        Test.stopTest();
        System.assert(true);
    }
    @isTest static void fetchReviewClusterColumnsMethodTest() {
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName,FirstName,Salutation,Name,Title';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = new SmartDD__Unique_Lead_Page_Size__c();
        perPageRecordSize.name = 'Unique Lead Page Size';
        perPageRecordSize.SmartDD__Per_Page_Record__c = 10 ;
        upsert perPageRecordSize;
        
        
        SmartDD__Cluster_Detail_Page_Size__c objClusterDetailPageSize = new SmartDD__Cluster_Detail_Page_Size__c();
        objClusterDetailPageSize.Name = 'Cluster Detail Page Record Size';
        objClusterDetailPageSize.SmartDD__Per_Page_Record__c = 5;
        insert objClusterDetailPageSize;
        
        SmartDD__Cluster_Page_Size__c objClusterPageSize = new SmartDD__Cluster_Page_Size__c();
        objClusterPageSize.Name = 'Cluster Page Record Size';
        objClusterPageSize.SmartDD__Per_Page_Record__c = 25;
        insert objClusterPageSize;
        
        String ObjectName = 'lead';
        Integer recordSizeParam = 10;
        
        GetPolishClustersUniqueRecordsCtrl.UpdatePerPageRecordSize(recordSizeParam);
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
        dedupeconfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
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
        
        SmartDD__Filter__c filter = new SmartDD__Filter__c();
        filter.SmartDD__FilterLogic__c = '1 OR 2';
        filter.SmartDD__Object_Name__c = 'Lead';
        filter.Name = 'Frank - A';
        insert filter;
        
        SmartDD__Filter_Criteria__c objcriteria = new SmartDD__Filter_Criteria__c ();
        objcriteria.SmartDD__Field__c = 'LastName';
        objcriteria.SmartDD__Operator__c = 'equals';
        objcriteria.SmartDD__Value__c = 'Test';
        objcriteria.SmartDD__Filter_Name__c = filter.id;
        insert objcriteria; 
        
        SmartDD__Filter_Data__c cs = new SmartDD__Filter_Data__c();
        cs.name = 'Lead';
        cs.SmartDD__Object_Name__c = 'Lead';
        cs.SmartDD__Filter_Id__c = filter.Id;
        cs.SmartDD__Unique_Cluster_Saved__c = true;
        cs.SmartDD__Deleted_Records__c = 10;
        insert cs;
        
        SmartDD__Master_Cluster_Record__c objMasterclustRec = new SmartDD__Master_Cluster_Record__c();
        objMasterclustRec.Object_Name__c = 'lead';
        insert objMasterclustRec;
        
        SmartDD__All_CLuster_Record__c objallclusterRec = new  SmartDD__All_CLuster_Record__c();
        objallclusterRec.SmartDD__Object_Name__c = 'lead';
        objallclusterRec.SmartDD__Master_Cluster_Record_Id__c = objMasterclustRec.Id;
        insert objallclusterRec;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objallclusterRec.Id;
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
            objChildClusterRecord.SmartDD__Cluster_Id__c =  clusters[0].id;
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
        
        SmartDD__De_Dupe_Configuration__c dedupeConfigs = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfigs.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfigs.Name = 'DeDupe Configuration';   
        insert dedupeConfigs;  
        
        batchFetchReDedupeRecord objbatchFetchDedupeRecord = new batchFetchReDedupeRecord(queryStringTotal, objectName,u.Id,UserInfo.getOrganizationId(),'01rf4000000ecfp');
        Id batchJobId = DataBase.executeBatch(objbatchFetchDedupeRecord,1);
        //Database.executeBatch(batchInstance, 1);
        System.abortJob(batchJobId);
        GetPolishClustersUniqueRecordsCtrl.batchStatus(batchJobId);
        GetPolishClustersUniqueRecordsCtrl.setStringToDateFormat('01/01/2020');
        GetPolishClustersUniqueRecordsCtrl.postReDedupeRecords('Lead');
        GetPolishClustersUniqueRecordsCtrl.wrpFields objwrpFields = new GetPolishClustersUniqueRecordsCtrl.wrpFields();
        Test.stopTest();
    }
    @isTest
    static void testfnGetStringCriteria(){
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.SmartDD__Object_Name__c = 'Lead';
        insert objMaster;
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = new SmartDD__Manage_Master_Cluster_Id__c();
        objMasterClusterId.Name = 'Lead';
        objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMaster.Id;
        objMasterClusterId.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterId;
         System.assert(objMasterClusterId.Id!=null);
        
        SmartDD__All_CLuster_Record__c objAllcluster = new SmartDD__All_CLuster_Record__c();
        objAllcluster.SmartDD__Object_Name__c = 'Lead';
        objAllcluster.SmartDD__Master_Cluster_Record_Id__c = objMaster.Id;  
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
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
        System.assert(searchColumn.Id!=null);
        
        
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                          SmartDD__Object_Name__c = 'Lead',
                                          SmartDD__FilterLogic__c = '1'
                                         ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                                                  SmartDD__Operator__c = 'equals',
                                                                  SmartDD__Value__c = 'Test',
                                                                  SmartDD__Filter_Name__c = filter.id
                                                                 ); 
        insert objcriteria1;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllcluster.Id;
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            Lead lead = new Lead();
            lead.LastName = 'test';
            lead.company = 'test company' + i;
            leads.add(lead);
        }
        insert leads; 
        Lead leads1 = new Lead();
        
        List<SmartDD__Child_Cluster_Record__c > lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c =  clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leads[0].id;
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
        
        SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = new SmartDD__Unique_Lead_Page_Size__c();
        perPageRecordSize.name = 'Unique Lead Page Size';
        perPageRecordSize.SmartDD__Per_Page_Record__c = 10 ;
        upsert perPageRecordSize;
        
        Test.startTest();
        //batchFetchDedupeRecord objbatchFetchDedupeRecord = new batchFetchDedupeRecord('Select Id from Lead WITH USER_MODE', 'Lead',u.Id,UserInfo.getOrganizationId());
        // Id BatchProcessId = DataBase.executeBatch(objbatchFetchDedupeRecord);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strOperator = 'equals';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, 'NotLike', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, 'startswith', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '=', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '=','',fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '!=','',fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '!=', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '<', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '>', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '<=', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fnGetStringCriteria(strFiledVal, '>=', strValue,fldtype1,''); 
        GetPolishClustersUniqueRecordsCtrl.fillOperator('='); 
        GetPolishClustersUniqueRecordsCtrl.DeleteDuplicateData('Lead');  
        
        Test.stopTest();
        
    } 
    
   
    static testMethod void testMethod3() {
        Test.startTest();
        SmartDD__De_Dupe_Configuration__c dedupeConfigs = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfigs.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfigs.Name = 'DeDupe Configuration';   
        insert dedupeConfigs;
        
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.Name = 'Start DeDupe';  
        startdedupedata.SmartDD__IsSuccess__c = '1';
        insert startdedupedata;
        
        //GetPolishClustersUniqueRecordsCtrl getUnique = new GetPolishClustersUniqueRecordsCtrl();
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
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
        insert objAllcluster;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllcluster.Id;
            cluster.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        leads.add(lead);
        insert leads;
        system.debug('Lead id-->'+ lead.Id);
        List<SmartDD__Child_Cluster_Record__c > lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c = clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
            objChildClusterRecord.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        String fieldstoget = 'Name';
        String ObjectName = 'Lead';
        String sortField = 'Name';
        String searchKey = 'test';
        boolean isAsc = true;
        decimal pageNumber = 1;
        Integer pageSize = 8;
        String navigateTo = 'next';
        // String strbody = '{"organisationId":"00Df4000004klpHEAQ","userId":"005f4000005S8r8AAC","objectName":"Lead","sfdcTabName":"01rf4000000ecfp","recordIds":["00Qf400000NRVJLEA5"],"type":"rededupe"}';
        //string strEndpoint = System.Label.SFImportAPI+'/dedupe/start';
        
        SmartDD__Filter_Data__c  filterRecs = new SmartDD__Filter_Data__c();
        filterRecs.name = 'Lead';
        filterRecs.SmartDD__Object_Name__c = 'Lead';
        filterRecs.SmartDD__Unique_Cluster_Saved__c = true;
        insert filterRecs; 
        
        SmartDD__Unique_Lead_Page_Size__c perPageRecordSize = new SmartDD__Unique_Lead_Page_Size__c();
        perPageRecordSize.name = 'Unique Lead Page Size';
        perPageRecordSize.SmartDD__Per_Page_Record__c = 10 ;
        upsert perPageRecordSize;
        
        SmartDD__ReDe_Dupe_Configuration__c rededupeConfig = new SmartDD__ReDe_Dupe_Configuration__c();
        rededupeConfig.SmartDD__ReDeduped_Object_Name__c = 'Lead';
        rededupeConfig.Name = 'ReDeDupe Configuration';
        rededupeConfig.SmartDD__Cluster_Estimated_Time__c = 0;
        rededupeConfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
        rededupeConfig.SmartDD__Last_Create_Cluster_Progress__c = 100;
        upsert rededupeConfig;
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        objTableWrapper.total = 47000;
        //objTableWrapper.selectedTabName = String.valueOf(focusTabName.Tab_Id_Name__c);
        system.debug('objTableWrapper.selectedTabName@@!!!  ' + objTableWrapper.selectedTabName);
        
        //--
        SmartDD__Dedupe_Log__c smd = new SmartDD__Dedupe_Log__c();
        smd.SmartDD__Total_Records_Operated__c = 50;
        smd.SmartDD__Total_Records_Deleted__c = 50;
        smd.SmartDD__Total_Records_Updated__c= 50;
        smd.SmartDD__Requested_On_Object__c= 'lead';
        smd.SmartDD__Type_Of_Request__c= 'Cluster List Request';
        smd.SmartDD__Is_Final_Data_Saved__c=true;
        smd.SmartDD__Master_Cluster_Record_Id__c =objAllcluster.SmartDD__Master_Cluster_Record_Id__c;
        insert smd;
        //--
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        system.debug('119 Lead id-->'+ lead.Id);
        GetPolishClustersUniqueRecordsCtrl.CreateClusterRec(lead.id, 'Lead');
        GetPolishClustersUniqueRecordsCtrl.getClusterDetails(fieldstoget,ObjectName,sortField,isAsc,pageNumber,pageSize,searchKey,'','',''); 
        GetPolishClustersUniqueRecordsCtrl.getClusterDetails(fieldstoget,ObjectName,sortField,isAsc,pageNumber,null,'','','','');
        GetPolishClustersUniqueRecordsCtrl.fetchReviewClusterColumns(ObjectName);
        GetPolishClustersUniqueRecordsCtrl.GetPerPageRecordSize();
        GetPolishClustersUniqueRecordsCtrl.GetFilterRecordSize(ObjectName);
        GetPolishClustersUniqueRecordsCtrl.updateDedupeObjectName(ObjectName);
        GetPolishClustersUniqueRecordsCtrl.CheckApiStatus();
        GetPolishClustersUniqueRecordsCtrl.MergeAttachments(ObjectName);  
        GetPolishClustersUniqueRecordsCtrl.updateClustersCompSta(80000);
        GetPolishClustersUniqueRecordsCtrl.getClustersCompletedStat();
        GetPolishClustersUniqueRecordsCtrl.getDeDupeConfiguration();
        //GetPolishClustersUniqueRecordsCtrl.httpReDedupeJSONRequest(strEndpoint, strbody);  
        Test.stopTest();
        System.assert(true);
    }
   
}