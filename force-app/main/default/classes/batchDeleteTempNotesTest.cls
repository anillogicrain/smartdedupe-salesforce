@isTest
public class batchDeleteTempNotesTest {
    static testMethod void testMethod1() {
        Lead objLead = new Lead();
        objLead.FirstName = 'FName';
        objLead.LastName = 'LName';
        objLead.Company = 'LCompany';
        insert objLead;
        
        List<SmartDD__TempDedupeNote__c> lstTempDedupeNotes = new List<SmartDD__TempDedupeNote__c>();
        for(Integer i=0 ;i <200;i++) {
            SmartDD__TempDedupeNote__c objDedupeNotes = new SmartDD__TempDedupeNote__c();
            objDedupeNotes.Name ='Name'+i;
            objDedupeNotes.SmartDD__Body__c = 'This is test Class.';
            objDedupeNotes.SmartDD__MergeType__c = 'Auto';
            objDedupeNotes.SmartDD__Title__c = 'Title'+i;
            objDedupeNotes.SmartDD__LeadParentId__c = objLead.Id;
            lstTempDedupeNotes.add(objDedupeNotes);
        }
        insert lstTempDedupeNotes;
        SmartDD__Master_Cluster_Record__c objMasterRecSel = new SmartDD__Master_Cluster_Record__c();
        objMasterRecSel.SmartDD__Object_Name__c = 'Lead';
        Insert objMasterRecSel;
        
        Test.startTest();
        batchDeleteTempNotes obj = new batchDeleteTempNotes('SmartDD__LeadParentId__c',objMasterRecSel.Id);
        DataBase.executeBatch(obj);
        Test.stopTest();
        List<Note> lstNote = [SELECT Id FROM Note WHERE ParentId =:objLead.Id WITH USER_MODE];
        System.assertEquals(0, lstNote.size(),'0 Note records should be returned');
        System.assert(0 == lstNote.size());
    }
}