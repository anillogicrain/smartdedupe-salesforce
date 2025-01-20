public class TestVisibleExample {
        // Private member variable
        @TestVisible static Integer recordNumber;
    	@TestVisible static String todaysDay;
     
        // Private method
        @TestVisible private static void updateRecord(String name) {
            // Do something
            System.debug('recordNumber Inside Main Class..................................'+TestVisibleExample.recordNumber);
            System.debug('recordNumber Inside Main Class..................................'+TestVisibleExample.todaysDay);
            //System.debug('recordNumbers Inside Main Class..................................'+TestVisibleExample.recordNumbers);
        }
    }