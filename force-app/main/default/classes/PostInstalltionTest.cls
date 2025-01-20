@isTest
public class PostInstalltionTest {      
    @isTest
    static void testInstallScript() {
        postInstallationClass postinstall = new postInstallationClass();
        Test.testInstall(postinstall, null);
        Test.testInstall(postinstall, new Version(1,0), true);
        List<SmartDD__ManageRule_Master_Record__c> a = [Select id, SmartDD__Object_Name__c from SmartDD__ManageRule_Master_Record__c where SmartDD__Object_Name__c ='Lead' WITH USER_MODE];
		System.assertEquals(a.size(), 6, 'ManageRule Record Not found');
    }
}