({
	doInit : function(component, event, helper) {
        debugger;
		var isDedupeStatus = component.get("v.blnIsDedupeStatus");         
        var action1 = component.get("c.getCustomSettingValue");
        action1.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.customSettingField", response.getReturnValue());
            } else{
                console.log("Error fecting value");
            }
        });
        var action = component.get("c.getDedupeStartedStat");                     
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {               
                var returnRes = response.getReturnValue();
                if(returnRes.SmartDD__Dedupe_Started_Stat__c != true) {
                    component.set("v.blnIsDedupeStatus",true);
                    //helper.pollApex(component, event, helper);
                    var actionStat = component.get('c.getDedupeStatusPageStat');
                    actionStat.setCallback(this, function(responseStat) {
                        var stateRes = responseStat.getState();
                        if(stateRes == 'SUCCESS') {
                            var returnResStat = responseStat.getReturnValue();
                            component.set('v.Notification',returnResStat);
                        }
                    });
                    $A.enqueueAction(actionStat);
                    
                } else {
                    component.set("v.blnIsDedupeStatus",false);
                    component.set('v.Notification','');
                }
            }
        });
        $A.enqueueAction(action1);
       
        $A.enqueueAction(action);
	}
})