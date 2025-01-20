global class lightningTableWrapper {
    @AuraEnabled
    public Integer page { get;set; }

    @AuraEnabled
    public Integer total { get;set; }
    
    @AuraEnabled
    public Integer totalNotReviewed { get;set; }

    @AuraEnabled
    public String selectedTabName { get;set; }
    
    @AuraEnabled
    public Boolean blnUniqueRecordSaved { get;set; }

    @AuraEnabled
    public List<sObject> sObjectrecords { get;set; }
    
    @AuraEnabled
    public List<sObject> sObjectTotalRecords { get;set; }
    
    @AuraEnabled
    public String mergeRuleMasterRecords { get;set; }
    
    @AuraEnabled
    public List<sObject> fieldSelectionMasterRecords { get;set; }
    
    @AuraEnabled
    public List<sObject> SpecificeFieldMasterRecords { get;set; }
    
    @AuraEnabled
    public List<SmartDD__Cluster__c> clusterList { get;set; }
    
    @AuraEnabled
    public String mergeRuleMasterRecordType { get;set; }
    
    @AuraEnabled
    public Integer leastConfidenceScore { get;set; }
    
    @AuraEnabled
    public Integer clusterConfidenceScore { get;set; }
    
    @AuraEnabled
    public String FirstReturnValue{ get;set; }
    
    @AuraEnabled
    public String LastReturnValue { get;set; }
    
    @AuraEnabled
    public List<sObject> sObjectEntireList { get;set; }
    
    @AuraEnabled
    public List<sObject> sObjectTotalRecordsIds { get;set; }
    
    @AuraEnabled
    public List<sObject> sObjectTotalNotReviewed { get;set; }
    
    @AuraEnabled
    public String mergeRuleObjectFieldVal{ get;set; }
}