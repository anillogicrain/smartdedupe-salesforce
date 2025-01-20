({
	getRecordSize: function(component,event) { 
		debugger;
        var action = component.get('c.GetPerPageRecordSize');
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var recordSizeVal = returnVal.SmartDD__Per_Page_Record__c;
                if(recordSizeVal != null) {
                    component.set("v.pageRecord",recordSizeVal.toString());
                }
                component.find("pgSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
	}
})