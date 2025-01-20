({
    validateForm: function (component, event) {
        var isValid = true;
        var objectname = component.find('objectid');
        var objectnamevalue = objectname.get("v.value");
        var filtername = component.find('filtername');
        var filternamevalue = filtername.get("v.value");

        if (filternamevalue == "") {
            isValid = false;
            component.find('filtername').showHelpMessageIfInvalid();
        }
        if (objectnamevalue == "" || objectnamevalue == "--None--") {
            isValid = false;
            component.find('objectid').showHelpMessageIfInvalid();
        }
        return isValid;
    },

    pollCreateCluster: function (component, event, helper) {
        debugger;
        var totalRecordCounts = component.get('v.totalRecCount');
        console.log("totalRecordCounts" + totalRecordCounts);
        var timeInterval = 0;
        var stopProgressbar = 100; //Math.floor((Math.random() * 10) + 80);
        console.log("stopProgressbar" + stopProgressbar);

        if (totalRecordCounts < 10000) {
            timeInterval = Math.floor((Math.random() * 5) + 5) * 1000;
        } else if (totalRecordCounts > 10000 && totalRecordCounts < 30000) {
            timeInterval = Math.floor((Math.random() * 10) + 20) * 1000;
        } else if (totalRecordCounts > 30000) {
            timeInterval = Math.floor((Math.random() * 10) + 25) * 1000;
        }
        console.log("timeInterval" + timeInterval);
        var createClusterInterval = setInterval($A.getCallback(function () {
            var i = 0;
            console.log("createClusterInterval i " + i++);

            helper.handleCreateCluster(component, helper, createClusterInterval, stopProgressbar);
        }), timeInterval);
        component.set("v.setClusterIntervalId", createClusterInterval);
    },

    handleCreateCluster: function (component, helper, createClusterInterval, stopProgressbar) {
        console.log("handleCreateCluster");
        debugger;
        var intPercentCount = component.get('v.createClusterpercentCount');
        /**Get Customsetting field Clusters_Completed_Stat__c value. */
        var action = component.get("c.getClustersCompletedStat");
        action.setCallback(this, function (response) {
            var errorMesssage = response.getReturnValue();
            var state = response.getState();
            console.log("state==" + state);
            if (state == "SUCCESS") {
                var returnResponse = response.getReturnValue();
                console.log("returnResponse==" + JSON.stringify(returnResponse));
                component.set("v.clustersCompletedStat", returnResponse.SmartDD__Clusters_Completed_Stat__c);
                component.set("v.totalRecDedupe", returnResponse.SmartDD__Total_Records_Deduped__c);
            }
        });
        $A.enqueueAction(action);
        /**END*/

        var clustersCompletedStat = component.get("v.clustersCompletedStat");
        console.log("clustersCompletedStat==" + clustersCompletedStat);
        console.log("intPercentCount x ==" + intPercentCount);
        console.log("stopProgressbar x ==" + stopProgressbar);

        if (intPercentCount < stopProgressbar && clustersCompletedStat != 'Completed' && intPercentCount < 90) {
            intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
            console.log("if intPercentCount==" + intPercentCount);
        } else if (clustersCompletedStat == 'Completed') {
            intPercentCount = 100;
            console.log("else if intPercentCount==" + intPercentCount);
        } else {
            component.set("v.showClusterLoader", true);
            console.log("else showClusterLoader==");
        }
        console.log("intPercentCount==" + intPercentCount);


        component.set("v.createClusterpercentCount", intPercentCount);
        console.log("createClusterpercentCount==" + component.get("v.createClusterpercentCount"));
        component.set("v.createClusterprogress", intPercentCount);
        console.log("createClusterprogress==" + component.get("v.createClusterprogress"));

        /**Update Customsetting field Last_Create_Cluster_Progress__c value. */
        var actionUpdate = component.get("c.updateCreateClusterProgress");
        console.log("updateCreateClusterProgress");
        console.log("updateCreateClusterProgress intPercentCount= " + intPercentCount);
        console.log("updateCreateClusterProgress estimatedTime= " + component.get('v.estimatedTime'));
        actionUpdate.setParams({
            'lastCreateClusterProgress': intPercentCount,
            'clusterEstimatedTime': component.get('v.estimatedTime')
        });
        console.log("actionUpdate.setParams");

        actionUpdate.setCallback(this, function (response) {
            console.log("actionUpdate.setCallback");
            //var errorMesssage = response.getReturnValue();
            var state = response.getState();
            console.log("updateCreateClusterProgress state==" + state);
            if (state == "SUCCESS") {

                if (intPercentCount == 100) {
                    console.log("if");

                    clearInterval(createClusterInterval);

                    var currentURL = window.location.href;
                    var url = new URL(currentURL);
                    var baseURL = url.origin;
                    var reDirUrl = baseURL + '/lightning/n/SmartDD__Manage_Cluster';
                    var urlEvent = $A.get("e.force:navigateToURL");
                    if (urlEvent) {
                        console.log("ifif");
                        urlEvent.setParams({
                            "url": reDirUrl

                        });
                        urlEvent.fire();
                    } else {
                        console.log("ifelse");
                        window.location = reDirUrl;
                    }
                    //window.open(window.location.origin+'/apex/DedupeManageClusterPage','_self'); 
                }
            }
        });
        $A.enqueueAction(actionUpdate);
    },
    setUsername: function (component, event, helper) {
        var action = component.get("c.credentialDetails");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var returnRes = response.getReturnValue();
                component.set("v.syncUserName", returnRes.SmartDD__Username__c);
                component.set("v.syncPassword", '');
            }
        });
        $A.enqueueAction(action);
    },
    saveCredentials: function (component, event, helper) {
        var userName = component.get("v.syncUserName");
        var password = component.get("v.syncPassword");
        var action = component.get("c.saveAuthCredentials");
        action.setParams({
            "userName": userName,
            "passWord": password
        });
        action.setCallback(this, function (response) {
            var errorMesssage = response.getReturnValue();

            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.isModalOpen", false);
                if (errorMesssage == 'authentication failure') {
                    component.set("v.syncUserName", '');
                    component.set("v.syncPassword", '');
                    component.set("v.isModalOpen", true);
                    helper.setUsername(component, event, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchFieldPicklist: function (component) {
        var selectedObject = component.get("v.filterObjName");
        var action = component.get("c.FieldPicklistOptions");
        action.setParams({
            "strObjectname": selectedObject
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var result = a.getReturnValue();
                var options = [];
                options.push({ value: "", label: "--None--" });
                for (var key in result) {
                    options.push({ value: result[key].split('#')[0], label: result[key].split('#')[1] });
                }
                component.set("v.fieldoptions", options);
            }
        });
        $A.enqueueAction(action);
    },
    fetchOperatorPicklist: function (component) {
        var action = component.get("c.getPicklistvalues");
        var objectname = 'SmartDD__Filter_Criteria__c';
        action.setParams({
            'objectName': objectname,
            'field_apiname': component.get("v.Operator"),
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.operatoroptions", a.getReturnValue());
                var result = a.getReturnValue();
                var options = [];
                options.push({ value: "", label: "--None--" });
                for (var key in result) {
                    options.push({ value: result[key], label: result[key] });
                }
                component.set("v.operatoroptions", options);
            }
        });
        $A.enqueueAction(action);
    },
    fetchObjectList: function (component, event, helper) {
        debugger;
        var action = component.get("c.getSyncedObjList");
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var result = a.getReturnValue();
                component.set("v.syncedObjList", result);
                if (result.length > 0) {
                    component.set("v.iserror", false);
                    component.set("v.errormsg", "");
                    if (result.includes("Lead")) {
                        component.find("viewObjectfilter").set("v.value", 'Lead');
                    } else if (result.includes("Account")) {
                        component.find("viewObjectfilter").set("v.value", 'Account');
                    } else if (result.includes("Contact")) {
                        component.find("viewObjectfilter").set("v.value", 'Contact');
                    }
                    var editlink = component.find("editlink");
                    var deletelink = component.find("deletelink");
                    $A.util.addClass(editlink, 'disablelink');
                    $A.util.addClass(deletelink, 'disablelink');
                    helper.fetchViewPicklist(component, event);
                    helper.chooseColumnsHelper(component, event, helper);
                }
                else {
                    component.set("v.iserror", true);
                    component.set("v.errormsg", "No object is synced yet.");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchViewPicklist: function (component) {
        var SelectedObjName = component.get("v.filterObjName");
        var action = component.get("c.getFiltername");
        action.setParams({
            'SelectedObjName': SelectedObjName
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var result = a.getReturnValue();
                var options = [];
                options.push({ value: "", label: "All" });
                for (var key in result) {
                    options.push({ value: result[key].split('#')[0], label: result[key].split('#')[1] });
                }
                component.set("v.Viewoptions", options);

            }
        });
        $A.enqueueAction(action);
    },

    fetchObjectPicklist: function (component) {
        var options = component.get("v.filterObjName");
        component.set("v.Objectoptions", options);
    },

    createFilterCriteria: function (component, event) {
        debugger;
        var addrow = component.find("addrow");
        var RowItemList = component.get("v.Filterlist");
        console.log("before" + RowItemList.length);
        RowItemList.push({
            'sobjectType': 'SmartDD__Filter_Criteria__c',
            'SmartDD__Field__c': '',
            'SmartDD__Filter_Name__c': '',
            'SmartDD__Operator__c': '',
            'SmartDD__Value__c': ''
        });
        // set the updated list to attribute (Filterlist) again    
        component.set("v.Filterlist", RowItemList);
        console.log("after" + RowItemList.length);
        if (RowItemList.length >= 10) {
            $A.util.addClass(addrow, 'disablelink');
        }
    },
    removeDeletedRow: function (component, index, dataid) {
        var AllRowsList = component.get("v.Filterlist");
        AllRowsList.splice(index, 1);
        component.set("v.Filterlist", AllRowsList);
        console.log(component.get("v.Filterlist"));
    },
    getSelectedObjColumns: function (component) {
        debugger;
        var action = component.get("c.fetchObjectColumns");
        action.setParams({
            "filterObjName": component.get("v.filterObjName")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                debugger;
                var returnValue = a.getReturnValue();
                var returnResult = returnValue[0].FieldsList;
                var arrLabel = [];
                var arrApiName = [];
                for (var i = 0; i < returnResult.length; i++) {
                    var opt = {};
                    opt.label = returnResult[i].fieldName;
                    opt.value = returnResult[i].fieldApiName;
                    arrApiName.push(returnResult[i].fieldApiName);
                    arrLabel.push(opt);
                }
                component.set("v.lstColumnsAPIName", arrApiName);
                component.set("v.lstColumnsLabels", arrLabel);
                if (component.get("v.lstColumnsAPIName") != undefined && component.get("v.lstColumnsAPIName") != null && component.get("v.lstColumnsAPIName") != '') {
                    component.set('v.leadsAvail', true);
                    component.find("searchKeyInp").set("v.value", "");
                    var childCmpTable = component.find("changeFilter");
                    childCmpTable.changeFilterMethod();
                }
                else {
                    component.set('v.leadsAvail', false);
                    component.set('v.searchResultAvail', false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getTrainingFIleRecordCount: function (component, event, helper) {
        console.log('getTrainingFIleRecordCount==');
        var selObject = component.find("viewObjectfilter").get("v.value");
        console.log('selObject==' + selObject);
        var action = component.get('c.getTrainingFileRecCount');
        action.setParams({
            "selectedObjectname": selObject
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //uncomplete line commented by saloni
            //response.get
            console.log('getTrainingFileRecCount state==' + state);
            if (state == "SUCCESS") {
                var totalTrainingRecCount = response.getReturnValue();
                console.log('totalTrainingRecCount ==' + totalTrainingRecCount);
                component.set("v.totalTrainingRecCount", totalTrainingRecCount);
            }
        });
        $A.enqueueAction(action);
    },
    // Function to generate random number 
    getEstimatedTime: function (component, event, helper) {
        var intEstimatedTime = 0; //estimatedTime
        var totalRecordCounts = component.get('v.totalRecCount');
        if (totalRecordCounts > 0 && totalRecordCounts < 2000) {
            intEstimatedTime = Math.floor(Math.random() * (3 - 1) + 1);
        } else if (totalRecordCounts > 2000 && totalRecordCounts < 5000) {
            intEstimatedTime = Math.floor(Math.random() * (4 - 2) + 2);
        } else if (totalRecordCounts > 5000 && totalRecordCounts < 10000) {
            intEstimatedTime = Math.floor(Math.random() * (5 - 3) + 3);
        } else if (totalRecordCounts > 10000 && totalRecordCounts < 15000) {
            intEstimatedTime = Math.floor(Math.random() * (6 - 4) + 4);
        } else if (totalRecordCounts > 15000 && totalRecordCounts < 20000) {
            intEstimatedTime = Math.floor(Math.random() * (7 - 5) + 5);
        } else if (totalRecordCounts > 20000 && totalRecordCounts < 25000) {
            intEstimatedTime = Math.floor(Math.random() * (9 - 7) + 7);
        } else if (totalRecordCounts > 25000 && totalRecordCounts < 30000) {
            intEstimatedTime = Math.floor(Math.random() * (11 - 9) + 9);
        } else if (totalRecordCounts > 30000 && totalRecordCounts < 35000) {
            intEstimatedTime = Math.floor(Math.random() * (13 - 11) + 11);
        } else if (totalRecordCounts > 35000 && totalRecordCounts < 40000) {
            intEstimatedTime = Math.floor(Math.random() * (14 - 12) + 12);
        } else if (totalRecordCounts > 40000 && totalRecordCounts < 45000) {
            intEstimatedTime = Math.floor(Math.random() * (15 - 13) + 13);
        } else if (totalRecordCounts > 45000 && totalRecordCounts < 50000) {
            intEstimatedTime = Math.floor(Math.random() * (17 - 14) + 14);
        } else if (totalRecordCounts > 50000 && totalRecordCounts < 55000) {
            intEstimatedTime = Math.floor(Math.random() * (19 - 16) + 16);
        } else if (totalRecordCounts > 55000 && totalRecordCounts < 60000) {
            intEstimatedTime = Math.floor(Math.random() * (23 - 18) + 18);
        } else if (totalRecordCounts > 60000) {
            intEstimatedTime = Math.floor(Math.random() * (50 - 30) + 30);
        }
        console.log('intEstimatedTime=' + intEstimatedTime);
        component.set('v.estimatedTime', intEstimatedTime);
    },
    postFilterRecords: function (component, event, helper) {
        debugger;
        console.log('postFilterRecords=');

        var selectedFilterId = component.find("viewfilter").get("v.value");
        if (selectedFilterId == undefined || selectedFilterId == null || selectedFilterId == '' || selectedFilterId == "") {
            selectedFilterId = '';
        }
        helper.getEstimatedTime(component, event, helper);
        console.log('1=');
        var selectedObjectname = component.find("viewObjectfilter").get("v.value");
        console.log('2=');
        var totalTrainingRecCount = component.get("v.totalTrainingRecCount");
        console.log('3=');
        var action = component.get("c.postDedupeFilterRecords");
        console.log('4=');
        action.setParams({
            "selectedFilterId": selectedFilterId,
            "filterId": component.get("v.selectedFilterId"),
            "selectedObjectname": selectedObjectname
        });
        console.log('5=');
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('postDedupeFilterRecords=' + state);
            if (state == "SUCCESS") {
                debugger;
                var returnresopnse = response.getReturnValue();
                console.log('postDedupeFilterRecords returnresopnse=' + JSON.stringify(returnresopnse));
                var returnVal = [];
                returnVal = returnresopnse.split('#');
                var ExceedLimit = returnVal[0];
                var actionMergeFlag = component.get("c.resetMergedFlag");
                actionMergeFlag.setParams({
                    "selectedObjectname": selectedObjectname,
                    "filterId": component.get("v.selectedFilterId")
                });
                actionMergeFlag.setCallback(this, function (responseMerge) {
                    debugger;
                    var stateMerge = responseMerge.getState();
                    var errorMerge = responseMerge.getError();
                    console.log('errorMerge');
                    console.log(errorMerge);
                    if (stateMerge == "SUCCESS") {
                        if (ExceedLimit != "") {
                            console.log('if ExceedLimit');
                            var batchId = returnVal[1];
                            helper.checkBatchStatus(component, event, helper, batchId);
                        } else if (returnVal[1] == "1") {
                            console.log('else if returnVal 1');
                            component.set("v.Likedisable", false);
                            component.find("Id_spinner").set("v.class", 'slds-hide');
                            helper.updateFilterData(component, event, helper, selectedFilterId, totalTrainingRecCount);
                            if (totalTrainingRecCount > 20) {
                                console.log(' if totalTrainingRecCount  >20 =' + totalTrainingRecCount);
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                component.set("v.isCreateClusterProgress", true);
                                helper.pollCreateCluster(component, event, helper);
                            } else {
                                console.log(' else totalTrainingRecCount  <20 =' + totalTrainingRecCount);
                                if (returnVal[2] == "Successfully Deduped.") {
                                    window.open(window.location.origin + '/apex/DedupeManageClusterPage', '_self');
                                } else {
                                    window.open(window.location.origin + '/apex/Dedupe_Status', '_blank');
                                }
                            }
                        } else {
                            console.log(' if returnVal');
                            component.find("Id_spinner").set("v.class", 'slds-hide');
                            component.set('v.showInformation', true);
                            var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                            component.set('v.Notification', homePageNewslabel);
                        }
                    }
                });
                $A.enqueueAction(actionMergeFlag);
            } else {
                component.find("Id_spinner").set("v.class", 'slds-hide');
                component.set('v.showInformation', true);
                var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                component.set('v.Notification', homePageNewslabel);
            }
        });
        $A.enqueueAction(action);
    },
    checkBatchStatus: function (component, event, helper, batchId) {
        debugger;
        var interval = setInterval($A.getCallback(function () {
            helper.checkBatchProcess(component, event, helper, interval, batchId);
        }), 5000);
        console.log('interval==' + interval);
        component.set("v.setIntervalId", interval);
    },

    checkBatchProcess: function (component, event, helper, interval, batchId) {
        debugger;
        console.log('batchId==' + batchId);

        var action = component.get("c.AsyncApexJobRecords");
        action.setParams({
            "BatchProcessId": batchId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('AsyncApexJobRecords state==' + state);
            if (state == "SUCCESS") {
                var statPercentVal = 0;
                var apexSyncRecord = response.getReturnValue();
                console.log('apexSyncRecord==' + JSON.stringify(apexSyncRecord));
                var batchProcessStatus = apexSyncRecord.JobItemStatus;
                console.log('batchProcessStatus==' + batchProcessStatus);
                if (batchProcessStatus != '') {
                    console.log('if batchProcessStatus==' + batchProcessStatus);

                    if (apexSyncRecord.JobItemsProcessed != 0 && apexSyncRecord.TotalJobItems != 0) {
                        statPercentVal = parseInt(((apexSyncRecord.JobItemsProcessed) / apexSyncRecord.TotalJobItems) * 100);
                    }
                    if (statPercentVal == 100) {
                        var action = component.get("c.setStartDedupeBatch");
                        console.log('setStartDedupeBatch==');
                        action.setCallback(this, function (response) {
                            var messsage = response.getReturnValue();
                            var state = response.getState();
                            if (state == "SUCCESS") {

                            }
                        });
                        $A.enqueueAction(action);
                    }
                    //component.set("v.statusStatement",'Start DeDupe In');
                    component.set("v.percentCount", statPercentVal);
                    component.set("v.progress", statPercentVal);
                }
                if (batchProcessStatus != 'Completed') {
                    console.log('if Completed');
                    if (statPercentVal === 100) {
                        console.log('if 100');
                        component.set("v.isDataProgress", true);
                        component.set("v.isCreateClusterProgress", false);
                    } else {
                        console.log('else not 100');
                        component.set("v.isDataProgress", true);
                        component.set("v.isCreateClusterProgress", false);
                        console.log("checkBatchProcess:Hide");
                        component.find("Id_spinner").set("v.class", 'slds-hide');
                        component.set("v.progress", statPercentVal);
                    }
                } else {
                    helper.getTrainingFIleRecordCount(component, event, helper);
                    var action = component.get("c.CheckApiStatus");
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        console.log('CheckApiStatus state==' + state);
                        if (state == "SUCCESS") {
                            var apistatus = response.getReturnValue();
                            console.log('apistatus==' + apistatus);
                            component.set("v.isDataProgress", false);
                            if (apistatus == null || apistatus == '' || apistatus == undefined || apistatus == "") {
                                console.log('if apistatus== ');
                                component.find("Id_spinner").set("v.class", 'slds-show');
                            } else if (apistatus == '1') {
                                console.log('else if apistatus== ');
                                window.clearInterval(component.get("v.setIntervalId"));
                                component.set("v.isDataProgress", false);
                                component.set("v.progress", 0);
                                component.set("v.percentCount", 0);
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                var selectedFilterId = component.find("viewfilter").get("v.value");
                                var totalTrainingRecCount = component.get("v.totalTrainingRecCount");
                                if (totalTrainingRecCount < 20) {
                                    console.log('if totalTrainingRecCount<20 ');
                                    window.open(window.location.origin + '/apex/Dedupe_Status', '_blank');
                                } else if (totalTrainingRecCount >= 20) {
                                    console.log('if totalTrainingRecCount>=20 ');
                                    component.find("Id_spinner").set("v.class", 'slds-hide');
                                    component.set("v.isCreateClusterProgress", true);
                                    helper.pollCreateCluster(component, event, helper);
                                }
                                //component.get("c.startDeduplication");
                                //component.find("StartDedupe_ID").set("v.class" , 'slds-show');                                                                                                           
                            } else if (apistatus == '0') {
                                console.log('else apistatus== ');
                                component.find("Id_spinner").set("v.class", 'slds-hide');
                                component.set('v.showInformation', true);
                                var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                                component.set('v.Notification', homePageNewslabel);
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
        });
        $A.enqueueAction(action);
    },
    //Update FilterData Custom setting  
    updateFilterData: function (component, event, helper, selectedFilterId, totalTrainingRecCount) {
        debugger;
        var action = component.get("c.UpdateFilterdataId");
        action.setParams({
            "selectedFilterId": selectedFilterId,
            "objectName": component.get("v.filterObjName"),
            "totalTrainingRecCount": totalTrainingRecCount
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
            }
        });
        $A.enqueueAction(action);
        /**END*/
    },
    /*UpdateFilterdataStartDeupes : function(component,event,helper){        
        var selectedFilterId = component.find("viewfilter").get("v.value");    
        var totalTrainingRecCount = component.get("v.totalTrainingRecCount");          
        if(selectedFilterId == undefined || selectedFilterId == null || selectedFilterId == '' || selectedFilterId == "") {
            selectedFilterId = '';
        }           
         helper.updateFilterData(component,event,helper,selectedFilterId,totalTrainingRecCount); 
        if(totalTrainingRecCount < 20) {            
            window.open(window.location.origin+'/apex/Dedupe_Status','_blank');          
        } else if(totalTrainingRecCount > 20) {           
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            component.set("v.isCreateClusterProgress",true);            
            helper.pollCreateCluster(component,event,helper);
        }
    },*/
    cancelCreateCluster: function (component, event, helper) {
        var selObjectname = component.find("viewObjectfilter").get("v.value");
        var createClusterInterval = component.get("v.setClusterIntervalId");
        clearInterval(createClusterInterval);
        component.set("v.isCreateClusterProgress", false);
        var action = component.get("c.updateLastCreateCluster");
        action.setCallback(this, function (response) {
            var messsage = response.getReturnValue();
            var state = response.getState();
            if (state == "SUCCESS") {
                component.find("Id_spinner").set("v.class", 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },

    chooseColumnsHelper: function (component, event, helper) {
        component.set("v.iserror", false);
        component.set("v.Likedisable", false);
        var selectedObjectName = component.find("viewObjectfilter").get("v.value");
        console.log("chooseColumnsHelper:show");
        component.find("Id_spinner").set("v.class", 'slds-show');
        component.set("v.iserror", false);
        if (selectedObjectName == undefined || selectedObjectName == null || selectedObjectName == '') {
            component.set("v.isShow", false);
            console.log("selectedObjectName:undefined:hide");
            component.find("Id_spinner").set("v.class", 'slds-hide');
            component.set('v.leadsAvail', false);
            component.set('v.searchResultAvail', false);
            component.set('v.selectedFilterId', '');
        }
        else {
            component.set("v.filterObjName", selectedObjectName);
            helper.getSelectedObjColumns(component);
            helper.fetchViewPicklist(component, event);
            component.set('v.isShow', true);
            component.set("v.selectedFilterId", '');
            var editlink = component.find("editlink");
            var deletelink = component.find("deletelink");
            $A.util.addClass(editlink, 'disablelink');
            $A.util.addClass(deletelink, 'disablelink');
            console.log("chooseColumnsHelper:hide");
            component.find("Id_spinner").set("v.class", 'slds-hide');
        }
    }
})