({
    doInit : function(component, event, helper) {
        debugger;
        component.find("pgSpinner").set("v.class" , 'slds-show');
        helper.getRecordSize(component, event);
	},
    firstPage : function(component, event, helper) {
        var myEvent = $A.get("e.c:PageChange");
        myEvent.setParams({ "direction": "first"});
        myEvent.setParams({ "recordSize": component.find("recordSize").get("v.value")});
        myEvent.fire();
    },
    previousPage : function(component, event, helper) {
        var myEvent = $A.get("e.c:PageChange");
        myEvent.setParams({ "direction": "previous"});
        myEvent.setParams({ "recordSize": component.find("recordSize").get("v.value")});
        myEvent.fire();
    },
    nextPage : function(component, event, helper) {
        var myEvent = $A.get("e.c:PageChange");
        myEvent.setParams({ "direction": "next"});
        myEvent.setParams({ "recordSize": component.find("recordSize").get("v.value")});
        myEvent.fire();
    },
    lastPage : function(component, event, helper) {
        var myEvent = $A.get("e.c:PageChange");
        myEvent.setParams({ "direction": "last"});
        myEvent.setParams({ "recordSize": component.find("recordSize").get("v.value")});
        myEvent.fire();
	},
    onOffsetChange : function(component, event, helper) {
        debugger;
        component.find("pgSpinner").set("v.class" , 'slds-show');
        var action = component.get('c.UpdatePerPageRecordSize');
        var varRecordSize = component.get("v.pageRecord");
        action.setParams({
            "recordSizeParam" : varRecordSize 
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                component.find("pgSpinner").set("v.class" , 'slds-hide');
                component.find("recordSize").set("v.value", varRecordSize);
                var myEvent = $A.get("e.c:PageChange");
                myEvent.setParams({ "recordSize": varRecordSize});
                myEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})