({	
    getRecordSize: function(component, event, helper) { 
        debugger;
        var action = component.get('c.GetPerPageRecordSize');
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var recordSizeVal = returnVal.SmartDD__Per_Page_Record__c;
                if(recordSizeVal != null) {
                    component.set("v.pageSize",recordSizeVal.toString());
                }
                component.set("v.isNavigate",false);
                this.getClusters(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    
    getClusters : function(component, event, direction) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var page = component.get("v.page") || 1;
        var pageSize = component.get("v.pageSize");
        var isNavigate = component.get("v.isNavigate");
        if(isNavigate == true && direction == 'Next') {
            var ClusterNo = component.get("v.ClusterNo");
            page = Math.floor(Number(ClusterNo)/Number(pageSize));
            page = Number(page) + Number(1); 
        }
        else if(isNavigate == true && direction == 'Previous') {
            var ClusterNo = component.get("v.ClusterNo");
            page = Math.floor(Number(ClusterNo)/Number(pageSize));
        }
        var action = component.get("c.fetchClusters");
        action.setParams({
            'pageNumber' : page,
            'pageSize' : pageSize,
            'sortField': component.get("v.selectedTabSortList"),
            'isAsc': component.get("v.isAscList"),
            'selObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValue = response.getReturnValue();
                //component.set('v.clusterList',returnValue.sObjectrecords);
                component.set('v.clusterList',returnValue.lstSObjWrapper);
                //component.set('v.entireClusterList',returnValue.sObjectEntireList);
                component.set('v.entireClusterList',returnValue.lstSObjEntireRecWrp);
                component.set('v.totalNotReviewedCount',returnValue.totalNotReviewed);
                component.set('v.selectedTabNameFocus',returnValue.selectedTabName);
                var totalrecords = returnValue.total;
                var pageSize = component.get("v.pageSize");
                component.set("v.total",totalrecords);
                var totalPages =  Math.ceil(totalrecords/pageSize); 
                if(totalPages != undefined && totalPages != null && totalPages != ''){
                    component.set("v.pages",totalPages);
                }
                var tempPageSize = component.get("v.pageSize");
                var tempPageNo = component.get("v.page");
                var currentCLusterNo = component.get("v.currentCLusterNo");
                var clusterlist = component.get("v.clusterList"); 
                var selectedTabFocus = '';
                if(clusterlist.length > 0 && component.get('v.totalNotReviewedCount') > 0) {
                    //selectedTabFocus = component.get('v.selectedTabNameFocus');
                    selectedTabFocus = 'detailTab';
                } else if(clusterlist.length > 0 && component.get('v.totalNotReviewedCount') == 0) {
                    selectedTabFocus = 'polishTab';
                } else {
                    selectedTabFocus = 'uniqueLeadTab';
                }
                
                var tabChangeEvent = component.getEvent("tabFocus");
                tabChangeEvent.setParams({
                    tabName : selectedTabFocus
                });
                tabChangeEvent.fire();
                
                if(isNavigate == true && direction == 'Next') {
                    var clusterCount = Number(currentCLusterNo) + Number(1);    
                    if(clusterlist.length > 0) {
                        var tempClusterNo = Number(clusterCount) - Number(tempPageSize);
                        if(tempClusterNo >= 0) {
                            clusterCount = tempClusterNo;
                        }
                        component.set("v.currentCLusterNo", clusterCount);
                      	var nextClusterId = clusterlist[clusterCount].clusterId;
                        component.set("v.isSaveCluster",true);
                        this.ShowClusterDetailRecs(component,nextClusterId,direction);
                    }
                }
                else if(isNavigate == true && direction == 'Previous') {
                    var clusterCount = Number(currentCLusterNo) - Number(1);
                    if(clusterlist.length > 0) {
                        var tempClusterNo = Number(clusterCount) + Number(tempPageSize);
                        if(tempClusterNo >= 0) {
                            clusterCount = tempClusterNo;
                        }
                        component.set("v.currentCLusterNo", clusterCount);
                        var nextClusterId = clusterlist[clusterCount].clusterId;
                        component.set("v.isSaveCluster",true);
                        this.ShowClusterDetailRecs(component,nextClusterId,direction);
                    }
                }
                if( component.get("v.fromClusterDetailPageFlag")==false){
                      component.set('v.clusterListPage',true);
                }
             //   component.set('v.clusterListPage',true);
                component.find("ClusterSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action); 
    },
    getClusterNavigate : function(component,nextClusterId,direction) {
        debugger;
        var page = component.get("v.page") || 1;
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.fetchClusters");
        action.setParams({
            'pageNumber' : page,
            'pageSize' : pageSize,
            'sortField': component.get("v.selectedTabSortList"),
            'isAsc': component.get("v.isAscList"),
            'selObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValue = response.getReturnValue();
                //component.set('v.entireClusterList',returnValue.sObjectEntireList);
                component.set('v.entireClusterList',returnValue.lstSObjEntireRecWrp);
                var lstEntireCluster = component.get("v.entireClusterList");
                if(lstEntireCluster.length > 0) {
                    this.ShowClusterDetailRecs(component,nextClusterId,direction);
                }
            }
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
        this.ShowClusterDetailRecs(component, clusterId);
    },
    sortClusterList: function(component, event, helper) {
        var currentDir = component.get("v.arrowDirectionList");
        if (currentDir == 'arrowdown') {
            // set the arrowDirectionList attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirectionList", 'arrowup');
            // set the isAscList flag to true for sort in Assending order.  
            component.set("v.isAscList", true);
        } else {
            component.set("v.arrowDirectionList", 'arrowdown');
            component.set("v.isAscList", false);
        }
        component.set("v.isNavigate",false);
        this.getClusters(component, event);
    },
    SaveClusters: function(component,event,checkboxName) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var checkboxes = document.querySelectorAll('input[name="' + checkboxName + '"]:checked'), values = [];
        Array.prototype.forEach.call(checkboxes, function(el) {
            if(el.checked == true) {
                values.push(el.value);
            }
        });
        component.set("v.selectedClusterRecords", values);
        var ClusterRecords = component.get("v.selectedClusterRecords");
        var action = component.get("c.postClusterChildRecs");
        var selectedClusterId = component.get("v.selectedClusterId");
        var ClusterNo = component.get("v.ClusterNo");
        var total = component.get("v.total");
        action.setParams({
            'clusterChildRecIds': ClusterRecords.join(),
            'clusterId': selectedClusterId,
            'clusterNo': ClusterNo,
            'ClusterTotal': total,
            'strObjectName': component.get("v.selectedObjectName") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isNavigate",false);
                var clusterlist = component.get("v.clusterList");
                var pageSize = component.get("v.pageSize");
                var pageNo = component.get("v.page");
                var clusterNo = component.get("v.currentCLusterNo");
                var clusterCount = Number(clusterNo) + Number(1);   
                var direction = 'Next';
                
                var returnStat = response.getReturnValue();
                if(returnStat) {
                    alert("L206 clusterlist.length >>> "+clusterlist.length);
                    if(clusterCount >= clusterlist.length) {
                        if(component.get("v.hideNavigationNext")) {
                            component.set("v.isNavigate",false);
                            this.getClusters(component, event);
                            component.set("v.iserror",false);
                            component.set("v.searchVal",'');
                            component.set("v.searchKey","");
                            component.set("v.clusterDetailPage",false);
                            component.set("v.hideObjectsPrm",false);
                            component.set("v.clusterListPage",true);
                        }
                        else{
                            component.set("v.clusterList",[]);
                            component.set("v.isNavigate",true);
                            this.getClusters(component, event, direction);                       
                        }
                    }
                    else { 
                        alert("L225 clusterlist.length >>> "+clusterlist.length);
                        //this.getClusters(component, event); 
                        component.set("v.currentCLusterNo", clusterCount);
                        var nextClusterId = clusterlist[clusterCount].clusterId;
                        component.set("v.isSaveCluster",true);
                        this.ShowClusterDetailRecs(component,nextClusterId,direction);
                    }
                }
                else {
                    var tabChangeEvent = component.getEvent("tabFocus");
                    tabChangeEvent.setParams({
                        tabName : "polishTab"
                    });
                    tabChangeEvent.fire();
                }
                
            }
        });
        $A.enqueueAction(action);
        component.find("ClusterSpinner").set("v.class" , 'slds-hide');
    },
    getClusterDetailPageSize: function(component,clusterId,helper) { 
        debugger;
        var action = component.get("c.GetClusterDetailRecordSize");
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var recordSizeVal = returnVal.SmartDD__Per_Page_Record__c;
                if(recordSizeVal != null) {
                    component.set("v.detailPageSize",recordSizeVal.toString());
                }
                component.set("v.isSaveCluster",false);
                this.ShowClusterDetailRecs(component, clusterId);
            }
        });
        $A.enqueueAction(action);
    },        
    pollApex : function(component, event, helper, BatchId) { 
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var interval = setInterval($A.getCallback(function () {
            helper.checkStatusMethod(component,helper,interval,BatchId);
        }), 10000);
        component.set("v.setIntervalId", interval) ;
    },
    checkStatusMethod: function (component,helper,interval,BatchIdPrm) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        component.set("v.clusterListPage",false);
        var action = component.get("c.batchStatus");  
        action.setParams({
            "BatchProcessId" : BatchIdPrm,
            "strObjectName": component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnvalue = response.getReturnValue();
                var statPercentVal = 0;
                if(returnvalue.JobItemsProcessed != 0 && returnvalue.TotalJobItems != 0) {
                    statPercentVal = parseInt(((returnvalue.JobItemsProcessed) / returnvalue.TotalJobItems) * 100);
                    component.find("ClusterSpinner").set("v.class" , 'slds-hide');
                    component.set("v.isDataProgress",true);
                    component.set("v.progress", statPercentVal);  
                    component.set("v.percentCount",statPercentVal);
                }
                if(returnvalue.JobItemStatus == 'Completed') {
                    window.setTimeout(
                        $A.getCallback(function() {
                            var tabChangeEvent = component.getEvent("tabFocus");
                            tabChangeEvent.setParams({
                                tabName : "polishTab"
                            });
                            tabChangeEvent.fire();
                            component.set("v.isDataProgress",false);
                            window.clearInterval(component.get("v.setIntervalId"));
                            component.find("ClusterSpinner").set("v.class" , 'slds-hide');
                        }), 500
                    );
                } 
            }
        });
        $A.enqueueAction(action);
    },
    searchKeyChange : function(component, strSearchKey, helper){
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var clusterId = component.get("v.selectedClusterId");
        component.set("v.isSaveCluster",false);
        this.ShowClusterDetailRecs(component,clusterId);
    },
    ShowClusterDetailRecs: function(component,clusterId,direction) {
        debugger;  
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        component.set("v.clusterDetailPage",true);
        component.set("v.hideObjectsPrm",true);
        component.set("v.clusterListPage",false);
        var fields = component.get("v.fields");
        component.set("v.selectedClusterId",clusterId);
        var lstClusters = component.get("v.entireClusterList");
        alert("L325 Entire cluster List >>> "+lstClusters);
        /*var foundCluster = lstClusters.find(cluster => cluster.clusterId === clusterId);
        if (foundCluster) {
            alert("L328 Found Cluster >>> "+foundCluster);
            component.set("v.ClusterExternalId", foundCluster.externalClusterId);
            component.set("v.ClusterCount", foundCluster.totalChildRecs);
            component.set("v.ClusterReviewStatus", foundCluster.clusterReviewStatus);
            component.set("v.ClusterInternalId", foundCluster.clusterId);
            component.set("v.ClusterName", foundCluster.sObjectRecordName);
            component.set("v.ConfidenceScore", foundCluster.confidenceLevelCount);
        } else {
            alert("L336 Cluster not Found >>> "+clusterId);
        }*/
        for(var i=0;i<lstClusters.length;i++) {
            if(lstClusters[i].clusterId == clusterId) {
                component.set("v.ClusterExternalId", lstClusters[i].externalClusterId);
                component.set("v.ClusterCount",lstClusters[i].totalChildRecs);
                component.set("v.ClusterReviewStatus",lstClusters[i].clusterReviewStatus);
                component.set("v.ClusterInternalId",lstClusters[i].clusterId);
                component.set("v.ClusterName",lstClusters[i].sObjectRecordName);
                component.set("v.ConfidenceScore",lstClusters[i].confidenceLevelCount);
                break;
            }
        }
        if(component.get("v.ClusterReviewStatus") != 'Not Reviewed') {
            component.set("v.hideSaveCluster",true); 
        }
        else{
            component.set("v.hideSaveCluster",false); 
        }
        var detailPageNo = component.get("v.detailPageNo") || 1;
        var detailPageSize = component.get("v.detailPageSize");
        var action = component.get("c.getClusterDetails");
        action.setParams({
            'ClusterId': clusterId,
            'fieldstoget' : fields.join(),
            'ObjectName': component.get("v.selectedObjectName"),
            'sortField': component.get("v.selectedTabsort"),
            'searchKey': component.get("v.searchKey"),
            'isAsc': component.get("v.isAsc"),
            'pageNumber' : detailPageNo,
            'pageSize' : detailPageSize
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var retRecords;
                document.getElementById("data").innerHTML ='';
                var returnvalue = response.getReturnValue();
                retRecords = returnvalue.sObjectrecords;
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
                        var strReplace = recStringfy.substring(0,duplicateRecStringfy.indexOf(dupserchKeyString)) + recStringfy.substring(duplicateRecStringfy.indexOf(dupserchKeyString),duplicateRecStringfy.indexOf(dupserchKeyString)+serchKeyString.length)
                        recStringfy = recStringfy.replace(strReplace,'');
                        duplicateRecStringfy = duplicateRecStringfy.replace(strReplace.toLowerCase(),'');
                    }
                    serchKeyResults.push(recStringfy);
                    //recStringfy= recStringfy.split(component.get("v.searchKey")).join('<span style=\'background: yellow;\'>' + component.get("v.searchKey") + '</span>');
                    //retRecords  = JSON.parse(recStringfy);
                    retRecords  = JSON.parse(serchKeyResults.join(''))
                }else{
                    retRecords = returnvalue.sObjectrecords;
                }
                // Code to highlight search key ends
                var isSaveCluster = component.get("v.isSaveCluster");
                if(isSaveCluster == true) {
                    var clusterNo = component.get('v.ClusterNo');
                    var totalClusters = component.get('v.total');
                    if(Number(totalClusters) >  Number(clusterNo) && direction == 'Next') { 
                        component.set('v.ClusterNo',Number(clusterNo)+Number(1));
                    } else if(direction == 'Previous' && clusterNo > 1) { 
                        component.set('v.ClusterNo',Number(clusterNo)-Number(1));
                    }
                }
                var totalrecords = returnvalue.total;
                var pageSize = component.get("v.detailPageSize");
                component.set("v.totalDetailRec",totalrecords);
                if(totalrecords < 2){
                    component.set("v.blnDisableGroupButton",true);
                }else {
                    component.set("v.blnDisableGroupButton",false);
                }
                var totalPages =  Math.ceil(totalrecords/pageSize); 
                if(totalPages != undefined && totalPages != null && totalPages != ''){
                    component.set("v.detailPages",totalPages);
                }
                var reviewClusterStatus = component.get('v.ClusterReviewStatus');
                if(returnvalue.total > 0){
                    retRecords.forEach(function(s) {
                        var tableRow = document.createElement('tr');
                        var chckTD = document.createElement('td');
                        var checkbox = document.createElement('input');
                        checkbox.type = "checkbox";
                        checkbox.name = "chkClusters";
                        if(reviewClusterStatus != 'Not Reviewed'){
                            checkbox.disabled = "disabled";
                        }
                        checkbox.value = s["Id"];
                        checkbox.id = s["Id"];
                        
                        chckTD.appendChild(checkbox);
                        tableRow.appendChild(chckTD);
                        fields.forEach(function(field){ 
                            var tableData = document.createElement('td');
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
                        document.getElementById("data").appendChild(tableRow);
                    });
                }
                var ClusterNo = component.get("v.ClusterNo");
                var total = component.get("v.total");
                if(ClusterNo <= 1) {
                    component.set("v.hideNavigationPrev",true);    
                }
                else {
                    component.set("v.hideNavigationPrev",false);    
                }
                if(ClusterNo == total) {
                    component.set("v.hideNavigationNext",true);    
                }
                else {
                    component.set("v.hideNavigationNext",false);    
                }
            }
            component.find("ClusterSpinner").set("v.class" , 'slds-hide');
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
                component.find("ClusterSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    }
})