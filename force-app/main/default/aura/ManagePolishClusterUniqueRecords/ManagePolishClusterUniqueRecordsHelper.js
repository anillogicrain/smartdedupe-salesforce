({
    checkSingleSpinnerProcess: function(component, event, helper,interval){
        var action = component.get("c.getDedupeStatus");  
        action.setParams({
            'dedupeObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var clustersCompletedStat = response.getReturnValue();
                var singleClustersCompletedStat = clustersCompletedStat;                                      
                if(singleClustersCompletedStat != 'Completed') {  
                    component.find("ClusterSpinner").set("v.class" , 'slds-show');                    
                }else{
                    debugger;
                    component.find("ClusterSpinner").set("v.class" , 'slds-hide');
                    console.log('clearInterval' + component.get("v.setSingleIntervalId"));
                    window.clearInterval(component.get("v.setSingleIntervalId"));
                    component.set("v.selectedTabsort", "");
                    component.set("v.hideObjectsPrm",false);         
                    helper.getReviewClusterColumns(component, event,helper);
                    helper.GetYourUniqueDataHelper(component, event, helper); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    getReviewClusterColumns: function(component, event, helper) {
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
                this.getReviewClusterdetails(component, event,helper);
                
            }
        });
        $A.enqueueAction(action);       
    },
    getReviewClusterdetails: function(component, event ,helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var page = component.get("v.page") || 1;
        var pageSize = component.get("v.pageSize");
         
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var fields = component.get("v.fields");        
        var action = component.get("c.getClusterDetails");
        action.setParams({
            'fieldstoget' : fields.join(),
            'ObjectName': component.get("v.selectedObjectName"),
            'sortField': component.get("v.selectedTabsort"),
            'isAsc': component.get("v.isAsc"),
            'pageNumber' : page,
            'pageSize' : pageSize,
            'searchKey' : component.get("v.searchKey"),
            'navigation' : component.get('v.NavigateDirection'),
            'firstLimitVal' : component.get('v.FirstLimitValue'),
            'lastLimitVal' : component.get('v.LastLimitValue')
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var retRecords;    
                if(document.getElementById("uniqueLeadData") != undefined) {
                    document.getElementById("uniqueLeadData").innerHTML ='';
                }
                var returnvalue = response.getReturnValue();
                if(returnvalue.clusterList.length > 0) {
                    var tabChangeEvent = component.getEvent("tabFocus");
                    tabChangeEvent.setParams({
                        tabName : "detailTab"
                    });
                    tabChangeEvent.fire();
                }
                retRecords = returnvalue.sObjectrecords;
                if(returnvalue.FirstReturnValue != '' || returnvalue.LastReturnValue != '') {
                    component.set('v.FirstLimitValue',returnvalue.FirstReturnValue);
					component.set('v.LastLimitValue',returnvalue.LastReturnValue);                                  
                }
                // Code to highlight search key starts 
                var retRecordsforsplit = returnvalue.sObjectrecords;
                var retRecords;
                if(component.get("v.searchKey") != '' && component.get("v.searchKey") != undefined){
                    var recStringfy = JSON.stringify(retRecordsforsplit);
                    var duplicateRecStringfy = JSON.stringify(retRecordsforsplit).toLowerCase();
                    var serchKeyResults =[];
                    var serchKeyString = component.get("v.searchKey").trim();
                    var dupserchKeyString = (component.get("v.searchKey").trim()).toLowerCase();
                    while(duplicateRecStringfy.indexOf(dupserchKeyString) != -1){
                        var indexvalue = recStringfy.substring(0,duplicateRecStringfy.indexOf(dupserchKeyString)) + "<span style='background: yellow;'>" + recStringfy.substring(duplicateRecStringfy.indexOf(dupserchKeyString),duplicateRecStringfy.indexOf(dupserchKeyString)+serchKeyString.length) +  "</span>" ; 
                        serchKeyResults.push(indexvalue);
                        var strReplace = recStringfy.substring(0,duplicateRecStringfy.indexOf(dupserchKeyString)) + recStringfy.substring(duplicateRecStringfy.indexOf(dupserchKeyString),duplicateRecStringfy.indexOf(dupserchKeyString)+serchKeyString.length);
                        recStringfy = recStringfy.replace(strReplace,'');
                        duplicateRecStringfy = duplicateRecStringfy.replace(strReplace.toLowerCase(),'');
                    }
                    serchKeyResults.push(recStringfy);
                    retRecords  = JSON.parse(serchKeyResults.join(''))
                }else{
                    retRecords = returnvalue.sObjectrecords;
                }
                if(returnvalue.blnUniqueRecordSaved != null) {
                    component.set("v.isClusterSaved", returnvalue.blnUniqueRecordSaved);
                }
                var totalrecords = returnvalue.total;
                var pageSize = component.get("v.pageSize");
               
                component.set("v.total",totalrecords);
                //check total records
                if(totalrecords > 48000){
                    component.set('v.iserror',true);
                    component.set('v.errormsg','You are now operating on more than 48 thousand record, so you may face some difference in operating the search and sorting functionalities in the page.');
                }
               
                var totalPages =  Math.ceil(totalrecords/pageSize); 
                if(totalPages != undefined && totalPages != null && totalPages != ''){
                    component.set("v.pages",totalPages);
                }
                var tempPageSize = component.get("v.pageSize");
                var tempPageNo = component.get("v.page");                
                console.log('@@@@@@@@@@totalrecords' + totalrecords);
                if(returnvalue.total > 0){
                    debugger;
                    retRecords.forEach(function(s) {
                        var tableRow = document.createElement("tr");
                        var chckTD = document.createElement('td');
                        if(component.get("v.isSaveCluster") == true) {
                            var checkbox = document.createElement('input');
                            checkbox.type = "checkbox";
                            checkbox.name = "chkUniqueClusters";
                            checkbox.value = s["Id"];
                            checkbox.id = s["Id"];
                            chckTD.appendChild(checkbox);
                            tableRow.appendChild(chckTD);
                        }
                        if(s["SmartDD__IsMerged__c"] == true) {
                            tableRow.style = "background-color: aquamarine;";
                        }
                        var notesTD = document.createElement('td');
                        var anchorLink = document.createElement('a');
                        //anchorLink.setAttribute('href',"#");
                        anchorLink.addEventListener('click', function(){
                            debugger;
                            if(s["SmartDD__IsMerged__c"] == true) {
                                component.set('v.blnPopNotes',true);
                                if(s["SmartDD__TempDedupeNotes__r"] != undefined && s["SmartDD__TempDedupeNotes__r"].length > 0 && s["SmartDD__TempDedupeNotes__r"][0]["SmartDD__Body__c"] != '') {
                                    component.set('v.ClusterNotes',s["SmartDD__TempDedupeNotes__r"][0]["SmartDD__Body__c"]);
                                } else if(s["SmartDD__TempDedupeNotes__r"] != undefined && s["TempDedupeNotes__r"]["SmartDD__Body__c"] != undefined && s["SmartDD__TempDedupeNotes__r"]["SmartDD__Body__c"] != '') {
                                    component.set('v.ClusterNotes',s["SmartDD__TempDedupeNotes__r"]["SmartDD__Body__c"]);
                                } else {
                                    component.set('v.ClusterNotes','No notes available for this record.');
                                }
                            } else {
                                component.set('v.blnPopNotes',false);
                            }
                            component.set('v.notesParentId',s["Id"]);
                        });
                        if(s["SmartDD__TempDedupeNotes__r"] != undefined && s["SmartDD__TempDedupeNotes__r"].length > 0 && s["SmartDD__IsMerged__c"] == true) {
                            anchorLink.innerText = s["SmartDD__TempDedupeNotes__r"][0]["SmartDD__MergeType__c"];
                        } else if(s["SmartDD__TempDedupeNotes__r"] != undefined && s["SmartDD__TempDedupeNotes__r"]["SmartDD__MergeType__c"] != undefined && s["SmartDD__TempDedupeNotes__r"]["SmartDD__MergeType__c"] != '') {
                            anchorLink.innerText = s["SmartDD__TempDedupeNotes__r"]["SmartDD__MergeType__c"];
                        } else{
                            anchorLink.innerText = "";
                        }
                        notesTD.appendChild(anchorLink);
                        tableRow.appendChild(notesTD);
                        fields.forEach(function(field){ 
                            var tableData = document.createElement("td");
                            if(field == 'Owner.Name'){
                                s[field] = s['Owner'].Name;
                            }
                            if(field == 'Account.Name' && s['Account'] != undefined){
                                s[field] = s['Account'].Name;
                            }
                            if( s[field] == null || s[field] == undefined || s[field] == ''){
                                s[field] = '-';
                            }
                            tableData.innerHTML = s[field];
                            tableRow.appendChild(tableData);
                        });
                        if(document.getElementById("uniqueLeadData") != undefined) {
                            document.getElementById("uniqueLeadData").appendChild(tableRow);  
                        }
                    });
                }
                
            }
            component.find("ClusterSpinner").set("v.class" , 'slds-hide');            
        });
        $A.enqueueAction(action);  
    },
    searchKeyChange : function(component, event, strSearchKey, helper){
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        this.getReviewClusterdetails(component, event,helper);
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
        // call the onLoad function for call server side method with pass sortFieldName 
        this.getReviewClusterdetails(component, event, helper);
    },
    
    //Merge Attachments using Batch Apex and pollapex.
    MergeAttachmentHelper : function(component,event,helper) {
        debugger;
        //var selectedFilterId = component.find("viewfilter").get("v.value"); 
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var action = component.get("c.MergeAttachments");
        action.setParams({
            'ObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var batchId = response.getReturnValue();
                helper.checkAttachmentBatchStatus(component, event, helper, batchId);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkAttachmentBatchStatus : function(component, event, helper, batchId) { 
        debugger;
        var interval = setInterval($A.getCallback(function () {
            helper.checkAttachBatchProcess(component,helper,interval,batchId);
        }), 5000); 
        component.set("v.setAttachIntervalId", interval) ;   
    },
    
    checkAttachBatchProcess: function (component,helper,interval,BatchIdPrm) {
        debugger;
        var action = component.get("c.batchStatus");  
        action.setParams({
            "BatchProcessId" : BatchIdPrm 
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
                    component.set("v.statusStatement",'Merge Attachment Files');
                    component.set("v.progress", statPercentVal);  
                    component.set("v.percentCount",statPercentVal);
                }
                if(returnvalue.JobItemStatus == 'Completed') {
                    component.set("v.progress", statPercentVal);  
                    component.set("v.percentCount",statPercentVal);
                    component.set("v.isDataProgress",false);
                    window.clearInterval(component.get("v.setAttachIntervalId"));
                    helper.SaveYourDataHelper(component, event, helper);
                } 
            }
        });
        $A.enqueueAction(action);
    },
    
    //Delete Duplicate records for final from the deduped object.
    SaveYourDataHelper : function(component,event,helper) {
        debugger;
        //var selectedFilterId = component.find("viewfilter").get("v.value"); 
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var action = component.get("c.DeleteDuplicateData");
        action.setParams({
            'ObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnBatchId = response.getReturnValue();
                if(returnBatchId != '') {
                    helper.checkDelDuplBatchStatus(component, event, helper, returnBatchId);
                } else {
                    var direction = '';
                    helper.GetYourUniqueDataHelper(component,event,helper);
                    helper.getReviewClusterColumns(component, event, direction,helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    checkDelDuplBatchStatus : function(component, event, helper, returnBatchId) { 
        var interval = setInterval($A.getCallback(function () {
            helper.checkDelDuplBatchProcess(component,helper,interval,returnBatchId);
        }), 5000); 
        component.set("v.setDelDuplIntervalId", interval) ;   
    },
    
    checkDelDuplBatchProcess: function (component,helper,interval,BatchIdPrm) {
        debugger;
        var action = component.get("c.batchStatus");  
        action.setParams({
            "BatchProcessId" : BatchIdPrm 
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
                    component.set("v.statusStatement",'Delete duplicate records');
                    component.set("v.progress", statPercentVal);  
                    component.set("v.percentCount",statPercentVal);
                }
                if(returnvalue.JobItemStatus == 'Completed') {
                    component.set("v.progress", statPercentVal);  
                    component.set("v.percentCount",statPercentVal);
                    component.set("v.isDataProgress",false);
                    window.clearInterval(component.get("v.setDelDuplIntervalId"));
                    var direction = '';
                    helper.GetYourUniqueDataHelper(component,event,helper);
                    helper.getReviewClusterColumns(component, event, direction,helper);
                } 
            }
        });
        $A.enqueueAction(action);
    },
    GetYourUniqueDataHelper : function(component,event,helper) {
        var action = component.get("c.GetFilterRecordSize");
        action.setParams({
            'strObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if(returnValue != null) {
                    component.set('v.iserror',false);
                    component.set("v.totalDeletedRec", returnValue.SmartDD__Deleted_Records__c);
                    component.set("v.totalUpdatedRec", returnValue.SmartDD__Updated_Records__c);
                    component.set("v.isClusterSaved", returnValue.SmartDD__Unique_Cluster_Saved__c);
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateFilterData : function(component,event,helper) { 
        var actionMasterCluster = component.get("c.updateDedupeObjectName");  
        actionMasterCluster.setParams({
            "selectedObjectname" : component.get("v.selectedObjectName")
        });
        actionMasterCluster.setCallback(this, function(responseMasterCluster){
            var stateMasterCluster = responseMasterCluster.getState(); 
            if(stateMasterCluster == "SUCCESS") {
                component.set("v.isCreateClusterProgress",true);
                this.pollCreateCluster(component,event,helper);
            }
        });
        $A.enqueueAction(actionMasterCluster);
    },
    // Function to generate random number 
    getEstimatedTime: function(component,event, helper) { 
        var intEstimatedTime = 0; //estimatedTime
        var totalRecordCounts = component.get('v.total'); 
        if(totalRecordCounts > 0 && totalRecordCounts < 2000) {
            intEstimatedTime = Math.floor(Math.random() * (3 - 1) + 1);
        } else if(totalRecordCounts > 2000 && totalRecordCounts < 5000) {
            intEstimatedTime = Math.floor(Math.random() * (4 - 2) + 2);
        } else if(totalRecordCounts > 5000 && totalRecordCounts < 10000) {
            intEstimatedTime = Math.floor(Math.random() * (5 - 3) + 3);
        } else if(totalRecordCounts > 10000 && totalRecordCounts < 15000) {
            intEstimatedTime = Math.floor(Math.random() * (6 - 4) + 4);
        } else if(totalRecordCounts > 15000 && totalRecordCounts < 20000) {
            intEstimatedTime = Math.floor(Math.random() * (7 - 5) + 5);
        } else if(totalRecordCounts > 20000 && totalRecordCounts < 25000) {
            intEstimatedTime = Math.floor(Math.random() * (9 - 7) + 7);
        } else if(totalRecordCounts > 25000 && totalRecordCounts < 30000) {
            intEstimatedTime = Math.floor(Math.random() * (11 - 9) + 9);
        } else if(totalRecordCounts > 30000 && totalRecordCounts < 35000) {
            intEstimatedTime = Math.floor(Math.random() * (13 - 11) + 11);
        } else if(totalRecordCounts > 35000 && totalRecordCounts < 40000) {
            intEstimatedTime = Math.floor(Math.random() * (14 - 12) + 12);
        } else if(totalRecordCounts > 40000 && totalRecordCounts < 45000) {
            intEstimatedTime = Math.floor(Math.random() * (15 - 13) + 13);
        } else if(totalRecordCounts > 45000 && totalRecordCounts < 50000) {
            intEstimatedTime = Math.floor(Math.random() * (17 - 14) + 14);
        } else if(totalRecordCounts > 50000 && totalRecordCounts < 55000) {
            intEstimatedTime = Math.floor(Math.random() * (19 - 16) + 16);
        } else if(totalRecordCounts > 55000 && totalRecordCounts < 60000) {
            intEstimatedTime = Math.floor(Math.random() * (23 - 18) + 18);
        } else if(totalRecordCounts > 60000) {
            intEstimatedTime = Math.floor(Math.random() * (50 - 30) + 30);
        }
        component.set('v.estimatedTime',intEstimatedTime);
    },
    StartReDedupe : function(component, event, helper) {
        component.set("v.iserror",false);
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        helper.getEstimatedTime(component,event,helper);
        var action = component.get("c.postReDedupeRecords");
        action.setParams({
            "selectedObjectname" : component.get("v.selectedObjectName")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS") {
                debugger;                
                var returnresopnse = response.getReturnValue();
                var returnVal = [];
                returnVal = returnresopnse.split('#');
                var BatchId = returnVal[0];
                var successVal = returnVal[1];
                if(BatchId != undefined && BatchId != null && BatchId != "") {
                    this.checkBatchStatus(component, event, helper, BatchId);
                }
                else {
                    if(successVal == "1"){
                        this.updateFilterData(component,event,helper);
                        //component.set("v.isCreateClusterProgress",true);
                        //this.pollCreateCluster(component,event,helper);
                    }
                }
                //component.find("ClusterSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    pollCreateCluster : function(component, event, helper) { 
        var totalRecordCounts = component.get('v.total'); 
        var timeInterval = 0; 
        var stopProgressbar = Math.floor((Math.random() * 10) + 80); 
        if(totalRecordCounts < 10000){
            //timeInterval = 5000;
            timeInterval = Math.floor((Math.random() * 5) + 5) * 1000;
        } else if(totalRecordCounts > 10000 && totalRecordCounts < 30000) {
            //timeInterval = 20000;
            timeInterval = Math.floor((Math.random() * 10) + 20) * 1000;
        }else if(totalRecordCounts > 30000) {
            //timeInterval = 30000;   
            timeInterval = Math.floor((Math.random() * 10) + 25) * 1000;
        }
        component.find("Id_spinner").set("v.class" , 'slds-hide');
        var createClusterInterval = setInterval($A.getCallback(function () {            
            helper.handleCreateCluster(component,helper,createClusterInterval,stopProgressbar);                  
        }), timeInterval);
        component.set("v.setClusterIntervalId", createClusterInterval) ;       
    },
    
    handleCreateCluster : function(component,helper,createClusterInterval,stopProgressbar) {
        debugger;
        var intPercentCount = component.get('v.createClusterpercentCount');               
        /**Get Customsetting field Clusters_Completed_Stat__c value. */
        var action = component.get("c.getClustersCompletedStat");      
        action.setCallback(this, function(response){
            var errorMesssage = response.getReturnValue();            
            var state = response.getState();
            if (state == "SUCCESS") {  
                var returnResponse = response.getReturnValue();
                component.set("v.clustersCompletedStat",returnResponse.SmartDD__Clusters_Completed_Stat__c);
                component.set("v.totalRecDedupe",returnResponse.SmartDD__Total_Records_Deduped__c);   
                var clustersCompletedStat = component.get("v.clustersCompletedStat");
                if(intPercentCount < stopProgressbar && clustersCompletedStat != 'Completed' && intPercentCount < 90) {
                    intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
                } else if(clustersCompletedStat == 'Completed') {  
                    intPercentCount = 100;
                    clearInterval(createClusterInterval);
                }
                component.set("v.createClusterpercentCount",intPercentCount); 
                component.set("v.createClusterprogress",intPercentCount);
            }
        });
        $A.enqueueAction(action);        
        /**END*/
        
        /**Update Customsetting field Last_Create_Cluster_Progress__c value. */
        var actionUpdate = component.get("c.updateCreateClusterProgress"); 
        actionUpdate.setParams({
            'lastCreateClusterProgress' : intPercentCount,
            'clusterEstimatedTime': component.get('v.estimatedTime')
        });
        actionUpdate.setCallback(this, function(response){
            var errorMesssage = response.getReturnValue();            
            var state = response.getState();
            if (state == "SUCCESS") { 
                if(intPercentCount == 100) {
                    window.open(window.location.origin+'/apex/DedupeManageClusterPage','_self');  
                }
            }
        });
        $A.enqueueAction(actionUpdate);    
    },
    
    CreateClusterHelper : function(component,event,helper) {
        debugger;
        var selectedObjectName = component.get("v.selectedObjectName");
        var checkboxName = "chkUniqueClusters";
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var checkboxes = document.querySelectorAll('input[name="' + checkboxName + '"]:checked'), values = [];
        Array.prototype.forEach.call(checkboxes, function(el) {
            values.push(el.value);
        });
        component.set("v.selectedClusterRecords", values);
        var ClusterRecords = component.get("v.selectedClusterRecords");
        if(ClusterRecords.length > 1) {
            var action = component.get("c.CreateClusterRec");
            action.setParams({
                'clusterChildRecIds': ClusterRecords.join(),
                'objectName':selectedObjectName
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var tabChangeEvent = component.getEvent("tabFocus");
                    tabChangeEvent.setParams({
                        tabName : "polishTab"
                    });
                    tabChangeEvent.fire();
                }
            });
            $A.enqueueAction(action);  
        } else {
            component.set("v.iserror",true);
            component.set("v.errormsg","Please select more than one records to create cluster.");
        }
        component.find("ClusterSpinner").set("v.class" , 'slds-hide');
    },
    checkBatchStatus : function(component, event, helper, batchId) { 
        var interval = setInterval($A.getCallback(function () {
            helper.checkBatchProcess(component,event,helper,interval,batchId);
        }), 5000); 
        component.set("v.setIntervalId", interval) ;   
    },
    checkBatchProcess : function (component,event,helper,interval,batchId){
        var action = component.get("c.AsyncApexJobRecords");  
        action.setParams({
            "BatchProcessId" : batchId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var statPercentVal = 0; 
                var apexSyncRecord = response.getReturnValue();
                var batchProcessStatus = apexSyncRecord.JobItemStatus;
                if(batchProcessStatus != ''){
                    if(apexSyncRecord.JobItemsProcessed != 0 && apexSyncRecord.TotalJobItems != 0){
                        statPercentVal = parseInt(((apexSyncRecord.JobItemsProcessed) / apexSyncRecord.TotalJobItems) * 100);
                    }    
                    component.set("v.statusStatement",'Re-DeDupe In');
                    component.set("v.percentCount",statPercentVal);
                    component.set("v.progress", statPercentVal);
                }
                if(batchProcessStatus != 'Completed') {
                    
                    if(statPercentVal === 100) {
                        component.set("v.isDataProgress",true); 
                        component.set("v.isCreateClusterProgress",false);
                    } else {
                        component.set("v.isDataProgress",true);
                        component.set("v.isCreateClusterProgress",false);
                        component.find("Id_spinner").set("v.class" , 'slds-hide');
                        component.set("v.progress", statPercentVal);
                    }
                } else {
                    var action = component.get("c.CheckApiStatus");
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if(state == "SUCCESS"){
                            var apistatus = response.getReturnValue();
                            component.set("v.isDataProgress",false); 
                            if(apistatus == '1'){
                                window.clearInterval(component.get("v.setIntervalId"));
                                component.set("v.isDataProgress",false);
                                component.set("v.progress",0);
                                component.set("v.percentCount",0);
                                component.find("Id_spinner").set("v.class" , 'slds-hide');
                                this.updateFilterData(component,event,helper);
                                //window.open(window.location.origin+'/apex/Dedupe_Status','_blank');
                            } else {
                                component.find("Id_spinner").set("v.class" , 'slds-hide');
                                component.set('v.showInformation',true);
                                var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                                //component.set('v.Notification', 'Server has stopped responding, please contact with the administrator: anil@logicrain.com');
                            	component.set('v.Notification', homePageNewslabel);
                                //window.clearInterval(component.get("v.setIntervalId"));
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
        });
        $A.enqueueAction(action);
    }
    
})