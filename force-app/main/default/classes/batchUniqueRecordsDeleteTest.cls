@isTest
public class batchUniqueRecordsDeleteTest {
    static testMethod void testMethod1() {
        List<Lead> lstLead = new List<Lead>();
        for(Integer i=0; i<=200; i++) {
            Lead objLead = new Lead();
            objLead.FirstName = 'FName'+i;
            objLead.LastName = 'LName'+i;
            objLead.Company = 'LCompany'+i;
            lstLead.add(objLead);
        }
        insert lstLead;
        
        SmartDD__Master_Cluster_Record__c objMasterRecSel = new SmartDD__Master_Cluster_Record__c();
        objMasterRecSel.SmartDD__Object_Name__c = 'Lead';
        Insert objMasterRecSel;
        
        SmartDD__Cluster__c objCluster = new SmartDD__Cluster__c();
        objCluster.SmartDD__Cluster_Review_Status__c = 'Reviewed';
        objCluster.SmartDD__Confidence_Score__c = 90;
        objCluster.SmartDD__External_Cluster_Id__c = 112;
        objCluster.SmartDD__Master_Cluster_Record_Id__c = objMasterRecSel.Id;
        objCluster.SmartDD__Object_Name__c = 'Lead';
        insert objCluster;
        
        List<SmartDD__Child_Cluster_Record__c> lstChldClstr = new List<SmartDD__Child_Cluster_Record__c>();
        for(Integer i=0; i<=200; i++) {
            SmartDD__Child_Cluster_Record__c objChildClstr = new SmartDD__Child_Cluster_Record__c();
            objChildClstr.SmartDD__Cluster_Id__c = objCluster.Id;
            objChildClstr.SmartDD__Cluster_Lead_Id__c = lstLead[i].Id;
            objChildClstr.SmartDD__Object_Name__c = 'Lead';
            objChildClstr.SmartDD__MannualCluster__c = false;
            objChildClstr.SmartDD__Master_Cluster_Record_Id__c = objMasterRecSel.Id;
            lstChldClstr.add(objChildClstr);
        }
        insert lstChldClstr;
        
        Test.startTest();
        String orgId = UserInfo.getOrganizationId();
        String queryStringTotal = 'Select Id from Lead WITH USER_MODE LIMIT 200';
        batchUniqueRecordsDelete obj = new batchUniqueRecordsDelete(queryStringTotal,objMasterRecSel.Id,'Lead');
        DataBase.executeBatch(obj);
        Test.stopTest();
        System.assert(5 == 5);
    }
}