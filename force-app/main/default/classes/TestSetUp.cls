public  with sharing class TestSetUp {
    
    public static ID getAllclusterID(){

        SmartDD__Master_Cluster_Record__c objMaster = new SmartDD__Master_Cluster_Record__c();
        objMaster.Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__Master_Cluster_Record__c.fields.Object_Name__c.isCreateable())
        {
             insert objMaster;
        }
       
        
        SmartDD__Manage_Master_Cluster_Id__c objMasterClusterId = new SmartDD__Manage_Master_Cluster_Id__c();
        objMasterClusterId.Name = 'Lead';
        objMasterClusterId.SmartDD__New_Master_Cluster_Id__c = objMaster.Id;
        objMasterClusterId.SmartDD__Object_Name__c = 'Lead';
        if(Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.Name.isCreateable() && Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__New_Master_Cluster_Id__c.isCreateable() && 
    	   Schema.sObjectType.SmartDD__Manage_Master_Cluster_Id__c.fields.SmartDD__Object_Name__c.isCreateable())
        {
            insert objMasterClusterId;
        }
        
      
        SmartDD__All_CLuster_Record__c objAllcluster = new SmartDD__All_CLuster_Record__c();
        objAllcluster.SmartDD__Object_Name__c = 'Lead';
        objAllcluster.SmartDD__Master_Cluster_Record_Id__c = objMaster.Id;  
        objAllcluster.SmartDD__External_Cluster_Id__c = 1;
        if(Schema.sObjectType.SmartDD__All_CLuster_Record__c.fields.SmartDD__Object_Name__c.isCreateable() && Schema.sObjectType.SmartDD__All_CLuster_Record__c.fields.SmartDD__Master_Cluster_Record_Id__c.isCreateable() &&
     	   Schema.sObjectType.SmartDD__All_CLuster_Record__c.fields.SmartDD__External_Cluster_Id__c.isCreateable())
        {
             insert objAllcluster;
        }
       
        
        return objAllcluster.Id;
    }

}