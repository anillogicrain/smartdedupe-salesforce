//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

global class DedupeJSON {

    public class Leaddata {
        public String zip {get;set;} 
        public Integer recordid {get;set;} 
        public String country {get;set;} 
        public String firstname {get;set;} 
        public String address {get;set;} 
        public String city {get;set;} 
        public String phone {get;set;} 
        public String company {get;set;} 
        public String state {get;set;} 
        public String title {get;set;} 
        public String email {get;set;} 
        public String lastname {get;set;} 

        public Leaddata(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'zip') {
                            zip = parser.getText();
                        } else if (text == 'recordid') {
                            recordid = parser.getIntegerValue();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'firstname') {
                            firstname = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'company') {
                            company = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'lastname') {
                            lastname = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Leaddata consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Integer status {get;set;} 
    public Integer errorcode {get;set;} 
    public String message {get;set;} 
    public List<Leaddata> leaddata {get;set;} 
    public Leadmetadata leadmetadata {get;set;} 

    public DedupeJSON(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'status') {
                        status = parser.getIntegerValue();
                    } else if (text == 'errorcode') {
                        errorcode = parser.getIntegerValue();
                    } else if (text == 'message') {
                        message = parser.getText();
                    } else if (text == 'leaddata') {
                        leaddata = arrayOfLeaddata(parser);
                    } else if (text == 'leadmetadata') {
                        leadmetadata = new Leadmetadata(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'DedupeJSON consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Leadmetadata {

        public Leadmetadata(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Leadmetadata consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public static DedupeJSON parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new DedupeJSON(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    private static List<Leaddata> arrayOfLeaddata(System.JSONParser p) {
        List<Leaddata> res = new List<Leaddata>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Leaddata(p));
        }
        return res;
    }
}