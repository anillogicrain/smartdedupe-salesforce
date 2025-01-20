({
    doInit : function(component, event, helper) {
        debugger;
        /**Get value of returnValBatchId using custom setting */
        var action = component.get('c.getBatchId');
        action.setParams({
            'strObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var returnValBatchId = returnVal.SmartDD__Batch_Id__c;  
                if(returnValBatchId != null && returnValBatchId != '' && returnValBatchId != 'undefined') {
                    helper.pollApex(component, event, helper, returnValBatchId);
                } else {
                    var initial = true;
                    var direction = '';     
                    component.set("v.masterRecordId","");
                    component.set("v.hideObjectsPrm",true);
                    component.set("v.tempFieldName",[]);
                    component.set("v.tempColumnName",[]);
                    component.set("v.arrTempColumnName",[]);
                    component.set("v.selectedTabsort", "");
                    
                    helper.getClusterRecordList(component, event, initial, direction,helper);
                }          
            }
        });
        $A.enqueueAction(action);
        /**END*/
        
        
    },
    fetchNextClusterRecord : function(component, event, helper) {
        debugger;
        var initial = false;
        var direction = "Next";
        component.set("v.showMasterRecord",false);
        component.set("v.iserror",false);
        component.set("v.masterRecordId","");
        component.set("v.tempFieldName",[]);
        component.set("v.tempColumnName",[]);
        component.set("v.arrTempColumnName",[]);
        component.set("v.selectedTabsort", "");
        helper.getClusterRecordList(component, event, initial, direction); 
    },
    fetchPreviousClusterRecord : function(component, event, helper) {
        debugger;
        var initial = false;
        var direction = "Previous";
        component.set("v.showMasterRecord",false);
        component.set("v.iserror",false);
        component.set("v.masterRecordId","");
        component.set("v.tempFieldName",[]);
        component.set("v.tempColumnName",[]);
        component.set("v.arrTempColumnName",[]);
        component.set("v.selectedTabsort", "");
        helper.getClusterRecordList(component, event, initial, direction); 
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
    saveMasterRecord: function(component, event, helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var fields = component.get("v.fields");
        var masterRecord = component.get("v.arrMasterRecord");
        var masterRecLeadId = component.get("v.masterRecordId");
        var action = component.get("c.postMasterRecord");
        action.setParams({
            'masterRecord': masterRecord.toString(),
            'lstColumnName': component.get('v.tempColumnName'),
            'clusterId': component.get("v.selectedClusterId"),
            'masterRecordId': component.get("v.masterRecordId"),
            'selObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnvalue = response.getReturnValue();
                var initial = false;
                var direction = "";
                //window.open(window.location.origin+'/apex/AttachmentDetails?leadId=' + masterRecLeadId,'_blank');
                component.set("v.masterRecordId","");
                component.set("v.tempFieldName",[]);
                component.set("v.tempColumnName",[]);
                component.set("v.arrTempColumnName",[]);
                component.set("v.selectedTabsort", "");
                helper.getClusterRecordList(component, event, initial, direction); 
                //component.find("ClusterSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    autoPolishCluster: function(component, event, helper) {
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var masterRecord = component.get("v.arrMasterRecord");
        var fields = component.get("v.fields");
        var action = component.get("c.autoPolishRecords");
        action.setParams({
            'fieldstoget': fields.join(),
            'ObjectName': component.get("v.selectedObjectName")
        });        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValBatchId = response.getReturnValue();
                helper.pollApex(component, event, helper, returnValBatchId);
            }
        });
        $A.enqueueAction(action);
    },
    IgnoreGroup: function(component, event, helper){
        debugger;
        var ignoreGroupId = component.get("v.selectedClusterId");
        var action = component.get("c.removeIgnoreGroup");
        action.setParams({
            'ignoreGroupId' : ignoreGroupId,
            'strObjectName': component.get("v.selectedObjectName")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var initial = false;
                var direction = "";
                component.set("v.showMasterRecord",false);
                component.set("v.iserror",false);
                component.set("v.masterRecordId","");
                component.set("v.tempFieldName",[]);
                component.set("v.tempColumnName",[]);
                component.set("v.arrTempColumnName",[]);
                component.set("v.selectedTabsort", "");
                helper.getClusterRecordList(component, event, initial, direction); 
            }
        });
        $A.enqueueAction(action); 
    }
})