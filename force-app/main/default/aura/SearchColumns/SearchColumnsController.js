({
    doInit: function (component, event, helper) {
        component.set('v.displaySave', true);
        component.find("Search_spinner").set("v.class", 'slds-show');
        var action = component.get("c.fetchDedupeSearchCols");
        action.setParams({
            "ObjectName": 'Lead'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var returnResult = returnValue[0].FieldsList;
                var rvwPolishResult = returnValue[0].ReviewPolishFieldsList;
                var options = [];

                for (var i = 0; i < returnResult.length; i++) {
                    var opt = {};
                    opt.label = returnResult[i].fieldLabelName;
                    opt.value = returnResult[i].fieldApiName;
                    options.push(opt);
                }
                component.set('v.options', options);

                var ColumnOptions = [];
                for (var i = 0; i < returnResult.length; i++) {
                    var opt = {};
                    opt.label = returnResult[i].fieldLabelName;
                    opt.value = returnResult[i].fieldApiName;
                    ColumnOptions.push(opt);
                }
                component.set('v.dedupeDisplayOption', options);
                var rvwPlshOptions = [];
                for (var i = 0; i < rvwPolishResult.length; i++) {
                    var opt = {};
                    opt.label = rvwPolishResult[i].fieldLabelName;
                    opt.value = rvwPolishResult[i].fieldApiName;
                    rvwPlshOptions.push(opt);
                }
                component.set('v.rvwPolishOptions', rvwPlshOptions);
                component.find("Search_spinner").set("v.class", 'slds-hide');
            }
        });
        $A.enqueueAction(action);
        var actionSetVals = component.get("c.fetchSelectedFieldsCols");
        actionSetVals.setParams({
            "objectName": 'Lead'
        });
        actionSetVals.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if (returnValue != '' && returnValue != null) {
                    if (returnValue[0].SmartDD__Search_Object_Fields__c != '' && returnValue[0].SmartDD__Search_Object_Fields__c != null) {
                        component.set('v.fieldValues', returnValue[0].SmartDD__Search_Object_Fields__c.split(','));
                    }
                    if (returnValue[0].SmartDD__Search_Column_Fields__c != '' && returnValue[0].SmartDD__Search_Column_Fields__c != null) {
                        component.set('v.columnValues', returnValue[0].SmartDD__Search_Column_Fields__c.split(','));
                        component.set('v.prevColumnValues', returnValue[0].SmartDD__Search_Column_Fields__c.split(','));
                    }
                    if (returnValue[0].SmartDD__Review_Polish_Display_Columns__c != '' && returnValue[0].SmartDD__Review_Polish_Display_Columns__c != null) {
                        component.set('v.rvwPlshValues', returnValue[0].SmartDD__Review_Polish_Display_Columns__c.split(','));
                        component.set('v.prevRvwPlshValues', returnValue[0].SmartDD__Review_Polish_Display_Columns__c.split(','));
                    }
                }
            }
        });
        $A.enqueueAction(actionSetVals);
    },
    saveSelectedFieldsColumns: function (component, event, handler) {
        debugger;
        component.find("Search_spinner").set("v.class", 'slds-show');
        var selectedFields = component.get("v.fieldValues");
        var selectedColumns = component.get("v.columnValues");
        var selectedRvwPolishColumns = component.get("v.rvwPlshValues");
        var selectedObjectName = component.find("viewObjectfilter").get("v.value");

        if ((selectedFields == '' || selectedFields == null || selectedFields == undefined) || (selectedColumns == '' || selectedColumns == null || selectedColumns == undefined) || (selectedRvwPolishColumns == '' || selectedRvwPolishColumns == null || selectedRvwPolishColumns == undefined)) {
            debugger;
            component.set('v.showMessage', true);
            component.set('v.isErrorMessage', true);
            component.set('v.Message', 'Please select atleast one element in each.');
            component.find("Search_spinner").set("v.class", 'slds-hide');
        }
        else {
            debugger;
            var actionSyncChk = component.get('c.GetDedupeConfigCustomSettings');
            actionSyncChk.setCallback(this, function (responseSyncChk) {
                var state = responseSyncChk.getState();
                if (state == 'SUCCESS') {
                    debugger;
                    var boolRetVal = responseSyncChk.getReturnValue();
                    if (boolRetVal.SmartDD__Sync_Data__c == true) {
                        component.set('v.showMessage', true);
                        component.set('v.isErrorMessage', true);
                        component.set("v.Message", "Sync data is in Progress on " + boolRetVal.SmartDD__Sync_Object_Name__c + " by " + boolRetVal.SmartDD__Synced_By_UserName__c + " for total " + boolRetVal.SmartDD__Total_Records_Synced__c + " records on " + boolRetVal.SmartDD__Last_Sync_date__c + ".");
                        component.find("Search_spinner").set("v.class", 'slds-hide');
                    }
                    else {
                        debugger;
                        component.set('v.showMessage', false);
                        component.set('v.isErrorMessage', false);
                        component.set('v.showInformation', false);
                        var action = component.get("c.saveDedupeSearchFields");
                        action.setParams({
                            "leadSelectedField": selectedFields.toString(),
                            "objectName": selectedObjectName,
                            "leadSelectedColumns": selectedColumns.toString(),
                            "leadRvwPolishColumns": selectedRvwPolishColumns.toString()
                        });
                        action.setCallback(this, function (response) {
                            debugger;
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var saveResult = response.getReturnValue();
                                if (saveResult != true) {
                                    var actionChkValidCols = component.get("c.CheckValidColumns");
                                    actionChkValidCols.setParams({
                                        "dedupeFieldCols": selectedFields.join(','),
                                        "objectName": selectedObjectName
                                    });
                                    actionChkValidCols.setCallback(this, function (respChkValidCols) {
                                        debugger;
                                        var stateChkValidCols = respChkValidCols.getState();
                                        if (stateChkValidCols === "SUCCESS") {
                                            var rsltChkValidCols = respChkValidCols.getReturnValue();
                                            /*if(rsltChkValidCols != '') {
                                                component.set('v.showMessage',true);
                                                component.set('v.isErrorMessage',true);
                                                component.set("v.Message", "The field "+ rsltChkValidCols +" you selected under section Dedupe Fields Columns have records less then 20. So please change the combination for the described section.");	
                                                component.find("Search_spinner").set("v.class" , 'slds-hide');
                                            } else {*/
                                            debugger;
                                            component.set('v.showMessage', false);
                                            component.set('v.isErrorMessage', false);
                                            var actionPost = component.get("c.postDedupeColsrequest");
                                            actionPost.setParams({
                                                "filterObjectName": selectedObjectName
                                            });
                                            actionPost.setCallback(this, function (responsePost) {
                                                debugger;
                                                var statePost = responsePost.getState();
                                                if (statePost === "SUCCESS") {
                                                    var isSuccessmsg = responsePost.getReturnValue();
                                                    if (isSuccessmsg == '1') {
                                                        component.find("Search_spinner").set("v.class", 'slds-hide');
                                                        var tabChangeEvent = component.getEvent("tabFocus");
                                                        tabChangeEvent.setParams({
                                                            tabName: "Synctab",
                                                            syncObjectName: selectedObjectName
                                                        });
                                                        tabChangeEvent.fire();
                                                    }
                                                    else {
                                                        component.set('v.showInformation', true);
                                                        component.set('v.Notification', 'Server is not responding, please contact with the administrator: Frank@mahcom.com');
                                                        component.find("Search_spinner").set("v.class", 'slds-hide');
                                                    }
                                                }
                                            });
                                            $A.enqueueAction(actionPost);
                                            //}
                                        }
                                    });
                                    $A.enqueueAction(actionChkValidCols);

                                } else {
                                    debugger;
                                    component.set('v.showMessage', true);
                                    var selectedColumns = component.get("v.columnValues");
                                    var prevSelectedColumns = component.get("v.prevColumnValues");
                                    var seltdRvwPlshColms = component.get("v.rvwPlshValues");
                                    var prevSeltdRvwPlshColms = component.get("v.prevRvwPlshValues");
                                    if (JSON.stringify(selectedColumns) != JSON.stringify(prevSelectedColumns) || JSON.stringify(seltdRvwPlshColms) != JSON.stringify(prevSeltdRvwPlshColms)) {
                                        component.set('v.isErrorMessage', false);
                                        component.set('v.Message', 'Records Saved Successfully.');
                                        component.set("v.prevColumnValues", selectedColumns);
                                        component.set("v.prevRvwPlshValues", seltdRvwPlshColms);
                                    } else {
                                        component.set('v.isErrorMessage', true);
                                        component.set('v.Message', 'No change made in the existed mapping record.');
                                    }

                                    component.find("Search_spinner").set("v.class", 'slds-hide');
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
    nextSelectedFieldsColumns: function (component, event, handler) {
        debugger;

        component.find("Search_spinner").set("v.class", 'slds-show');
        var selectedFields = component.get("v.fieldValues");
        var selectedColumns = component.get("v.columnValues");
        var selectedRvwPolishColumns = component.get("v.rvwPlshValues");
        var selectedObjectName = component.find("viewObjectfilter").get("v.value");

        if ((selectedFields == '' || selectedFields == null || selectedFields == undefined) || (selectedColumns == '' || selectedColumns == null || selectedColumns == undefined) || (selectedRvwPolishColumns == '' || selectedRvwPolishColumns == null || selectedRvwPolishColumns == undefined)) {
            debugger;
            component.set('v.showMessage', true);
            component.set('v.isErrorMessage', true);
            component.set('v.Message', 'Please select atleast one element in each.');
            component.find("Search_spinner").set("v.class", 'slds-hide');
        }
        else {
            debugger;
            var actionSyncChk = component.get('c.GetDedupeConfigCustomSettings');
            actionSyncChk.setCallback(this, function (responseSyncChk) {
                var state = responseSyncChk.getState();
                if (state == 'SUCCESS') {
                    debugger;
                    var boolRetVal = responseSyncChk.getReturnValue();
                    if (boolRetVal.SmartDD__Sync_Data__c == true) {
                        component.set('v.showMessage', true);
                        component.set('v.isErrorMessage', true);
                        component.set("v.Message", "Sync data is in Progress on " + boolRetVal.SmartDD__Sync_Object_Name__c + " by " + boolRetVal.SmartDD__Synced_By_UserName__c + " for total " + boolRetVal.SmartDD__Total_Records_Synced__c + " records on " + boolRetVal.SmartDD__Last_Sync_date__c + ".");
                        component.find("Search_spinner").set("v.class", 'slds-hide');
                    }
                    else {
                        debugger;
                        component.set('v.showMessage', false);
                        component.set('v.isErrorMessage', false);
                        component.set('v.showInformation', false);
                        var action = component.get("c.nextDedupeSearchFields");
                        action.setParams({
                            "leadSelectedField": selectedFields.toString(),
                            "objectName": selectedObjectName,
                            "leadSelectedColumns": selectedColumns.toString(),
                            "leadRvwPolishColumns": selectedRvwPolishColumns.toString()
                        });
                        action.setCallback(this, function (response) {
                            debugger;

                            var state = response.getState();

                            if (state === "SUCCESS") {
                                var saveResult = response.getReturnValue();

                                if (saveResult != true) {
                                    var actionChkValidCols = component.get("c.CheckValidColumns");
                                    actionChkValidCols.setParams({
                                        "dedupeFieldCols": selectedFields.join(','),
                                        "objectName": selectedObjectName
                                    });
                                    actionChkValidCols.setCallback(this, function (respChkValidCols) {
                                        debugger;
                                        var stateChkValidCols = respChkValidCols.getState();
                                        if (stateChkValidCols === "SUCCESS") {
                                            var rsltChkValidCols = respChkValidCols.getReturnValue();
                                            /*if(rsltChkValidCols != '') {
                                                component.set('v.showMessage',true);
                                                component.set('v.isErrorMessage',true);
                                                component.set("v.Message", "The field "+ rsltChkValidCols +" you selected under section Dedupe Fields Columns have records less then 20. So please change the combination for the described section.");	
                                                component.find("Search_spinner").set("v.class" , 'slds-hide');
                                            } else {*/
                                            debugger;
                                            component.set('v.showMessage', false);
                                            component.set('v.isErrorMessage', false);
                                            var actionPost = component.get("c.postDedupeColsrequest");
                                            actionPost.setParams({
                                                "filterObjectName": selectedObjectName
                                            });
                                            actionPost.setCallback(this, function (responsePost) {
                                                debugger;
                                                var statePost = responsePost.getState();
                                                if (statePost === "SUCCESS") {
                                                    var isSuccessmsg = responsePost.getReturnValue();
                                                    if (isSuccessmsg == '1') {
                                                        component.find("Search_spinner").set("v.class", 'slds-hide');
                                                        var tabChangeEvent = component.getEvent("tabFocus");
                                                        tabChangeEvent.setParams({
                                                            tabName: "Synctab",
                                                            syncObjectName: selectedObjectName
                                                        });
                                                        tabChangeEvent.fire();
                                                    }
                                                    else {
                                                        component.set('v.showInformation', true);
                                                        component.set('v.Notification', 'Server is not responding, please contact with the administrator: Frank@mahcom.com');
                                                        component.find("Search_spinner").set("v.class", 'slds-hide');
                                                    }
                                                }
                                            });
                                            $A.enqueueAction(actionPost);
                                        }
                                        //}
                                    });
                                    $A.enqueueAction(actionChkValidCols);

                                } else {
                                    debugger;
                                    // component.set('v.showMessage',true);
                                    var selectedColumns = component.get("v.columnValues");
                                    var prevSelectedColumns = component.get("v.prevColumnValues");
                                    var seltdRvwPlshColms = component.get("v.rvwPlshValues");
                                    var prevSeltdRvwPlshColms = component.get("v.prevRvwPlshValues");

                                    /*  if(JSON.stringify(selectedColumns)!=JSON.stringify(prevSelectedColumns) || JSON.stringify(seltdRvwPlshColms)!=JSON.stringify(prevSeltdRvwPlshColms)) {
                                          component.set('v.isErrorMessage',false);
                                          component.set('v.Message', 'Records Saved Successfully.');
                                          component.set("v.prevColumnValues",selectedColumns);
                                          component.set("v.prevRvwPlshValues",seltdRvwPlshColms);
                                      } else {
                                          component.set('v.isErrorMessage',true);
                                          component.set('v.Message', '-->No change made in the existed mapping record.');
                                      }*/

                                    component.find("Search_spinner").set("v.class", 'slds-hide');
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
    chooseColumns: function (component, event, helper) {
        component.set('v.showMessage', false);
        helper.displayObjectColumns(component, event, helper);
    },
    DedupeFieldColClick: function (component, event, helper) {
        $A.util.toggleClass(component.find("DedupeFieldRuleId"), 'slds-hide');
    },
    DedupeFieldColMouseLeave: function (component, event, helper) {
        $A.util.addClass(component.find("DedupeFieldRuleId"), 'slds-hide');
    },
    DedupeFieldColMouseEnter: function (component, event, helper) {
        $A.util.removeClass(component.find("DedupeFieldRuleId"), 'slds-hide');
    },
    DedupeDispClick: function (component, event, helper) {
        $A.util.toggleClass(component.find("DedupeDispRuleId"), 'slds-hide');
    },
    DedupeDispLeave: function (component, event, helper) {
        $A.util.addClass(component.find("DedupeDispRuleId"), 'slds-hide');
    },
    DedupeDispEnter: function (component, event, helper) {
        $A.util.removeClass(component.find("DedupeDispRuleId"), 'slds-hide');
    },
    ReviewMergeClick: function (component, event, helper) {
        $A.util.toggleClass(component.find("ReviewMergeRuleId"), 'slds-hide');
    },
    ReviewMergeLeave: function (component, event, helper) {
        $A.util.addClass(component.find("ReviewMergeRuleId"), 'slds-hide');
    },
    ReviewMergeEnter: function (component, event, helper) {
        $A.util.removeClass(component.find("ReviewMergeRuleId"), 'slds-hide');
    }
})