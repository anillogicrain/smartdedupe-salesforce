/********************************************************************************************
* NAME         : JSONSyncData
* DESCRIPTION  : This class is used to parse the json records.
*
* @AUTHOR: Dev team
* @DATE: 10/17/2018
*
*
* MODIFICATION LOG:
* DEVELOPER                         DATE                               DESCRIPTION
* ----------------------------------------------------------------------------      
    Dev team                            10/17/2018                
********************************************************************************************/
global with sharing class JSONSyncData {

    global String duplicateRecords {get;set;} 
    global String insertedRecords {get;set;}
    global String successMessage {get;set;} 
    global String totalRecords {get;set;}
    global String strClusterId {get;set;}
    global String isSuccess {get;set;}
    global String error {get;set;}
    global String errorDescription {get;set;}
    global String trainingFile {get;set;} 
    global String settingFile {get;set;}
    global String feilds {get;set;}  
    global String totalTrainingRecords {get;set;}
    
    // Method to parse the json records. 
    global JSONSyncData(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'Duplicate Records') { duplicateRecords = parser.getText();
                    } 
                    else if (text == 'Inserted Records') {insertedRecords = parser.getText();
                    }
                    else if (text == 'Total Records') { totalRecords = parser.getText();
                    }
                    else if (text == 'clusterid'){strClusterId = parser.getText();
                    }
                    else if (text == 'isSuccess'){isSuccess = parser.getText();
                    }
                    else if (text == 'success'){successMessage = parser.getText();
                    }
                    else if (text == 'error'){error = parser.getText();
                    }
                    else if (text == 'error_description'){errorDescription = parser.getText();
                    }
                    else if (text == 'trainingFile'){ trainingFile = parser.getText();
                    }
                     else if (text == 'settingFile'){settingFile = parser.getText();
                    }
                    else if (text == 'feilds'){ feilds = parser.getText();
                    }
                    else if (text == 'totalTrainingRecords'){ totalTrainingRecords = parser.getText();
                    }
                    else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                    }
                }
            }
        }
    }
    global static JSONSyncData parse(String json) {
        system.debug('@@@json:'+json);
        return new JSONSyncData(System.JSON.createParser(json));
    }
}