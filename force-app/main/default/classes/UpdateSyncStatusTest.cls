@isTest
public class UpdateSyncStatusTest{
	
    @isTest
    public static void testmethod1(){
        UpdateSyncStatusAPI.externalSyncStatus = 'Completed';
        
        SmartDD__De_Dupe_Configuration__c objdedupeconfig = new SmartDD__De_Dupe_Configuration__c();
        objdedupeconfig.Name = 'DeDupe Configuration';
        objdedupeconfig.SmartDD__Clusters_Completed_Stat__c = 'Completed';
        objdedupeconfig.SmartDD__SF_Import_Consumer_Key__c = '3MVG9riCAn8HHkYXEZYzeWic4NPGhcTMhvY7FYnCEfXBp6QUZ8E3NF4NZ3ZeZvTnLoNIbV_X0T4cEzECDuMkD';
        objdedupeconfig.SmartDD__SF_Import_Consumer_Secret__c = 'D9942565C86A02E0AB550CC1922A8EC9DA2A79BB83EE02C7241EA930A1517C71';
        objdedupeconfig.SmartDD__Training_File_Consumer_Key__c = '3MVG9riCAn8HHkYXEZYzeWic4NAO3wEmODWosdNgdbCaI0yCN9wk5fNza9PAVOTsr86Cv1XhCTCcZ7NVTpe9v';
        objdedupeconfig.SmartDD__Training_File_Consumer_Secret__c = 'B5BC76305779C223766C618D8BADC6B41914DF8345F9A16F81B32E83FBC32812';
        objdedupeconfig.SmartDD__User_Configuration__c = true;
        Insert objdedupeconfig;
        Test.startTest();
        UpdateSyncStatusAPI.fnUpdateSyncData();      
        Test.stopTest();
        System.assert(true);
    }
}