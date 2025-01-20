@isTest
public class ClusterAPITest {
    @isTest static void testMethod1() {
         Test.startTest();
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
    
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.company = 'test company';
        leads.add(lead);
        insert leads;
        
        /*Lead objlead = new Lead();
        objlead.LastName = 'LeadLastName';
        objlead.Company = 'TestComapny';
        insert objLead;

        Cluster__c cluster = new Cluster__c();
        //cluster.Name = 'TestCluster';
        cluster.Cluster_Review_Status__c = 'Reviewed';
        cluster.External_Cluster_Id__c = 1;
        insert cluster;
        
        /*Child_Cluster_Record__c childRecords = New Child_Cluster_Record__c();
        childRecords.Cluster_Id__c = cluster.Id;
        childRecords.Cluster_Record_External_Id__c = '151138';
        childRecords.Cluster_Object_Id__c = objLead.id;
        childRecords.MannualCluster__c = False;
        Insert childRecords;*/

        ClusterAPI.insertClusterWrapper objClapiClwrap = new ClusterAPI.insertClusterWrapper();
        objClapiClwrap.clusterid = 1;
        objClapiClwrap.leadid = lead.id;
        objClapiClwrap.recordid = '151138';
        objClapiClwrap.objectName = 'Lead';
        objClapiClwrap.pair_score = '5';
         
        SmartDD__Manage_Master_Cluster_Id__c LeadMasterCluster = new SmartDD__Manage_Master_Cluster_Id__c();
        LeadMasterCluster.Name='Lead';
        LeadMasterCluster.SmartDD__New_Master_Cluster_Id__c = 'a0N3g000001JQK0EAO';
        insert LeadMasterCluster;
         System.assert(LeadMasterCluster.Id!=null);
        
        SmartDD__Filter_Data__c  filterRecs = new SmartDD__Filter_Data__c();
        filterRecs.name = 'Lead';
        filterRecs.SmartDD__Object_Name__c = 'Lead';
        filterRecs.SmartDD__Unique_Cluster_Saved__c = false;
        Insert filterRecs;
        System.assert(filterRecs.Id!=null);
        
        SmartDD__De_Dupe_Configuration__c customsettingdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        customsettingdedupeconfig.Name = 'DeDupe Configuration';
        customsettingdedupeconfig.SmartDD__User_Configuration__c  = true;
        if(Schema.sObjectType.SmartDD__De_Dupe_Configuration__c.isCreateable()) {
            insert customsettingdedupeconfig;
            System.assert(customsettingdedupeconfig.Id!=null);
        }
        
        String myJSON ='[' + JSON.serialize(objClapiClwrap) + ']';
    
        RestRequest request = new RestRequest();
        request.requestUri ='https://smartdedupdev-dev-ed.my.salesforce.com/services/apexrest/Cluster';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator());
        String StrResponce = ClusterAPI.fnGetClusterData();
        Test.stopTest();
        
    }
}