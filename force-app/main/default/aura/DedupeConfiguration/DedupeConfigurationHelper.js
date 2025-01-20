({
	getUserProfile : function(component,event,helper) {
        debugger;
		var action = component.get('c.getUserProfileName');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var profileName = response.getReturnValue();
                if(profileName != 'System Administrator') {
                    component.set('v.isPermissionTrue',false);
                }
            }
        });
        $A.enqueueAction(action);
	}
})