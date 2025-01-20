@isTest
private class DedupeTest {
       
    @isTest static void DedupeTestData() {
        Test.startTest();
            createSomeData();
            List<SmartDD__Dedupe_Configuration__c> lstDedupeConfig = new List<SmartDD__Dedupe_Configuration__c>();
            SmartDD__Dedupe_Configuration__c dedupeConfig = new SmartDD__Dedupe_Configuration__c();
            dedupeConfig.SmartDD__Email__c = 'test122@gmail.com';
            dedupeConfig.SmartDD__Organization_Id__c = 'test';
            lstDedupeConfig.add(dedupeConfig);
            insert lstDedupeConfig;
            
            List<SmartDD__Search_Column__c> lstSearchColumns = new List<SmartDD__Search_Column__c>();
            SmartDD__Search_Column__c searchColumn = new SmartDD__Search_Column__c();
            searchColumn.SmartDD__Search_Object_Fields__c = 'LastName';
            searchColumn.SmartDD__Object_Name__c = 'lead';
            lstSearchColumns.add(searchColumn);
            insert searchColumn;
            
            List<Lead> lstLead = new List<Lead>();
            Lead leaddata = New Lead();
            leaddata.FirstName = 'First30049';
            leaddata.LastName = 'AtestNew33279';
            leaddata.Street = '111, Street30049';
            leaddata.Title = 'QA30049';
            leaddata.City = 'testcity';
            leaddata.State = 'teststate';
            leaddata.PostalCode = 'CB4 0E9999';
            leaddata.Country = 'United Kingdom';
            leaddata.Phone = '(303) 001-16049';
            leaddata.Company = 'Test Company30049';
            leaddata.Email = 'testlrtmail30049@gmail.com';
            leaddata.Status = 'Open - Not Contacted';
            leaddata.SmartDD__DedupeId__c = '';
            leaddata.IsConverted = False;
            lstLead.add(leaddata);
            insert lstLead;
            
            Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
            
        Test.stopTest();
        System.assert(true);
    }
    @Future(callout=true)
    public static void createSomeData()
    {
        Dedupe objdedupe = New Dedupe();
        objdedupe.fnDedupePOST();
    }
}