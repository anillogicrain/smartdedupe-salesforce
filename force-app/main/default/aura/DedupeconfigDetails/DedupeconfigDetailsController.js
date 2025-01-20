({
    doInit : function(component, event, helper) {
        
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var action = component.get("c.getDedupeConfig");
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue != null){
                    component.set("v.newDedupeConfig",returnValue);
                }
            }
        });
        $A.enqueueAction(action);
        var action = component.get("c.dedupeConfigCustomsetting");
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === 'SUCCESS') {
                var isMatch = response.getReturnValue();
                if(isMatch.User_Configuration__c == true){
                    component.set('v.isDisabled',false);
                }else{
                    component.set('v.isDisabled',true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    /*OnChangeIsMannual: function(component,event,helper){
       // debugger;
        var blnIsMannual = component.find('IsMannualCluster').get("v.checked");
        component.set('v.isMannualFlag',blnIsMannual);
    },*/
    /*validate : function(component, event, helper) {
        debugger;
        var password = component.find('pwd');
        var pwdValue = password.get('v.value');
        if(!pwdValue || pwdValue.trim().length === 0) {
            password.set("v.errors", [{message:"Password is required."}]);
            $A.util.addClass(password, 'slds-has-error');
        }else{
            $A.util.removeClass(password, 'slds-has-error');
            password.set("v.errors", false); 
        }
    },*/
    onSave : function(component, event, helper) {
        debugger;
        var newDedupeConfig = component.get("v.newDedupeConfig");
        newDedupeConfig.sobjectType = 'SmartDD__Dedupe_Configuration__c';
        var blnValidate = helper.validate(component,newDedupeConfig);
        if(blnValidate) {
            var searchUser = component.get('v.newDedupeConfig.SmartDD__Username__c');
            var searchEmail = component.get('v.newDedupeConfig.SmartDD__Email__c');
            component.set('v.showMessage',false);
            component.find("Id_spinner").set("v.class" , 'slds-show');
            var action = component.get("c.searchUser");
            action.setParams({
                'searchUsername': searchUser,
                'searchEmail': searchEmail
            });
            action.setCallback(this, function(response) {
                debugger;
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var isMatch = response.getReturnValue();
                    if(isMatch){
                        var action = component.get("c.saveDedupeConfig");
                        action.setParams({
                            "newDedupeConfig": component.get("v.newDedupeConfig"),
                            "isMannualFlag": component.get('v.isMannualFlag')
                        });
                        action.setCallback(this, function(response){
                             debugger;
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var returnValue = response.getReturnValue();
                                var actionCallJson = component.get("c.postDedupeAuthRecords");
                                actionCallJson.setParams({
                                    "LogId": returnValue
                                });
                                actionCallJson.setCallback(this, function(responseJson){
                                    debugger;
                                    var stateJson = responseJson.getState();
                                    if (state === "SUCCESS") {
                                        var returnJsonVal = responseJson.getReturnValue();
                                        if(returnJsonVal != 'Success') {
                                            component.set('v.showMessage',true);
                                            component.set('v.isErrorMessage',true);
                                            component.set('v.isDisabled',true);
                                            component.set('v.Message', returnJsonVal);
                                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                                        } else {
                                            component.set('v.showMessage',true);
                                            component.set('v.isErrorMessage',false);
                                            component.set('v.isDisabled',false);
                                            component.set('v.Message', 'Records Saved Successfully');
                                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                                        }
                                    }
                                });
                                $A.enqueueAction(actionCallJson);
                            }
                        });
                        $A.enqueueAction(action);
                    }
                    else{
                        component.set('v.showMessage',true);
                        component.set('v.isErrorMessage',true);
                        component.set('v.isDisabled',true);
                        component.set('v.Message', 'Please enter valid Username and Email');
                        component.find("Id_spinner").set("v.class" , 'slds-hide');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    onNext : function(component, event, helper) {
        helper.Next(component, event,helper);
    },
    //checkConnection
    checkConnection : function(component, event, helper) {
        helper.SearchHelper(component, event,helper);
    },
    OnRuleClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("ruleId"), 'slds-hide');
    },
    OnRuleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("ruleId"), 'slds-hide');
    },
    OnRuleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("ruleId"), 'slds-hide');
    }
})