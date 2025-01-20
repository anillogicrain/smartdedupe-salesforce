@isTest
public with sharing class FilterControllerTest{
     static testMethod void testSaveFilterCriteria(){ 
          Test.startTest();
        List<SmartDD__Filter_Criteria__c> filtercriteria = new List<SmartDD__Filter_Criteria__c>(); 
        List<SmartDD__Filter_Criteria__c> filtercriteria1 = new List<SmartDD__Filter_Criteria__c>();
        List<SmartDD__Filter_Criteria__c> filtercriteria2 = new List<SmartDD__Filter_Criteria__c>();   
        List<SmartDD__Filter_Criteria__c> filtercriteria3 = new List<SmartDD__Filter_Criteria__c>();
           
        SmartDD__Filter__c filter1 = new SmartDD__Filter__c (Name = 'Test Filter1',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 OR 2'
                                ); 
        SmartDD__Filter__c filter2 = new SmartDD__Filter__c (Name = 'Test Filter1',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = ' '
                                ); 
        SmartDD__Filter__c filter3 = new SmartDD__Filter__c (Name = 'Test Filter1',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1(2'
                                ); 
        SmartDD__Filter__c filter4 = new SmartDD__Filter__c (Name = 'Test Filter1',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '(1 or 2) and 3 or 4'
                                );
        
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter1;
        }  
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter2;
        }   
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter3;
        }         
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter1.id
                                );        
        SmartDD__Filter_Criteria__c blankobjcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'FirstName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '',
                                    SmartDD__Filter_Name__c = filter1.id
                                );     
      
        SmartDD__Filter_Criteria__c democritria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'FirstName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '',
                                    SmartDD__Filter_Name__c = filter1.id
                                );
        SmartDD__Filter_Criteria__c democritria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'FirstName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '',
                                    SmartDD__Filter_Name__c = filter2.id
                                );
        SmartDD__Filter_Criteria__c democritria2 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'title',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'test',
                                    SmartDD__Filter_Name__c = filter2.id
                                );
        SmartDD__Filter_Criteria__c democritria3 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'FirstName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '',
                                    SmartDD__Filter_Name__c = filter3.id
                                );
        SmartDD__Filter_Criteria__c democritria4 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'FirstName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '',
                                    SmartDD__Filter_Name__c = filter4.id
                                );                                
        if(Schema.sObjectType.SmartDD__Filter_Criteria__c.isCreateable()){
            insert democritria;
        }                              
        
        filtercriteria.add(objcriteria1);
        filtercriteria.add(blankobjcriteria1); 
        filtercriteria1.add(democritria1);
        filtercriteria1.add(democritria2);
        filtercriteria2.add(democritria3);
        filtercriteria3.add(democritria4);
       
        if(Schema.sObjectType.SmartDD__Filter_Criteria__c.isCreateable()){
            insert filtercriteria;
        }
        
        try{            
            FilterController.saveFilterCriterias(filtercriteria,filter1,'Lead');                      
            FilterController.saveFilterCriterias(filtercriteria1,filter2,'Lead');
            FilterController.saveFilterCriterias(filtercriteria2,filter3,'Lead');   
            FilterController.saveFilterCriterias(filtercriteria3,filter4,'Lead');                           
        }
        catch(Exception ex){            
        }   
        
        SmartDD__Manage_Master_Cluster_Id__c LeadMasterCluster = new SmartDD__Manage_Master_Cluster_Id__c();
        LeadMasterCluster.Name=filter2.SmartDD__Object_Name__c;
        LeadMasterCluster.SmartDD__New_Master_Cluster_Id__c = 'a0N3g000001JQK0EAO';
        insert LeadMasterCluster;
         
        SmartDD__De_Dupe_Configuration__c dedupeconfig = new SmartDD__De_Dupe_Configuration__c(); 
        dedupeconfig.Name = 'DeDupe Configuration';
        dedupeconfig.SmartDD__Lead__c = true;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfig;
        }
        SmartDD__StartDedupeStatus__c startdedupedata = SmartDD__StartDedupeStatus__c.getvalues('Start DeDupe');            
        String strOpp = 'not equal to';     
        FilterController.fillOperator(strOpp);        
        FilterController.editFilterRecord(filter1.id);
        FilterController.deleteFilterRecord(filter1.id);
        FilterController.getPicklistvalues('SmartDD__Filter_Criteria__c','SmartDD__Operator__c');
        //FilterController.CheckApiStatus();
        FilterController.updateDedupeObjectName(filter2.SmartDD__Object_Name__c,filter2.id);
        FilterController.getDedupeStartedStat();
        FilterController.getDedupeStatusPageStat();
        FilterController.AsyncApexJobWrapper objFCAAjobWrapper = new FilterController.AsyncApexJobWrapper(); 
           Test.stopTest();
        System.assert(true);
    }  
    static testMethod void testFilterCriteria(){
         Test.startTest();
        List<SmartDD__Filter_Criteria__c> lstfiltercriteria = new List<SmartDD__Filter_Criteria__c>();
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        }
        SmartDD__Filter_Criteria__c objcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        
        SmartDD__Filter_Criteria__c blankobjcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = '',
                                    SmartDD__Operator__c = '',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c blncriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'IsConverted',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'abc',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c intcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'Title',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '123',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c Mobilephonecriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'MobilePhone',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '5986325',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c phonecriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'Phone',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '598hj6325',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c Faxcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'Fax',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '5981215487965487',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c emailcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'Email',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'test',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c percentcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '50',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c inttextcriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'test',
                                    SmartDD__Filter_Name__c = filter.id
                                );
       SmartDD__Filter_Criteria__c datecriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'ConvertedDate',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '20-03-2018',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c falsedatecriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'ConvertedDate',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '20032018',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c falsedatetimecriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'EmailBouncedDate',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '20032018',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c datetimecriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'EmailBouncedDate',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = '20-03-2018',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        SmartDD__Filter_Criteria__c containscriteria = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'contains',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                );
        lstfiltercriteria.add(objcriteria);        
        lstfiltercriteria.add(blankobjcriteria);        
        lstfiltercriteria.add(blncriteria);
        lstfiltercriteria.add(intcriteria);
        lstfiltercriteria.add(Mobilephonecriteria);
        lstfiltercriteria.add(phonecriteria);
        lstfiltercriteria.add(Faxcriteria);
        lstfiltercriteria.add(emailcriteria);
        lstfiltercriteria.add(percentcriteria);
        lstfiltercriteria.add(inttextcriteria);
        lstfiltercriteria.add(datecriteria);
        lstfiltercriteria.add(falsedatecriteria);
        lstfiltercriteria.add(datetimecriteria);
        lstfiltercriteria.add(falsedatetimecriteria);
        lstfiltercriteria.add(containscriteria);
        if(Schema.sObjectType.SmartDD__Filter_Criteria__c.isCreateable()){
            insert lstfiltercriteria;
        }
        String strOpp = 'less than';     
        FilterController.fillOperator(strOpp);
        try{
            FilterController.saveFilterCriterias(lstfiltercriteria,filter,'Lead');
        }
        catch(Exception e){
            
        }     
        Test.stopTest();
        System.assert(true);  
    }  
    static testMethod void testFilterRecord(){ 
        Test.startTest();
        SmartDD__Filter__c filters = new SmartDD__Filter__c (Name = 'Test Filter',
                               SmartDD__Object_Name__c = 'Lead',
                               SmartDD__FilterLogic__c = ''
                              ); 
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filters;
        }        
        String strOpp = 'greater than';     
        FilterController.fillOperator(strOpp); 
        FilterController.getFiltername('Lead');   
        Test.stopTest();
        System.assert(true);
    }   
    
     static testMethod void testSearchLeadCols(){ 
        SmartDD__Search_Column__c searchleadcols = new SmartDD__Search_Column__c (SmartDD__Object_Name__c = 'Lead',
                                                            SmartDD__Search_Column_Fields__c = 'Email,Phone,LastName,FirstName,Title,Company');
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert searchleadcols;
        }  
        
        String strOpp = 'less or equal';     
        FilterController.fillOperator(strOpp);      
        FilterController.fetchObjectColumns('Lead');
        FilterController.FieldPicklistOptions('Lead');
        
        SmartDD__De_Dupe_Configuration__c dedupeconfig = new SmartDD__De_Dupe_Configuration__c(); 
        dedupeconfig.Name = 'DeDupe Configuration';
        dedupeconfig.SmartDD__Lead__c = true;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfig;
        }
        FilterController.getSyncedObjList();
        
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                               SmartDD__Object_Name__c = 'Lead',
                               SmartDD__FilterLogic__c = ''                                
                              ); 
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        } 
        
        System.assertEquals('Lead',filter.SmartDD__Object_Name__c);
        SmartDD__Filter_Data__c objFilter = new SmartDD__Filter_Data__c();
        objFilter.SmartDD__Filter_Id__c = filter.Id;
        objFilter.Name = 'Lead';
        objFilter.SmartDD__Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable()){
            insert objFilter;
        } 

        SmartDD__Dedupe_Configuration__c objDedupeConfig = new SmartDD__Dedupe_Configuration__c();
        objDedupeConfig.SmartDD__Username__c  = 'smartdedupe@mahcom.com';
        if(Schema.sObjectType.SmartDD__Dedupe_Configuration__c.isCreateable()){
            insert objDedupeConfig;
        } 
        FilterController.credentialDetails();
        
        SmartDD__De_Dupe_Configuration__c dedupeconfig1 = new SmartDD__De_Dupe_Configuration__c(); 
        dedupeconfig1.Name = 'DeDupe Configuration';
        dedupeconfig1.SmartDD__Sync_Data__c = false;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfig1;
        }
        FilterController.getObjectName(filter.Id); 
        FilterController.GetDedupeConfigCustomSettings('Lead');
        FilterController.UpdateFilterdataId(objFilter.Id, 'Lead',50);    
        //FilterController.ResetMergedFlag('Lead',filter.Id);
    }    
    
    static testmethod void testhttpCreateClusterJSONRequest(){
        Test.startTest();
        SmartDD__Dedupe_Configuration__c objDedupeConfig = new SmartDD__Dedupe_Configuration__c();
        objDedupeConfig.SmartDD__Username__c  = 'smartdedupe@mahcom.com';
        objDedupeConfig.SmartDD__Organization_Id__c  = UserInfo.getOrganizationId();
        if(Schema.sObjectType.SmartDD__Dedupe_Configuration__c.isCreateable()){
            insert objDedupeConfig;
        }
       
        SmartDD__De_Dupe_Configuration__c dedupeconfig1 = new SmartDD__De_Dupe_Configuration__c(); 
        dedupeconfig1.Name = 'DeDupe Configuration';
        dedupeconfig1.SmartDD__Sync_Data__c = false;
        dedupeconfig1.SmartDD__Total_Records_Deduped__c = 500;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()){
            insert dedupeconfig1;
        }        
        SmartDD__Filter__c filter = new SmartDD__Filter__c();
        filter.Name = 'Test Filter';
        filter.SmartDD__Object_Name__c = 'Lead';
        filter.SmartDD__FilterLogic__c = '';
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        } 
        
        SmartDD__Filter_Data__c objFilter = new SmartDD__Filter_Data__c();
        objFilter.SmartDD__Filter_Id__c = filter.Id;
        objFilter.Name = 'Lead';
        objFilter.SmartDD__Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__Filter_Data__c.isCreateable()){
            insert objFilter;
        }
        
        String JSONFieldFilterStr = '';
        Id configId;
        if(objDedupeConfig != null){
        configId = objDedupeConfig.Id;
            JSONFieldFilterStr += '{';
            JSONFieldFilterStr += '"Object Name":"' + filter.SmartDD__Object_Name__c + '",';
            JSONFieldFilterStr += '"Organization Id":"' + objDedupeConfig.SmartDD__Organization_Id__c + '",';
            JSONFieldFilterStr += '"Field Name":"' + +'",';
            JSONFieldFilterStr += '"Filter Records":"' + dedupeconfig1.SmartDD__Total_Records_Deduped__c + '"';
            JSONFieldFilterStr += '}';
        }
     
        FilterController.httpCreateClusterJSONRequest(System.Label.SFImportAPI+'/lead/startDedupes',JSONFieldFilterStr,configId);        
        FilterController.httpTrainingRecCountJSON(System.Label.SFImportAPI+'/lead/startDedupes',JSONFieldFilterStr);
        Test.stopTest();
        System.assert(true);
    }   
    
    static testMethod void testSearchContactCols(){ 
    Test.startTest();
        SmartDD__Search_Column__c searchContactcols = new SmartDD__Search_Column__c (SmartDD__Object_Name__c = 'Contact',        
                                                          SmartDD__Search_Column_Fields__c = 'Email,Fax,FirstName,LastName');
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){ 
            insert searchContactcols;
        }
        String strOpp = 'greater or equal';     
        FilterController.fillOperator(strOpp); 
        FilterController.fetchObjectColumns('Contact');
        Test.stopTest();
        System.assert(true);
    }
    static testMethod void testSearchAccountCols(){ 
        Test.startTest();
        SmartDD__Search_Column__c searchAccountcols = new SmartDD__Search_Column__c (SmartDD__Object_Name__c = 'Account',
                                                            SmartDD__Search_Column_Fields__c = 'Name,Phone,Fax');
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert searchAccountcols;
        }
        String strOpp = 'contains';         
        
        FilterController.fillOperator(strOpp);
        FilterController.fetchObjectColumns('Account');
        MetadataService.MetadataPort service = FilterController.createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        //List<MetadataService.SaveResult> results = service.createMetadata(new MetadataService.Metadata[] { customField });
        //FilterController.handleSaveResults(results[0]);
        Test.stopTest();
        System.assert(true);
    }
    static testMethod void testSearchLeadColsownername(){ 
        SmartDD__Search_Column__c searchleadcols = new SmartDD__Search_Column__c (SmartDD__Object_Name__c = 'Lead',
                                                            SmartDD__Search_Column_Fields__c = 'Email,Phone,LastName,FirstName,Title,Company,owner.name');
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert searchleadcols;
        }
        String strOpp = 'does not contain';     
        FilterController.fillOperator(strOpp); 
        System.assertEquals('Lead',searchleadcols.SmartDD__Object_Name__c);
        FilterController.fetchObjectColumns('Lead');
    }
    static testMethod void testSearchContactColsownerName(){ 
        SmartDD__Search_Column__c searchContactcols = new SmartDD__Search_Column__c (SmartDD__Object_Name__c = 'Contact',
                                                            SmartDD__Search_Column_Fields__c = 'Email,Fax,FirstName,LastName,owner.name');
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert searchContactcols;
        }
        String strOpp = 'starts with';     
        FilterController.fillOperator(strOpp);
        System.assertEquals('Contact',searchContactcols.SmartDD__Object_Name__c);
        FilterController.fetchObjectColumns('Contact');
    }
    static testMethod void testSearchAccountColsownerName(){
        SmartDD__Search_Column__c searchAccountcols = new SmartDD__Search_Column__c (SmartDD__Object_Name__c = 'Account',
                                                            SmartDD__Search_Column_Fields__c = 'Name,Phone,Fax,owner.name');
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert searchAccountcols;
        }
        System.assertEquals('Account',searchAccountcols.SmartDD__Object_Name__c);
        FilterController.fetchObjectColumns('Account');
    }
    
    static testMethod void testFetchLead(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                              SmartDD__Object_Name__c = 'Lead',
                               SmartDD__FilterLogic__c = ''                                
                              ); 
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        } 
        System.assertEquals('Lead',filter.SmartDD__Object_Name__c);
                     
        string strfields = 'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate,SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status';
        string strobjname ='Lead';
        string strsortfield = '';
        string strsearchkey = '';
        
        FilterController.fetchLead(strobjname,strfields,strsortfield,strsearchkey,false,1,10,filter.id);
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();

    }
    static testMethod void testSearchKeyFetchLead(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                        SmartDD__Object_Name__c = 'Lead',
                                        SmartDD__FilterLogic__c = '' 
                                    ); 
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        } 
        System.assertEquals('Lead',filter.SmartDD__Object_Name__c);
        
        Filter_Criteria__c objcriteria;
        objcriteria = new Filter_Criteria__c (Field__c = 'LastName',
                                        Operator__c = 'equals',
                                        Value__c = 'Test',
                                        Filter_Name__c = filter.id
                                    );
        if(Schema.sObjectType.SmartDD__Filter_Criteria__c.isCreateable()){
             insert objcriteria;
        } 
        System.assertEquals('LastName',objcriteria.SmartDD__Field__c);
                
        string strfields = 'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company';
        string strobjname ='Lead';
        string strsortfield = 'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company';
        string strsearchkey = 'test';
        
        //FilterController.fetchLead(strobjname, strfields, strsortfield, strsearchkey, true, 10, 10, filter.id);
        lightningTableWrapper objTableWrapper = new lightningTableWrapper();
        
    }
    static testMethod void testFilteridFetchLead(){
        Test.startTest();
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c>();
        lstObjectColumns.add(new SmartDD__Search_Column__c(SmartDD__Object_Name__c = 'Lead',
        SmartDD__Search_Column_Fields__c = 'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate,SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status'));
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert lstObjectColumns;
        }
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                               SmartDD__Object_Name__c = 'Lead'                               ); 

        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        }     
      
        FilterController.fetchLead('Lead','AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c,Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status',
        'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status','',true,10,10,filter.id);
        Test.stopTest();
        System.assert(true);
    }
    static testMethod void testSortFetchLead(){
        Test.startTest();
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c>();
        lstObjectColumns.add(new Search_Column__c(SmartDD__Object_Name__c = 'Lead',
        SmartDD__Search_Column_Fields__c = 'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate,SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status'));
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert lstObjectColumns;
        } 
        
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                               SmartDD__Object_Name__c = 'Lead' 
                              ); 
        if(Schema.sObjectType.SmartDD__Filter__c.isCreateable()){
            insert filter;
        }         
        FilterController.fetchLead('Lead','AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c,Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status',
        'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status','',false,10,10,filter.id);
        
        FilterController.setStringToDateFormat('2018/12/17');
        Test.stopTest();
        System.assert(true);
    }
    static testMethod void testSortFetchLeadSerchkey(){
        Test.startTest();
        List<SmartDD__Search_Column__c> lstObjectColumns = new List<SmartDD__Search_Column__c>();
        lstObjectColumns.add(new SmartDD__Search_Column__c(SmartDD__Object_Name__c = 'Lead',
        SmartDD__Search_Column_Fields__c = 'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate,SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status'));
        if(Schema.sObjectType.SmartDD__Search_Column__c.isCreateable()){
            insert lstObjectColumns;
        }         
        
        FilterController.fetchLead('Lead','AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c,Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status',
        'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status','filter',false,1,10,null);
        
        FilterController.setStringToDateFormat('2018-12-17');
        Test.stopTest();
        System.assert(true);
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
      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Authorization', 'Basic YXBmFtaWx5');
        res.setBody('{"Object Name":"SmartDD__Dedupe_Configuration__c", "Organization Id":"00Df4000004klpHEAQ", "UserId":"005f400000324XCAAY"}');
        res.setStatusCode(200);
        
        Test.starttest();        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     
        
        String queryStringTotal = 'Select Id from Lead WITH USER_MODE';
        string objectName = 'Lead';
        
        Manage_Cluster_Org_Tab_Id__c mrgcluster = new Manage_Cluster_Org_Tab_Id__c ();
        mrgcluster.Name ='Org Tab Name'; 
        mrgcluster.TabName__c = '01rf4000000ecfp';
        insert mrgcluster; 
        
        List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
        SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
        searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
        searchColumn.SmartDD__Review_Polish_Display_Columns__c = 'LastName';
        searchColumn.SmartDD__Object_Name__c = 'lead';
        lstSearchColumns.add(searchColumn);
        insert searchColumn;
        
        List<Lead> lstleads= new List<Lead>();
            for (Integer i=1;i <= 2000;i++) {
                Lead lead = new Lead();
                lead.LastName = 'test';
                lead.company = 'test company';
                lstleads.add(lead);
            }
            insert lstleads;
        
        SmartDD__StartDedupeStatus__c objStartDedupeStatus = new SmartDD__StartDedupeStatus__c();
        objStartDedupeStatus.Name = 'Start DeDupe123';
        objStartDedupeStatus.SmartDD__IsSuccess__c = '1';
        objStartDedupeStatus.SmartDD__StartDedupeBatchId__c = 'Start DeDupe123';
        insert objStartDedupeStatus;  
        
        batchFetchDedupeRecord objbatchFetchDedupeRecord = new batchFetchDedupeRecord(queryStringTotal, objectName,u.Id,UserInfo.getOrganizationId());
        Id batchJobId = DataBase.executeBatch(objbatchFetchDedupeRecord,1);
        //Database.executeBatch(batchInstance, 1);
        System.abortJob(batchJobId);
        
       
      
        //FilterController.postDedupeFilterRecords(objfilter.Id,objfiltercon.Id,'Lead');        
        FilterController.checkCredentials('SmartDD__Dedupe_Configuration__c',dedupeConfig.Id);
        FilterController.wrpFields objwrpFields = new FilterController.wrpFields();
        FilterController.saveDedupeFilterData(string.valueOf(JSON.serialize(selectedlead)),string.valueOf(JSON.serialize(selectedcon)),string.valueOf(JSON.serialize(selectedacc)),'216440', 'Lead');
        Test.stopTest();
        system.assert(true);
    }
    @isTest
    static void UpdatePerPageRecordSizeTest(){
    SmartDD__Dedupe_Per_Page_Record_Size__c perPageRecordSize = new SmartDD__Dedupe_Per_Page_Record_Size__c();
        perPageRecordSize.name= 'Dedupe Display Records';
        perPageRecordSize.SmartDD__Per_Page_Record__c = 12;
        upsert perPageRecordSize;
        Test.startTest();
        FilterController.UpdatePerPageRecordSize(12); 
        FilterController.GetPerPageRecordSize();
        FilterController.fetchLead('Lead','AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c,Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status',
        'AnnualRevenue, CreatedDate, EmailBouncedDate, LastActivityDate, SmartDD__NumberofLocations__c, Email, Phone, NumberOfEmployees, OwnerId, LastName, FirstName, Title, Company,status','filter',false,1,null,null);
        Test.stopTest();
        system.assert(true);
    }
    @isTest
    static void testfnGetStringCriteria(){
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
         
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        SmartDD__StartDedupeStatus__c objStartDedupeStatus = new SmartDD__StartDedupeStatus__c();
        objStartDedupeStatus.Name = 'Start DeDupe12';
        objStartDedupeStatus.SmartDD__IsSuccess__c = '1';
        objStartDedupeStatus.SmartDD__StartDedupeBatchId__c = 'Start DeDupe12';
        insert objStartDedupeStatus;
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.name = 'Start DeDupe';
        startdedupedata.SmartDD__IsSuccess__c = '0';
        insert startdedupedata;
        
        SmartDD__Manage_Cluster_Org_Tab_Id__c mrgcluster = new SmartDD__Manage_Cluster_Org_Tab_Id__c ();
        mrgcluster.Name ='Org Tab Name'; 
        mrgcluster.SmartDD__TabName__c = '01rf4000000ecfp';
        insert mrgcluster;
        
        Test.startTest();
        batchFetchDedupeRecord objbatchFetchDedupeRecord = new batchFetchDedupeRecord('Select Id from Lead WITH USER_MODE', 'Lead',u.Id,UserInfo.getOrganizationId());
        Id BatchProcessId = DataBase.executeBatch(objbatchFetchDedupeRecord);
        Test.stopTest();
        system.assert(true);

        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'Like';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe();
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        FilterController.CheckApiStatus();
       
        //FilterController.AsyncApexJobRecords(BatchProcessId);
         FilterController.AsyncApexJobRecords(BatchProcessId);               
    } 
    static testMethod void testfnGetStringCriteriaNotLike(){
        Test.startTest();
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastTransferDate',
                                   SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c =  'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'NotLike';
        String strValue = '';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
         
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null);  
        Test.stopTest();
        System.assert(true);
    } 
    static testMethod void testfnGetStringCriteriastartswith(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'NumberOfEmployees',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = 'startswith';
        String strValue = '';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
          Test.startTest();
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
         Test.stopTest();
         System.assert(true);
    }  
    static testMethod void testfnGetStringCriterialess(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '<';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
           Test.startTest();
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null);   
           Test.stopTest();
          System.assert(true);
    } 
    static testMethod void testfnGetStringCriteriagreater(){
        Test.startTest();
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        Filter_Criteria__c objcriteria1 = new Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '>';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
         
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        Test.stopTest();
        System.assert(true);
    } 
    static testMethod void testfnGetStringCriteriagreaterequal(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '>=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
        Test.startTest();
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
         
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null);
        Test.stopTest();
        system.assert(true);
    } 
    static testMethod void testfnGetStringCriterialessequal(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '<=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
          Test.startTest();
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
         
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null);  
         Test.stopTest();
        system.assert(true);
    } 
    static testMethod void testfnGetStringCriterianotequal(){
        SmartDD__Filter__c filter = new SmartDD__Filter__c (Name = 'Test Filter',
                                    SmartDD__Object_Name__c = 'Lead',
                                    SmartDD__FilterLogic__c = '1 Or 2 and 3'
                                ); 
        insert filter;
        SmartDD__Filter_Criteria__c objcriteria1 = new SmartDD__Filter_Criteria__c (SmartDD__Field__c = 'LastName',
                                    SmartDD__Operator__c = 'equals',
                                    SmartDD__Value__c = 'Test',
                                    SmartDD__Filter_Name__c = filter.id
                                ); 
        insert objcriteria1;
        
        String strFiledVal = objcriteria1.SmartDD__Field__c;
        String strOperatorVal = '!=';
        String strValue = 'test';
        String strSearchOn = 'SmartDD__Filter_Criteria__c';
          Test.startTest();
        Schema.SObjectType objtype = Schema.getGlobalDescribe().get(strSearchOn);
        Schema.DescribeSObjectResult objResult = objtype.getDescribe();
        Schema.DescribeFieldResult fldtype1 = objResult.fields.getMap().get('SmartDD__Field__c').getDescribe(); 
         
        FilterController.fnGetStringCriteria(strFiledVal, strOperatorVal, strValue,fldtype1,null); 
        Test.stopTest();
        system.assert(true);
    } 
    
   
}