({
	doInit : function(component, event, helper) {
		//let urlString = window.location.origin;
		let urlString = window.location.protocol + '//' + window.location.hostname;
        component.set('v.baseUrl',urlString);
    },
    redirectToRSS : function(component, event, helper) {
        window.open(window.location.origin+'/0rp','_blank'); 
    },
    onNext : function(component, event, helper) {
        if(component.getEvent("tabFocus") != undefined) {
            var tabChangeEvent = component.getEvent("tabFocus");
            tabChangeEvent.setParams({
                tabName : "detailTab"
            });
            tabChangeEvent.fire();        
        }
    }
    
    
})