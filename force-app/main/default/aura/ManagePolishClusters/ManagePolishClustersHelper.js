({
    getClusterRecordList: function(component, event, initial, direction,helper) {
        debugger;
        var action = component.get("c.getClusterRecords");
        action.setParams({
            'selObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnvalue = response.getReturnValue();
                var clusterListTest = returnvalue[0].lstWrpClusters;
                component.set("v.clusterList",returnvalue[0].lstWrpClusters);
                var columnLabels = component.get("v.fieldlabels");
                component.set("v.masterRecordId","");
                component.set("v.showMasterRecord",false);
                if(clusterListTest.length > 0 && columnLabels.length == 0) {
                    this.getReviewClusterColumns(component, event, initial, direction,helper); 
                }
                else if(clusterListTest.length > 0 && columnLabels.length > 0) {
                    this.getReviewClusterdetails(component, event, initial, direction,helper);
                }
                else {
                    var tabChangeEvent = component.getEvent("tabFocus");
                    tabChangeEvent.setParams({
                        tabName : 'uniqueLeadTab'
                    });
                    tabChangeEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    getReviewClusterColumns: function(component, event, initial, direction,helper) {
        debugger;
        var action = component.get("c.fetchReviewClusterColumns");
        action.setParams({
            'filterObjName': component.get("v.selectedObjectName")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                debugger;
                var returnValue = a.getReturnValue();
                var returnResult = returnValue[0].FieldsList;
                var arrLabel = [];
                var arrApiName = [];
                for(var i=0;i<returnResult.length;i++){
                    var opt = {};
                    opt.label = returnResult[i].fieldName;
                    opt.value = returnResult[i].fieldApiName ;
                    arrApiName.push(returnResult[i].fieldApiName);
                    arrLabel.push(opt);
                }
                component.set("v.fieldlabels", arrLabel);
                component.set("v.fields", arrApiName);
                this.getReviewClusterdetails(component, event, initial, direction,helper);
            }
        });
        $A.enqueueAction(action);       
    },
    getReviewClusterdetails: function(component, event, initial, direction,helper) {
        debugger;  
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var fields = component.get("v.fields");        
        var clusterCount = component.get("v.ClusterCount");
        var firstClusterlist = '';
        var clusterlist = component.get("v.clusterList");
        if(initial == true && direction == '') {
            component.set("v.ClusterCount", 0);            
            firstClusterlist = clusterlist[0].Id; 
        }
        else{
            if(clusterlist.length > clusterCount) {
                if(direction == 'Next') {
                    if(clusterlist.length > 0 && (clusterlist.length <= Number(clusterCount))) {
                        clusterCount = 0;
                    } else {
                        clusterCount = Number(clusterCount) + Number(1);
                    }
                    if(clusterlist[clusterCount] == undefined && clusterlist.length > 0) {
                        clusterCount = 0
                    }
                    component.set("v.ClusterCount", clusterCount);
                    firstClusterlist = clusterlist[clusterCount].Id;
                }    
                else if(direction == 'Previous'){
                    clusterCount = Number(clusterCount) - Number(1); 
                    component.set("v.ClusterCount", clusterCount);
                    firstClusterlist = clusterlist[clusterCount].Id;
                }
                    else {
                        component.set("v.ClusterCount", clusterCount);
                        firstClusterlist = clusterlist[clusterCount].Id;
                    }
            } else {
                clusterCount = 0;
                component.set("v.ClusterCount", clusterCount);
                firstClusterlist = clusterlist[clusterCount].Id;
            }
        }
        if(clusterCount < 1){
            if(component.find("btnPrevious") != undefined) {
                component.find("btnPrevious").set("v.disabled",true);
            }
        }
        else{
            if(component.find("btnPrevious") != undefined) {
                component.find("btnPrevious").set("v.disabled",false);
            }
        }
        
        if(clusterlist.length == Number(clusterCount) + Number(1)){
            if(component.find("btnNext") != undefined) {
                component.find("btnNext").set("v.disabled",true);
            }
        }
        else{
            if(component.find("btnNext") != undefined) {
                component.find("btnNext").set("v.disabled",false);
            }
        }
        component.set("v.selectedClusterId",firstClusterlist);
        var action = component.get("c.getClusterDetails");
        action.setParams({
            'fieldstoget' : fields.join(),
            'ClusterId': firstClusterlist,
            'ObjectName': component.get("v.selectedObjectName"),
            'sortField': component.get("v.selectedTabsort"),
            'isAsc': component.get("v.isAsc")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var retRecords;   
                document.getElementById("ClusterData").innerHTML ='';
                var returnvalue = response.getReturnValue();
                retRecords = returnvalue.sObjectrecords;
                var totalrecords = returnvalue.total;
                var mergeRuleMasterRec = returnvalue.mergeRuleMasterRecords;
                var mergeRuleMasterRecordType = returnvalue.mergeRuleMasterRecordType;
                var varConfidenceScore = returnvalue.leastConfidenceScore;
                var varClstrConfidenceScore = returnvalue.clusterConfidenceScore;
                var userDefinedField = returnvalue.mergeRuleObjectFieldVal;
                var strFieldValRuleMasterRec = returnvalue.SpecificeFieldMasterRecords;
                var strSpecificFieldValRuleMasterRec = returnvalue.fieldSelectionMasterRecords;
                console.log('strFieldValRuleMasterRec@@ ' + strFieldValRuleMasterRec);
                if(mergeRuleMasterRec != undefined && mergeRuleMasterRec != null && mergeRuleMasterRec != '') {
                    component.set("v.masterRecordId",mergeRuleMasterRec);
                    component.set("v.FieldValUpdateFieldName",strFieldValRuleMasterRec);
                    component.set("v.FieldValUpdateSpecificFieldName",strSpecificFieldValRuleMasterRec);
                    console.log('TEMP MasterRec@@ ' + component.get ("v.FieldValUpdateFieldName"));
                    component.set("v.masterRecordType",mergeRuleMasterRecordType);
                    component.set("v.leastConfidenceScore",varConfidenceScore);
                    component.set("v.clstrConfidenceScore",varClstrConfidenceScore);
                    component.set("v.userDefinedField",userDefinedField); 
                    
                }
                var masterRecordId = component.get("v.masterRecordId");
                
                if(masterRecordId == '' || masterRecordId == null) {
                    component.set("v.showMasterRecord",false);
                }
                if(returnvalue.total > 0){
                    debugger;
                    var arrFieldApiName = component.get("v.tempFieldName");
                    var arrColumnName = component.get("v.tempColumnName");
                    if(arrFieldApiName == undefined) {
                        arrFieldApiName = [];
                    }
                    if(arrColumnName == undefined) {
                        arrColumnName = [];
                    }
                    var arrTempHoldFields = component.get("v.arrTempColumnName");
                    if(arrTempHoldFields == undefined) {
                        arrTempHoldFields = [];
                    }
                    retRecords.forEach(function(s) {
                        var tableRow = document.createElement("tr");
                        var chckTD = document.createElement("td");                     
                        var radiobtn = document.createElement("input");
                        var tempHoldFields = component.get("v.objTempColumnName");
                        if(tempHoldFields == undefined) {
                            tempHoldFields = {};
                        }
                        var temp;
                        radiobtn.type = "radio";
                        radiobtn.name = "radClusters";
                        radiobtn.value = s["Id"];
                        radiobtn.id = s["Id"]; 
                        if(masterRecordId == s["Id"]) {
                            radiobtn.checked = true;
                        }
                        radiobtn.addEventListener('click', function(){
                            debugger;
                            component.set("v.iserror",false);
                            for(var i = 0; i < arrTempHoldFields.length; i++) {
                                if(arrTempHoldFields[i] != undefined) {
                                    document.getElementById(arrTempHoldFields[i].id).style =  "";
                                    document.getElementById(arrTempHoldFields[i].masterTabId).style =  "";
                                }
                            }
                            component.set("v.arrTempColumnName",[]);
                            arrTempHoldFields = [];
                            debugger;
                            var checkboxes = document.getElementsByName('radClusters');
                            for (var i = 0; i < checkboxes.length; i++) {
                                var rowno = checkboxes[i].id;
                                if(checkboxes[i].checked) {
                                    document.getElementById(rowno).parentElement.parentElement.style = "background-color: aquamarine; pointer-events: none;";
                                } 
                                else {
                                    document.getElementById(rowno).parentElement.parentElement.style = "background-color: white;";
                                }
                            }
                            component.set("v.showMasterRecord",false);
                            component.set("v.masterRecordId",s["Id"]);
                            component.set("v.tempFieldName",[]);
                            component.set("v.tempColumnName",[]);
                            component.set("v.showMasterRecord",true);
                        });
                        chckTD.appendChild(radiobtn);
                        tableRow.appendChild(chckTD);
                        fields.forEach(function(field){
                            var tableData = document.createElement("td");
                            tableData.id = s["Id"] + field;
                            if(field == 'Owner.Name'){
                                s[field] = s['Owner'].Name;
                            }
                            if(field == 'Account.Name' && s['Account'] != undefined){
                                s[field] = s['Account'].Name;
                            }
                            if( s[field] == null || s[field] == undefined || s[field] == ''){
                                s[field] = '-';
                            }
                            tableData.addEventListener('click', function(){
                                debugger;
                                if(!field.includes('Date') && !field.includes('date') && !field.includes('DATE')) {
                                    component.set("v.iserror",false);
                                    var detailtemp = {};
                                    var datatableId = {};
                                    component.set("v.showMasterRecord",false);
                                    detailtemp = { [field]: s[field]};
                                    arrFieldApiName.push(detailtemp);
                                    arrColumnName.push(field);
                                    
                                    component.set("v.tempFieldName",arrFieldApiName);
                                    component.set("v.tempColumnName",arrColumnName);
                                    if(component.get("v.masterRecordId") != '') {
                                        var masrterTabid = component.get("v.masterRecordId") + field;
                                        if(tempHoldFields[field] != undefined) {
                                            tempHoldFields[field].style = "";
                                        }
                                        tempHoldFields[field] = tableData;
                                        for(var i = 0; i < arrTempHoldFields.length; i++) {
                                            if(arrTempHoldFields[i] != undefined) {
                                                if(arrTempHoldFields[i].fieldName == field) {
                                                    document.getElementById(arrTempHoldFields[i].id).style =  "";
                                                    delete arrTempHoldFields[i];
                                                    break;
                                                }
                                            }
                                        }
                                        datatableId.id = tableData.id;
                                        datatableId.fieldName = field;
                                        datatableId.masterTabId = masrterTabid;
                                        arrTempHoldFields.push(datatableId);
                                        component.set("v.arrTempColumnName",arrTempHoldFields);
                                        document.getElementById(masrterTabid).style = "background-color: whitesmoke;";
                                        tableData.style = "background-color: aquamarine;";
                                        component.set("v.showMasterRecord",true);
                                    }
                                }
                                else {
                                    component.set("v.iserror",true);
                                    component.set("v.errormsg","Can not update date fields.");
                                }  
                            });
                            tableData.innerHTML = s[field];
                            tableRow.appendChild(tableData);
                        });
                        document.getElementById("ClusterData").appendChild(tableRow);
                        component.set("v.objTempColumnName", tempHoldFields);
                        if(component.get("v.masterRecordId") != '') {
                            component.set("v.showMasterRecord",true);
                        }
                    });
                    setTimeout(function(){  
                        if(component.get("v.masterRecordId") != '') {
                            var masterRecId = component.get("v.masterRecordId");
                            for(var i = 0; i < arrTempHoldFields.length; i++) {
                                if(arrTempHoldFields[i] != undefined) {
                                    document.getElementById(arrTempHoldFields[i].id).style =  "background-color: aquamarine;";
                                    document.getElementById(arrTempHoldFields[i].masterTabId).style =  "background-color: whitesmoke;";
                                }
                            }
                            var checkboxes1 = document.getElementsByName('radClusters');
                            for (var i = 0; i < checkboxes1.length; i++) {
                                var rowno = checkboxes1[i].id;
                                if(checkboxes1[i].checked) {
                                    document.getElementById(rowno).parentElement.parentElement.style = "background-color: aquamarine; pointer-events: none;";
                                } 
                                else {
                                    document.getElementById(rowno).parentElement.parentElement.style = "background-color: white;";
                                }
                            }
                            if(checkboxes1.length == 0) {
                                document.getElementById(masterRecId).parentElement.parentElement.style = "background-color: aquamarine; pointer-events: none;";
                            }
                        }                    
                    }, 100);
                    
                }
                
            }
            component.find("ClusterSpinner").set("v.class" , 'slds-hide');            
        });
        $A.enqueueAction(action);  
    },
    sortHelper: function(component, event, helper) {
        var currentDir = component.get("v.arrowDirection");
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }
        var clusterId = component.get("v.selectedClusterId");
        // call the onLoad function for call server side method with pass sortFieldName 
        component.set("v.isSaveCluster",false);
        this.getReviewClusterdetails(component, clusterId);
    },
    pollApex : function(component, event, helper, BatchId) { 
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var interval = setInterval($A.getCallback(function () {
            helper.checkStatusMethod(component,helper,interval,BatchId);
        }), 10000);
        component.set("v.setIntervalId", interval) ;
    },
    checkStatusMethod: function (component,helper,interval,BatchIdPrm) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var action = component.get("c.batchStatus"); 
        
        action.setParams({
            "BatchProcessId" : BatchIdPrm ,
            "strObjectName": component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnvalue = response.getReturnValue();
                var statPercentVal = 0; 
                if(returnvalue.JobItemsProcessed != 0 && returnvalue.TotalJobItems != 0){
                    statPercentVal = parseInt(((returnvalue.JobItemsProcessed) / returnvalue.TotalJobItems) * 100);
                    component.find("ClusterSpinner").set("v.class" , 'slds-hide');
                    component.set("v.isDataProgress",true);
                    component.set("v.progress", statPercentVal);  
                    component.set("v.percentCount",statPercentVal);
                    var intTotalClusterCount = component.get('v.clusterList'); 
                    intTotalClusterCount = intTotalClusterCount.length * 0.38;
                    if(intTotalClusterCount < 60) {
                        component.set('v.timeUnit',' seconds');
                        component.set('v.estimatedTime',intTotalClusterCount);
                    } else {
                        component.set('v.timeUnit',' minutes');
                        var estimatedTime = intTotalClusterCount/60;
                        var floatEstimatedTime = estimatedTime.toFixed(2);
                        component.set('v.estimatedTime',floatEstimatedTime);
                    }
                } 
                if(returnvalue.JobItemStatus == 'Completed') {
                    window.setTimeout(
                        $A.getCallback(function() {
                            var tabChangeEvent = component.getEvent("tabFocus");
                            tabChangeEvent.setParams({
                                tabName : "uniqueLeadTab"
                            });
                            tabChangeEvent.fire();
                            component.set("v.isDataProgress",false);
                            window.clearInterval(component.get("v.setIntervalId"));
                            component.find("ClusterSpinner").set("v.class" , 'slds-hide');
                        }), 10000
                    );
                } 
            }
        });
        $A.enqueueAction(action);
    }
})