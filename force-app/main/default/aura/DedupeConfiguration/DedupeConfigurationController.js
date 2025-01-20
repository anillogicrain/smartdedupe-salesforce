({
    doInit : function(component, event, helper) {
        helper.getUserProfile(component,event,helper);
    },
    onChangeTabFocus : function(component, event, helper) {
        debugger;
        if(event.getParam("message") != null){
            component.set("v.strErrorMessage",event.getParam("message"));
        }
        if(event.getParam("syncObjectName") != null){
            component.set("v.strSyncObjectName",event.getParam("syncObjectName"));
        }
        component.find("tabset").set("v.selectedTabId",event.getParam("tabName"));
        var selectedtab = component.find("tabset").get("v.selectedTabId",event.getParam("tabName"));
        if(selectedtab == 'Synctab'){
            var result = component.find("SyncCompId");
            result.reLoadMethod();
        }
        helper.getUserProfile(component,event,helper);
    },
    
    tabSelected : function(component, event, helper) {
        debugger;
        var selectedtab = component.find("tabset").get("v.selectedTabId");
        if(selectedtab == 'detailTab'){
            component.find("tabset").set("v.selectedTabId","detailTab");
        }else if(selectedtab == 'SearchCol'){ 
            component.find("Id_spinner").set("v.class" , 'slds-show');
            var action = component.get("c.dedupeConfigCustomsetting");
            action.setCallback(this, function(response) {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === 'SUCCESS') {
                    debugger;
                    var isMatch = response.getReturnValue();
                    if(component.find("DedupeconfigdetailId") != undefined) {
                    component.find("DedupeconfigdetailId").set('v.showMessage',true);
                    }
                    if(isMatch.SmartDD__User_Configuration__c != true){ 
                        component.find("tabset").set("v.selectedTabId","detailTab");
                        if(component.find("DedupeconfigdetailId") != undefined) {
                        component.find("DedupeconfigdetailId").set('v.isErrorMessage',true);
                        component.find("DedupeconfigdetailId").set('v.Message', 'Please check connection first.');
                        }
                    }else{
                        component.find("tabset").set("v.selectedTabId","SearchCol");
                        if(component.find("DedupeconfigdetailId") != undefined) {
                        component.find("DedupeconfigdetailId").set('v.isErrorMessage',false);  
                        component.find("DedupeconfigdetailId").set('v.showMessage',false);   
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }else if(selectedtab == 'Synctab'){
            debugger;
            component.find("Id_spinner").set("v.class" , 'slds-show');
            var actionstatus = component.get("c.dedupeConfigCustomsetting");
            actionstatus.setCallback(this, function(response) {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state == 'SUCCESS') {
                    var isMatch = response.getReturnValue();
                    if(isMatch.SmartDD__User_Configuration__c != true){ 
                        component.find("tabset").set("v.selectedTabId","detailTab");
                        if(component.find("DedupeconfigdetailId") != undefined) {
                        component.find("DedupeconfigdetailId").set('v.showMessage',true);
                        component.find("DedupeconfigdetailId").set('v.isErrorMessage',true);
                        component.find("DedupeconfigdetailId").set('v.Message', 'Please check connection first.');
                        }
                    }else{
                        component.find("tabset").set("v.selectedTabId","Synctab");
                        var result = component.find("SyncCompId");
                        result.reLoadMethod(); 
                        if(component.find("DedupeconfigdetailId") != undefined) {
                        component.find("DedupeconfigdetailId").set('v.isErrorMessage',false);  
                        component.find("DedupeconfigdetailId").set('v.showMessage',false); 
                        }    
                    }
                }
            });
            $A.enqueueAction(actionstatus);
            
        }else if(selectedtab == 'ManageFilesTab'){debugger;
            component.find("Id_spinner").set("v.class" , 'slds-show');
            var action = component.get("c.dedupeConfigCustomsetting");
            action.setCallback(this, function(response) {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var isMatch = response.getReturnValue();
                    if(component.find("DedupeconfigdetailId") != undefined) {
                    component.find("DedupeconfigdetailId").set('v.showMessage',true);
                    }
                    if(isMatch.SmartDD__User_Configuration__c != true){ 
                        component.find("tabset").set("v.selectedTabId","ManageFilesTab");
                        if(component.find("DedupeconfigdetailId") != undefined) {
                        component.find("DedupeconfigdetailId").set('v.isErrorMessage',true);
                        component.find("DedupeconfigdetailId").set('v.Message', 'Please check connection first.');
                        }
                    }else{
                        component.find("tabset").set("v.selectedTabId","ManageFilesTab");
                        if(component.find("DedupeconfigdetailId") != undefined) {
                        component.find("DedupeconfigdetailId").set('v.isErrorMessage',false);  
                        component.find("DedupeconfigdetailId").set('v.showMessage',false);   
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    togglePopup: function(component, event, helper) {
        component.set("v.isPopupVisible", true);
    },
        
    closePopup: function(component, event, helper) {
        component.set("v.isPopupVisible", false);
    }
    
})