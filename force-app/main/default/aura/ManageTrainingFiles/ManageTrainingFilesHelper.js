({
    /*manageFileHelper : function(component, event,helper) {
        debugger;
        var action = component.get("c.getTrainingFilesList");
        action.setParams({ 
            'objectName' : 'Lead'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue == '1'){
                    helper.fetchRecords(component, event, helper);
                }else{
                    
                }
            } 
            else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    fetchRecords : function(component, event, helper) {
        debugger;
        var action = component.get("c.fetchTrainingFileDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue.length > 0) {
                    component.set("v.blnTrainingFileAvial",true);
                }else{
                    component.set("v.blnTrainingFileAvial",false);   
                }
            } 
            else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    deleteTrainingFiles : function(component, event, helper) {
        var action = component.get("c.deleteTrainingFiles");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue();
                
            } 
            else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    }*/
    
})