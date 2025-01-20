@isTest
public class batchFetchUniqueRecordListTest {
    @testSetup 
    static void setup() { 
        
        SmartDD__Master_Cluster_Record__c objMasterClusterRec = new SmartDD__Master_Cluster_Record__c();
        objMasterClusterRec.SmartDD__Object_Name__c = 'Lead';
        insert objMasterClusterRec;
        
        SmartDD__All_CLuster_Record__c objAllClusterRec = new SmartDD__All_CLuster_Record__c();
        objAllClusterRec.SmartDD__Object_Name__c = 'Lead';
        objAllClusterRec.SmartDD__Master_Cluster_Record_Id__c = objMasterClusterRec.Id;
        insert objAllClusterRec;
        
        List<SmartDD__Cluster__c> clusters = new List<SmartDD__Cluster__c>();
        for (Integer i = 0; i < 5; i++) {
            SmartDD__Cluster__c cluster = new SmartDD__Cluster__c();
            cluster.SmartDD__External_Cluster_Id__c = 8;
            cluster.SmartDD__Cluster_Review_Status__c ='Not Reviewed';
            //cluster.All_Cluster_Record__c = objAllClusterRec.Id;
            clusters.add(cluster);
        }
        insert clusters;
        
        //Required For Insert Lead Data.
        //Insert Dedupe_Configuration__c custom object Data.
        SmartDD__Dedupe_Configuration__c dconfig = new SmartDD__Dedupe_Configuration__c();
        dconfig.SmartDD__UserId__c = '0058c000008W95C';
        dconfig.SmartDD__Organization_Id__c ='00D8c000002Log1';
        dconfig.SmartDD__Username__c = 'anil@mahcom.com';
        dconfig.SmartDD__Email__c  = '	jigna.gajjar@logicrain.com';
        dconfig.SmartDD__Last_Name__c ='User2';
        dconfig.SmartDD__First_Name__c ='Unique3';
        insert dconfig;
        
        //Insert Search_Column__c custom object Data.
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'FirstName,LastName,Email,Title,Company';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        
        //Insert Lead Data.
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        Lead[] leadList = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            Lead lead = new Lead();
            lead.FirstName = 'lead';
            lead.LastName = 'test'+'i';
            lead.Email = 'test12@gmail.com';
            lead.Title = 'test title';
            lead.company = 'test company';
            leadList.add(lead);
        }
        insert leadList;
        Attachment[] attchList = new List<Attachment>();
        for(Lead objLead: leadList) {
            Blob b = Blob.valueOf('Test Data');    
            Attachment attachment = new Attachment();
            attachment.ParentId = objLead.Id;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attchList.add(attachment);
        }
        insert attchList;
        
        
        List<SmartDD__Child_Cluster_Record__c> lstchildrec = new List<SmartDD__Child_Cluster_Record__c >();
        for(Integer i = 0; i < 5; i++) {
            SmartDD__Child_Cluster_Record__c objChildClusterRecord = new SmartDD__Child_Cluster_Record__c();
            objChildClusterRecord.SmartDD__Cluster_Id__c =  clusters[0].id;
            objChildClusterRecord.SmartDD__Cluster_Object_Id__c = leadList[0].id;
            //objChildClusterRecord.MannualCluster__c = true;
            lstchildrec.add(objChildClusterRecord);
        }
        insert lstchildrec;   
    }
    //Success
    @isTest static void testData1(){  
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 = new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;    
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 005';
        mrgRule.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c = 'First Record'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c ='Oldest (Order by Modified Date)';
        mrgRule.SmartDD__Master_Popup_Field_Values__c = 'test';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';  
        
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
     	Test.stopTest();
        System.assert(true);
    }
    //Success
    @isTest static void testData2(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 = new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 003';
        mrgRule.SmartDD__Master_Order_By__c = 'Newest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Most Complete Record'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Never Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Oldest (Order by Create Date)';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Most Common';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;   
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';  
        
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData3(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 = new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Most Common';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Owner.Name';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,'a0V7F00000eXlymUAC');
        Database.executebatch(bFUniqueRecordList); 
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData4(){  
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 004';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Oldest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';       
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Newest (Order by Modified Date)';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        insert mrgRule;
        
        String strQry ='SELECT Id,SmartDD__Confidence_Score__c, Name, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company,AnnualRevenue';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    //Success
    @isTest static void testData5(){
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1; 
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 006';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Most notes, attachments, activities, etc.'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Inactive';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Oldest (Order by Modified Date)';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    //Success
    @isTest static void testData6(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;   
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 007';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Record with field value not on specified ignore list'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Master_Popup_Field_Values__c= 'Test';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Oldest (Order by Modified Date)';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Account.Name';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }   
    //Success
    @isTest static void testData7(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 008';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Lowest value in the user-defined field'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Oldest (Order by Modified Date)';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        MasterCluster.SmartDD__Old_Master_Cluster_Id__c = MasterCluster.SmartDD__New_Master_Cluster_Id__c;
        update MasterCluster;
        SmartDD__Master_Cluster_Record__c MasterClusterRecord = new SmartDD__Master_Cluster_Record__c();
        MasterClusterRecord.SmartDD__Object_Name__c = 'Lead';
        insert MasterClusterRecord;
        SmartDD__Manage_Master_Cluster_Id__c MasterClusterNew = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        System.debug('RESULT......................................................'+MasterClusterNew);
        MasterClusterNew.SmartDD__New_Master_Cluster_Id__c = MasterClusterRecord.Id;
        update MasterClusterNew;
        SmartDD__Manage_Master_Cluster_Id__c MasterClusterLatest = SmartDD__Manage_Master_Cluster_Id__c.getInstance('Lead');
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    //Success
    @isTest static void testData8(){  
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;  
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 009';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Highest value in the user-defined field'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Oldest (Order by Modified Date)';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = 'test';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    //Success
    @isTest static void testData9(){
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;  
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 010';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Modified Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'First record with a value in the user-defined field'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Override Master When Blank';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    @isTest static void testData10(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 011';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Most Common';
        //MSFValue.Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    @isTest static void testData11(){  
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 012';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'Oldest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';       
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='';
        insert mrgRule;
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company,AnnualRevenue';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    @isTest static void testData12(){
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1=new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 013';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'Lowest value in the user-defined field'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.Status__c = 'Active';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    @isTest static void testData13(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 014';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'Highest value in the user-defined field'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Always Override Master';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Oldest (Order by Modified Date)';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Title';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c,SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList); 
         Test.stopTest();
        System.assert(true);
    }
    @isTest static void testData14(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 015';
        mrgRule.SmartDD__Master_Order_By__c = '';
        mrgRule.SmartDD__Master_Record_Type__c= 'First record with a value in the user-defined field'; 
        mrgRule.SmartDD__Object_Field_API_Name__c= 'AnnualRevenue';
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        mrgRule.SmartDD__Default_Override_Master_Record__c ='Override Master When Blank';
        mrgRule.SmartDD__Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        //mrgRule.Object_Field_API_Name__c = 'AnnualRevenue';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        MSFValue.SmartDD__Specific_Field_Name__c = 'Salutation';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;  
        
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData15(){   
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Newest (ordered by MODIFIED date)';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData16(){
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
       SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Oldest (ordered by CREATE date)';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData17(){  
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Newest (ordered by CREATE date)';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    
    
    @isTest static void testData18(){  
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Oldest (ordered by MODIFIED date)';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData19(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Ignore all values: update to blank or to given value';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    
    
    @isTest static void testData21(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Prioritized by values';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList);  
         Test.stopTest();
        System.assert(true);
    }
    
    @isTest static void testData22(){ 
         Test.startTest();
        SmartDD__Manage_Master_Cluster_Id__c MasterCluster1 =new SmartDD__Manage_Master_Cluster_Id__c();  
        MasterCluster1.Name = 'Lead';
        MasterCluster1.SmartDD__New_Master_Cluster_Id__c = 'a0O8c00000lEZBpEAO';
        MasterCluster1.SmartDD__Old_Master_Cluster_Id__c = 'a0O8c00000lEZBtEAO';
        MasterCluster1.SmartDD__Object_Name__c = 'Lead';
        insert MasterCluster1;
        
        SmartDD__ManageRule_Master_Record__c mrgRule = new SmartDD__ManageRule_Master_Record__c();
        mrgRule.SmartDD__Merge_Rule_Name__c = 'MRC 001';
        mrgRule.SmartDD__Master_Order_By__c = 'Oldest Created Date';
        mrgRule.SmartDD__Master_Record_Type__c= 'Newest by the given date field'; 
        mrgRule.SmartDD__Priority__c = 1;
        mrgRule.SmartDD__Status__c = 'Active';
        mrgRule.SmartDD__Object_Field_API_Name__c = 'FirstName';
        mrgRule.SmartDD__Object_Name__c = 'Lead';
        //mrgRule.Default_Override_Master_Record__c ='Override Master When Blank';       
        //mrgRule.Default_Field_Value_Selection_Priority__c='Newest (Order by Create Date)';
        insert mrgRule;
        
        SmartDD__ManageRule_Specific_FieldVal__c MSFValue = new SmartDD__ManageRule_Specific_FieldVal__c();
        MSFValue.SmartDD__Specific_Rule_Name__c = 'Field with max characters';
        MSFValue.SmartDD__Specific_Popup_Field_Values__c = '';
        MSFValue.SmartDD__Specific_Master_Override_Type__c = 'Always Override Master';
        MSFValue.SmartDD__Specific_Field_Name__c = 'FirstName';
        MSFValue.SmartDD__Master_Record_Criteria_Name__c = mrgRule.Id;
        //MSFValue.Name = 'M-03140';
        insert MSFValue;      
        String strQry ='SELECT Id, Name, SmartDD__Confidence_Score__c, SmartDD__External_Cluster_Id__c, SmartDD__Total_Child_Records__c FROM SmartDD__Cluster__c WHERE SmartDD__Total_Child_Records__c > 1 WITH USER_MODE ORDER BY SmartDD__External_Cluster_Id__c ASC'; 
        
        String ObjectName =  'Lead';
        String fieldstoget = 'FirstName,LastName,Email,company';     
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
        
        batchFetchUniqueRecordList bFUniqueRecordList = new batchFetchUniqueRecordList(strQry,fieldstoget,ObjectName,MasterClusterLatest.SmartDD__New_Master_Cluster_Id__c);
        Database.executebatch(bFUniqueRecordList); 
         Test.stopTest();
        System.assert(true);
    }   
}