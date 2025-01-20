({
    doInit : function(component, event, helper) {
        component.set('v.showMessage',false);
        component.set('v.httpResMessage',false);
        component.set('v.httpResAuthErr',false);
        component.set('v.Message', '');
        component.set("v.percentCount",0);
        component.set('v.progress', 0);
        component.set("v.isDataProgress",false);
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var countRecord = component.get("c.SyncCountRecordsData"); 
        countRecord.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnresopnse = response.getReturnValue();
                component.set("v.prmSyncObjectName" , returnresopnse.SmartDD__Sync_Object_Name__c);
                component.set("v.prmSyncRecordCount" , returnresopnse.SmartDD__Total_Records_Synced__c);
            }
        });
        $A.enqueueAction(countRecord);
        
        var actionstatus = component.get("c.CheckSyncStatus");  
        actionstatus.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnresopnse = response.getReturnValue();
                component.set("v.flagProgressCheck",false);
                component.set("v.showBodyStructure",true);
                component.set("v.showHideSyncButton",false);
                /*if(component.find("chkObject") != undefined) {
                    component.find("chkObject").set("v.disabled", false);
                }*/
                
                /*if(component.find("chkObject") != undefined) {
                    component.find("chkObject").set("v.value",false);
                }*/
                if(returnresopnse != "Completed"){
                    component.find("Id_spinner").set("v.class" , 'slds-show');
                    /*if(component.find("chkObject") != undefined) {
                        component.find("chkObject").set("v.disabled", true);
                    }*/
                    helper.pollApex(component, event, helper);
                }
                else{
                    var action = component.get("c.synDataMapCustomsetting");
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state == 'SUCCESS') {
                            var isMatch = response.getReturnValue();
                            if(isMatch){
                                var actionCheckCred = component.get('c.checkCredentials');
                                actionCheckCred.setCallback(this, function(response){
                                    var errorMesssage = response.getReturnValue(); 
                                    var state = response.getState();
                                    if (state == "SUCCESS") {
                                        if(errorMesssage == 'success') {
                                            component.set("v.isModalOpen", false);
                                            component.set("v.flagProgressCheck",false);
                                            component.set("v.showBodyStructure",true);
                                            component.set("v.isDataProgress",true);
                                            component.set("v.showHideSyncButton",false);
                                            helper.helpercallSyncData(component, event, helper);
                                        } else if(errorMesssage == 'authentication failure') {
                                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                                            helper.setUsername(component, event, helper);
                                            component.set("v.isModalOpen", true); 
                                        } else if(errorMesssage == 'Database not available') { 
                                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                                            component.set("v.showMessage", true); 
                                            component.set("v.isErrorMessage", 'Database Not Available for This user. Please save configuration.');
                                        } else if(errorMesssage == 'Connected App Details Wrong') {
                                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                                            component.set("v.showMessage", true);
                                            component.set("v.isErrorMessage", 'Consumer Key and Consumer Secret key are wrong in Configuration page. Please Correct.');
                                            var tabChangeEvent = component.getEvent("tabFocus");
                                            tabChangeEvent.setParams({
                                                tabName : "detailTab",
                                                message : "Consumer Key and Consumer Secret key are wrong in Configuration page. Please Correct."
                                            });
                                            tabChangeEvent.fire();
                                        } 
                                    } 
                                }); 
                                $A.enqueueAction(actionCheckCred);
                            } else {
                                var action = component.get('c.GetDedupeConfigCustomSettings');
                                action.setCallback(this, function(response){
                                    var state = response.getState(); 
                                    if(state == 'SUCCESS') {
                                        var boolRetVal = response.getReturnValue();
                                        if(boolRetVal.SmartDD__Sync_Data__c == true) {
                                            //component.find("chkObject").set("v.disabled", true);
                                            component.set("v.flagProgressCheck",true);
                                            component.find("Id_spinner").set("v.class" , 'slds-show');
                                            helper.pollApex(component, event, helper);
                                        }
                                        else {
                                            component.set("v.showBodyStructure",true);
                                            component.set("v.flagProgressCheck",false);
                                            component.find("Id_spinner").set("v.class" , 'slds-hide');
                                        }
                                    }
                                });
                                 $A.enqueueAction(action);
                            }
                        }
                    });
                    
                    $A.enqueueAction(action);
                }
            }
        });
        $A.enqueueAction(actionstatus);
    },
    closeModel: function(component, event, helper) { 
        component.set("v.isModalOpen", false);
    },
    
    callSyncData : function(component, event, helper) {
        component.set("v.isDataProgress",true);        
        helper.helpercallSyncData(component, event, helper);
    },
    /*onChangeLead: function(component, event, helper) {
        var checkCmp = component.find("chkObject").get("v.value");
        if(checkCmp == true){
            component.set("v.showHideSyncButton",true);
        }
        else{
            component.set("v.showHideSyncButton",false);
        }
        var disable = component.get("v.disabled");
        if(disable == true){
            component.set("v.showHideSyncButton",false);
        }
    },*/
    fetchDuplicatData: function(component, event, helper) {
        var actionCheckCred = component.get('c.checkCredentials');
        actionCheckCred.setCallback(this, function(response) {
            var errorMesssage = response.getReturnValue(); 
            var state = response.getState();
            if (state == "SUCCESS") {
                if(errorMesssage == 'success') {
                    component.set("v.isModalOpen", false);
                    var action = component.get('c.findDuplicateData');
                    component.set("v.flagProgressCheck",false);
                    component.set("v.showBodyStructure",true);
                    component.set("v.isDataProgress",true);
                    component.set("v.showHideSyncButton",false);
                    action.setCallback(this, function(response){
                        var state = response.getState(); 
                        if(state == 'SUCCESS') {
                            //component.find("chkObject").set("v.disabled", true);
                            var batchName = 'fatchData';
                            component.set("v.BatchName",batchName);
                            var batchId = response.getReturnValue() ;
                            helper.checkBatchStatus(component,event,helper,batchId,batchName);
                        }
                    });
                    $A.enqueueAction(action); 
                } else if(errorMesssage == 'authentication failure') {
                    helper.setUsername(component, event, helper);
                    component.set("v.isModalOpen", true); 
                } 
            } 
        }); 
        $A.enqueueAction(actionCheckCred);
    },
    DeleteLeadDuplicateData : function(component, event, helper) {
        var action = component.get('c.findDeleteDuplicateData');
        component.set("v.isOpenPopUp", false); 
        component.set("v.flagProgressCheck",true);
        component.set("v.showBodyStructure",true);
        component.set("v.isDataProgress",true);
        component.set("v.showHideSyncButton",false);
        component.set("v.isOpenPopUp", false);
        debugger;
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var batchName = 'deleteData';
                component.set("v.BatchName",batchName);
                var batchId = response.getReturnValue() ;
                helper.checkBatchStatus(component,event,helper,batchId,batchName);
            }
        });
        $A.enqueueAction(action);
    }
})