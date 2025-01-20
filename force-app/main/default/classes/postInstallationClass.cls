global class postInstallationClass implements InstallHandler {
    
    //private Version previousVersion;
    
    global void onInstall(InstallContext context) {
        
        doInstall();
    }
    
    public static void doInstall() {
        // ----------------------------------Merge Rule-----------------------------------------//
        
        List<SmartDD__ManageRule_Master_Record__c> lstObjMstrRecCriteria = new List<SmartDD__ManageRule_Master_Record__c>();
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaLead1 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaLead1.SmartDD__Object_Name__c = 'Lead';
        objMstrRecCriteriaLead1.SmartDD__Merge_Rule_Name__c = 'LeadMergeRule1';
        objMstrRecCriteriaLead1.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaLead1.SmartDD__Master_Record_Type__c = 'Most notes, attachments, activities, etc.';
        objMstrRecCriteriaLead1.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaLead1.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaLead1.SmartDD__Priority__c = 1;
        objMstrRecCriteriaLead1.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaLead1.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaLead1.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaLead1.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaLead1.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaLead1);
        
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaLead2 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaLead2.SmartDD__Object_Name__c = 'Lead';
        objMstrRecCriteriaLead2.SmartDD__Merge_Rule_Name__c = 'LeadMergeRule2';
        objMstrRecCriteriaLead2.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaLead2.SmartDD__Master_Record_Type__c = 'Most Complete Record';
        objMstrRecCriteriaLead2.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaLead2.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaLead2.SmartDD__Priority__c = 2;
        objMstrRecCriteriaLead2.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaLead2.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaLead2.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaLead2.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaLead2.SmartDD__Status__c = 'Active';
        }
        
        lstObjMstrRecCriteria.add(objMstrRecCriteriaLead2);
        
        
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaLead3 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaLead3.SmartDD__Object_Name__c = 'Lead';
        objMstrRecCriteriaLead3.SmartDD__Merge_Rule_Name__c = 'LeadMergeRule3';
        objMstrRecCriteriaLead3.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaLead3.SmartDD__Master_Record_Type__c = 'First Record';
        objMstrRecCriteriaLead3.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaLead3.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaLead3.SmartDD__Priority__c = 3;
        objMstrRecCriteriaLead3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaLead3.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaLead3.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaLead3.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaLead3.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaLead3);
        
       // List<SmartDD__ManageRule_Master_Record__c> lstObjMstrRecCriteria1 = new List<SmartDD__ManageRule_Master_Record__c>();
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaAcc1 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaAcc1.SmartDD__Object_Name__c = 'Account';
        objMstrRecCriteriaAcc1.SmartDD__Merge_Rule_Name__c = 'AccountMergeRule1';
        objMstrRecCriteriaAcc1.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaAcc1.SmartDD__Master_Record_Type__c = 'Most notes, attachments, activities, etc.';
        objMstrRecCriteriaAcc1.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaAcc1.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaAcc1.SmartDD__Priority__c = 1;
        objMstrRecCriteriaAcc1.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaAcc1.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaAcc1.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaAcc1.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaAcc1.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaAcc1);
        
         SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaAcc2 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaAcc2.SmartDD__Object_Name__c = 'Account';
        objMstrRecCriteriaAcc2.SmartDD__Merge_Rule_Name__c = 'AccountMergeRule2';
        objMstrRecCriteriaAcc2.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaAcc2.SmartDD__Master_Record_Type__c = 'Most Complete Record';
        objMstrRecCriteriaAcc2.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaAcc2.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaAcc2.SmartDD__Priority__c = 2;
        objMstrRecCriteriaAcc2.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaAcc2.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaAcc2.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaAcc2.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaAcc2.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaAcc2);
        
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaAcc3 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaAcc3.SmartDD__Object_Name__c = 'Account';
        objMstrRecCriteriaAcc3.SmartDD__Merge_Rule_Name__c = 'AccountMergeRule3';
        objMstrRecCriteriaAcc3.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaAcc3.SmartDD__Master_Record_Type__c = 'First Record';
        objMstrRecCriteriaAcc3.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaAcc3.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaAcc3.SmartDD__Priority__c = 3;
        objMstrRecCriteriaAcc3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaAcc3.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaAcc3.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaAcc3.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaAcc3.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaAcc3);
        
        // List<SmartDD__ManageRule_Master_Record__c> lstObjMstrRecCriteria2 = new List<SmartDD__ManageRule_Master_Record__c>();
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaCon1 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaCon1.SmartDD__Object_Name__c = 'Contact';
        objMstrRecCriteriaCon1.SmartDD__Merge_Rule_Name__c = 'ContactMergeRule1';
        objMstrRecCriteriaCon1.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaCon1.SmartDD__Master_Record_Type__c = 'Most notes, attachments, activities, etc.';
        objMstrRecCriteriaCon1.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaCon1.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaCon1.SmartDD__Priority__c = 1;
        objMstrRecCriteriaCon1.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaCon1.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaCon1.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaCon1.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaCon1.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaCon1);
        
         SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaCon2 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaCon2.SmartDD__Object_Name__c = 'Contact';
        objMstrRecCriteriaCon2.SmartDD__Merge_Rule_Name__c = 'ContactMergeRule2';
        objMstrRecCriteriaCon2.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaCon2.SmartDD__Master_Record_Type__c = 'Most Complete Record';
        objMstrRecCriteriaCon2.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaCon2.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaCon2.SmartDD__Priority__c = 2;
        objMstrRecCriteriaCon2.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaCon2.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaCon2.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaCon2.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaCon2.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaCon2);
        
        SmartDD__ManageRule_Master_Record__c objMstrRecCriteriaCon3 = new SmartDD__ManageRule_Master_Record__c();
        objMstrRecCriteriaCon3.SmartDD__Object_Name__c = 'Contact';
        objMstrRecCriteriaCon3.SmartDD__Merge_Rule_Name__c = 'ContactMergeRule3';
        objMstrRecCriteriaCon3.SmartDD__Least_Confidence_Score__c = 40;
        objMstrRecCriteriaCon3.SmartDD__Master_Record_Type__c = 'First Record';
        objMstrRecCriteriaCon3.SmartDD__Object_Field_API_Name__c = '';
        objMstrRecCriteriaCon3.SmartDD__Master_Popup_Field_Values__c = '';
        objMstrRecCriteriaCon3.SmartDD__Priority__c = 3;
        objMstrRecCriteriaCon3.SmartDD__Master_Order_By__c = 'Newest Modified Date';
        objMstrRecCriteriaCon3.SmartDD__Default_Field_Value_Selection_Priority__c = 'Newest (Order by Modified Date)';
        //objMstrRecCriteria.Default_Note_For_Each_Field__c = DefaultEachFieldVal;
        //objMstrRecCriteria.Default_If_Master_Updated__c = DefaultMasterUpdated;
        objMstrRecCriteriaCon3.SmartDD__Default_Override_Master_Record__c = 'Override Master When Blank';
        if(objMstrRecCriteriaCon3.SmartDD__Priority__c == 1) {
            objMstrRecCriteriaCon3.SmartDD__Status__c = 'Active';
        }
        lstObjMstrRecCriteria.add(objMstrRecCriteriaCon3);
        
   
        
        
        if((Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Object_Name__c.isCreateable()) || 
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Merge_Rule_Name__c.isCreateable()) || 
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Least_Confidence_Score__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Record_Type__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Object_Field_API_Name__c.isCreateable()) || 
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Popup_Field_Values__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Priority__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Master_Order_By__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Default_Field_Value_Selection_Priority__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Default_Override_Master_Record__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Master_Record__c.fields.SmartDD__Status__c.isCreateable()))
        {
            insert lstObjMstrRecCriteria;
            //insert lstObjMstrRecCriteria1;
        }
        
        
        List<SmartDD__ManageRule_Specific_FieldVal__c> lstManageRuleSpecificFieldVal = new List<SmartDD__ManageRule_Specific_FieldVal__c>();
        SmartDD__ManageRule_Specific_FieldVal__c manageRuleSpecificFieldVal = new SmartDD__ManageRule_Specific_FieldVal__c();
        manageRuleSpecificFieldVal.SmartDD__Master_Record_Criteria_Name__c = lstObjMstrRecCriteria[0].Id;
        manageRuleSpecificFieldVal.SmartDD__Specific_Field_Name__c = 'AnnualRevenue';
        manageRuleSpecificFieldVal.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        manageRuleSpecificFieldVal.SmartDD__Specific_Rule_Name__c = 'Combined list';
        lstManageRuleSpecificFieldVal.add(manageRuleSpecificFieldVal) ;
        SmartDD__ManageRule_Specific_FieldVal__c manageRuleSpecificFieldVal1 = new SmartDD__ManageRule_Specific_FieldVal__c();
        manageRuleSpecificFieldVal1.SmartDD__Master_Record_Criteria_Name__c = lstObjMstrRecCriteria[1].Id;
        manageRuleSpecificFieldVal1.SmartDD__Specific_Field_Name__c = 'FirstName';
        manageRuleSpecificFieldVal1.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        manageRuleSpecificFieldVal1.SmartDD__Specific_Rule_Name__c = 'Most Common';
        lstManageRuleSpecificFieldVal.add(manageRuleSpecificFieldVal1) ;
        SmartDD__ManageRule_Specific_FieldVal__c manageRuleSpecificFieldVal2 = new SmartDD__ManageRule_Specific_FieldVal__c();
        manageRuleSpecificFieldVal2.SmartDD__Master_Record_Criteria_Name__c = lstObjMstrRecCriteria[2].Id;
        manageRuleSpecificFieldVal2.SmartDD__Specific_Field_Name__c = 'Name';
        manageRuleSpecificFieldVal2.SmartDD__Specific_Master_Override_Type__c = 'Override Master When Blank';
        manageRuleSpecificFieldVal2.SmartDD__Specific_Rule_Name__c = 'Newest (ordered by CREATE date)';
        lstManageRuleSpecificFieldVal.add(manageRuleSpecificFieldVal2) ;
        
        
        if((Schema.sObjectType.SmartDD__ManageRule_Specific_FieldVal__c.fields.SmartDD__Master_Record_Criteria_Name__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__ManageRule_Specific_FieldVal__c.fields.SmartDD__Specific_Field_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ManageRule_Specific_FieldVal__c.fields.SmartDD__Specific_Master_Override_Type__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ManageRule_Specific_FieldVal__c.fields.SmartDD__Specific_Rule_Name__c.isCreateable()))
        {
            insert lstManageRuleSpecificFieldVal;
        }
        
        // ----------------------------------Mapping-----------------------------------------//
        List<SmartDD__Search_Column__c> lstSearchClm = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchClm = new SmartDD__Search_Column__c();
        searchClm.SmartDD__Object_Name__c = 'Lead';
        searchClm.SmartDD__Review_Polish_Display_Columns__c = 'FirstName,LastName,Title,Company,Email';
        searchClm.SmartDD__Search_Column_Fields__c = 'FirstName,LastName,Title,Company,Email' ;
        searchClm.SmartDD__Search_Object_Fields__c = 'FirstName,LastName,Company,Title,Email,City';
        lstSearchClm.add(searchClm);
        if((Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Object_Name__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Review_Polish_Display_Columns__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Column_Fields__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Object_Fields__c.isCreateable()))
        {
            insert lstSearchClm;
        }
        
        // ----------------------------------Contact Mapping-----------------------------------------//
        List<SmartDD__Search_Column__c> lstConSearchClm = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c conSearchClm = new SmartDD__Search_Column__c();
        conSearchClm.SmartDD__Object_Name__c = 'Contact';
        conSearchClm.SmartDD__Review_Polish_Display_Columns__c = 'FirstName,LastName,Title,Email';
        conSearchClm.SmartDD__Search_Column_Fields__c = 'FirstName,LastName,Title,Email' ;
        conSearchClm.SmartDD__Search_Object_Fields__c = 'FirstName,LastName,Title,Email';
        lstConSearchClm.add(conSearchClm);
        if((Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Object_Name__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Review_Polish_Display_Columns__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Column_Fields__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Object_Fields__c.isCreateable()))
        {
            insert lstConSearchClm;
        }
        
        // ----------------------------------Account Mapping-----------------------------------------//
        List<SmartDD__Search_Column__c> lstAccSearchClm = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c accSearchClm = new SmartDD__Search_Column__c();
        accSearchClm.SmartDD__Object_Name__c = 'Account';
        accSearchClm.SmartDD__Review_Polish_Display_Columns__c = 'Name,Phone,BillingCity,BillingCountry';
        accSearchClm.SmartDD__Search_Column_Fields__c = 'Name,Phone,BillingCity,BillingCountry' ;
        accSearchClm.SmartDD__Search_Object_Fields__c = 'Name,Phone,BillingCity,BillingCountry';
        lstAccSearchClm.add(accSearchClm);
        if((Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Object_Name__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Review_Polish_Display_Columns__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Column_Fields__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Search_Column__c.fields.SmartDD__Search_Object_Fields__c.isCreateable()))
        {
            insert lstAccSearchClm;
        }
        
        // ----------------------------------Custom settings-----------------------------------------//
        /*DeDupe Configuration*/
        List<SmartDD__De_Dupe_Configuration__c> lstDeDupeConfiguration = new List<SmartDD__De_Dupe_Configuration__c>();
        SmartDD__De_Dupe_Configuration__c deDupeConfiguration = new SmartDD__De_Dupe_Configuration__c();
        deDupeConfiguration.Name = 'DeDupe Configuration';
        deDupeConfiguration.SmartDD__Account__c =true;
        deDupeConfiguration.SmartDD__Cluster_Estimated_Time__c=2;
        deDupeConfiguration.SmartDD__Clusters_Completed_Stat__c='Completed';
        deDupeConfiguration.SmartDD__Single_Clusters_Completed_Stat__c='Completed';
        deDupeConfiguration.SmartDD__Clusters_Created_Stat__c =true;
        deDupeConfiguration.SmartDD__Clusters_Deleted__c=false;
        deDupeConfiguration.SmartDD__Contact__c=true;
        deDupeConfiguration.SmartDD__Data_Mapping__c=true;
        deDupeConfiguration.SmartDD__DeDupe_Object_Name__c='lead';
        deDupeConfiguration.SmartDD__Dedupe_Started_Stat__c=true;
        deDupeConfiguration.SmartDD__Deduped_By_UserName__c='';
        deDupeConfiguration.SmartDD__ExternalSyncStatus__c='Completed';
        deDupeConfiguration.SmartDD__Last_Create_Cluster_Progress__c=100;
        deDupeConfiguration.SmartDD__Last_Dedupe_Time__c='';
        deDupeConfiguration.SmartDD__Last_Sync_date__c= null;
        deDupeConfiguration.SmartDD__Lead__c=true;
        deDupeConfiguration.SmartDD__Manage_Cluster_BatchId__c='';
        deDupeConfiguration.SmartDD__SF_Import_Consumer_Key__c='';
        deDupeConfiguration.SmartDD__SF_Import_Consumer_Secret__c='';
        deDupeConfiguration.SmartDD__Start_Dedupe_Batch_Id__c='';
        deDupeConfiguration.SmartDD__Sync_Data__c=false;
        deDupeConfiguration.SmartDD__Sync_Object_Name__c='Lead';
        deDupeConfiguration.SmartDD__Synced_By_UserName__c='Frank Mahdavi';
        deDupeConfiguration.SmartDD__Total_CLusters_Created__c=0;
        deDupeConfiguration.SmartDD__Total_Records_Deduped__c=0;
        deDupeConfiguration.SmartDD__Total_Records_Synced__c=0;
        deDupeConfiguration.SmartDD__Training_File_Consumer_Key__c='';
        deDupeConfiguration.SmartDD__Training_File_Consumer_Secret__c='';
        deDupeConfiguration.SmartDD__User_Configuration__c  =true;
        deDupeConfiguration.SmartDD__Filter_Id__c = '';
        lstDeDupeConfiguration.add(deDupeConfiguration);
        if((Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Account__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Created_Stat__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Single_Clusters_Completed_Stat__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Clusters_Deleted__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Contact__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Data_Mapping__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__DeDupe_Object_Name__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Dedupe_Started_Stat__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Deduped_By_UserName__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__ExternalSyncStatus__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Dedupe_Time__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Last_Sync_date__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Lead__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Manage_Cluster_BatchId__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__SF_Import_Consumer_Key__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__SF_Import_Consumer_Secret__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Data__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Sync_Object_Name__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Synced_By_UserName__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Total_CLusters_Created__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Total_Records_Deduped__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Total_Records_Synced__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Training_File_Consumer_Key__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Filter_Id__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__Training_File_Consumer_Secret__c.isCreateable()) ||
           (Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.fields.SmartDD__User_Configuration__c.isCreateable()))
        {
            insert lstDeDupeConfiguration;
        }
        
        /*ReDeDupe Configuration*/
        List<SmartDD__ReDe_Dupe_Configuration__c> lstReDeDupeConfiguration = new List<SmartDD__ReDe_Dupe_Configuration__c>();
        SmartDD__ReDe_Dupe_Configuration__c reDeDupeConfiguration = new SmartDD__ReDe_Dupe_Configuration__c();
        reDeDupeConfiguration.Name = 'ReDeDupe Configuration';
        reDeDupeConfiguration.SmartDD__Cluster_Estimated_Time__c = 1;
        reDeDupeConfiguration.SmartDD__Clusters_Completed_Stat__c = 'Completed';
        reDeDupeConfiguration.SmartDD__Single_Clusters_Completed_Stat__c='Completed';
        reDeDupeConfiguration.SmartDD__Last_Create_Cluster_Progress__c = 4;
        reDeDupeConfiguration.SmartDD__ReDeduped_Object_Name__c = 'Lead';
        reDeDupeConfiguration.SmartDD__Start_Dedupe_Batch_Id__c = '';
        reDeDupeConfiguration.SmartDD__Total_Records_ReDeduped__c = 0;
        lstReDeDupeConfiguration.add(reDeDupeConfiguration);
        if((Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Cluster_Estimated_Time__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Clusters_Completed_Stat__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Single_Clusters_Completed_Stat__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Last_Create_Cluster_Progress__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__ReDeduped_Object_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Start_Dedupe_Batch_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__ReDe_Dupe_Configuration__c.fields.SmartDD__Total_Records_ReDeduped__c.isCreateable())
          )
        {
            insert lstReDeDupeConfiguration;
        }   
        
        
        /*Cluster Detail Page Size*/
        List<SmartDD__Cluster_Detail_Page_Size__c> lstClstrDetailpageSize = new List<SmartDD__Cluster_Detail_Page_Size__c>();
        SmartDD__Cluster_Detail_Page_Size__c clstrDetailpageSize = new SmartDD__Cluster_Detail_Page_Size__c();
        clstrDetailpageSize.Name = 'Cluster Detail Page Record Size';
        clstrDetailpageSize.SmartDD__Per_Page_Record__c = 50;
        lstClstrDetailpageSize.add(clstrDetailpageSize);
        if((Schema.sObjectType.SmartDD__Cluster_Detail_Page_Size__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Cluster_Detail_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isCreateable()))
        {
            insert lstClstrDetailpageSize;
        }
        
        
        /*Cluster Page Size*/
        List<SmartDD__Cluster_Page_Size__c> lstClstrpageSize = new List<SmartDD__Cluster_Page_Size__c>();
        SmartDD__Cluster_Page_Size__c clstrpageSize = new SmartDD__Cluster_Page_Size__c();
        clstrpageSize.Name = 'Cluster Page Record Size';
        clstrpageSize.SmartDD__Per_Page_Record__c = 250;
        lstClstrpageSize.add(clstrpageSize);
        if((Schema.sObjectType.SmartDD__Cluster_Page_Size__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Cluster_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isCreateable()))
        {
            insert lstClstrpageSize;
        }
        
        /*Dedupe Per Page Record Size*/
        List<SmartDD__Dedupe_Per_Page_Record_Size__c> lstDedupePerPageRecSize = new   List<SmartDD__Dedupe_Per_Page_Record_Size__c>();
        SmartDD__Dedupe_Per_Page_Record_Size__c dedupePerPageRecSize = new SmartDD__Dedupe_Per_Page_Record_Size__c();
        dedupePerPageRecSize.Name = 'Dedupe Display Records';
        dedupePerPageRecSize.SmartDD__Per_Page_Record__c = 500;
        lstDedupePerPageRecSize.add(dedupePerPageRecSize);
        if((Schema.sObjectType.SmartDD__Dedupe_Per_Page_Record_Size__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Dedupe_Per_Page_Record_Size__c.fields.SmartDD__Per_Page_Record__c.isCreateable()))
        {
            insert lstDedupePerPageRecSize;
        }
        
        /*Filter Data*/
        List<SmartDD__Filter_Data__c> lstFilterData = new List<SmartDD__Filter_Data__c>();
        SmartDD__Filter_Data__c filterData = new SmartDD__Filter_Data__c();
        filterData.Name = 'Account';
        filterData.SmartDD__Deleted_Records__c = 0;
        filterData.SmartDD__Filter_Id__c='';
        filterData.SmartDD__Object_Name__c='Account';
        filterData.SmartDD__Unique_Cluster_Saved__c=false;
        filterData.SmartDD__Updated_Records__c=0;
        lstFilterData.add(filterData);
        SmartDD__Filter_Data__c filterData1 = new SmartDD__Filter_Data__c();
        filterData1.Name = 'Contact';
        filterData1.SmartDD__Deleted_Records__c = 0;
        filterData1.SmartDD__Filter_Id__c='';
        filterData1.SmartDD__Object_Name__c='Contact';
        filterData1.SmartDD__Unique_Cluster_Saved__c=false;
        filterData1.SmartDD__Updated_Records__c=0;
        lstFilterData.add(filterData1);
        SmartDD__Filter_Data__c filterData2 = new SmartDD__Filter_Data__c();
        filterData2.Name = 'Lead';
        filterData2.SmartDD__Deleted_Records__c = 0;
        filterData2.SmartDD__Filter_Id__c='';
        filterData2.SmartDD__Object_Name__c='Lead';
        filterData2.SmartDD__Unique_Cluster_Saved__c=false;
        filterData2.SmartDD__Updated_Records__c=0;
        lstFilterData.add(filterData2);
        if((Schema.sObjectType.SmartDD__Filter_Data__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Deleted_Records__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Filter_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Object_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Unique_Cluster_Saved__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Filter_Data__c.fields.SmartDD__Updated_Records__c.isCreateable())
          )
        {
            insert lstFilterData;
        }
        
        /*Manage Cluster Batch Id*/
        List<SmartDD__Manage_Cluster_Batch_Id__c> lstMngClstrBtchId = new List<SmartDD__Manage_Cluster_Batch_Id__c>();
        SmartDD__Manage_Cluster_Batch_Id__c mngClstrBtchId = new SmartDD__Manage_Cluster_Batch_Id__c();
        mngClstrBtchId.Name = 'Contact';
        mngClstrBtchId.SmartDD__Batch_Id__c = '';
        mngClstrBtchId.SmartDD__Object_Name__c = 'Contact';
        lstMngClstrBtchId.add(mngClstrBtchId);
        SmartDD__Manage_Cluster_Batch_Id__c mngClstrBtchId1 = new SmartDD__Manage_Cluster_Batch_Id__c();
        mngClstrBtchId1.Name = 'Account';
        mngClstrBtchId1.SmartDD__Batch_Id__c = '';
        mngClstrBtchId1.SmartDD__Object_Name__c = 'Account';
        lstMngClstrBtchId.add(mngClstrBtchId1);
        SmartDD__Manage_Cluster_Batch_Id__c mngClstrBtchId2 = new SmartDD__Manage_Cluster_Batch_Id__c();
        mngClstrBtchId2.Name = 'Lead';
        mngClstrBtchId2.SmartDD__Batch_Id__c = '';
        mngClstrBtchId2.SmartDD__Object_Name__c = 'Lead';
        lstMngClstrBtchId.add(mngClstrBtchId2);
        if((Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Batch_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Cluster_Batch_Id__c.fields.SmartDD__Object_Name__c.isCreateable()))
        {
        insert lstMngClstrBtchId;
        }
        
        /*Manage Cluster Org Tab Id*/
        List<SmartDD__Manage_Cluster_Org_Tab_Id__c> lstMngClstrOrgTabId = new List<SmartDD__Manage_Cluster_Org_Tab_Id__c>();
        SmartDD__Manage_Cluster_Org_Tab_Id__c mngClstrOrgTabId = new SmartDD__Manage_Cluster_Org_Tab_Id__c();
        mngClstrOrgTabId.Name = 'Org Tab Name';
        mngClstrOrgTabId.SmartDD__TabName__c = 'DedupeManageClusterPage';
        lstMngClstrOrgTabId.add(mngClstrOrgTabId);
        if((Schema.sObjectType.SmartDD__Manage_Cluster_Org_Tab_Id__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Cluster_Org_Tab_Id__c.fields.SmartDD__TabName__c.isCreateable()))
        {
        insert lstMngClstrOrgTabId;
        }
        
        /*Manage Master Cluster Id*/
        List<SmartDD__Manage_Master_Cluster_Id__c> lstMngMstrClstrId = new List<SmartDD__Manage_Master_Cluster_Id__c>();
        SmartDD__Manage_Master_Cluster_Id__c mngMstrClstrId = new SmartDD__Manage_Master_Cluster_Id__c();
        mngMstrClstrId.Name = 'Account';
        mngMstrClstrId.SmartDD__New_Master_Cluster_Id__c = '';
        mngMstrClstrId.SmartDD__Object_Name__c = '';
        mngMstrClstrId.SmartDD__Old_Master_Cluster_Id__c = '';
        mngMstrClstrId.SmartDD__Process_Type__c = '';
        lstMngMstrClstrId.add(mngMstrClstrId);
        SmartDD__Manage_Master_Cluster_Id__c mngMstrClstrId1 = new SmartDD__Manage_Master_Cluster_Id__c();
        mngMstrClstrId1.Name = 'Contact';
        mngMstrClstrId1.SmartDD__New_Master_Cluster_Id__c = '';
        mngMstrClstrId1.SmartDD__Object_Name__c = '';
        mngMstrClstrId1.SmartDD__Old_Master_Cluster_Id__c = '';
        mngMstrClstrId1.SmartDD__Process_Type__c = '';
        lstMngMstrClstrId.add(mngMstrClstrId1);
        SmartDD__Manage_Master_Cluster_Id__c mngMstrClstrId2 = new SmartDD__Manage_Master_Cluster_Id__c();
        mngMstrClstrId2.Name = 'Lead';
        mngMstrClstrId2.SmartDD__New_Master_Cluster_Id__c = '';
        mngMstrClstrId2.SmartDD__Object_Name__c = '';
        mngMstrClstrId2.SmartDD__Old_Master_Cluster_Id__c = '';
        mngMstrClstrId2.SmartDD__Process_Type__c = '';
        lstMngMstrClstrId.add(mngMstrClstrId2);
         if((Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__New_Master_Cluster_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Object_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Process_Type__c.isCreateable())|| 
           (Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Old_Master_Cluster_Id__c.isCreateable()))
        {
        insert lstMngMstrClstrId;
        }
        
        /*Selected Tab Id*/
        List<SmartDD__Selected_Tab_Id__c> lstSelectedTabId = new List<SmartDD__Selected_Tab_Id__c>();
        SmartDD__Selected_Tab_Id__c selectedTabId = new SmartDD__Selected_Tab_Id__c();
        selectedTabId.Name = 'Selected Tab Name';
        selectedTabId.SmartDD__Tab_Id_Name__c = 'uniqueLeadTab';
        lstSelectedTabId.add(selectedTabId);
        if((Schema.sObjectType.SmartDD__Selected_Tab_Id__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Selected_Tab_Id__c.fields.SmartDD__Tab_Id_Name__c.isCreateable()))
        {
        insert lstSelectedTabId;
        }
        
        /*StartDedupeStatus*/
        List<SmartDD__StartDedupeStatus__c>  lstStrtDedupeSts = new List<SmartDD__StartDedupeStatus__c>();
        SmartDD__StartDedupeStatus__c  strtDedupeSts = new SmartDD__StartDedupeStatus__c ();
        strtDedupeSts.Name = 'Start DeDupe';
        strtDedupeSts.SmartDD__StartDedupeBatchId__c  = '';
        strtDedupeSts.SmartDD__IsSuccess__c = '' ;
        lstStrtDedupeSts.add(strtDedupeSts);
         if((Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__StartDedupeBatchId__c.isCreateable())||
           (Schema.sObjectType.SmartDD__StartDedupeStatus__c.fields.SmartDD__IsSuccess__c.isCreateable()))
        {
        insert lstStrtDedupeSts;
        }
        
        /*Sync Data*/
        List<SmartDD__Sync_Data__c> lstSyncData = new List<SmartDD__Sync_Data__c>();
        SmartDD__Sync_Data__c syncData = new SmartDD__Sync_Data__c();
        syncData.Name = 'Sync Data Status';
        syncData.SmartDD__Delete_Duplicate_Batch_Id__c = '';
        syncData.SmartDD__Find_Duplicate_Batch_Id__c = '';
        syncData.SmartDD__Save_Mapping__c = false;
        lstSyncData.add(syncData);
        if((Schema.sObjectType.SmartDD__Sync_Data__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Delete_Duplicate_Batch_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Find_Duplicate_Batch_Id__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Sync_Data__c.fields.SmartDD__Save_Mapping__c.isCreateable()))
        {
        insert lstSyncData;
        }
        
        /*Unique Lead Page Size*/
        List<SmartDD__Unique_Lead_Page_Size__c> lstUnqLeadPageSize = new List<SmartDD__Unique_Lead_Page_Size__c>();
        SmartDD__Unique_Lead_Page_Size__c unqLeadPageSize = new SmartDD__Unique_Lead_Page_Size__c();
        unqLeadPageSize.Name = 'Unique Lead Page Size';
        unqLeadPageSize.SmartDD__Per_Page_Record__c = 500;
        lstUnqLeadPageSize.add(unqLeadPageSize);
         if((Schema.sObjectType.SmartDD__Unique_Lead_Page_Size__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Unique_Lead_Page_Size__c.fields.SmartDD__Per_Page_Record__c.isCreateable()))
        {
        insert lstUnqLeadPageSize;
        }

        /*Manage Rule Exceptions*/
        List<SmartDD__Manage_Rule_Exceptions__c> lstManageRuleExp = new List<SmartDD__Manage_Rule_Exceptions__c>();
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp.Name = 'Non Master Record is not an Import';
        manageRuleExp.SmartDD__Field_Name__c = 'Record when Non Master Record is not an Import Record';
        lstManageRuleExp.add(manageRuleExp);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp1 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp1.Name = 'Value exists in more than one record';
        manageRuleExp1.SmartDD__Field_Name__c = 'Group when Value exists in more than one record';
        lstManageRuleExp.add(manageRuleExp1);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp2 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp2.Name = '(Blank value matched)';
        manageRuleExp2.SmartDD__Field_Name__c = 'Record when Value does not match master record (Blank value matched)';
        lstManageRuleExp.add(manageRuleExp2);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp3 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp3.Name = 'Group when its size is <= X';
        manageRuleExp3.SmartDD__Field_Name__c = 'Group when its size is <= X';
        lstManageRuleExp.add(manageRuleExp3);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp4 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp4.Name = 'Group when its size is >= X';
        manageRuleExp4.SmartDD__Field_Name__c = 'Group when its size is >= X';
        lstManageRuleExp.add(manageRuleExp4);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp5 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp5.Name = 'Non Master Record is protected';
        manageRuleExp5.SmartDD__Field_Name__c = 'Record when Non Master Record is protected';
        lstManageRuleExp.add(manageRuleExp5);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp6 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp6.Name = 'Specified Value in more than one';
        manageRuleExp6.SmartDD__Field_Name__c = 'Group when Specified Value exists in more than one record';
        lstManageRuleExp.add(manageRuleExp6);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp7 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp7.Name = 'Non Master Record has specified value';
        manageRuleExp7.SmartDD__Field_Name__c = 'Record when Non Master Record has specified value in field';
        lstManageRuleExp.add(manageRuleExp7);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp8 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp8.Name = 'record has less than X%';
        manageRuleExp8.SmartDD__Field_Name__c = 'Group when record has less than X% of the fields with values';
        lstManageRuleExp.add(manageRuleExp8);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp9 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp9.Name = 'Non Master Record has value in field';
        manageRuleExp9.SmartDD__Field_Name__c = 'Record when Non Master Record has any value in field';
        lstManageRuleExp.add(manageRuleExp9);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp10 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp10.Name = 'Value does not match master record';
        manageRuleExp10.SmartDD__Field_Name__c = 'Record when Value does not match master record for field';
        lstManageRuleExp.add(manageRuleExp10);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp11 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp11.Name = 'NO value exists for any record';
        manageRuleExp11.SmartDD__Field_Name__c = 'Group when NO value exists for any record in group for field';
        lstManageRuleExp.add(manageRuleExp11);
        SmartDD__Manage_Rule_Exceptions__c manageRuleExp12 = new SmartDD__Manage_Rule_Exceptions__c();
        manageRuleExp12.Name = 'when one or more records is protected';
        manageRuleExp12.SmartDD__Field_Name__c = 'Group when one or more records is protected';
        lstManageRuleExp.add(manageRuleExp12);
         if((Schema.sObjectType.SmartDD__Manage_Rule_Exceptions__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Manage_Rule_Exceptions__c.fields.SmartDD__Field_Name__c.isCreateable()))
        {
        insert lstManageRuleExp;
        }
        
        /*Lead Unused Fields*/
        List<SmartDD__Lead_Unused_Fields__c> lstLeadUnusdFlds = new List<SmartDD__Lead_Unused_Fields__c>();
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds1 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds1.Name = '107';
        leadUnusdFlds1.SmartDD__Field_Name__c = 'LastModifiedDate';
        leadUnusdFlds1.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds1);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds2 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds2.Name = '40';
        leadUnusdFlds2.SmartDD__Field_Name__c = '';
        leadUnusdFlds2.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds2);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds3 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds3.Name = '14';
        leadUnusdFlds3.SmartDD__Field_Name__c = 'GeocodeAccuracy';
        leadUnusdFlds3.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds3);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds4 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds4.Name = '18';
        leadUnusdFlds4.SmartDD__Field_Name__c = 'IsConverted';
        leadUnusdFlds4.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds4);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds5 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds5.Name = '45';
        leadUnusdFlds5.SmartDD__Field_Name__c = '';
        leadUnusdFlds5.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds5);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds6 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds6.Name = '47';
        leadUnusdFlds6.SmartDD__Field_Name__c = '';
        leadUnusdFlds6.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds6);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds7 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds7.Name = '52';
        leadUnusdFlds7.SmartDD__Field_Name__c = '';
        leadUnusdFlds7.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds7);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds8 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds8.Name = '33';
        leadUnusdFlds8.SmartDD__Field_Name__c = '';
        leadUnusdFlds8.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds8);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds9 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds9.Name = '23';
        leadUnusdFlds9.SmartDD__Field_Name__c = '';
        leadUnusdFlds9.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds9);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds10 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds10.Name = '2';
        leadUnusdFlds10.SmartDD__Field_Name__c = 'ConvertedAccountId';
        leadUnusdFlds10.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds10);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds11 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds11.Name = '68';
        leadUnusdFlds11.SmartDD__Field_Name__c = '';
        leadUnusdFlds11.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds11);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds12 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds12.Name = '72';
        leadUnusdFlds12.SmartDD__Field_Name__c = '';
        leadUnusdFlds12.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds12);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds13 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds13.Name = '63';
        leadUnusdFlds13.SmartDD__Field_Name__c = '';
        leadUnusdFlds13.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds13);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds14 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds14.Name = '61';
        leadUnusdFlds14.SmartDD__Field_Name__c = '';
        leadUnusdFlds14.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds14);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds15 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds15.Name = '62';
        leadUnusdFlds15.SmartDD__Field_Name__c = '';
        leadUnusdFlds15.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds15);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds16 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds16.Name = '69';
        leadUnusdFlds16.SmartDD__Field_Name__c = '';
        leadUnusdFlds16.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds16);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds17 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds17.Name = '71';
        leadUnusdFlds17.SmartDD__Field_Name__c = '';
        leadUnusdFlds17.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds17);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds18 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds18.Name = '43';
        leadUnusdFlds18.SmartDD__Field_Name__c = '';
        leadUnusdFlds18.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds18);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds19 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds19.Name = '46';
        leadUnusdFlds19.SmartDD__Field_Name__c = '';
        leadUnusdFlds19.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds19);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds20 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds20.Name = '9';
        leadUnusdFlds20.SmartDD__Field_Name__c = '';
        leadUnusdFlds20.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds20);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds21 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds21.Name = '35';
        leadUnusdFlds21.SmartDD__Field_Name__c = '';
        leadUnusdFlds21.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds21);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds22 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds22.Name = '73';
        leadUnusdFlds22.SmartDD__Field_Name__c = '';
        leadUnusdFlds22.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds22);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds23 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds23.Name = '76';
        leadUnusdFlds23.SmartDD__Field_Name__c = '';
        leadUnusdFlds23.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds23);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds24 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds24.Name = '80';
        leadUnusdFlds24.SmartDD__Field_Name__c = '';
        leadUnusdFlds24.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds24);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds25 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds25.Name = '82';
        leadUnusdFlds25.SmartDD__Field_Name__c = '';
        leadUnusdFlds25.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds25);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds26 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds26.Name = '77';
        leadUnusdFlds26.SmartDD__Field_Name__c = '';
        leadUnusdFlds26.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds26);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds27 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds27.Name = '65';
        leadUnusdFlds27.SmartDD__Field_Name__c = '';
        leadUnusdFlds27.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds27);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds28 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds28.Name = '11';
        leadUnusdFlds28.SmartDD__Field_Name__c = 'DoNotCall';
        leadUnusdFlds28.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds28);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds29 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds29.Name = '17';
        leadUnusdFlds29.SmartDD__Field_Name__c = 'Id';
        leadUnusdFlds29.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds29);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds30 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds30.Name = '15';
        leadUnusdFlds30.SmartDD__Field_Name__c = 'HasOptedOutOfEmail';
        leadUnusdFlds30.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds30);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds31 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds31.Name = '3';
        leadUnusdFlds31.SmartDD__Field_Name__c = '';
        leadUnusdFlds31.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds31);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds32 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds32.Name = '10';
        leadUnusdFlds32.SmartDD__Field_Name__c = 'DedupeId__c';
        leadUnusdFlds32.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds32);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds33 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds33.Name = '81';
        leadUnusdFlds33.SmartDD__Field_Name__c = '';
        leadUnusdFlds33.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds33);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds34 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds34.Name = '39';
        leadUnusdFlds34.SmartDD__Field_Name__c = '';
        leadUnusdFlds34.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds34);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds35 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds35.Name = '87';
        leadUnusdFlds35.SmartDD__Field_Name__c = '';
        leadUnusdFlds35.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds35);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds36 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds36.Name = '88';
        leadUnusdFlds36.SmartDD__Field_Name__c = '';
        leadUnusdFlds36.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds36);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds37 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds37.Name = '13';
        leadUnusdFlds37.SmartDD__Field_Name__c = 'EmailBouncedReason';
        leadUnusdFlds37.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds37);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds38 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds38.Name = '22';
        leadUnusdFlds38.SmartDD__Field_Name__c = 'JigsawCompanyId';
        leadUnusdFlds38.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds38);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds39 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds39.Name = '59';
        leadUnusdFlds39.SmartDD__Field_Name__c = '';
        leadUnusdFlds39.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds39);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds40 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds40.Name = '53';
        leadUnusdFlds40.SmartDD__Field_Name__c = '';
        leadUnusdFlds40.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds40);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds41 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds41.Name = '54';
        leadUnusdFlds41.SmartDD__Field_Name__c = '';
        leadUnusdFlds41.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds41);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds42 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds42.Name = '20';
        leadUnusdFlds42.SmartDD__Field_Name__c = 'IsUnreadByOwner';
        leadUnusdFlds42.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds42);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds43 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds43.Name = '26';
        leadUnusdFlds43.SmartDD__Field_Name__c = '';
        leadUnusdFlds43.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds43);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds44 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds44.Name = '28';
        leadUnusdFlds44.SmartDD__Field_Name__c = '';
        leadUnusdFlds44.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds44);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds45 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds45.Name = '27';
        leadUnusdFlds45.SmartDD__Field_Name__c = '';
        leadUnusdFlds45.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds45);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds46 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds46.Name = '12';
        leadUnusdFlds46.SmartDD__Field_Name__c = 'EmailBouncedDate';
        leadUnusdFlds46.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds46);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds47 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds47.Name = '4';
        leadUnusdFlds47.SmartDD__Field_Name__c = '';
        leadUnusdFlds47.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds47);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds48 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds48.Name = '7';
        leadUnusdFlds48.SmartDD__Field_Name__c = '';
        leadUnusdFlds48.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds48);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds49 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds49.Name = '38';
        leadUnusdFlds49.SmartDD__Field_Name__c = '';
        leadUnusdFlds49.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds49);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds50 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds50.Name = '110';
        leadUnusdFlds50.SmartDD__Field_Name__c = 'ReportsToId';
        leadUnusdFlds50.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds50);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds51 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds51.Name = '106';
        leadUnusdFlds51.SmartDD__Field_Name__c = 'LastModifiedById';
        leadUnusdFlds51.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds51);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds52 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds52.Name = '6';
        leadUnusdFlds52.SmartDD__Field_Name__c = '';
        leadUnusdFlds52.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds52);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds53 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds53.Name = '1';
        leadUnusdFlds53.SmartDD__Field_Name__c = 'Address';
        leadUnusdFlds53.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds53);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds54 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds54.Name = '51';
        leadUnusdFlds54.SmartDD__Field_Name__c = '';
        leadUnusdFlds54.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds54);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds55 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds55.Name = '41';
        leadUnusdFlds55.SmartDD__Field_Name__c = '';
        leadUnusdFlds55.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds55);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds56 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds56.Name = '111';
        leadUnusdFlds56.SmartDD__Field_Name__c = 'DoNotCall';
        leadUnusdFlds56.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds56);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds57 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds57.Name = '104';
        leadUnusdFlds57.SmartDD__Field_Name__c = 'HasOptedOutOfFax';
        leadUnusdFlds57.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds57);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds58 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds58.Name = '24';
        leadUnusdFlds58.SmartDD__Field_Name__c = '';
        leadUnusdFlds58.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds58);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds59 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds59.Name = '55';
        leadUnusdFlds59.SmartDD__Field_Name__c = '';
        leadUnusdFlds59.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds59);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds60 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds60.Name = '56';
        leadUnusdFlds60.SmartDD__Field_Name__c = '';
        leadUnusdFlds60.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds60);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds61 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds61.Name = '50';
        leadUnusdFlds61.SmartDD__Field_Name__c = '';
        leadUnusdFlds61.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds61);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds62 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds62.Name = '105';
        leadUnusdFlds62.SmartDD__Field_Name__c = 'LastActivityDate';
        leadUnusdFlds62.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds62);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds63 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds63.Name = '102';
        leadUnusdFlds63.SmartDD__Field_Name__c = 'CreatedById';
        leadUnusdFlds63.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds63);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds64 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds64.Name = '109';
        leadUnusdFlds64.SmartDD__Field_Name__c = 'LastViewedDate';
        leadUnusdFlds64.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds64);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds65 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds65.Name = '16';
        leadUnusdFlds65.SmartDD__Field_Name__c = 'HasOptedOutOfFax';
        leadUnusdFlds65.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds65);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds66 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds66.Name = '84';
        leadUnusdFlds66.SmartDD__Field_Name__c = '';
        leadUnusdFlds66.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds66);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds67 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds67.Name = '85';
        leadUnusdFlds67.SmartDD__Field_Name__c = '';
        leadUnusdFlds67.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds67);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds68 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds68.Name = '86';
        leadUnusdFlds68.SmartDD__Field_Name__c = '';
        leadUnusdFlds68.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds68);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds69 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds69.Name = '29';
        leadUnusdFlds69.SmartDD__Field_Name__c = '';
        leadUnusdFlds69.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds69);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds70 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds70.Name = '36';
        leadUnusdFlds70.SmartDD__Field_Name__c = '';
        leadUnusdFlds70.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds70);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds71 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds71.Name = '57';
        leadUnusdFlds71.SmartDD__Field_Name__c = '';
        leadUnusdFlds71.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds71);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds72 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds72.Name = '60';
        leadUnusdFlds72.SmartDD__Field_Name__c = '';
        leadUnusdFlds72.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds72);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds73 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds73.Name = '93';
        leadUnusdFlds73.SmartDD__Field_Name__c = '';
        leadUnusdFlds73.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds73);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds74 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds74.Name = '90';
        leadUnusdFlds74.SmartDD__Field_Name__c = '';
        leadUnusdFlds74.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds74);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds75 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds75.Name = '89';
        leadUnusdFlds75.SmartDD__Field_Name__c = '';
        leadUnusdFlds75.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds75);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds76 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds76.Name = '30';
        leadUnusdFlds76.SmartDD__Field_Name__c = '';
        leadUnusdFlds76.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds76);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds77 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds77.Name = '94';
        leadUnusdFlds77.SmartDD__Field_Name__c = '';
        leadUnusdFlds77.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds77);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds78 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds78.Name = '32';
        leadUnusdFlds78.SmartDD__Field_Name__c = '';
        leadUnusdFlds78.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds78);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds79 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds79.Name = '42';
        leadUnusdFlds79.SmartDD__Field_Name__c = '';
        leadUnusdFlds79.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds79);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds80 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds80.Name = '49';
        leadUnusdFlds80.SmartDD__Field_Name__c = '';
        leadUnusdFlds80.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds80);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds81 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds81.Name = '58';
        leadUnusdFlds81.SmartDD__Field_Name__c = '';
        leadUnusdFlds81.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds81);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds82 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds82.Name = '48';
        leadUnusdFlds82.SmartDD__Field_Name__c = '';
        leadUnusdFlds82.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds82);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds83 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds83.Name = '25';
        leadUnusdFlds83.SmartDD__Field_Name__c = '';
        leadUnusdFlds83.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds83);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds84 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds84.Name = '34';
        leadUnusdFlds84.SmartDD__Field_Name__c = '';
        leadUnusdFlds84.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds84);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds85 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds85.Name = '8';
        leadUnusdFlds85.SmartDD__Field_Name__c = '';
        leadUnusdFlds85.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds85);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds86 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds86.Name = '44';
        leadUnusdFlds86.SmartDD__Field_Name__c = '';
        leadUnusdFlds86.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds86);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds87 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds87.Name = '74';
        leadUnusdFlds87.SmartDD__Field_Name__c = '';
        leadUnusdFlds87.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds87);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds88 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds88.Name = '79';
        leadUnusdFlds88.SmartDD__Field_Name__c = '';
        leadUnusdFlds88.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds88);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds89 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds89.Name = '66';
        leadUnusdFlds89.SmartDD__Field_Name__c = '';
        leadUnusdFlds89.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds89);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds90 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds90.Name = '67';
        leadUnusdFlds90.SmartDD__Field_Name__c = '';
        leadUnusdFlds90.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds90);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds91 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds91.Name = '21';
        leadUnusdFlds91.SmartDD__Field_Name__c = 'Jigsaw';
        leadUnusdFlds91.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds91);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds92 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds92.Name = '5';
        leadUnusdFlds92.SmartDD__Field_Name__c = '';
        leadUnusdFlds92.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds92);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds93 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds93.Name = '31';
        leadUnusdFlds93.SmartDD__Field_Name__c = '';
        leadUnusdFlds93.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds93);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds94 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds94.Name = '70';
        leadUnusdFlds94.SmartDD__Field_Name__c = '';
        leadUnusdFlds94.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds94);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds95 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds95.Name = '75';
        leadUnusdFlds95.SmartDD__Field_Name__c = '';
        leadUnusdFlds95.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds95);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds96 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds96.Name = '78';
        leadUnusdFlds96.SmartDD__Field_Name__c = '';
        leadUnusdFlds96.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds96);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds97 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds97.Name = '64';
        leadUnusdFlds97.SmartDD__Field_Name__c = '';
        leadUnusdFlds97.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds97);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds98 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds98.Name = '37';
        leadUnusdFlds98.SmartDD__Field_Name__c = '';
        leadUnusdFlds98.SmartDD__Object_Name__c = '';
        lstLeadUnusdFlds.add(leadUnusdFlds98);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds99 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds99.Name = '19';
        leadUnusdFlds99.SmartDD__Field_Name__c = '';
        leadUnusdFlds99.SmartDD__Object_Name__c = 'Lead';
        lstLeadUnusdFlds.add(leadUnusdFlds99);
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds100 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds100.Name = '103';
        leadUnusdFlds100.SmartDD__Field_Name__c = '';
        leadUnusdFlds100.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds100);
        
        SmartDD__Lead_Unused_Fields__c leadUnusdFlds101 = new SmartDD__Lead_Unused_Fields__c();
        leadUnusdFlds101.Name = '108';
        leadUnusdFlds101.SmartDD__Field_Name__c = 'LastReferencedDate';
        leadUnusdFlds101.SmartDD__Object_Name__c = 'Contact';
        lstLeadUnusdFlds.add(leadUnusdFlds101);
        if((Schema.sObjectType.SmartDD__Lead_Unused_Fields__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Lead_Unused_Fields__c.fields.SmartDD__Field_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Lead_Unused_Fields__c.fields.SmartDD__Object_Name__c.isCreateable()))
        {
        insert lstLeadUnusdFlds;
        }
        
        
        /* Master Record Selection */
        List<SmartDD__Master_Record_Selection__c> lstMstrRecSel = new List<SmartDD__Master_Record_Selection__c>();
        SmartDD__Master_Record_Selection__c mstrRecSel1 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel1.Name = 'Highest Value In Given Field';
        mstrRecSel1.SmartDD__Field_Name__c = 'Highest value in the user-defined field';
        lstMstrRecSel.add(mstrRecSel1);
        SmartDD__Master_Record_Selection__c mstrRecSel2 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel2.Name = 'First Record With A Value';
        mstrRecSel2.SmartDD__Field_Name__c = 'First Record With A Value in the user-defined field';
        lstMstrRecSel.add(mstrRecSel2);
        SmartDD__Master_Record_Selection__c mstrRecSel3 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel3.Name = 'Lowest Value In Given Field';
        mstrRecSel3.SmartDD__Field_Name__c = 'Lowest value in the user-defined field';
        lstMstrRecSel.add(mstrRecSel3);
        SmartDD__Master_Record_Selection__c mstrRecSel4 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel4.Name = 'Protected Record';
        mstrRecSel4.SmartDD__Field_Name__c = 'Protected Record';
        lstMstrRecSel.add(mstrRecSel4);
        SmartDD__Master_Record_Selection__c mstrRecSel5 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel5.Name = 'Most Notes & Attchments';
        mstrRecSel5.SmartDD__Field_Name__c = 'Most notes, attachments, activities, etc.';
        lstMstrRecSel.add(mstrRecSel5);
        SmartDD__Master_Record_Selection__c mstrRecSel6 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel6.Name = 'Oldest By Given Date Field';
        mstrRecSel6.SmartDD__Field_Name__c = 'Oldest by the given date field';
        lstMstrRecSel.add(mstrRecSel6);
        SmartDD__Master_Record_Selection__c mstrRecSel7 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel7.Name = 'First Record';
        mstrRecSel7.SmartDD__Field_Name__c = 'First Record';
        lstMstrRecSel.add(mstrRecSel7);
        SmartDD__Master_Record_Selection__c mstrRecSel8 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel8.Name = 'Prioritized On The Given Field Value';
        mstrRecSel8.SmartDD__Field_Name__c = 'Prioritized on the given field and values';
        lstMstrRecSel.add(mstrRecSel8);
        SmartDD__Master_Record_Selection__c mstrRecSel9 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel9.Name = 'Most Complete Record';
        mstrRecSel9.SmartDD__Field_Name__c = 'Most Complete Record';
        lstMstrRecSel.add(mstrRecSel9);
        SmartDD__Master_Record_Selection__c mstrRecSel10 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel10.Name = 'Newest By Given Date Field';
        mstrRecSel10.SmartDD__Field_Name__c = 'Newest by the given date field';
        lstMstrRecSel.add(mstrRecSel10);
        SmartDD__Master_Record_Selection__c mstrRecSel11 = new SmartDD__Master_Record_Selection__c();
        mstrRecSel11.Name = 'Record Not On Specified Ignore List';
        mstrRecSel11.SmartDD__Field_Name__c = 'Record with field value not on specified ignore list';
        lstMstrRecSel.add(mstrRecSel11);
         if((Schema.sObjectType.SmartDD__Master_Record_Selection__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Master_Record_Selection__c.fields.SmartDD__Field_Name__c.isCreateable()))
        {
        insert lstMstrRecSel;
        }
        
        
        /*Review and Polish Unused Fields */
        List<SmartDD__Review_and_Polish_Unused_Fields__c> lstRvwPlsUnusdFlds = new List<SmartDD__Review_and_Polish_Unused_Fields__c>();
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds1 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds1.Name = '48';
        rvwPlsUnusdFlds1.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds1.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds1);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds2 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds2.Name = '24';
        rvwPlsUnusdFlds2.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds2.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds2);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds3 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds3.Name = '27';
        rvwPlsUnusdFlds3.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds3.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds3);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds4 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds4.Name = '31';
        rvwPlsUnusdFlds4.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds4.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds4);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds5 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds5.Name = '54';
        rvwPlsUnusdFlds5.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds5.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds5);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds6 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds6.Name = '37';
        rvwPlsUnusdFlds6.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds6.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds6);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds7 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds7.Name = '36';
        rvwPlsUnusdFlds7.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds7.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds7);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds8 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds8.Name = '38';
        rvwPlsUnusdFlds8.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds8.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds8);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds9 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds9.Name = '64';
        rvwPlsUnusdFlds9.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds9.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds9);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds10 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds10.Name = '56';
        rvwPlsUnusdFlds10.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds10.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds10);
        
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds11 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds11.Name = '55';
        rvwPlsUnusdFlds11.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds11.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds11);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds12 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds12.Name = '61';
        rvwPlsUnusdFlds12.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds12.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds12);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds13 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds13.Name = '62';
        rvwPlsUnusdFlds13.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds13.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds13);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds14 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds14.Name = '66';
        rvwPlsUnusdFlds14.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds14.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds14);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds15 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds15.Name = '68';
        rvwPlsUnusdFlds15.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds15.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds15);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds16 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds16.Name = '57';
        rvwPlsUnusdFlds16.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds16.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds16);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds17 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds17.Name = '63';
        rvwPlsUnusdFlds17.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds17.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds17);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds18 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds18.Name = '60';
        rvwPlsUnusdFlds18.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds18.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds18);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds19 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds19.Name = '58';
        rvwPlsUnusdFlds19.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds19.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds19);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds20 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds20.Name = '59';
        rvwPlsUnusdFlds20.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds20.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds20);
        
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds21 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds21.Name = '65';
        rvwPlsUnusdFlds21.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds21.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds21);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds22 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds22.Name = '67';
        rvwPlsUnusdFlds22.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds22.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds22);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds23 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds23.Name = '10';
        rvwPlsUnusdFlds23.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds23.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds23);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds24 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds24.Name = '23';
        rvwPlsUnusdFlds24.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds24.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds24);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds25 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds25.Name = '2';
        rvwPlsUnusdFlds25.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds25.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds25);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds26 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds26.Name = '30';
        rvwPlsUnusdFlds26.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds26.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds26);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds27 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds27.Name = '21';
        rvwPlsUnusdFlds27.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds27.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds27);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds28 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds28.Name = '9';
        rvwPlsUnusdFlds28.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds28.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds28);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds29 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds29.Name = '6';
        rvwPlsUnusdFlds29.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds29.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds29);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds30 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds30.Name = '5';
        rvwPlsUnusdFlds30.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds30.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds30);
        
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds31 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds31.Name = '29';
        rvwPlsUnusdFlds31.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds31.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds31);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds32 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds32.Name = '13';
        rvwPlsUnusdFlds32.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds32.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds32);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds33 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds33.Name = '25';
        rvwPlsUnusdFlds33.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds33.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds33);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds34 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds34.Name = '39';
        rvwPlsUnusdFlds34.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds34.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds34);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds35 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds35.Name = '40';
        rvwPlsUnusdFlds35.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds35.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds35);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds36 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds36.Name = '41';
        rvwPlsUnusdFlds36.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds36.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds36);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds37 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds37.Name = '50';
        rvwPlsUnusdFlds37.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds37.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds37);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds38 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds38.Name = '69';
        rvwPlsUnusdFlds38.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds38.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds38);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds39 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds39.Name = '1';
        rvwPlsUnusdFlds39.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds39.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds39);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds40 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds40.Name = '14';
        rvwPlsUnusdFlds40.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds40.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds40);
        
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds41 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds41.Name = '43';
        rvwPlsUnusdFlds41.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds41.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds41);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds42 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds42.Name = '42';
        rvwPlsUnusdFlds42.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds42.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds42);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds43 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds43.Name = '32';
        rvwPlsUnusdFlds43.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds43.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds43);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds44 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds44.Name = '19';
        rvwPlsUnusdFlds44.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds44.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds44);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds45 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds45.Name = '11';
        rvwPlsUnusdFlds45.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds45.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds45);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds46 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds46.Name = '3';
        rvwPlsUnusdFlds46.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds46.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds46);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds47 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds47.Name = '4';
        rvwPlsUnusdFlds47.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds47.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds47);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds48 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds48.Name = '47';
        rvwPlsUnusdFlds48.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds48.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds48);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds49 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds49.Name = '46';
        rvwPlsUnusdFlds49.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds49.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds49);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds50 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds50.Name = '7';
        rvwPlsUnusdFlds50.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds50.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds50);
        
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds51 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds51.Name = '28';
        rvwPlsUnusdFlds51.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds51.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds51);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds52 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds52.Name = '8';
        rvwPlsUnusdFlds52.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds52.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds52);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds53 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds53.Name = '49';
        rvwPlsUnusdFlds53.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds53.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds53);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds54 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds54.Name = '15';
        rvwPlsUnusdFlds54.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds54.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds54);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds55 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds55.Name = '17';
        rvwPlsUnusdFlds55.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds55.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds55);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds56 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds56.Name = '26';
        rvwPlsUnusdFlds56.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds56.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds56);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds57 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds57.Name = '52';
        rvwPlsUnusdFlds57.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds57.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds57);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds58 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds58.Name = '51';
        rvwPlsUnusdFlds58.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds58.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds58);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds59 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds59.Name = '35';
        rvwPlsUnusdFlds59.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds59.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds59);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds60 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds60.Name = '53';
        rvwPlsUnusdFlds60.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds60.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds60);
        
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds61 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds61.Name = '34';
        rvwPlsUnusdFlds61.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds61.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds61);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds62 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds62.Name = '33';
        rvwPlsUnusdFlds62.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds62.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds62);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds63 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds63.Name = '45';
        rvwPlsUnusdFlds63.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds63.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds63);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds64 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds64.Name = '22';
        rvwPlsUnusdFlds64.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds64.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds64);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds65 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds65.Name = '12';
        rvwPlsUnusdFlds65.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds65.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds65);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds66 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds66.Name = '20';
        rvwPlsUnusdFlds66.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds66.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds66);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds67 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds67.Name = '18';
        rvwPlsUnusdFlds67.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds67.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds67);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds68 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds68.Name = '16';
        rvwPlsUnusdFlds68.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds68.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds68);
        SmartDD__Review_and_Polish_Unused_Fields__c rvwPlsUnusdFlds69 = new SmartDD__Review_and_Polish_Unused_Fields__c();
        rvwPlsUnusdFlds69.Name = '44';
        rvwPlsUnusdFlds69.SmartDD__Field_Name__c = '';
        rvwPlsUnusdFlds69.SmartDD__Object_Name__c = '';
        lstRvwPlsUnusdFlds.add(rvwPlsUnusdFlds69);
        if((Schema.sObjectType.SmartDD__Review_and_Polish_Unused_Fields__c.fields.Name.isCreateable())||
           (Schema.sObjectType.SmartDD__Review_and_Polish_Unused_Fields__c.fields.SmartDD__Field_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Review_and_Polish_Unused_Fields__c.fields.SmartDD__Object_Name__c.isCreateable()))
        {
        insert lstRvwPlsUnusdFlds;
        }
        
        /*Merge Specific Field Values*/
        List<SmartDD__Merge_Specific_Field_Values__c> lstMergeSpcFlds = new List<SmartDD__Merge_Specific_Field_Values__c>();
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds1 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds1.Name = 'MSF-0000';
        mergeSpcFlds1.SmartDD__Field_API_Name__c = 'AnnualRevenue';
        mergeSpcFlds1.SmartDD__Field_Name__c = 'AnnualRevenue';
        mergeSpcFlds1.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds1.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds1);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds2 = new SmartDD__Merge_Specific_Field_Values__c();
        // mergeSpcFlds2.Name = 'MSF-0001';
        mergeSpcFlds2.SmartDD__Field_API_Name__c = 'City';
        mergeSpcFlds2.SmartDD__Field_Name__c = 'City';
        mergeSpcFlds2.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds2.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds2);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds3 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds3.Name = 'MSF-0002';
        mergeSpcFlds3.SmartDD__Field_API_Name__c = 'Country';
        mergeSpcFlds3.SmartDD__Field_Name__c = 'Country';
        mergeSpcFlds3.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds3.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds3);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds4 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds4.Name = 'MSF-0003';
        mergeSpcFlds4.SmartDD__Field_API_Name__c = 'Email';
        mergeSpcFlds4.SmartDD__Field_Name__c = 'Email';
        mergeSpcFlds4.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds4.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds4);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds5 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds5.Name = 'MSF-0004';  
        mergeSpcFlds5.SmartDD__Field_API_Name__c = 'FirstName';
        mergeSpcFlds5.SmartDD__Field_Name__c = 'FirstName';
        mergeSpcFlds5.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds5.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds5);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds6 = new SmartDD__Merge_Specific_Field_Values__c();
        // mergeSpcFlds6.Name = 'MSF-0005'; 
        mergeSpcFlds6.SmartDD__Field_API_Name__c = 'Industry';
        mergeSpcFlds6.SmartDD__Field_Name__c = 'Industry';
        mergeSpcFlds6.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds6.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds6);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds7 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds7.Name = 'MSF-0006'; 
        mergeSpcFlds7.SmartDD__Field_API_Name__c = 'LastName';
        mergeSpcFlds7.SmartDD__Field_Name__c = 'LastName';
        mergeSpcFlds7.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds7.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds7);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds8 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds8.Name = 'MSF-0007'; 
        mergeSpcFlds8.SmartDD__Field_API_Name__c = 'LeadSource';
        mergeSpcFlds8.SmartDD__Field_Name__c = 'LeadSource';
        mergeSpcFlds8.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds8.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds8);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds9 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds9.Name = 'MSF-0008';  
        mergeSpcFlds9.SmartDD__Field_API_Name__c = 'Name';
        mergeSpcFlds9.SmartDD__Field_Name__c = 'Name';
        mergeSpcFlds9.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds9.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds9);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds10 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds10.Name = 'MSF-0009'; 
        mergeSpcFlds10.SmartDD__Field_API_Name__c = 'NumberOfEmployees';
        mergeSpcFlds10.SmartDD__Field_Name__c = 'NumberOfEmployees';
        mergeSpcFlds10.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds10.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds10);
        
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds11 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds11.Name = 'MSF-0010'; 
        mergeSpcFlds11.SmartDD__Field_API_Name__c = 'Phone';
        mergeSpcFlds11.SmartDD__Field_Name__c = 'Phone';
        mergeSpcFlds11.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds11.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds11);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds12 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds12.Name = 'MSF-0011'; 
        mergeSpcFlds12.SmartDD__Field_API_Name__c = 'PostalCode';
        mergeSpcFlds12.SmartDD__Field_Name__c = 'PostalCode';
        mergeSpcFlds12.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds12.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds12);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds13 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds13.Name = 'MSF-0012'; 
        mergeSpcFlds13.SmartDD__Field_API_Name__c = 'Rating';
        mergeSpcFlds13.SmartDD__Field_Name__c = 'Rating';
        mergeSpcFlds13.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds13.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds13);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds14 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds14.Name = 'MSF-0013'; 
        mergeSpcFlds14.SmartDD__Field_API_Name__c = 'Salutation';
        mergeSpcFlds14.SmartDD__Field_Name__c = 'Salutation';
        mergeSpcFlds14.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds14.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds14);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds15 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds15.Name = 'MSF-0014'; 
        mergeSpcFlds15.SmartDD__Field_API_Name__c = 'State';
        mergeSpcFlds15.SmartDD__Field_Name__c = 'State';
        mergeSpcFlds15.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds15.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds15);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds16 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds16.Name = 'MSF-0015'; 
        mergeSpcFlds16.SmartDD__Field_API_Name__c = 'Status';
        mergeSpcFlds16.SmartDD__Field_Name__c = 'Status';
        mergeSpcFlds16.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds16.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds16);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds17 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds17.Name = 'MSF-0016'; 
        mergeSpcFlds17.SmartDD__Field_API_Name__c = 'Street';
        mergeSpcFlds17.SmartDD__Field_Name__c = 'Street';
        mergeSpcFlds17.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds17.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds17);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds18 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds18.Name = 'MSF-0017'; 
        mergeSpcFlds18.SmartDD__Field_API_Name__c = 'Website';
        mergeSpcFlds18.SmartDD__Field_Name__c = 'Website';
        mergeSpcFlds18.SmartDD__Object_Name__c = 'Lead';
        mergeSpcFlds18.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds18);
        
        
        // Account Field Record
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds19 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds19.Name = 'MSF-0019';
        mergeSpcFlds19.SmartDD__Field_API_Name__c = 'AnnualRevenue';
        mergeSpcFlds19.SmartDD__Field_Name__c = 'AnnualRevenue';
        mergeSpcFlds19.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds19.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds19);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds20 = new SmartDD__Merge_Specific_Field_Values__c();
        // mergeSpcFlds20.Name = 'MSF-0020';
        mergeSpcFlds20.SmartDD__Field_API_Name__c = 'City';
        mergeSpcFlds20.SmartDD__Field_Name__c = 'City';
        mergeSpcFlds20.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds20.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds20);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds21 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds21.Name = 'MSF-0021';
        mergeSpcFlds21.SmartDD__Field_API_Name__c = 'Country';
        mergeSpcFlds21.SmartDD__Field_Name__c = 'Country';
        mergeSpcFlds21.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds21.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds21);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds22 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds22.Name = 'MSF-0022';
        mergeSpcFlds22.SmartDD__Field_API_Name__c = 'Email';
        mergeSpcFlds22.SmartDD__Field_Name__c = 'Email';
        mergeSpcFlds22.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds22.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds22);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds23 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds23.Name = 'MSF-0023';  
        mergeSpcFlds23.SmartDD__Field_API_Name__c = 'FirstName';
        mergeSpcFlds23.SmartDD__Field_Name__c = 'FirstName';
        mergeSpcFlds23.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds23.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds23);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds24 = new SmartDD__Merge_Specific_Field_Values__c();
        // mergeSpcFlds24.Name = 'MSF-0024'; 
        mergeSpcFlds24.SmartDD__Field_API_Name__c = 'Industry';
        mergeSpcFlds24.SmartDD__Field_Name__c = 'Industry';
        mergeSpcFlds24.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds24.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds24);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds25 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds25.Name = 'MSF-0025'; 
        mergeSpcFlds25.SmartDD__Field_API_Name__c = 'LastName';
        mergeSpcFlds25.SmartDD__Field_Name__c = 'LastName';
        mergeSpcFlds25.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds25.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds25);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds26 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds26.Name = 'MSF-0026'; 
        mergeSpcFlds26.SmartDD__Field_API_Name__c = 'LeadSource';
        mergeSpcFlds26.SmartDD__Field_Name__c = 'LeadSource';
        mergeSpcFlds26.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds26.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds26);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds27 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds27.Name = 'MSF-0027';  
        mergeSpcFlds27.SmartDD__Field_API_Name__c = 'Name';
        mergeSpcFlds27.SmartDD__Field_Name__c = 'Name';
        mergeSpcFlds27.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds27.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds27);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds28 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds28.Name = 'MSF-0028'; 
        mergeSpcFlds28.SmartDD__Field_API_Name__c = 'NumberOfEmployees';
        mergeSpcFlds28.SmartDD__Field_Name__c = 'NumberOfEmployees';
        mergeSpcFlds28.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds28.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds28);        
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds29 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds29.Name = 'MSF-0029'; 
        mergeSpcFlds29.SmartDD__Field_API_Name__c = 'Phone';
        mergeSpcFlds29.SmartDD__Field_Name__c = 'Phone';
        mergeSpcFlds29.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds29.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds29);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds30 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds30.Name = 'MSF-0030'; 
        mergeSpcFlds30.SmartDD__Field_API_Name__c = 'PostalCode';
        mergeSpcFlds30.SmartDD__Field_Name__c = 'PostalCode';
        mergeSpcFlds30.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds30.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds30);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds31 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds31.Name = 'MSF-0031'; 
        mergeSpcFlds31.SmartDD__Field_API_Name__c = 'Rating';
        mergeSpcFlds31.SmartDD__Field_Name__c = 'Rating';
        mergeSpcFlds31.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds31.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds31);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds32 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds32.Name = 'MSF-0032'; 
        mergeSpcFlds32.SmartDD__Field_API_Name__c = 'Salutation';
        mergeSpcFlds32.SmartDD__Field_Name__c = 'Salutation';
        mergeSpcFlds32.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds32.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds32);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds33 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds33.Name = 'MSF-0033'; 
        mergeSpcFlds33.SmartDD__Field_API_Name__c = 'State';
        mergeSpcFlds33.SmartDD__Field_Name__c = 'State';
        mergeSpcFlds33.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds33.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds33);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds34 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds34.Name = 'MSF-0034'; 
        mergeSpcFlds34.SmartDD__Field_API_Name__c = 'Status';
        mergeSpcFlds34.SmartDD__Field_Name__c = 'Status';
        mergeSpcFlds34.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds34.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds34);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds35 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds35.Name = 'MSF-0035'; 
        mergeSpcFlds35.SmartDD__Field_API_Name__c = 'Street';
        mergeSpcFlds35.SmartDD__Field_Name__c = 'Street';
        mergeSpcFlds35.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds35.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds35);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds36 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds36.Name = 'MSF-0036'; 
        mergeSpcFlds36.SmartDD__Field_API_Name__c = 'Website';
        mergeSpcFlds36.SmartDD__Field_Name__c = 'Website';
        mergeSpcFlds36.SmartDD__Object_Name__c = 'Account';
        mergeSpcFlds36.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds36);
        
        
        
         // Contact Field Record
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds37 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds37.Name = 'MSF-0037';
        mergeSpcFlds37.SmartDD__Field_API_Name__c = 'AnnualRevenue';
        mergeSpcFlds37.SmartDD__Field_Name__c = 'AnnualRevenue';
        mergeSpcFlds37.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds37.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds37);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds38 = new SmartDD__Merge_Specific_Field_Values__c();
        // mergeSpcFlds38.Name = 'MSF-0038';
        mergeSpcFlds38.SmartDD__Field_API_Name__c = 'City';
        mergeSpcFlds38.SmartDD__Field_Name__c = 'City';
        mergeSpcFlds38.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds38.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds38);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds39 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds39.Name = 'MSF-0039';
        mergeSpcFlds39.SmartDD__Field_API_Name__c = 'Country';
        mergeSpcFlds39.SmartDD__Field_Name__c = 'Country';
        mergeSpcFlds39.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds39.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds39);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds40 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds40.Name = 'MSF-0040';
        mergeSpcFlds40.SmartDD__Field_API_Name__c = 'Email';
        mergeSpcFlds40.SmartDD__Field_Name__c = 'Email';
        mergeSpcFlds40.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds40.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds40);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds41 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds41.Name = 'MSF-0041';  
        mergeSpcFlds41.SmartDD__Field_API_Name__c = 'FirstName';
        mergeSpcFlds41.SmartDD__Field_Name__c = 'FirstName';
        mergeSpcFlds41.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds41.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds41);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds42 = new SmartDD__Merge_Specific_Field_Values__c();
        // mergeSpcFlds42.Name = 'MSF-0042'; 
        mergeSpcFlds42.SmartDD__Field_API_Name__c = 'Industry';
        mergeSpcFlds42.SmartDD__Field_Name__c = 'Industry';
        mergeSpcFlds42.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds42.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds42);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds43 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds43.Name = 'MSF-0043'; 
        mergeSpcFlds43.SmartDD__Field_API_Name__c = 'LastName';
        mergeSpcFlds43.SmartDD__Field_Name__c = 'LastName';
        mergeSpcFlds43.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds43.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds43);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds44 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds44.Name = 'MSF-0044'; 
        mergeSpcFlds44.SmartDD__Field_API_Name__c = 'LeadSource';
        mergeSpcFlds44.SmartDD__Field_Name__c = 'LeadSource';
        mergeSpcFlds44.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds44.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds44);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds45 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds45.Name = 'MSF-0045';  
        mergeSpcFlds45.SmartDD__Field_API_Name__c = 'Name';
        mergeSpcFlds45.SmartDD__Field_Name__c = 'Name';
        mergeSpcFlds45.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds45.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds45);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds46 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds46.Name = 'MSF-0046'; 
        mergeSpcFlds46.SmartDD__Field_API_Name__c = 'NumberOfEmployees';
        mergeSpcFlds46.SmartDD__Field_Name__c = 'NumberOfEmployees';
        mergeSpcFlds46.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds46.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds46);        
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds47 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds47.Name = 'MSF-0047'; 
        mergeSpcFlds47.SmartDD__Field_API_Name__c = 'Phone';
        mergeSpcFlds47.SmartDD__Field_Name__c = 'Phone';
        mergeSpcFlds47.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds47.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds47);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds48 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds48.Name = 'MSF-0048'; 
        mergeSpcFlds48.SmartDD__Field_API_Name__c = 'PostalCode';
        mergeSpcFlds48.SmartDD__Field_Name__c = 'PostalCode';
        mergeSpcFlds48.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds48.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds48);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds49 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds49.Name = 'MSF-0049'; 
        mergeSpcFlds49.SmartDD__Field_API_Name__c = 'Rating';
        mergeSpcFlds49.SmartDD__Field_Name__c = 'Rating';
        mergeSpcFlds49.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds49.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds49);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds50 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds50.Name = 'MSF-0050'; 
        mergeSpcFlds50.SmartDD__Field_API_Name__c = 'Salutation';
        mergeSpcFlds50.SmartDD__Field_Name__c = 'Salutation';
        mergeSpcFlds50.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds50.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds50);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds51 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds51.Name = 'MSF-0051'; 
        mergeSpcFlds51.SmartDD__Field_API_Name__c = 'State';
        mergeSpcFlds51.SmartDD__Field_Name__c = 'State';
        mergeSpcFlds51.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds51.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds51);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds52 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds52.Name = 'MSF-0052'; 
        mergeSpcFlds52.SmartDD__Field_API_Name__c = 'Status';
        mergeSpcFlds52.SmartDD__Field_Name__c = 'Status';
        mergeSpcFlds52.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds52.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds52);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds53 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds53.Name = 'MSF-0053'; 
        mergeSpcFlds53.SmartDD__Field_API_Name__c = 'Street';
        mergeSpcFlds53.SmartDD__Field_Name__c = 'Street';
        mergeSpcFlds53.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds53.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds53);
        SmartDD__Merge_Specific_Field_Values__c mergeSpcFlds54 = new SmartDD__Merge_Specific_Field_Values__c();
        //mergeSpcFlds54.Name = 'MSF-0054'; 
        mergeSpcFlds54.SmartDD__Field_API_Name__c = 'Website';
        mergeSpcFlds54.SmartDD__Field_Name__c = 'Website';
        mergeSpcFlds54.SmartDD__Object_Name__c = 'Contact';
        mergeSpcFlds54.SmartDD__Specific_Field_Rules__c = 'Most Common;Ignore all values: update to blank or to given value;Newest (ordered by MODIFIED date);Prioritized by values;Combined list;Oldest (ordered by CREATE date);Newest (ordered by CREATE date);Oldest (ordered by MODIFIED date);Highest (numeric);Lowest (numeric);Sum (numeric);Override Master Value with value not on ignore list;Preserve Master Value if not on ignore list;Newest (ordered by date field);Oldest (ordered by date field);Field with max characters;System Determined';
        lstMergeSpcFlds.add(mergeSpcFlds54);
        
        
         if((Schema.sObjectType.SmartDD__Merge_Specific_Field_Values__c.fields.SmartDD__Field_API_Name__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Merge_Specific_Field_Values__c.fields.SmartDD__Field_Name__c.isCreateable())||
            (Schema.sObjectType.SmartDD__Merge_Specific_Field_Values__c.fields.SmartDD__Specific_Field_Rules__c.isCreateable())||
           (Schema.sObjectType.SmartDD__Merge_Specific_Field_Values__c.fields.SmartDD__Object_Name__c.isCreateable()))
        {
        insert lstMergeSpcFlds;
        }
    }  
}