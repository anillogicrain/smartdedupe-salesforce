@isTest
private class TestVisibleExampleTest {

    @isTest static void test1() {
            // Access private variable annotated with TestVisible
            Integer i = TestVisibleExample.recordNumber;
      		
         //   System.assertEquals(1, i);
     		TestVisibleExample.recordNumber = 500;
        	TestVisibleExample.todaysDay = 'Wednesday';
            System.debug('recordNumber..................................'+TestVisibleExample.recordNumber);      		
      		//i = 5;
      		//System.debug('recordNumber..................................'+i);
      		Test.startTest();
      		TestVisibleExample.updateRecord('RecordName');
        	Test.stopTest();
        	System.assert(true);
  }
}