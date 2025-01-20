({
    doInit : function(component, event, helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var interval = setInterval($A.getCallback(function () {
            helper.checkSingleSpinnerProcess(component,event,helper,interval);
        }), 15000); 
        console.log('interval' + interval);
        component.set("v.setSingleIntervalId", interval) ;                 
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
    pageChange: function(component, event, helper) {
        debugger;
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        var recordSize = event.getParam("recordSize");
        page = direction === "previous" ? (page - 1) : (direction === "first" ? (1) : (direction === "last" ? (component.get("v.pages")) : (direction === "next" ? (page + 1) : (1))));
        component.set("v.NavigateDirection",direction);
        component.set("v.page",page);
        component.set("v.pageSize",recordSize);
        helper.getReviewClusterColumns(component, event, helper);
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
                    helper.searchKeyChange(component, event, strSearchKey, helper);
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
            component.set("v.disableReset",true);
            helper.getReviewClusterdetails(component,event,helper);
        }
        else{
            strSearchKey = strSearchKey.trim();
            component.set("v.disableReset",false);
            if(strSearchKey.length < 1){
                //component.set("v.iserror",true);
                //component.set("v.errormsg","Please enter a search string at least 2 characters long.");
                component.set("v.iserror",false);
                component.set("v.searchVal",'');
                component.set("v.searchKey","");
                helper.getReviewClusterdetails(component,event,helper);
            }
            else {
                component.set("v.iserror",false);
                component.set("v.isSearchActive",true);
                component.set("v.searchKey", strSearchKey);
                helper.searchKeyChange(component, event, strSearchKey, helper);
            }
        }
    },
    clearSearch : function(component,event,helper) { 
        debugger;
        component.set("v.iserror",false);
        component.set("v.searchVal",'');
        component.set("v.searchKey","");
        component.set("v.isSaveCluster",false);
        component.set("v.disableReset",true);
        //helper.getReviewClusterdetails(component,event,helper);
        helper.getReviewClusterColumns(component,event,helper);
    },
    SaveYourData : function(component, event, helper) {
        debugger;
        component.set("v.iserror",false);
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        //helper.SaveYourDataHelper(component, event, helper);
        helper.MergeAttachmentHelper(component, event, helper);
    },
    CloseNotesPop: function(component,event,helper) {
        component.set("v.blnPopNotes",false);
    },
    ReDedupe : function(component, event, helper) {
        debugger;
        /**Custom Setting Update Call.*/
        var action = component.get("c.updateClustersCompSta");  
        action.setParams({
            'recordsReDeduped' : component.get('v.total')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {  
                helper.StartReDedupe(component,event,helper);            
            }
        });
        $A.enqueueAction(action);        
        /**END*/
    },
    
    cancelReq : function(component,event,helper) {
        component.set("v.isCreateClusterProgress",false);
        var action = component.get("c.updateLastCreateCluster");      
        action.setCallback(this, function(response){
            var messsage = response.getReturnValue();            
            var state = response.getState();
            if (state == "SUCCESS") { 
                var returnResponse = response.getReturnValue();                                                  
                var actionUpdate = component.get("c.updateprocessStatus"); 
                actionUpdate.setParams({
                    'objectName' : component.get("v.selectedObjectName")                      
                });
                actionUpdate.setCallback(this, function(response){
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
    
    selectCluster : function(component, event, helper) {
        component.set("v.isSaveCluster",true);
        component.set("v.disableReset",false);
        helper.getReviewClusterdetails(component,event,helper);
    },
    createCluster: function(component, event, helper) {
        helper.CreateClusterHelper(component, event, helper);
    } 
})