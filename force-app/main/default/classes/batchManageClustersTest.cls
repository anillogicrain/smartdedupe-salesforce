@isTest
public class batchManageClustersTest {
    static testmethod void manageClusterSchedulerTest() {
        List<SmartDD__Cluster__c> lstclauster= new List<SmartDD__Cluster__c>();
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
        dedupeconfig.SmartDD__Organization_Id__c = UserInfo.getOrganizationId();
        dedupeconfig.SmartDD__UserId__c = u.Id;
        Schema.DescribeSObjectResult dsr = SmartDD__Dedupe_Configuration__c.sObjectType.getDescribe();
        if(dsr.isCreateable() && dsr.isUpdateable()){
            upsert dedupeconfig;
        }
        
        SmartDD__Manage_Cluster_Org_Tab_Id__c objOrgTabNameId = new SmartDD__Manage_Cluster_Org_Tab_Id__c ();
        objOrgTabNameId.Name ='Org Tab Name'; 
        objOrgTabNameId.SmartDD__TabName__c = '01rf4000000ecfp';
        insert objOrgTabNameId; 
        
        System.assertEquals('Ftest',dedupeconfig.SmartDD__First_Name__c);
        for(Integer i=0 ;i <20;i++)
        {
            SmartDD__Cluster__c clust = new SmartDD__Cluster__c();
            clust.SmartDD__External_Cluster_Id__c = 8;
            lstclauster.add(clust);
        }
        insert lstclauster;
        
        Test.StartTest();
        manageClusterScheduler scheduleClass = new manageClusterScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Delete Clusters', sch, scheduleClass );
        Test.StopTest();
    }
}