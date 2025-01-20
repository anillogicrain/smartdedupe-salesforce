({
    doInit: function (component, event, helper) {

        component.set("v.isShow", false);
        component.set("v.editFilter", false);
        component.set("v.objectColumns", true);
        component.set("v.Likedisable", false);
        component.set("v.isCreateClusterProgress", false);
        helper.fetchObjectList(component, event, helper);

        /**Restart DE-Dupe Process Call.*/
        var action = component.get("c.getDeDupeConfiguration");
        action.setCallback(this, function (response) {
            var messsage = response.getReturnValue();
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnResponse = response.getReturnValue();
                component.set('v.estimatedTime', returnResponse.SmartDD__Cluster_Estimated_Time__c);
                if (returnResponse.SmartDD__Start_Dedupe_Batch_Id__c != '' && returnResponse.SmartDD__Start_Dedupe_Batch_Id__c != null) {
                    console.log("SmartDD__Start_Dedupe_Batch_Id__c");
                    helper.checkBatchStatus(component, event, helper, returnResponse.SmartDD__Start_Dedupe_Batch_Id__c);
                } else {
                    debugger;
                    if (returnResponse.SmartDD__Clusters_Completed_Stat__c != 'Completed' && returnResponse.SmartDD__Clusters_Completed_Stat__c != '' && returnResponse.SmartDD__Last_Create_Cluster_Progress__c < 100) {
                        console.log("SmartDD__Clusters_Completed_Stat__c");
                        component.find("Id_spinner").set("v.class", 'slds-hide');
                        component.set("v.isCreateClusterProgress", true);
                        var intPercentCount = returnResponse.SmartDD__Last_Create_Cluster_Progress__c;
                        console.log("intPercentCount" + intPercentCount);
                        intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
                        console.log("intPercentCount1" + intPercentCount);
                        component.set("v.createClusterpercentCount", intPercentCount);
                        component.set("v.createClusterprogress", intPercentCount);
                        component.set('v.totalRecCount', returnResponse.SmartDD__Total_Records_Deduped__c);
                        console.log("returnResponse.SmartDD__Total_Records_Deduped__c" + returnResponse.SmartDD__Total_Records_Deduped__c);

                        helper.pollCreateCluster(component, event, helper);
                    }
                }
            }
        });
        $A.enqueueAction(action);
        /**END*/

    },

    chooseColumns: function (component, event, helper) {
        helper.chooseColumnsHelper(component, event, helper);
    },

    onSelectChange: function (component, event, helper) {
        component.set("v.Likedisable", false);
        component.find("Id_spinner").set("v.class", 'slds-show');
        // this function call on the select opetion change
        component.set("v.iserror", false);
        component.set('v.showInformation', false);
        component.set("v.errormsg", "");
        component.set("v.pageNoParm", 1);
        var editlink = component.find("editlink");
        var deletelink = component.find("deletelink");
        var selectedvalue = component.find("viewfilter").get("v.value");
        if (selectedvalue == undefined || selectedvalue == null || selectedvalue == '') {
            component.set('v.selectedFilterId', '');
        }
        else {
            component.set('v.selectedFilterId', selectedvalue);
        }
        if (selectedvalue == "") {
            $A.util.addClass(editlink, 'disablelink');
            $A.util.addClass(deletelink, 'disablelink');
        }
        else {
            $A.util.removeClass(editlink, 'disablelink');
            $A.util.removeClass(deletelink, 'disablelink');
        }
        component.set('v.showMessage', false);
        component.set('v.isErrorMessage', false);
        if (component.get("v.leadsAvail") == true) {
            component.find("searchKeyInp").set("v.value", "");
        }
        // Fetching Per page record Size from Custom Settings
        var action = component.get('c.GetPerPageRecordSize');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var recordSizeVal = returnVal.SmartDD__Per_Page_Record__c;
                component.set("v.totalTrainingRecCount", recordSizeVal.toString());
            }
        });
        $A.enqueueAction(action);
        helper.getSelectedObjColumns(component);
        component.find("Id_spinner").set("v.class", 'slds-hide');
    },
    onSelectObject: function (component, event, helper) {
        component.set("v.Likedisable", false);
        var objselected = component.find('objectid').get("v.value");
        component.set("v.ObjectName", objselected);
        helper.fetchFieldPicklist(component);
    },
    showHideDataTable: function (component, event, helper) {
        if (component.get("v.isSearchActive") == false) {
            component.set('v.leadsAvail', event.getParam("isAvailable"));
        }
        if (component.get("v.leadsAvail") == false) {
            component.set('v.searchResultAvail', false);
        }
    },
    showFilterPage: function (component, event, helper) {
        component.set("v.Likedisable", false);
        var editlink = component.find("editlink");
        var deletelink = component.find("deletelink");
        $A.util.addClass(editlink, 'disablelink');
        $A.util.addClass(deletelink, 'disablelink');
        component.set("v.objectColumns", false);
        component.set("v.isShow", false);
        component.set("v.editFilter", true);
        var filterpage = component.find('filterpage');
        $A.util.removeClass(filterpage, 'slds-hide');
        $A.util.addClass(filterpage, 'slds-show');
        component.set("v.iserror", false);
        component.set("v.errormsg", "");
        component.set('v.showInformation', false);
        component.set("v.Filter", {
            'sobjectType': 'SmartDD__Filter__c',
            'Name': ''
        });
        var filtercriterialist = component.get("v.Filterlist");
        if (filtercriterialist.length != 0) {
            component.set("v.Filterlist", filtercriterialist.splice(filtercriterialist.length, 1));
        }
        helper.fetchObjectPicklist(component);
        helper.fetchFieldPicklist(component);
        helper.fetchOperatorPicklist(component);
        helper.createFilterCriteria(component, event);
    },
    addFilterCriteria: function (component, event, helper) {
        component.set("v.Likedisable", false);
        component.getEvent("AddRowEvent").fire();
        var RowItemList = component.get("v.Filterlist");
        if (RowItemList.length > 1) {
            component.set("v.showDeleteIcon", true);
        } else {
            component.set("v.showDeleteIcon", false);
        }
    },
    addRow: function (component, event, helper) {
        component.set("v.Likedisable", false);
        var addrow = component.find("addrow");
        var RowItemList = component.get("v.Filterlist");
        if (RowItemList.length > 9) {
            $A.util.addClass(addrow, 'disablelink');
        }
        else {
            helper.createFilterCriteria(component, event);
        }
    },
    deleteRow: function (component, event, helper) {
        component.set("v.Likedisable", false);
        debugger;
        var RowItemList = component.get("v.Filterlist");
        var addrow = component.find("addrow");
        var self = this;  // safe reference
        var index = event.target.dataset.index;
        var dataid = event.target.dataset.id;
        helper.removeDeletedRow(component, index, dataid);
        console.log('@$#RowItemList' + RowItemList.length);
        if (RowItemList.length < 10) {
            $A.util.removeClass(addrow, 'disablelink');
        }
        if (RowItemList.length > 1) {
            component.set("v.showDeleteIcon", true);
        } else {
            component.set("v.showDeleteIcon", false);
        }
    },
    cancelFilter: function (component, event, helper) {
        component.set("v.Likedisable", false);
        component.find("filtername").set("v.value", "");
        component.set("v.txtfilterlogic", 'Add Filter Logic');
        var filtercriterialist = component.get("v.Filterlist");
        if (filtercriterialist.length != 0) {
            component.set("v.Filterlist", filtercriterialist.splice(filtercriterialist.length, 1));
        }
        component.set("v.isShow", true);
        component.set("v.iserror", false);
        component.set('v.showInformation', false);
        component.set("v.editFilter", false);
        component.set("v.objectColumns", true);
        component.find("viewObjectfilter").set("v.value", component.get("v.filterObjName"));
        var editlink = component.find("editlink");
        var deletelink = component.find("deletelink");
        var selectedvalue = component.get("v.selectedFilterId");

        if (selectedvalue == undefined || selectedvalue == null || selectedvalue == "") {
            $A.util.addClass(editlink, 'disablelink');
            $A.util.addClass(deletelink, 'disablelink');
        }
        else {
            component.find("viewfilter").set("v.value", selectedvalue);
            $A.util.removeClass(editlink, 'disablelink');
            $A.util.removeClass(deletelink, 'disablelink');
        }
    },
    removeRecord: function (component, event, helper) {
        component.set("v.Likedisable", false);
        component.set("v.iserror", false);
        var self = this;  // safe reference        
        var selectedvalue = component.find("viewfilter").get("v.value");
        var action = component.get("c.deleteFilterRecord");
        action.setParams({
            "filterid": selectedvalue
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isShow", true);
                component.set("v.editFilter", false);
                component.set("v.objectColumns", true);
                component.find("viewObjectfilter").set("v.value", component.get("v.filterObjName"));
                component.set('v.showInformation', false);
                component.set("v.iserror", true);
                component.set("v.errormsg", "Record deleted Successfully.");
                component.set("v.leadsAvail", false);
                component.set('v.searchResultAvail', false);
            }
        });
        $A.enqueueAction(action);
        helper.fetchViewPicklist(component);
        component.set("v.selectedFilterId", '');
        var editlink = component.find("editlink");
        var deletelink = component.find("deletelink");
        $A.util.addClass(editlink, 'disablelink');
        $A.util.addClass(deletelink, 'disablelink');

    },

    saveFilter: function (component, event, helper) {
        debugger;
        component.set("v.Likedisable", false);
        if (helper.validateForm(component, event)) {
            var action = component.get("c.saveFilterCriterias");
            var newfiltercriteria = component.get("v.Filterlist");
            var newfilter = component.get("v.Filter");
            var objectName = component.get("v.filterObjName");
            action.setParams({
                "filterCriteriaDetails": newfiltercriteria,
                "filterDetails": newfilter,
                "objectname": objectName
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var returnvalue = response.getReturnValue();
                var error = returnvalue[0];
                var filterid = returnvalue[1];
                if (state === "SUCCESS") {
                    if (error == '') {
                        component.set("v.selectedFilterId", filterid);
                        component.set("v.isShow", true);
                        component.set('v.leadsAvail', true);
                        component.set("v.editFilter", false);
                        component.set("v.objectColumns", true);
                        if (component.find("viewObjectfilter") != undefined) {
                            component.find("viewObjectfilter").set("v.value", component.get("v.filterObjName"));
                        }
                        if (component.find("viewfilter") != undefined) {
                            component.find("viewfilter").set("v.value", filterid);
                        }
                        component.set("v.iserror", false);
                    }
                    else {
                        component.set("v.errormsg", error);
                        component.set("v.iserror", true);
                    }
                }
                if (state === "ERROR") {

                }
            });
            $A.enqueueAction(action);
        }
        helper.fetchViewPicklist(component);
    },
    editRecord: function (component, event, helper) {
        component.set("v.iserror", false);
        component.set("v.Likedisable", false);
        var selectedvalue = component.find("viewfilter").get("v.value");
        component.set("v.isShow", false);
        component.set("v.editFilter", true);
        component.set("v.objectColumns", false);
        var filterpage = component.find('filterpage');
        $A.util.removeClass(filterpage, 'slds-hide');
        $A.util.addClass(filterpage, 'slds-show');
        helper.fetchObjectPicklist(component);
        helper.fetchFieldPicklist(component);
        helper.fetchOperatorPicklist(component);
        var action = component.get("c.editFilterRecord");
        action.setParams({
            "filterid": selectedvalue
        });
        action.setCallback(this, function (response) {
            var addrow = component.find("addrow");
            var state = response.getState();
            if (state === "SUCCESS") {
                var filterRecords = response.getReturnValue();
                var recordsize = filterRecords.lstFilterCriterias;
                component.set("v.Filter", filterRecords.objFilter);

                if (filterRecords.objFilter.SmartDD__FilterLogic__c == null || filterRecords.objFilter.SmartDD__FilterLogic__c == '') {
                    component.set("v.txtfilterlogic", 'Add Filter Logic');
                }
                else {
                    component.set("v.txtfilterlogic", 'Clear Filter Logic');
                    var txtfilter = component.find('filterlogic');
                    $A.util.removeClass(txtfilter, 'slds-hide');
                    $A.util.addClass(txtfilter, 'slds-show');
                }
                if (recordsize.length == 0) {
                    component.set("v.Filterlist", {
                        'sobjectType': 'SmartDD__Filter_Criteria__c',
                        'SmartDD__Field__c': '',
                        'SmartDD__Filter_Name__c': '',
                        'SmartDD__Operator__c': '',
                        'SmartDD__Value__c': ''
                    });
                }
                else {
                    component.set("v.Filterlist", filterRecords.lstFilterCriterias);
                    var RowItemList = component.get("v.Filterlist");
                    if (RowItemList.length > 1) {
                        component.set("v.showDeleteIcon", true);
                    } else {
                        component.set("v.showDeleteIcon", false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    /*UpdateFilterdataStart: function(component,event,helper){
        helper.UpdateFilterdataStartDeupes(component,event,helper);
    },*/

    strtDedupeCallout: function (component, event, helper) {
        debugger;
        console.log('strtDedupeCallout');
        var selObjectname = component.find("viewObjectfilter").get("v.value");
        var selectedFilterId = component.find("viewfilter").get("v.value");
        var totalRecordCounts = component.get('v.totalRecCount');
        component.set("v.createClusterpercentCount", 0);
        component.set("v.createClusterprogress", 0);
        var actionSyncChk = component.get('c.GetDedupeConfigCustomSettings');
        helper.getTrainingFIleRecordCount(component, event, helper);
        actionSyncChk.setParams({
            'selectedObjectname': selObjectname
        });
        actionSyncChk.setCallback(this, function (responseSyncChk) {
            var state = responseSyncChk.getState();
            console.log('GetDedupeConfigCustomSettingsstate=' + state);
            if (state == 'SUCCESS') {
                var boolRetVal = responseSyncChk.getReturnValue();
                component.set("v.Canceldisable", true);
                if (boolRetVal.SmartDD__Sync_Data__c == true) {
                    component.set("v.iserror", true);
                    component.set("v.errormsg", "Sync data is in Progress on " + boolRetVal.SmartDD__Sync_Object_Name__c + " by " + boolRetVal.SmartDD__Synced_By_UserName__c + " for total " + boolRetVal.SmartDD__Total_Records_Synced__c + " records on " + boolRetVal.SmartDD__Last_Sync_date__c + ".");
                } else {
                    component.set("v.iserror", false);
                    component.find("Id_spinner").set("v.class", 'slds-show');
                    if (selectedFilterId == undefined || selectedFilterId == null || selectedFilterId == '' || selectedFilterId == "") {
                        selectedFilterId = '';
                    }
                    var actionConnect = component.get("c.checkCredentials");
                    actionConnect.setParams({
                        'objectType': selObjectname,
                        'filterId': component.get("v.selectedFilterId")
                    });
                    actionConnect.setCallback(this, function (responseConnect) {
                        debugger;
                        var stateConnect = responseConnect.getState();
                        console.log('checkCredentials=' + stateConnect);

                        if (stateConnect === 'SUCCESS') {
                            var isCorrectPass = responseConnect.getReturnValue();
                            if (isCorrectPass == 'success') {
                                /**Check cluster Reviewed or not*/
                                var action = component.get("c.getReviewStatus");
                                action.setParams({
                                    "selObjectname": selObjectname,
                                });
                                action.setCallback(this, function (response) {
                                    debugger;
                                    var state = response.getState();
                                    console.log('getReviewStatus=' + state);
                                    if (state == "SUCCESS") {
                                        var returnValue = response.getReturnValue();
                                        console.log('returnValue=' + JSON.stringify(returnValue));

                                        if (returnValue[0].objWrpClusterList.length > 0 || (returnValue[0].strWrpBatchId != '' && returnValue[0].strWrpBatchId != undefined && returnValue[0].strWrpBatchId != null)) {
                                            console.log('if=');
                                            if (confirm('You have some pending cluster to review Or merge on "Manage Duplicate Groups" page. Please confirm if you still want to continue.') == true) {
                                                console.log('if if=');
                                                if (totalRecordCounts > 200) {
                                                    console.log('if if if=');
                                                    if (confirm('You have deduped on more than 48000 records. This process will take more time then usual, so do you want to continue the dedupe process or want to change the filter with less records.') == true) {
                                                        console.log('if if if if=');
                                                        helper.postFilterRecords(component, event, helper);
                                                    } else {//update field                                                       	
                                                        console.log('if if if else=');
                                                        helper.cancelCreateCluster(component, event, helper);
                                                    }
                                                } else {
                                                    console.log('if if else=');
                                                    helper.postFilterRecords(component, event, helper);
                                                }
                                            } else {//update field                                                  
                                                console.log('if else=');
                                                helper.cancelCreateCluster(component, event, helper);
                                            }
                                        } else {
                                            console.log('else=');
                                            if (totalRecordCounts > 200) {
                                                console.log('else if=');
                                                if (confirm('You have deduped on more than 48000 records. This process will take more time then usual, so do you want to continue the dedupe process or want to change the filter with less records.') == true) {
                                                    console.log('else if if=');
                                                    helper.postFilterRecords(component, event, helper);
                                                } else {//update field
                                                    console.log('else if else=');
                                                    helper.cancelCreateCluster(component, event, helper);
                                                }
                                            } else {
                                                console.log('else else=');
                                                helper.postFilterRecords(component, event, helper);
                                            }
                                        }
                                        //alert('returnResponse..........................................'+returnResponse)            
                                    }
                                });
                                $A.enqueueAction(action);
                                /**END*/

                            } else if (isCorrectPass == 'authentication failure') {
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                helper.setUsername(component, event, helper);
                                component.set("v.isModalOpen", true);
                            } else if (isCorrectPass == 'Database not available') {
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                component.set("v.iserror", true);
                                component.set("v.errormsg", 'Database Not Available for This user. Please save configuration.');
                            } else if (isCorrectPass == 'Connected App Details Wrong') {
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                component.set("v.iserror", true);
                                component.set("v.errormsg", 'Consumer Key and Consumer Secret key are wrong in Configuration page. Please Correct.');
                            } else {
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                component.set("v.iserror", true);
                                var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                                //component.set("v.errormsg",'Server has stopped responding, please contact with the administrator: anil@logicrain.com');
                                component.set('v.errormsg', homePageNewslabel);
                            }
                        }
                    });
                    $A.enqueueAction(actionConnect);
                }
            }
        });
        $A.enqueueAction(actionSyncChk);
    },

    saveCredentials: function (component, event, helper) {
        var userName = component.get("v.syncUserName");
        var password = component.get("v.syncPassword");

        if (userName != '') {
            helper.saveCredentials(component, event, helper);
        } else {
            helper.setUsername(component, event, helper);
            component.set("v.isModalOpen", true);
        }
    },

    cancelReq: function (component, event, helper) {
        var selObjectname = component.find("viewObjectfilter").get("v.value");
        var createClusterInterval = component.get("v.setClusterIntervalId");
        clearInterval(createClusterInterval);
        component.set("v.isCreateClusterProgress", false);
        var action = component.get("c.updateLastCreateCluster");
        action.setCallback(this, function (response) {
            var messsage = response.getReturnValue();
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnResponse = response.getReturnValue();
                var actionUpdate = component.get("c.updateprocessStatus");
                actionUpdate.setParams({
                    'objectName': selObjectname
                });
                actionUpdate.setCallback(this, function (response) {
                    var errorMesssage = response.getReturnValue();
                    var state = response.getState();
                    if (state == "SUCCESS") {
                    }
                });
                $A.enqueueAction(actionUpdate);
            }
        });
        $A.enqueueAction(action);
    },
    findSearchkeyEnter: function (component, event, helper) {
        component.set("v.Likedisable", false);
        component.set("v.iserror", false);
        if (component.get("v.leadsAvail") == true) {
            if (event.which == 13) {
                var strSearchKey = component.find("searchKeyInp").get("v.value");
                component.set('v.showInformation', false);
                if (strSearchKey == undefined || strSearchKey == null || strSearchKey == '' || !strSearchKey.trim() || strSearchKey.length === 0) {
                    component.set("v.iserror", true);
                    component.set("v.errormsg", "Please enter a search key.");
                }
                else {
                    strSearchKey = strSearchKey.trim();
                    if (strSearchKey.length == 1) {
                        component.set("v.iserror", true);
                        component.set("v.errormsg", "Please enter a search string at least 2 characters long.");
                    }
                    else {
                        component.set("v.iserror", false);
                        component.set("v.isSearchActive", true);
                        component.set("v.leadsAvail", true);
                        component.set("v.searchKeyParam", strSearchKey);
                        var childCmpTable = component.find("changeFilter");
                        childCmpTable.searchKeyMethod();
                    }
                }
            }
        }
    },
    findSearchkey: function (component, event, helper) {
        if (component.get("v.leadsAvail") == true) {
            debugger;
            var strSearchKey = component.find("searchKeyInp").get("v.value");
            component.set('v.showInformation', false);
            if (strSearchKey == undefined || strSearchKey == null || strSearchKey == '' || !strSearchKey.trim() || strSearchKey.length === 0) {
                component.set("v.iserror", true);
                component.set("v.errormsg", "Please enter a search key.");
            }
            else {
                strSearchKey = strSearchKey.trim();
                if (strSearchKey.length == 1) {
                    component.set("v.iserror", true);
                    component.set("v.errormsg", "Please enter a search string at least 2 characters long.");
                }
                else {
                    component.set("v.iserror", false);
                    component.set("v.isSearchActive", true);
                    component.set("v.leadsAvail", true);
                    component.set("v.searchKeyParam", strSearchKey);
                    var childCmpTable = component.find("changeFilter");
                    childCmpTable.searchKeyMethod();
                }
            }
        }
    },
    clearSearch: function (component, event) {
        component.set("v.Likedisable", false);
        component.find("searchKeyInp").set("v.value", "");
        component.set("v.isSearchActive", false);
        component.set("v.iserror", false);
        component.set('v.showInformation', false);
        var childCmpTable = component.find("changeFilter");
        childCmpTable.changeFilterMethod();
    },
    showlogicfield: function (component, event, helper) {
        component.set("v.Likedisable", false);
        var txtfilter = component.find('filterlogic');
        var logicname = component.get('v.txtfilterlogic');

        if (logicname == 'Add Filter Logic') {
            $A.util.removeClass(txtfilter, 'slds-hide');
            $A.util.addClass(txtfilter, 'slds-show');
            component.set("v.txtfilterlogic", 'Clear Filter Logic');
        } else {
            $A.util.addClass(txtfilter, 'slds-hide');
            $A.util.removeClass(txtfilter, 'slds-show');
            component.set("v.txtfilterlogic", 'Add Filter Logic');
            component.find('filterlogicname').set("v.value", '');
        }
    },
    togglePopup: function (component, event, helper) {
        component.set("v.isPopupVisible", true);
    },

    closePopup: function (component, event, helper) {
        component.set("v.isPopupVisible", false);
    },
})