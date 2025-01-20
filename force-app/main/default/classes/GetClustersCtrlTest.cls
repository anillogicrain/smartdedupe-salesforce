@isTest
private class GetClustersCtrlTest {
    @isTest static void GetClustersCtrlMethodTest() {
        
        SmartDD__De_Dupe_Configuration__c dedupeConfigs = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfigs.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfigs.Name = 'DeDupe Configuration'; 
        dedupeConfigs.SmartDD__Lead__c = true;
        insert dedupeConfigs;
         System.assert(dedupeConfigs.Id!=null);
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0V7F00000eXlymUAC';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0V7F00000eXlZdUAK';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
         System.assert(MasterCluster1.Id!=null);
        
        SmartDD__Master_Cluster_Record__c MasterClusterRecordLead = new SmartDD__Master_Cluster_Record__c();
        MasterClusterRecordLead.SmartDD__Object_Name__c = 'Lead';
        insert MasterClusterRecordLead;
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        MasterCluster.SmartDD__Old_Master_Cluster_Id__c = MasterCluster.SmartDD__New_Master_Cluster_Id__c;
        update MasterCluster;
        SmartDD__Master_Cluster_Record__c MasterClusterRecord = new SmartDD__Master_Cluster_Record__c();
        MasterClusterRecord.SmartDD__Object_Name__c = 'Lead';
        insert MasterClusterRecord;
        SmartDD__Manage_Master_Cluster_Id__c MasterClusterNew = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        MasterClusterNew.SmartDD__New_Master_Cluster_Id__c = MasterClusterRecord.Id;
        update MasterClusterNew;
        SmartDD__Manage_Master_Cluster_Id__c MasterClusterLatest = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        
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
        
        SmartDD__All_CLuster_Record__c objAllcluster = new SmartDD__All_CLuster_Record__c();
        objAllcluster.SmartDD__Object_Name__c = 'Lead';
        objAllcluster.SmartDD__Master_Cluster_Record_Id__c = MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c;  
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
        insert objAllcluster;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllcluster.id;
            cluster.SmartDD__Master_Cluster_Record_Id__c = MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c;
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
            objChildClusterRecord.SmartDD__Cluster_Id__c = clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
                
        String ClusterId = clusters[0].id;
        String fieldstoget = 'Name';
        String ObjectName = 'Lead';
        String sortField = 'Name';
        String searchKey = 'test';
        boolean isAsc = true;
        decimal pageNumber = 1;
        Integer pageSize = 8;
        String navigateTo = 'next';
        
        SmartDD__Selected_Tab_Id__c focusTabName = new SmartDD__Selected_Tab_Id__c();
        focusTabName.Name = 'Selected Tab Name';
        focusTabName.SmartDD__Tab_Id_Name__c= 'uniqueLeadTab';
        insert focusTabName;
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        String nextClusterName = clusters[0].Name;
        List<SmartDD__Cluster__c> lstNextClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Name =: nextClusterName WITH USER_MODE];
        
        SmartDD__Dedupe_Log__c objDebugLog = new SmartDD__Dedupe_Log__c();
        objDebugLog.SmartDD__Requested_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        objDebugLog.SmartDD__Time_Of_Request__c = Datetime.now();
        objDebugLog.SmartDD__Type_Of_Request__c = 'Cluster List Request';
        if(Schema.sObjectType.SmartDD__Dedupe_Log__c.isCreateable()) {
            insert objDebugLog;
        }
        
        Test.startTest();
        GetClustersCtrl objGetClustersCtrl = new GetClustersCtrl();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator()); 
        GetClustersCtrl.navigateClusterChildRecs(navigateTo,ClusterId); 
        GetClustersCtrl.postClusterChildRecs(lstchildrec[0].id, clusters[0].Id , 2, 10,'Lead');
        GetClustersCtrl.getClusterRecords();
        GetClustersCtrl.getClusterDetails(ClusterId,fieldstoget,ObjectName,sortField,searchKey,isAsc,pageNumber,pageSize);
        GetClustersCtrl.fetchClusters(pageNumber,pageSize,sortField,isAsc,'Lead');
        GetClustersCtrl.GetClusterDetailRecordSize();
        GetClustersCtrl.GetPerPageRecordSize();
        GetClustersCtrl.AsyncApexJobRecords();
       // GetClustersCtrl.rededupeBatchStatus();
        //GetClustersCtrl.autoReviewAllClusters('Lead');
        GetClustersCtrl.checkClusterStat(); 
        GetClustersCtrl.getSyncedObjList();
        GetClustersCtrl.deDupeObjectName();        
        Test.stopTest();
    }
    @isTest static void removeIgnoreGroupTest() {
        SmartDD__De_Dupe_Configuration__c dedupeConfigs1 = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfigs1.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfigs1.Name = 'DeDupe Configuration';  
        dedupeConfigs1.SmartDD__Account__c = true;
        insert dedupeConfigs1;
         System.assert(dedupeConfigs1.Id!=null);
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
         //System.assert(lstDedupeConfig.Id!=null);
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
         System.assert(searchColumn.Id!=null);
        
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
            //cluster.All_Cluster_Record__c = objAllcluster.id;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            clusters.add(cluster);
        }
        insert clusters;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        leads.add(lead);
        insert leads;
        List<SmartDD__Child_Cluster_Record__c> lstchildrec = new List<SmartDD__Child_Cluster_Record__c>();
        
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c = clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
            objChildClusterRecord.SmartDD__Cluster_Record_External_Id__c = '18250185';
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        GetClustersCtrl.getSyncedObjList();
        Test.startTest();
        GetClustersCtrl objGetClustersCtrl = new GetClustersCtrl();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        GetClustersCtrl.removeIgnoreGroup(lstchildrec[0].SmartDD__Cluster_Id__c,'Lead');
        Test.stopTest();
    }
    @isTest static void GetClustersCtrlMethodTest1() {
        SmartDD__De_Dupe_Configuration__c dedupeConfigs2 = new SmartDD__De_Dupe_Configuration__c();
        dedupeConfigs2.SmartDD__Sync_Object_Name__c = 'Lead';
        dedupeConfigs2.SmartDD__DeDupe_Object_Name__c = 'Lead';
        dedupeConfigs2.Name = 'DeDupe Configuration';  
        dedupeConfigs2.SmartDD__Contact__c = true;
        insert dedupeConfigs2;
        System.assert(dedupeConfigs2.Id!=null);
        
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
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.SmartDD__Object_Name__c = 'Lead';
        insert objMaster;        
               
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0V7F00000eXlymUAC';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0V7F00000eXlZdUAK';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__All_CLuster_Record__c objAllcluster = new SmartDD__All_CLuster_Record__c();
        objAllcluster.SmartDD__Object_Name__c = 'Lead';
        objAllcluster.SmartDD__Master_Cluster_Record_Id__c = objMaster.Id;  
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
        insert objAllcluster;
        System.assert(objAllcluster.Id!=null);
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            //cluster.All_Cluster_Record__c = objAllcluster.id;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            cluster.SmartDD__Master_Cluster_Record_Id__c = MasterCluster1.SmartDD__New_Master_Cluster_Id__c;
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
        
        String ClusterId = clusters[0].id;
        String fieldstoget = 'Name';
        String ObjectName = 'Lead';
        String sortField = 'Name';
        String searchKey = '';
        boolean isAsc = false;
        decimal pageNumber = 1;
        Integer pageSize = 8;
        String navigateTo = 'next';
        
        
        SmartDD__Selected_Tab_Id__c focusTabName = new SmartDD__Selected_Tab_Id__c();
        focusTabName.Name = 'Selected Tab Name';
        focusTabName.SmartDD__Tab_Id_Name__c= 'uniqueLeadTab';
        insert focusTabName;
                 
        SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
        cluster.SmartDD__External_Cluster_Id__c = 8;
        //cluster.All_Cluster_Record__c = objAllcluster.id;
        cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
        cluster.SmartDD__Master_Cluster_Record_Id__c = MasterCluster1.SmartDD__New_Master_Cluster_Id__c;
        insert cluster;
       
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Object_Name__c = 'Lead';
        objChildClusterRecord.SmartDD__Cluster_Id__c = cluster.id;
        insert objChildClusterRecord;
        
        SmartDD__Dedupe_Log__c objdedupelog = new SmartDD__Dedupe_Log__c();
        objdedupelog.SmartDD__Master_Cluster_Record_Id__c = MasterCluster1.SmartDD__New_Master_Cluster_Id__c;
        objdedupelog.SmartDD__Type_Of_Request__c = 'Cluster List Request';
       	insert objdedupelog;
        
        SmartDD__ReDe_Dupe_Configuration__c objrededupeConfig = new SmartDD__ReDe_Dupe_Configuration__c();
        objrededupeConfig.Name = 'ReDeDupe Configuration';
        objrededupeConfig.SmartDD__ReDeduped_Object_Name__c = 'Lead';
        objrededupeConfig.SmartDD__Start_Dedupe_Batch_Id__c = '';
        Insert objrededupeConfig;
        
        
        /*Dedupe_SaveYourData_Log__c objdedupesavedatalog = new Dedupe_SaveYourData_Log__c();
        objdedupesavedatalog.Dedupe_Log__c = objdedupelog.Id;
        objdedupesavedatalog.Save_Record_Status__c = 'Duplicate Records';
        objdedupesavedatalog.Records_Operated__c = cluster.Total_Child_Records__c;
        insert objdedupelog;*/
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        //objTableWrapper.selectedTabName = String.valueOf(focusTabName.Tab_Id_Name__c);
        String nextClusterName = clusters[0].Name;
        List<SmartDD__Cluster__c> lstNextClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Name =: nextClusterName WITH USER_MODE];
        
        Test.startTest();
        GetClustersCtrl objGetClustersCtrl = new GetClustersCtrl();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        //GetClustersCtrl.postClusterChildRecs(objChildClusterRecord.id, cluster.Id , 2, 10,'Lead'); 
        GetClustersCtrl.getClusterDetails(ClusterId,fieldstoget,ObjectName,sortField,searchKey,isAsc,pageNumber,pageSize);
        GetClustersCtrl.fetchClusters(pageNumber,pageSize,sortField,isAsc,'Lead');
        //GetClustersCtrl.navigateClusterChildRecs(navigateTo,clusters[0].d);
        GetClustersCtrl.GetSelectedTabName();
        GetClustersCtrl.getSyncedObjList();
        GetClustersCtrl.updateprocessStatus('Lead');
        GetClustersCtrl.updateDedupeObjectName(ObjectName);
        GetClustersCtrl.UpdateSelectedTabName(focusTabName.name);
        Test.stopTest();
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
        
        SmartDD__Cluster_Detail_Page_Size__c objClusterDetailPageSize = new SmartDD__Cluster_Detail_Page_Size__c();
        objClusterDetailPageSize.Name = 'Cluster Detail Page Record Size';
        objClusterDetailPageSize.SmartDD__Per_Page_Record__c = 5;
        insert objClusterDetailPageSize;
         System.assert(objClusterDetailPageSize.Id!=null);
        
        SmartDD__Cluster_Page_Size__c objClusterPageSize = new SmartDD__Cluster_Page_Size__c();
        objClusterPageSize.Name = 'Cluster Page Record Size';
        objClusterPageSize.SmartDD__Per_Page_Record__c = 25;
        insert objClusterPageSize;
         System.assert(objClusterPageSize.Id!=null);
        
        String ObjectName = 'lead';
        Integer recordSizeParam = 10;
        
        GetClustersCtrl.fetchReviewClusterColumns(ObjectName);
        GetClustersCtrl.UpdateClusterDetailRecordSize(recordSizeParam);
        GetClustersCtrl.UpdatePerPageRecordSize(recordSizeParam);
        
    }
    
    @isTest static void navigateClusterChildRecsMethodTest() {
        
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
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
        insert objAllcluster;
        System.assert(objAllcluster.Id!=null);
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            Cluster__c cluster = new Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllcluster.id;
            cluster.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterId.SmartDD__New_Master_Cluster_Id__c;
            clusters.add(cluster);
        }
        insert clusters;
        String strClusterId = clusters[0].Id;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord.SmartDD__Cluster_Id__c = strClusterId;
        insert objChildClusterRecord;
        
        SmartDD__Child_Cluster_Record__c objChildClusterRecord1 = new SmartDD__Child_Cluster_Record__c();
        objChildClusterRecord1.SmartDD__Cluster_Id__c = strClusterId;
        insert objChildClusterRecord1;
       
       
        
       GetClustersCtrl.navigateClusterChildRecs('Next',clusters[0].Id);
    }
    @isTest static void GetClustersCtrlMethodTest_clone() {
        
        List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
        SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
        dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
        dedupeConfig.SmartDD__Organization_Id__c = 'test';
        lstDedupeConfig.add(dedupeConfig);
        insert lstDedupeConfig;
         //System.assert(lstDedupeConfig.Id!=null);
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        System.assert(searchColumn.Id!=null);
        
        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.SmartDD__Object_Name__c = 'Lead';
        insert objMaster;
         System.assert(objMaster.Id!=null);
        
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
            //cluster.All_Cluster_Record__c = objAllcluster.id;
            cluster.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterId.Id;
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
            objChildClusterRecord.SmartDD__Cluster_Id__c = clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = lead.id;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;
        
        String ClusterId = clusters[0].id;
        String fieldstoget = 'Name';
        String ObjectName = 'Lead';
        String sortField = 'Name';
        String searchKey = 'test';
        boolean isAsc = true;
        decimal pageNumber = 1;
        Integer pageSize = 8;
        String navigateTo = 'next';
        
        SmartDD__Selected_Tab_Id__c focusTabName = new SmartDD__Selected_Tab_Id__c();
        focusTabName.Name = 'Selected Tab Name';
        focusTabName.SmartDD__Tab_Id_Name__c= 'uniqueLeadTab';
        insert focusTabName;
        
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        //objTableWrapper.selectedTabName = String.valueOf(focusTabName.Tab_Id_Name__c);
        system.debug('objTableWrapper.selectedTabName@@!!!  ' + objTableWrapper.selectedTabName);
        String nextClusterName = clusters[0].Name;
        List<SmartDD__Cluster__c> lstNextClusterId = [SELECT Id, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c, SmartDD__Cluster_Review_Status__c FROM SmartDD__Cluster__c WHERE Name =: nextClusterName WITH USER_MODE];
        
        Test.startTest();
        GetClustersCtrl objGetClustersCtrl = new GetClustersCtrl();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        //GetClustersCtrl.postClusterChildRecs(lstchildrec[0].id, clusters[0].id , 2, 10,'Lead'); 
        
        
        GetClustersCtrl.getClusterRecords();
        //GetClustersCtrl.getClusterDetails(ClusterId,fieldstoget,ObjectName,sortField,searchKey,isAsc,pageNumber,pageSize);
        GetClustersCtrl.fetchClusters(pageNumber,pageSize,sortField,isAsc,'Lead');
        GetClustersCtrl.GetClusterDetailRecordSize();
        GetClustersCtrl.GetPerPageRecordSize();
        //GetClustersCtrl.autoReviewAllClusters('Lead');
        GetClustersCtrl.checkClusterStat(); 
        //GetClustersCtrl.navigateClusterChildRecs(navigateTo,clusterId);               
        Test.stopTest();
    }
    
    @isTest static void updateLastCreateClusterTest(){
        SmartDD__ReDe_Dupe_Configuration__c objReDedupe = new SmartDD__ReDe_Dupe_Configuration__c();
        objReDedupe.Name  = 'ReDeDupe Configuration';
        Insert objReDedupe;
         System.assert(objReDedupe.Id!=null);
        GetClustersCtrl.updateLastCreateCluster();          
    }
}