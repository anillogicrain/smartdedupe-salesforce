@isTest(SeeAllData=true)
public class batchFetchDedupeRecordTest {
    /*static testMethod void testMethod1() {
        List<Lead> lstLead = new List<Lead>();
        for(Integer i=0; i<=200; i++) {
            Lead objLead = new Lead();
            objLead.FirstName = 'FName'+i;
            objLead.LastName = 'LName'+i;
            objLead.Company = 'LCompany'+i;
            lstLead.add(objLead);
        }
        insert lstLead;
        User objUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Moderator User' WITH USER_MODE].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert objUser;
        SmartDD__Manage_Cluster_Org_Tab_Id__c objOrgTabNameId = new SmartDD__Manage_Cluster_Org_Tab_Id__c();  
        objOrgTabNameId.Name = 'Org Tab Name Test';
        objOrgTabNameId.SmartDD__TabName__c = 'Manage Duplicate Group Test';
        upsert objOrgTabNameId;
        
        SmartDD__StartDedupeStatus__c startdedupedata = new SmartDD__StartDedupeStatus__c();
        startdedupedata.Name = 'Start DeDupe Test';
        startdedupedata.SmartDD__IsSuccess__c = '0';
        upsert startdedupedata;
        
        Test.startTest();
            String orgId = UserInfo.getOrganizationId();
            String queryStringTotal = 'Select Id from Lead WITH USER_MODE LIMIT 200';
            batchFetchDedupeRecord obj = new batchFetchDedupeRecord(queryStringTotal,'Lead',objUser.Id,orgId);
            DataBase.executeBatch(obj);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCheckSyncGenerator());
        Test.stopTest();
        System.assert(true);
    }*/
}