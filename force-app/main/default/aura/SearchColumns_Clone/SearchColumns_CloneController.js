({
    doInit: function(component,event,helper) { 
        component.find("Search_spinner").set("v.class" , 'slds-show');
        
        var action = component.get("c.fetchDedupeSearchCols");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var returnResult = returnValue[0].FieldsList; 
                var rvwPolishResult = returnValue[0].ReviewPolishFieldsList;
                console.log('@@##$returnValue: '+returnValue);
                var options = [];
                for(var i=0;i<returnResult.length;i++){
                    var opt = {};
                    opt.label = returnResult[i].fieldLabelName;
                    opt.value = returnResult[i].fieldApiName ;
                    options.push(opt);
                }
                component.set('v.options',options);
                
                var rvwPlshOptions = [];		
                for(var i=0;i<rvwPolishResult.length;i++){		
                    var opt = {};		
                    opt.label = rvwPolishResult[i].fieldLabelName;		
                    opt.value = rvwPolishResult[i].fieldApiName ;		
                    rvwPlshOptions.push(opt);		
                }		
                component.set('v.rvwPolishOptions',rvwPlshOptions);
                component.find("Search_spinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.fetchContactSearchCols");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var returnResult = returnValue[0].FieldsList; 
                var rvwPolishResult = returnValue[0].ReviewPolishFieldsList;
                var options = [];
                for(var i=0;i<returnResult.length;i++){
                    var opt = {};
                    opt.label = returnResult[i].fieldLabelName;
                    opt.value = returnResult[i].fieldApiName ;
                    options.push(opt);
                }
                component.set('v.ContactOptions',options);
                
                var rvwPlshOptions = [];		
                for(var i=0;i<rvwPolishResult.length;i++){		
                    var opt = {};		
                    opt.label = rvwPolishResult[i].fieldLabelName;		
                    opt.value = rvwPolishResult[i].fieldApiName ;		
                    rvwPlshOptions.push(opt);		
                }		
                component.set('v.ContactRVWPolishOptions',rvwPlshOptions);
                component.find("Search_spinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
        
        var actionSetVals = component.get("c.fetchSelectedFieldsCols");
        actionSetVals.setParams({ 
            "objectName" : 'Lead'
        });
        actionSetVals.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue != '' && returnValue != null){
                    if(returnValue[0].SmartDD__Search_Object_Fields__c != '' && returnValue[0].SmartDD__Search_Object_Fields__c != null){
                        //alert(returnValue[0].Search_Object_Fields__c.split(','));
                        component.set('v.fieldValues',returnValue[0].SmartDD__Search_Object_Fields__c.split(','));
                    }
                    if(returnValue[0].SmartDD__Search_Column_Fields__c != '' && returnValue[0].SmartDD__Search_Column_Fields__c != null){
                        component.set('v.columnValues',returnValue[0].SmartDD__Search_Column_Fields__c.split(','));
                    }
                    if(returnValue[0].SmartDD__Review_Polish_Display_Columns__c != '' && returnValue[0].SmartDD__Review_Polish_Display_Columns__c != null){
                        component.set('v.rvwPlshValues',returnValue[0].SmartDD__Review_Polish_Display_Columns__c.split(','));
                    }
                }
            }
        });
        $A.enqueueAction(actionSetVals);
        
        var actionSetVals = component.get("c.fetchSelectedFieldsCols");
        actionSetVals.setParams({ 
            "objectName" : 'Contact'
        });
        actionSetVals.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue != '' && returnValue != null){
                    if(returnValue[0].SmartDD__Search_Object_Fields__c != '' && returnValue[0].SmartDD__Search_Object_Fields__c != null){
                        component.set('v.ContactFieldValues',returnValue[0].SmartDD__Search_Object_Fields__c.split(','));
                    }
                    if(returnValue[0].SmartDD__Search_Column_Fields__c != '' && returnValue[0].SmartDD__Search_Column_Fields__c != null){
                        component.set('v.ContactColumnValues',returnValue[0].SmartDD__Search_Column_Fields__c.split(','));
                    }
                    if(returnValue[0].SmartDD__Review_Polish_Display_Columns__c != '' && returnValue[0].SmartDD__Review_Polish_Display_Columns__c != null){
                        component.set('v.ContactRvwPlshValues',returnValue[0].SmartDD__Review_Polish_Display_Columns__c.split(','));
                    }
                }
            }
        });
        $A.enqueueAction(actionSetVals);
        
    },
    saveSelectedFieldsColumns: function (component, event, handler) { 
        debugger;
        component.find("Search_spinner").set("v.class" , 'slds-show');
        var selectedFields = component.get("v.fieldValues");
        var selectedColumns = component.get("v.columnValues");
        var selectedRvwPolishColumns = component.get("v.rvwPlshValues");
        
        if((selectedFields == '' || selectedFields == null || selectedFields == undefined) || (selectedColumns == '' || selectedColumns == null || selectedColumns == undefined) || (selectedRvwPolishColumns == '' || selectedRvwPolishColumns == null || selectedRvwPolishColumns == undefined)){
            component.set('v.showMessage',true);
            component.set('v.isErrorMessage',true);
            component.set('v.Message', 'Please select atleast one element in each.');
            component.find("Search_spinner").set("v.class" , 'slds-hide');
        }
        else{
            var actionSyncChk = component.get('c.GetDedupeConfigCustomSettings');
            actionSyncChk.setCallback(this, function(responseSyncChk){
                var state = responseSyncChk.getState();
                if(state == 'SUCCESS') {
                    var boolRetVal = responseSyncChk.getReturnValue();
                    if(boolRetVal.SmartDD__Sync_Data__c == true) {
                        component.set('v.showMessage',true);
						component.set('v.isErrorMessage',true);
						component.set('v.Message', 'Sync Data is in progress.');	
                        component.find("Search_spinner").set("v.class" , 'slds-hide');
                    }
                    else {
                        component.set('v.showMessage',false);
						component.set('v.isErrorMessage',false);
						component.set('v.showInformation',false);
                        var action = component.get("c.saveDedupeSearchFields");
                        action.setParams({ 
                            "leadSelectedField" : selectedFields.toString(),
                            "objectName" : 'Lead',
                            "leadSelectedColumns" : selectedColumns.toString(),
                            "leadRvwPolishColumns" : selectedRvwPolishColumns.toString()
                        });
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var saveResult = response.getReturnValue();
                                if(saveResult != true) {
                                    var actionPost = component.get("c.postDedupeColsrequest");
                                    actionPost.setParams({ 
                                    	"filterObjectName" : 'Lead'
                                    });
                                    actionPost.setCallback(this, function(responsePost){
                                        var statePost = responsePost.getState();
                                        if (statePost === "SUCCESS") {
                                            var isSuccessmsg =  responsePost.getReturnValue(); 
                                            if(isSuccessmsg == '1'){
                                                component.find("Search_spinner").set("v.class" , 'slds-hide');
                                                var tabChangeEvent = component.getEvent("tabFocus");
                                                tabChangeEvent.setParams({
                                                    tabName : "Synctab"
                                                });
                                                tabChangeEvent.fire();
                                            }
                                            else{
                                                component.set('v.showInformation',true);
                                                component.set('v.Notification', 'Server is not responding, please contact with the administrator: frank.mahdavi@mahcom.com');
                                                component.find("Search_spinner").set("v.class" , 'slds-hide');
                                            }
                                        }
                                    });
                                    $A.enqueueAction(actionPost);
                                }else{
                                    component.set('v.showMessage',true);
                                    component.set('v.isErrorMessage',true);
                                    component.set('v.Message', 'No change made in the existed mapping record.');
                                    component.find("Search_spinner").set("v.class" , 'slds-hide');
                                }
                            }
                        });
                        $A.enqueueAction(action);
                    }
                }
            });
            $A.enqueueAction(actionSyncChk);
        }
    },
    saveSelectedContactFieldsColumns: function (component, event, handler) { 
        debugger;
        component.find("Search_spinner").set("v.class" , 'slds-show');
        var selectedFields = component.get("v.ContactFieldValues");
        var selectedColumns = component.get("v.ContactColumnValues");
        var selectedRvwPolishColumns = component.get("v.ContactRvwPlshValues");
        
        if((selectedFields == '' || selectedFields == null || selectedFields == undefined) || (selectedColumns == '' || selectedColumns == null || selectedColumns == undefined) || (selectedRvwPolishColumns == '' || selectedRvwPolishColumns == null || selectedRvwPolishColumns == undefined)){
            component.set('v.ContactSectionshowMessage',true);
            component.set('v.ContactSectionIsErrorMessage',true);
            component.set('v.ContactSectionMessage', 'Please select atleast one element in each.');
            component.find("Search_spinner").set("v.class" , 'slds-hide');
        }
        else{
            var actionSyncChk = component.get('c.GetDedupeConfigCustomSettings');
            actionSyncChk.setCallback(this, function(responseSyncChk){
                var state = responseSyncChk.getState();
                if(state == 'SUCCESS') {
                    var boolRetVal = responseSyncChk.getReturnValue();
                    if(boolRetVal.SmartDD__Sync_Data__c == true) {
                        component.set('v.ContactSectionshowMessage',true);
						component.set('v.ContactSectionIsErrorMessage',true);
						component.set('v.ContactSectionMessage', 'Sync Data is in progress.');	
                        component.find("Search_spinner").set("v.class" , 'slds-hide');
                    }
                    else {
                        component.set('v.ContactSectionshowMessage',false);
						component.set('v.ContactSectionIsErrorMessage',false);
						component.set('v.ContactSectionShowInformation',false);
                        var action = component.get("c.saveDedupeSearchFields");
                        alert(selectedFields.toString());
                        alert(selectedColumns.toString());
                        alert(selectedFields.toString());
                        action.setParams({ 
                            "leadSelectedField" : selectedFields.toString(),
                            "objectName" : 'Contact',
                            "leadSelectedColumns" : selectedColumns.toString(),
                            "leadRvwPolishColumns" : selectedRvwPolishColumns.toString()
                        });
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var saveResult = response.getReturnValue();
                                alert('saveResult'+saveResult);
                                if(saveResult != true) {
                                    var actionPost = component.get("c.postDedupeColsrequest");
                                    actionPost.setParams({ 
                                    	"filterObjectName" : 'Contact'
                                    });
                                    actionPost.setCallback(this, function(responsePost){
                                        var statePost = responsePost.getState();
                                        if (statePost === "SUCCESS") {
                                            var isSuccessmsg =  responsePost.getReturnValue(); 
                                            if(isSuccessmsg == '1'){
                                                component.find("Search_spinner").set("v.class" , 'slds-hide');
                                                var tabChangeEvent = component.getEvent("tabFocus");
                                                tabChangeEvent.setParams({
                                                    tabName : "Synctab"
                                                });
                                                tabChangeEvent.fire();
                                            }
                                            else{
                                                component.set('v.ContactSectionShowInformation',true);
                                                component.set('v.ContactNotification', 'Server is not responding, please contact with the administrator: anil@logicrain.com');
                                                component.find("Search_spinner").set("v.class" , 'slds-hide');
                                            }
                                        }
                                    });
                                    $A.enqueueAction(actionPost);
                                }else{
                                    component.set('v.ContactSectionshowMessage',true);
                                    component.set('v.ContactSectionIsErrorMessage',true);
                                    component.set('v.ContactSectionMessage', 'No change made in the existed mapping record.');
                                    component.find("Search_spinner").set("v.class" , 'slds-hide');
                                }
                            }
                        });
                        $A.enqueueAction(action);
                    }
                }
            });
            $A.enqueueAction(actionSyncChk);
        }
    }
})