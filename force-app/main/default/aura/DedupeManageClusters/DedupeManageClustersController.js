({
    doInit : function(component, event, helper) {
        debugger;
        component.find("Id_spinner").set("v.class" , 'slds-show');
        component.set("v.isShowTabs",false);
        var dedupeObj;
        // To Get the last processed object.
        var deDupeObjectName = component.get('c.deDupeObjectName');
        deDupeObjectName.setCallback(this, function(response){
            var stateDedObjName = response.getState(); 
            if(stateDedObjName === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                dedupeObj = response.getReturnValue();
                component.set("v.selectedStatus",returnResponse);
                // To Get the list of objects
                var actionObjList = component.get("c.getSyncedObjList");
                actionObjList.setCallback(this, function(a) {
                    var stateObjList = a.getState();
                    if(stateObjList === "SUCCESS") {
                        var result = a.getReturnValue();
                        var options = [];
                        options.push({value:dedupeObj,label:dedupeObj,Selected:dedupeObj});
                        for(var key in result){      
                            if(result[key].split(',')[0] != dedupeObj){
                                options.push({value: result[key].split(',')[0], label: result[key].split(',')[0]});
                            }
                        }
                        component.set("v.syncedObjList", options);
                        var actionDedupeConfig = component.get("c.getDeDupeConfiguration");      
                        actionDedupeConfig.setCallback(this, function(response){
                            var messsage = response.getReturnValue();            
                            var stateDedupeConfig = response.getState();
                            if (stateDedupeConfig == "SUCCESS") {  
                                var returnConfigResponse = response.getReturnValue(); 
                                component.set('v.total',returnConfigResponse.SmartDD__Total_Records_ReDeduped__c);
                                if(returnConfigResponse.SmartDD__Cluster_Estimated_Time__c != 0) {
                                	component.set('v.estimatedTime',returnConfigResponse.SmartDD__Cluster_Estimated_Time__c);    
                                } else {
                                    helper.getEstimatedTime(component,event,helper);
                                }
                                if(returnConfigResponse.SmartDD__Start_Dedupe_Batch_Id__c != '' && returnConfigResponse.SmartDD__Start_Dedupe_Batch_Id__c != null){
                                    //alert('11');
                                    helper.manageRededupeBatchStatus(component, event, helper, returnConfigResponse.SmartDD__Start_Dedupe_Batch_Id__c);
                                } else if(returnConfigResponse.SmartDD__Clusters_Completed_Stat__c != '' && returnConfigResponse.SmartDD__Clusters_Completed_Stat__c != 'Completed' && returnConfigResponse.SmartDD__Last_Create_Cluster_Progress__c < 100) {
                                    //alert('22');
                                    debugger;
                                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                                    component.set("v.isCreateClusterProgress",true);
                                    var intPercentCount = returnConfigResponse.SmartDD__Last_Create_Cluster_Progress__c;
                                    intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
                                    //alert('intPercentCount: '+ intPercentCount);
                                    component.set("v.createClusterpercentCount",intPercentCount); 
                                    component.set("v.createClusterprogress",intPercentCount); 
                                    helper.checkRedeDupeProgress(component, event, helper, returnConfigResponse.SmartDD__Total_Records_ReDeduped__c); 
                                } else {
                                    //alert('33');
                                    helper.checkBatchStatus(component, event, helper);
                                }               
                            }
                        });
                        $A.enqueueAction(actionDedupeConfig); 
                    }
                });
                $A.enqueueAction(actionObjList);
            }
        });
        $A.enqueueAction(deDupeObjectName);
    },
    cancelReq : function(component,event,helper) {
        //alert('INSIDE CANCELLED.....................');
        component.set("v.isCreateClusterProgress",false);
        var action = component.get("c.updateLastCreateCluster");      
        action.setCallback(this, function(response){
            var messsage = response.getReturnValue();            
            var state = response.getState();
            if (state == "SUCCESS") { 
                var returnResponse = response.getReturnValue();                                                  
                var actionUpdate = component.get("c.updateprocessStatus"); 
                actionUpdate.setParams({
                    'objectName' : component.get('v.selectedStatus')                      
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
    popObjResult: function(component, event, helper) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        component.set("v.isShowTabs",false);
       	var objectName = component.find('viewObjectfilter').get('v.value');
        component.set("v.isShowTabs",true);
        component.find("Id_spinner").set("v.class" , 'slds-hide');
        component.set('v.selectedStatus',objectName);
        /*
        var action = component.get("c.getSyncedObjList");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state === "SUCCESS") {
                var result = a.getReturnValue();
                var options = [];
                options.push({value:objectName,label:objectName,Selected:objectName});
                for(var key in result){                   
                    if(result[key].split(',')[0] != objectName){
                        options.push({value: result[key].split(',')[0], label: result[key].split(',')[0]});
                    }
                }
                component.set("v.syncedObjList", options);
            }
        });
        $A.enqueueAction(action);
        */
    },
    onChangeTabFocus : function(component, event, helper) {
        debugger;
        var selectedtab = event.getParam("tabName");       
        if(selectedtab == 'polishTab') {            
            component.set("v.selectedTab","polishTab");
            component.set("v.showPolishTab",true);
            component.set("v.showUniqueTab",false);
            component.set("v.polistabactive",false);
            component.set("v.uniquetabactive",true);
            //var result = component.find("polishClusterId");
            //result.reLoadMethod();
        }
        else if(selectedtab == 'uniqueLeadTab') {            
            component.set("v.selectedTab","uniqueLeadTab");
            var result = component.find("uniqueLeadId");
            component.set("v.showUniqueTab",true);
            component.set("v.showPolishTab",true);
            component.set("v.polistabactive",true);
            component.set("v.uniquetabactive",false);
            //result.reLoadUniqueMethod();
        }
            else {
                component.set("v.selectedTab","detailTab");      
            }
    },
    manageClusterAction: function(component, event, helper) {
        debugger;
        var manageClusterTab = component.find("ManageClusterId");
        manageClusterTab.showClusterList();
    },
    polishClusterAction: function(component, event, helper) {
        debugger;
        var polishClusterTab = component.find("polishClusterId");
        polishClusterTab.showPolishClusterList();
    },
    uniqueClusterAction: function(component, event, helper) {
        debugger;
        var uniqueClusterTab = component.find("uniqueLeadId");
        uniqueClusterTab.showUniqueClusterList();
    },
    togglePopup: function(component, event, helper) {
        component.set("v.isPopupVisible", true);
    },
        
    closePopup: function(component, event, helper) {
        component.set("v.isPopupVisible", false);
    }
	
})