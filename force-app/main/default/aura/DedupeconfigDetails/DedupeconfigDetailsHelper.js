({
    SearchHelper: function(component, event,helper) {
        debugger;
        var searchUser = component.get('v.newDedupeConfig.SmartDD__Username__c');
        var searchEmail = component.get('v.newDedupeConfig.SmartDD__Email__c');
        var newDedupeConfig = component.get("v.newDedupeConfig");
        newDedupeConfig.sobjectType = 'SmartDD__Dedupe_Configuration__c';
        var isValid = helper.validate(component,newDedupeConfig);
        component.set('v.showMessage',false);
        if(isValid) {
            component.find("Id_spinner").set("v.class" , 'slds-show');
            var actionSearchUser = component.get("c.searchUser");
            actionSearchUser.setParams({
                'searchUsername': searchUser,
                'searchEmail': searchEmail,
            });
            //alert('searchUser :' + searchUser);
            //alert('searchEmail : ' + searchEmail);
            actionSearchUser.setCallback(this, function(responseSearchUser) {
                debugger;
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = responseSearchUser.getState();
                if (state === 'SUCCESS') {
                    var isMatch = responseSearchUser.getReturnValue();
                    if(isMatch && isValid){
                        component.find("Id_spinner").set("v.class" , 'slds-show');
                        var objectname = 'Lead';
                        var action = component.get("c.checkCredentials");
                        action.setParams({
                            'objectName' : objectname
                        });
                        action.setCallback(this, function(response){
                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                            var state = response.getState();
                            //alert(state);
                            if (state === 'SUCCESS') {
                                var isCorrectPass = response.getReturnValue();
                                if(isCorrectPass == 'Success'){
                                    //alert('IN IF');
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',false);
                                    component.set('v.Message', 'Connection is valid');
                                    component.set('v.isDisabled',false);
                                } else if(isCorrectPass == 'authentication failure') {
                                    //alert('IN Else IF');
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',true);
                                    component.set('v.Message', 'Please enter valid Username and Email');
                                    component.set('v.isDisabled',true);
                                } else if(isCorrectPass == 'Database not available') {
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',true);
                                    component.set('v.isDisabled',true);
                                    component.set("v.Message", 'Database Not Available for This user. Please save configuration.');
                                } else if(isCorrectPass == 'Connected App Details Wrong') {
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',true);
                                    component.set('v.isDisabled',true);                                   
                                    component.set("v.Message", 'Consumer Key and Consumer Secret key are wrong in Configuration page. Please Correct.');
                                    
                                }/* else if(isCorrectPass == 'LicenseKey Invalid') {
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',true);
                                    component.set('v.isDisabled',true);
                                    component.set("v.Message", 'LicenseKey Invalid, Please Enter Valid Key.');
                                }*/ else {
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',true);
                                    component.set('v.isDisabled',true);
                                    var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                                    //component.set("v.Message", 'Server has stopped responding, please contact with the administrator: anil@logicrain.com');
                                    component.set('v.Message', homePageNewslabel);
                                }  
                            }
                        });
                        $A.enqueueAction(action);
                    }else{
                        component.set('v.showMessage',true);
                        component.set('v.isErrorMessage',true);
                        component.set('v.Message', 'Please enter valid Username and Email');
                        component.set('v.isDisabled',true);
                    }
                }
            });
            $A.enqueueAction(actionSearchUser);
        }
    },
    Next : function(component, event,helper){
        debugger;
        var newDedupeConfig = component.get("v.newDedupeConfig");
        newDedupeConfig.sobjectType = 'SmartDD__Dedupe_Configuration__c';
        var isValid = helper.validate(component,newDedupeConfig);
        component.set('v.showMessage',false);        
        if(isValid) {
            component.find("Id_spinner").set("v.class" , 'slds-show');
            var action = component.get("c.dedupeConfigCustomsetting");
            action.setCallback(this, function(response) {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var isMatch = response.getReturnValue();
                    if(isValid && isMatch.SmartDD__User_Configuration__c == true){
                        var tabChangeEvent = component.getEvent("tabFocus");
                        tabChangeEvent.setParams({
                            tabName : "SearchCol"
                        });
                        tabChangeEvent.fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    validate: function(component,newDedupeConfig) {
        debugger;
        if(newDedupeConfig != null){
            component.set('v.showMessage',true);
            if(newDedupeConfig.SmartDD__First_Name__c == null || newDedupeConfig.SmartDD__First_Name__c.trim() == '' 
               || newDedupeConfig.SmartDD__Last_Name__c == null || newDedupeConfig.SmartDD__Last_Name__c.trim() == ''
              // || newDedupeConfig.SmartDD__License_Key__c == null || newDedupeConfig.SmartDD__License_Key__c.trim() == ''
               || newDedupeConfig.SmartDD__Username__c == null || newDedupeConfig.SmartDD__Username__c.trim() == ''
               || newDedupeConfig.SmartDD__Email__c == null || newDedupeConfig.SmartDD__Email__c.trim() == '' ){
               //|| newDedupeConfig.SmartDD__Password__c == null || newDedupeConfig.SmartDD__Password__c.trim() == '') {
                component.set('v.isErrorMessage',true);
                component.set('v.Message', 'Required field is missing.');
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                return false;
            }
            return true;
        } else {
            return false;
        }
    },
})