({
    doInit : function(component, event, helper) {
        debugger;
       
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        //component.set('v.clusterListPage',true);        
        //component.set("v.selectedTabSortList", 'Confidence_Score__c');
        /**Get value of returnValBatchId using custom setting */
        var action = component.get('c.getReviewBatchId');
        action.setParams({
            'strObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var returnValBatchId = returnVal.SmartDD__Batch_Id__c;
                if(returnValBatchId == undefined || returnValBatchId == null || returnValBatchId == '' || returnValBatchId == "") {
                    returnValBatchId = '';
                }
                if(returnValBatchId != null && returnValBatchId != '') {              
                    helper.pollApex(component, event, helper, returnValBatchId);
                } else {
                    component.set('v.clusterList',[]);
                    component.set('v.entireClusterList',[]);
                    helper.getRecordSize(component, event, helper);
                    helper.getReviewClusterColumns(component, event, helper);
                    //helper.pollApexChekCluster(component, event, helper);
                }          
            }
        });
        $A.enqueueAction(action);
        /**END*/       
    },
    findSearchkeyEnter : function(component,event,helper){
        debugger;
        if(event.which == 13) {
            var strSearchKey = component.find("searchKeyInp").get("v.value");
            if(strSearchKey == undefined || strSearchKey == null || strSearchKey == '' || !strSearchKey.trim() || strSearchKey.length === 0){
                component.set("v.iserror",true);
                component.set("v.errormsg","Please enter a search key.");
            }
            else{
                strSearchKey = strSearchKey.trim();
                if(strSearchKey.length == 1){
                    component.set("v.iserror",true);
                    component.set("v.errormsg","Please enter a search string at least 2 characters long.");
                }
                else{
                    component.set("v.iserror",false);
                    component.set("v.isSearchActive",true);
                    component.set("v.searchKey", strSearchKey);
                    helper.searchKeyChange(component, strSearchKey, helper);
                }
            }
        }
    },
    findSearchkey : function(component,event,helper){
        debugger;
        var strSearchKey = component.find("searchKeyInp").get("v.value");
        if(strSearchKey == undefined || strSearchKey == null || strSearchKey == '' || !strSearchKey.trim() || strSearchKey.length === 0){
            component.set("v.iserror",false);
            component.set("v.searchVal",'');
            component.set("v.searchKey","");
            var clusterId = component.get("v.selectedClusterId");
            helper.ShowClusterDetailRecs(component,clusterId,helper);
        }
        else{
            strSearchKey = strSearchKey.trim();
            if(strSearchKey.length < 1){
                //component.set("v.iserror",true);
                //component.set("v.errormsg","Please enter a search string at least 2 characters long.");
                component.set("v.iserror",false);
                component.set("v.searchVal",'');
                component.set("v.searchKey","");
                var clusterId = component.get("v.selectedClusterId");
                helper.ShowClusterDetailRecs(component,clusterId,helper);
            }
            else{
                component.set("v.iserror",false);
                component.set("v.isSearchActive",true);
                component.set("v.searchKey", strSearchKey);
                helper.searchKeyChange(component, strSearchKey, helper);
            }
        }
    },
    clearSearch : function(component,event,helper) { 
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        var clusterId = component.get("v.selectedClusterId");
        helper.ShowClusterDetailRecs(component,clusterId,helper);
    },
    ShowClusterDetail: function(component,event,helper) {
        debugger;  
        var clusterId = event.target.dataset.id;
        var clusterNo = event.target.dataset.clustercont;
        component.set("v.currentCLusterNo",clusterNo);
        component.set("v.searchKey","");
        var pageSize = component.get("v.pageSize");
        var pageNo = component.get("v.page");
        //alert('pageSize: '+pageSize+ ' pageNo: '+pageNo+ ' clusterNo: '+clusterNo);
        var total = (Number(pageSize)*(Number(pageNo)-Number(1))) + Number(clusterNo)+Number(1);
        component.set('v.ClusterNo',total);
        var ClusterNo = component.get("v.ClusterNo");
        var total = component.get("v.total");
        if(ClusterNo == total) {
            component.set("v.hideNavigationNext",true);    
        }
        else {
            component.set("v.hideNavigationNext",false);    
        }
        helper.getClusterDetailPageSize(component,clusterId,helper);
    },
    SaveCheckedClusters:  function(component,event,helper) {
        debugger;
        var checkboxName = "chkClusters";
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        component.set("v.detailPageNo",1);
        component.set("v.hideSaveCluster",true); 
        var ClusterNo = component.get("v.ClusterNo");
        var total = component.get("v.total");
        if(ClusterNo <=  total) {
            helper.SaveClusters(component,event,checkboxName);
        }
    },
    MoveToPrevCluster:  function(component,event,helper) {
        debugger;
        var direction = "Previous";
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        component.set("v.isNavigate",false);
        component.set("v.detailPageNo",1);
        var clusterlist = component.get("v.clusterList");
        alert("L138 clusterlist >>> "+clusterlist);
        var pageSize = component.get("v.pageSize");
        var pageNo = component.get("v.page");
        var clusterNo = component.get("v.currentCLusterNo");
        var clusterCount = Number(clusterNo) - Number(1); 
        if(clusterCount < 0) {
            component.set("v.clusterList",[]);
            component.set("v.isNavigate",true);
            component.set("v.fromClusterDetailPageFlag",true);
            helper.getClusters(component, event, direction);
        }
        else {
            component.set("v.entireClusterList", []);
            component.set("v.currentCLusterNo", clusterCount);
            var nextClusterId = clusterlist[clusterCount].clusterId;
            component.set("v.isSaveCluster",true);
            helper.getClusterNavigate(component,nextClusterId,direction);
        }
    },
    MoveToNextCluster:  function(component,event,helper) {
        debugger;
        var direction = "Next";
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        component.set("v.detailPageNo",1);
        component.set("v.isNavigate",false);
        
        var clusterlist = component.get("v.clusterList");
        var pageSize = component.get("v.pageSize");
        var pageNo = component.get("v.page");
        var clusterNo = component.get("v.currentCLusterNo");
        var clusterCount = Number(clusterNo) + Number(1);    
        if(clusterCount >= pageSize) {
            component.set("v.clusterList",[]);
            component.set("v.isNavigate",true);
            component.set("v.fromClusterDetailPageFlag",true);
            helper.getClusters(component, event, direction);
            // component.set("v.fromClusterDetailPageFlag",false); 
        }
        else {
            component.set("v.entireClusterList", []);
          //  component.set("v.isShowPagination", false);
            if(clusterlist[clusterCount] != undefined) {
                component.set("v.currentCLusterNo", clusterCount);
                var nextClusterId = clusterlist[clusterCount].clusterId;
                component.set("v.isSaveCluster",true);
                helper.getClusterNavigate(component,nextClusterId,direction);
            }
        }
    },
    CancelClusterDetail: function(component,event,helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        component.set("v.isNavigate",false);
        helper.getClusters(component, event);
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        component.set("v.clusterDetailPage",false);
        component.set("v.hideObjectsPrm",false);
        component.set("v.clusterListPage",true);
        component.find("ClusterSpinner").set("v.class" , 'slds-hide');
    },
    CancelCreateClusterDetail: function(component,event,helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        component.set("v.page",1);
        component.set("v.isNavigate",false);
        helper.getClusters(component, event);
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        component.set("v.clusterDetailPage",false);
        component.set("v.hideObjectsPrm",false);
        //component.set("v.clusterListPage",true);
        //component.find("ClusterSpinner").set("v.class" , 'slds-hide');
    },
    sortColumns: function(component, event, helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var sortingColName = event.target.getAttribute("data-Id");
        // set current selected header field on selectedTabsort attribute.     
        component.set("v.selectedTabsort", sortingColName);
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, helper);
        component.find("ClusterSpinner").set("v.class" , 'slds-hide');
    },
    sortListPage: function(component, event, helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var sortingColName = event.target.getAttribute("data-Id");
        // set current selected header field on selectedTabsort attribute.     
        component.set("v.selectedTabSortList", sortingColName);
        // call the helper function with pass sortField Name   
        helper.sortClusterList(component, event, helper);
        component.find("ClusterSpinner").set("v.class" , 'slds-hide');
    },
    pageChange: function(component, event, helper) {
        debugger;
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        var recordSize = event.getParam("recordSize");
        page = direction === "previous" ? (page - 1) : (direction === "first" ? (1) : (direction === "last" ? (component.get("v.pages")) : (direction === "next" ? (page + 1) : (1))));
        
        component.set("v.page",page);
        component.set("v.pageSize",recordSize);
        component.set("v.isNavigate",false);
        helper.getClusters(component, event);
    },
    DetailPageChange: function(component, event, helper) {
        debugger;
        var page = component.get("v.detailPageNo") || 1;
        var direction = event.getParam("direction");
        var recordSize = event.getParam("recordSize");
        page = direction === "previous" ? (page - 1) : (direction === "first" ? (1) : (direction === "last" ? (component.get("v.detailPages")) : (direction === "next" ? (page + 1) : (1))));
        
        component.set("v.detailPageNo",page);
        component.set("v.detailPageSize",recordSize);
        var clusterId = component.get("v.selectedClusterId");
        helper.ShowClusterDetailRecs(component, clusterId, helper);
    },
    // Redirect to Polish Cluster Tab
    goToClusterPolish: function(component, event, helper){
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var action = component.get("c.autoReviewAllClusters");
        action.setParams({
            'strObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValBatchId = response.getReturnValue();
                component.set("v.clusterListPage",false);
                if(returnValBatchId != null && returnValBatchId != '') {
                    helper.pollApex(component, event, helper, returnValBatchId);
                } else {
                    var tabChangeEvent = component.getEvent("tabFocus");
                    tabChangeEvent.setParams({
                        tabName : "polishTab"
                    });
                    tabChangeEvent.fire();
                    component.find("ClusterSpinner").set("v.class" , 'slds-hide');
                }
                
            }
        });
        $A.enqueueAction(action); 
    },
    IgnoreGroup: function(component, event, helper){
        debugger;
        var ignoreGroupId = component.get("v.ClusterInternalId");
        var action = component.get("c.removeIgnoreGroup");
        action.setParams({
            'ignoreGroupId' : ignoreGroupId,
            'strObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnStat = response.getReturnValue();
                if(returnStat == true) {
                    var direction = "Next";
                    component.set("v.iserror",false);
                    component.set("v.searchVal",'');
                    component.set("v.searchKey","");
                    component.set("v.detailPageNo",1);
                    component.set("v.isNavigate",false);
                    
                    var pageSize = component.get("v.pageSize");
                    var pageNo = component.get("v.page");
                    var total = component.get("v.total");
                    var clusterNo = component.get("v.ClusterNo");//component.get("v.currentCLusterNo");
                    var clusterCount = Number(clusterNo);
                    //  clusterCount = Number(clusterNo) + Number(1);
                    if(clusterCount >= pageSize) {
                        component.set("v.clusterList",[]);
                        component.set("v.isNavigate",true);
                        helper.getClusters(component, event, direction);
                    }
                    else {
                        helper.getClusters(component, event, direction);
                        var clusterlist = component.get("v.clusterList");
                        component.set("v.entireClusterList", []);
                        component.set("v.ClusterNo", clusterCount);//component.set("v.currentCLusterNo", clusterCount);
                        //alert('IgnoreGroup: ' + clusterlist.length + ' count: '+ clusterCount + ' ClusterNo: ' +component.get('v.ClusterNo'));
                        var nextClusterId = clusterlist[clusterCount].clusterId;
                        component.set("v.isSaveCluster",true);
                        helper.getClusterNavigate(component,nextClusterId);
                    }
                    alert("L329 controller clusterlist.length >>> "+clusterlist.length);
                } else {
                    var tabChangeEvent = component.getEvent("tabFocus");
                    tabChangeEvent.setParams({
                        tabName : "polishTab"
                    });
                    tabChangeEvent.fire();
                }
            }
        });
        $A.enqueueAction(action); 
    }
})