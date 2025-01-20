({
    pollApex : function(component, event, helper) { 
        var interval = setInterval($A.getCallback(function () {
            helper.getDedupeStatus(component,helper,interval);
        }), 5000);
        component.set("v.setIntervalId", interval) ;
    },
	getDedupeStatus : function(component, event, helper) {
        var actionStat = component.get('c.getDedupeStatusPageStat');
        alert(actionStat);
        actionStat.setParams({
            "blnIsJavaClusterCreated": component.get('v.isJavaClusterCreated')
        });
        actionStat.setCallback(this, function(responseStat) {
            var stateRes = responseStat.getState();
            alert(stateRes,'Before');
            if(stateRes == 'SUCCESS') {
                alert(stateRes,'After');
                var returnResStat = responseStat.getReturnValue();
                console.log('##returnResStat',returnResStat);
                if(returnResStat != 'Completed' && returnResStat != 'Java Clusters Created') {
                    component.set('v.isJavaClusterCreated',false);
                    var rndNumber = Math.floor(Math.random() * (40 - 10) + 10);
                    if(component.get("v.percentCount") == 0) {
                        component.set("v.percentCount",rndNumber)
                    }
                    var percentCountProgress = component.get("v.percentCount");
                    if(percentCountProgress < 90) {
                        var leastNumber = Math.floor(Math.random() * 4 + 1);
                        percentCountProgress = Number(percentCountProgress) + Number(leastNumber);
                        component.set("v.percentCount",percentCountProgress);
                        component.set("v.progress", percentCountProgress);
                    } else{
                        component.find("Id_spinner").set("v.class" , 'slds-show');
                    } 
                } else if(returnResStat == 'Java Clusters Created'){
                    component.set('v.isJavaClusterCreated',true);
                } else {
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    component.set("v.percentCount",100);
                    component.set("v.progress", 100);
                    window.clearInterval(component.get("v.setIntervalId"));
                }
                //component.set('v.Notification',returnResStat);
            }
        });
        $A.enqueueAction(actionStat);
	}
})