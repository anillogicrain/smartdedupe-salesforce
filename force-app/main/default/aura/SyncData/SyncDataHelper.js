({
    pollApex : function(component, event, helper) { 
        var interval = setInterval($A.getCallback(function () {
            helper.checkStatusMethod(component,helper,interval);
        }), 120000);
        component.set("v.setIntervalId", interval) ;
    },
    setUsername : function(component, event, helper){
        var action = component.get("c.credentialDetails");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnRes = response.getReturnValue();
                component.set("v.syncUserName", returnRes.SmartDD__Username__c);
            }
        });
        $A.enqueueAction(action);
    },

    handleResponse : function(response, component,interval) {
        component.set("v.isOpenPopUp", false);
        var intPercentCount = component.get('v.percentCount');
        var retVal = response.getReturnValue();
        //if(retVal != null || retVal != 0 || retVal != undefined){
        if(retVal.Completed != 1 && retVal.Processing != 1) {
            var statPercentVal = (retVal.duplicateRecords + retVal.insertedRecords) * 100 / retVal.totalRecords;
            var range = Math.floor((Math.random() * 10) +60);
            if(statPercentVal != null) {
                range = statPercentVal;
            }
            if(statPercentVal >= range) {
                intPercentCount = Math.trunc( statPercentVal )
            } else {
                if(intPercentCount < 90) {
                    intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
                }
            }
            //component.set("v.percentCount",Math.trunc( statPercentVal ));
            component.set("v.percentCount",intPercentCount);
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            if(statPercentVal == 100) {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                component.set("v.showBodyStructure",true);
                component.set("v.isDataProgress",true);
                component.set('v.progress', intPercentCount);
                component.set('v.showMessage',true);
                component.set('v.Message', 'Records Synced Successfully.');
                component.set("v.showHideSyncButton", false);
                //component.find("chkObject").set("v.disabled", true);
                clearInterval(interval);
                var action = component.get('c.GetDedupeConfigCustomSettings');
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    if(state == 'SUCCESS') {
                        var lstSyncDate = response.getReturnValue();
                        if(lstSyncDate.SmartDD__Last_Sync_date__c != '') {
                            component.set('v.lastSyncDateTrue',true);
                            component.set("v.lastSyncDateTime",lstSyncDate.SmartDD__Last_Sync_date__c);
                        }
                    }
                });
                $A.enqueueAction(action);
                return;
            }
            else {
                component.set("v.showBodyStructure",false);
                component.set("v.isDataProgress",true);                
                component.set('v.progress', intPercentCount);
                component.set("v.showHideSyncButton",false);
            }
        } else {
            if(retVal.Completed == 1) {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                component.set("v.showBodyStructure",true);
                component.set("v.isDataProgress",true);
                component.set('v.progress', 100);
                component.set("v.percentCount", 100);
                component.set('v.showMessage',true);
                component.set('v.Message', 'Records Synced Successfully.');
                component.set("v.showHideSyncButton", false);
                //component.find("chkObject").set("v.disabled", true);
                clearInterval(interval);
                var action = component.get('c.GetDedupeConfigCustomSettings');
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    if(state == 'SUCCESS') {
                        var lstSyncDate = response.getReturnValue();
                        if(lstSyncDate.SmartDD__Last_Sync_date__c != '') {
                            component.set('v.lastSyncDateTrue',true);
                            component.set("v.lastSyncDateTime",lstSyncDate.SmartDD__Last_Sync_date__c);
                        }
                    }
                });
                $A.enqueueAction(action);
                return;
            } else {
                component.set("v.showBodyStructure",false);
                //component.set("v.isDataProgress",true);                
                component.set("v.showHideSyncButton",false);
            }
        }
        //component.set('v.showMessage',false);
        //component.set('v.Message', '');
        //component.find("Id_spinner").set("v.class" , 'slds-hide');
        //component.set('v.httpResMessage',true);
        //component.set("v.flagProgressCheck",false);
        //component.set("v.showBodyStructure",true);
        //component.set("v.isDataProgress",false);
        //component.set("v.showHideSyncButton",false);
        //component.set('v.progress', 0);
        //clearInterval(interval);
        return;
    },
    checkStatusMethod: function (component,helper,interval) {
        //component.find("chkObject").set("v.disabled", true);
        var syncProgress = component.get('c.CheckSyncprogress');
        syncProgress.setCallback(this, function(response){
            var state = response.getState(); 
            var returnResponse = response.getReturnValue();
            if(state == 'SUCCESS') {
                debugger;
                if(returnResponse != null || returnResponse != undefined){
                    this.handleResponse(response, component,interval);
                }
                else{
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    component.set('v.httpResMessage',true);
                    component.set("v.flagProgressCheck",false);
                    component.set("v.showBodyStructure",true);
                    component.set("v.isDataProgress",false);
                    component.set("v.showHideSyncButton",false);
                    component.set('v.progress', 0);
                    clearInterval(interval);
                    return;
                }
            }
            else{
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                component.set('v.httpResMessage',true);
                component.set("v.flagProgressCheck",false);
                component.set("v.showBodyStructure",true);
                component.set("v.isDataProgress",false);
                component.set("v.showHideSyncButton",false);
                component.set('v.progress', 0);
                clearInterval(interval);
                return;
            }
        });
        $A.enqueueAction(syncProgress);
    },
    checkBatchStatus : function(component, event, helper, batchId,batchName) { 
        debugger;
        var interval = setInterval($A.getCallback(function () {
            helper.checkBatchProcess(component,helper,interval,batchId,batchName);
        }), 15000); 
        component.set("v.setIntervalId", interval) ;   
    },
    checkBatchProcess : function (component,event,helper,batchId,batchName){
        var action = component.get("c.AsyncApexJobRecords");  
        //component.find("chkObject").set("v.disabled", true);
        action.setParams({
            "BatchProcessId" : batchId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var batchName = batchName;
                var statPercentVal = 0;
                var apexSyncRecord = response.getReturnValue();
                var batchProcessStatus = apexSyncRecord.JobItemStatus;
                if(batchProcessStatus != 'Completed'){
                    if(apexSyncRecord.JobItemsProcessed != 0 && apexSyncRecord.TotalJobItems != 0){
                        statPercentVal = parseInt(((apexSyncRecord.JobItemsProcessed) / apexSyncRecord.TotalJobItems) * 100);  
                    }                 
                    component.set("v.percentCount",statPercentVal);
                    if(statPercentVal === 100) {
                        component.set("v.isDataProgress",true); 
                    }else{
                        component.set("v.isDataProgress",true);
                        component.find("Id_spinner").set("v.class" , 'slds-hide');
                        component.set('v.progress', statPercentVal);
                    }
                }
                if(batchProcessStatus == 'Completed'){
                    component.set("v.BatchName","");
                    if(batchName == 'deleteData'){
                        component.set("v.isDataProgress",true);
                        component.set('v.progress', statPercentVal);
                        this.helperdeletecallSyncData(component,event,helper);
                    }
                    else{
                        var totalNoOfRecord = this.totalnumberOfRecords(component,event,helper);
                        component.find("Id_spinner").set("v.class" , 'slds-hide');
                        window.clearInterval(component.get("v.setIntervalId"));
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    totalnumberOfRecords : function(component, event, helper) {
        debugger;
        var action = component.get("c.getDuplicateRecords");
        var noOfReco = 0;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var duplicateRecord = response.getReturnValue();
                component.set("v.duplicateleadCount",duplicateRecord); 
                noOfReco = duplicateRecord;
                component.set("v.isDataProgress",false);
                
                if(noOfReco != 0){
                    component.set("v.isOpenPopUp", true); 
                    component.set("v.isDataProgress",false);
                    window.clearInterval(component.get("v.setIntervalId"));
                }else{
                    component.set("v.isOpenPopUp", false); 
                    component.set("v.isDataProgress",false);
                    this.helpercallSyncData(component,event,helper);
                    window.clearInterval(component.get("v.setIntervalId"));
                }
            }
        });
        $A.enqueueAction(action); 
        return noOfReco;
    },
    helpercallSyncData : function(component, event, helper) {
        debugger;
        component.find("Id_spinner").set("v.class" , 'slds-hide');
        component.set("v.isOpenPopUp", false); 
        var action = component.get('c.SyncData');
        component.set("v.flagProgressCheck",false);
        component.set("v.showBodyStructure",true);
        component.set("v.isDataProgress",true);
        component.set("v.showHideSyncButton",false);
        action.setCallback(this, function(response){
            var errorMesssage = response.getReturnValue(); 
            var state = response.getState();
            if (state == "SUCCESS") {
                if(errorMesssage == 'success' || errorMesssage == 'Read timed out') {
                    this.pollApex(component,event,this);
                } else if(errorMesssage == 'authentication failure') {
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    component.set('v.httpResAuthErr',true);
                    component.set("v.flagProgressCheck",false);
                    component.set("v.showBodyStructure",true);
                    component.set("v.isDataProgress",false);
                    component.set("v.showHideSyncButton",false);
                    component.set("v.setIntervalId", 0) ;
                    window.clearInterval(component.get("v.setIntervalId"));
                } else {
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    component.set('v.httpResAuthErr',false);
                    component.set('v.httpResMessage',true);
                    component.set("v.flagProgressCheck",false);
                    component.set("v.showBodyStructure",true);
                    component.set("v.isDataProgress",false);
                    component.set("v.showHideSyncButton",false);
                    component.set("v.setIntervalId", 0) ;
                    window.clearInterval(component.get("v.setIntervalId"));
                }
            } else {
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                component.set('v.httpResAuthErr',false);
                component.set('v.httpResMessage',true);
                component.set("v.flagProgressCheck",false);
                component.set("v.showBodyStructure",true);
                component.set("v.isDataProgress",false);
                component.set("v.showHideSyncButton",false);
                component.set("v.setIntervalId", 0) ;
                window.clearInterval(component.get("v.setIntervalId"));
            }
        });
        component.set("v.flagProgressCheck",false);
        component.set("v.showBodyStructure",true);
        component.set("v.isDataProgress",true);
        component.set("v.showHideSyncButton",false);
        component.set("v.isDataProgress",true);
        //component.set('v.progress', 0);
        //component.set("v.setIntervalId", 0) ;
        //window.clearInterval(component.get("v.setIntervalId"));
        $A.enqueueAction(action);
    },
    helperdeletecallSyncData : function(component, event, helper) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        component.set("v.isOpenPopUp", false); 
        var action = component.get('c.SyncData');
        component.set("v.flagProgressCheck",false);
        component.set("v.showBodyStructure",true);
        component.set("v.isDataProgress",true);
        component.set("v.showHideSyncButton",false);
        action.setCallback(this, function(response){
            var errorMesssage = response.getReturnValue(); 
            if (state == "SUCCESS") {
            	if(errorMesssage == 'success') {	
                	this.pollApex(component,event,this);
                }else{
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    component.set('v.httpResMessage',true);
                    component.set("v.flagProgressCheck",false);
                    component.set("v.showBodyStructure",true);
                    component.set("v.isDataProgress",false);
                    component.set("v.showHideSyncButton",false);
                    component.set("v.setIntervalId", 0) ;
                    window.clearInterval(component.get("v.setIntervalId"));
                }
            }else{
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                component.set('v.httpResMessage',true);
                component.set("v.flagProgressCheck",false);
                component.set("v.showBodyStructure",true);
                component.set("v.isDataProgress",false);
                component.set("v.showHideSyncButton",false);
                component.set('v.progress', 0);
                window.clearInterval(component.get("v.setIntervalId"));
            }
        });
        window.clearInterval(component.get("v.setIntervalId"));
        component.set("v.isDataProgress",false);
        component.set('v.progress', 0);
        $A.enqueueAction(action);
    }
})