({
	upDateSelectedTab : function(component, event, selectedtab) {
		var action = component.get('c.UpdateSelectedTabName');
        action.setParams({
            'tabName': selectedtab
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                if(selectedtab == 'polishTab') {            
                    component.set("v.selectedTab","polishTab");
                    component.set("v.showPolishTab",true);
                    component.set("v.showUniqueTab",false);
                    //var result = component.find("polishClusterId");
                    //result.reLoadMethod();
                }
                else if(selectedtab == 'uniqueLeadTab') {            
                    component.set("v.selectedTab","uniqueLeadTab");
                    var result = component.find("uniqueLeadId");
                    component.set("v.showUniqueTab",true);
                    component.set("v.showPolishTab",true);
                    //result.reLoadUniqueMethod();
                }
                    else{
                        component.set("v.selectedTab","detailTab");      
                    }
            }
        });
        $A.enqueueAction(action);
	},
    checkRedeDupeProgress: function(component, event, helper, totalRecordsRededuped) { 
        debugger;
        var totalRecordCounts = totalRecordsRededuped; 
        //alert('totalRecordCounts........................'+totalRecordCounts);
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
		 //alert('timeInterval........................'+timeInterval);
        
        var createClusterInterval = setInterval($A.getCallback(function () {            
            helper.checkRedeDupeBatchProcess(component,event,helper,createClusterInterval,stopProgressbar);                  
        }), timeInterval);
        component.set("v.setClusterIntervalId", createClusterInterval) ; 
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
    checkRedeDupeBatchProcess : function (component,event,helper,createClusterInterval,stopProgressbar){
        debugger;
        var intPercentCount = component.get('v.createClusterpercentCount');               
        /**Get Customsetting field Clusters_Completed_Stat__c value. */
        var action = component.get("c.getDeDupeConfiguration");      
        action.setCallback(this, function(response){
            var errorMesssage = response.getReturnValue();            
            var state = response.getState();
            if (state == "SUCCESS") {  
                var returnResponse = response.getReturnValue();
                var clustersCompletedStat = returnResponse.SmartDD__Clusters_Completed_Stat__c;
                component.set("v.clustersCompletedStat",clustersCompletedStat);
                component.set("v.totalRecDedupe",returnResponse.SmartDD__Total_Records_Deduped__c);           
                
                if(intPercentCount < stopProgressbar && clustersCompletedStat != 'Completed' && intPercentCount < 90) {
                    intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
                } else if(clustersCompletedStat == 'Completed') {  
                    intPercentCount = 100;
                    clearInterval(createClusterInterval);
                    component.set("v.isCreateClusterProgress",false);
                    helper.checkBatchStatus(component, event, helper);
                }
                component.set("v.createClusterpercentCount",intPercentCount); 
                component.set("v.createClusterprogress",intPercentCount);
                
                /**Update Customsetting field Last_Create_Cluster_Progress__c value. */
                var actionUpdate = component.get("c.updateCreateClusterProgress"); 
                actionUpdate.setParams({
                    'lastCreateClusterProgress' : intPercentCount,
                    'clusterEstimatedTime': component.get('v.estimatedTime')                      
                });
                actionUpdate.setCallback(this, function(response){
                    var state = response.getState();
                    if (state == "SUCCESS") {                  
                    }
                });
                $A.enqueueAction(actionUpdate);
            }
        });
        $A.enqueueAction(action);  
    },
    checkBatchStatus : function(component, event, helper) { 
        debugger;
        var interval = setInterval($A.getCallback(function () {
            helper.checkBatchProcess(component,helper,interval);
        }), 15000); 
        component.set("v.setIntervalId", interval) ;   
    },
    checkBatchProcess : function (component,event,helper){
        var action = component.get("c.AsyncApexJobRecords");  
        //component.find("chkObject").set("v.disabled", true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var apexSyncRecord = response.getReturnValue();
                var batchProcessStatus = apexSyncRecord.JobItemStatus;
                var ClustersCompletedStat = apexSyncRecord.ClustersCompletedStat;
                var startDedupeBatchId = apexSyncRecord.startDedupeBatchId;
                if(startDedupeBatchId == undefined) {
                    startDedupeBatchId = '';
                }
                var LastCreateClusterProgress = apexSyncRecord.LastCreateClusterProgress;
                if(batchProcessStatus == 'Completed' && ClustersCompletedStat == 'Completed' && startDedupeBatchId == '' && LastCreateClusterProgress == 100){
                    component.set("v.isShowTabs",true);
                	component.find("Id_spinner").set("v.class" , 'slds-hide');
                    window.clearInterval(component.get("v.setIntervalId"));
                    component.set("v.spinnerMsg",'');
                } else { 
                    if(startDedupeBatchId != '') {
                    	component.set("v.spinnerMsg",'');
                    } else {
                        component.set("v.spinnerMsg",'');
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateFilterData : function(component,event,helper) {
        //alert('test1: '+component.get("v.selectedStatus"));
        var actionMasterCluster = component.get("c.updateDedupeObjectName");  
        actionMasterCluster.setParams({
            "selectedObjectname" : component.get("v.selectedStatus")
        });
        actionMasterCluster.setCallback(this, function(responseMasterCluster){
            var stateMasterCluster = responseMasterCluster.getState(); 
            if(stateMasterCluster == "SUCCESS") {
                
            }
        });
        $A.enqueueAction(actionMasterCluster);
    },
    manageRededupeBatchStatus : function(component, event, helper, batchId) { 
        var interval = setInterval($A.getCallback(function () {
            helper.checkRededupeBatchProcess(component,event,helper,interval,batchId);
        }), 5000); 
        component.set("v.setCreateCLusterIntervalId", interval) ;   
    },
    checkRededupeBatchProcess : function (component,event,helper,interval,batchId){
        debugger;
        var action = component.get("c.rededupeBatchStatus");  
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
                    } else {
                        component.set("v.isDataProgress",true);
                        component.find("Id_spinner").set("v.class" , 'slds-hide');
                        component.set("v.progress", statPercentVal);
                    }
                } else {
                    var actionCheckAPI = component.get("c.CheckApiStatus");
                    actionCheckAPI.setCallback(this, function(response){
                        var state = response.getState();
                        if(state == "SUCCESS"){
                            var apistatus = response.getReturnValue();
                            component.set("v.isDataProgress",false); 
                            if(apistatus == '1'){
                                window.clearInterval(component.get("v.setCreateCLusterIntervalId"));
                                component.set("v.isDataProgress",false);
                                component.set("v.progress",0);
                                component.set("v.percentCount",0);
                                component.find("Id_spinner").set("v.class" , 'slds-hide');
                                this.updateFilterData(component,event,helper);
                                component.set("v.isCreateClusterProgress",true);
                                this.pollCreateCluster(component,event,helper);
                                //window.open(window.location.origin+'/apex/Dedupe_Status','_blank');
                            } else {
                                component.find("Id_spinner").set("v.class" , 'slds-hide');
                                component.set('v.showInformation',true);
                                var homePageNewslabel = $A.get("$Label.c.AdminErrorMessage");
                                //component.set('v.Notification', 'Server has stopped responding, please contact with the administrator: anil@logicrain.com');
                            	component.set('v.Notification', homePageNewslabel);
                                //window.clearInterval(component.get("v.setCreateCLusterIntervalId"));
                            }
                        }
                    });
                    $A.enqueueAction(actionCheckAPI);
                }
            }
        });
        $A.enqueueAction(action);
    },
    pollCreateCluster : function(component, event, helper) { 
        var totalRecordCounts = component.get('v.total'); 
        //alert('totalRecordCounts........................'+totalRecordCounts);
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
       // alert('timeInterval........................'+timeInterval);
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
            }
        });
        $A.enqueueAction(action);        
        /**END*/
        
        var clustersCompletedStat = component.get("v.clustersCompletedStat");
        if(intPercentCount < stopProgressbar && clustersCompletedStat != 'Completed' && intPercentCount < 90) {
            intPercentCount = intPercentCount + Math.floor((Math.random() * 5) + 1);
        }else if(clustersCompletedStat == 'Completed') {  
            intPercentCount =100;
            clearInterval(createClusterInterval);
            component.set("v.isCreateClusterProgress",false);
            helper.checkBatchStatus(component, event, helper);         
        }
        component.set("v.createClusterpercentCount",intPercentCount); 
        component.set("v.createClusterprogress",intPercentCount);
        
        /**Update Customsetting field Last_Create_Cluster_Progress__c value. */
        var actionUpdate = component.get("c.updateCreateClusterProgress"); 
        actionUpdate.setParams({
            'lastCreateClusterProgress' : intPercentCount                      
        });
        actionUpdate.setCallback(this, function(response){
            var errorMesssage = response.getReturnValue();            
            var state = response.getState();
            if (state == "SUCCESS") {                  
            }
        });
        $A.enqueueAction(actionUpdate);    
    },
    getLastSelectedTabName: function(component, event, helper) { 
        debugger;
        var action = component.get('c.GetSelectedTabName');
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var selectedtab = response.getReturnValue();
                if(selectedtab == 'polishTab') {            
                    component.set("v.selectedTab","polishTab");
                    component.set("v.showPolishTab",true);
                    component.set("v.showUniqueTab",false);
                    //var result = component.find("polishClusterId");
                    //result.reLoadMethod();
                }
                else if(selectedtab == 'uniqueLeadTab') {            
                    component.set("v.selectedTab","uniqueLeadTab");
                    var result = component.find("uniqueLeadId");
                    component.set("v.showUniqueTab",true);
                    component.set("v.showPolishTab",true);
                    //result.reLoadUniqueMethod();
                }
                    else{
                        component.set("v.selectedTab","detailTab");      
                    }
            }
        });
        $A.enqueueAction(action);
    }
})