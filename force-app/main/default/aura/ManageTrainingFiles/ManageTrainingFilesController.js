({
   doInit: function(component, event, helper){
        var action = component.get("c.getCustomSettingValue");
        action.setCallback(this, function(response){
             //alert(response.getReturnValue());
            var state = response.getState();
           // alert(state);
            if(state === "SUCCESS"){
               
                component.set("v.customSettingField", response.getReturnValue());
            } else{
                console.log("Error fecting value");
            }
         });
        $A.enqueueAction(action);
        
    }
  /*doInit : function(component, event, helper) {
        debugger;
        helper.manageFileHelper(component, event,helper);
        window.open(window.location.origin+'/apex/Manage_Training_File','_self');
    },
    deleteAction: function(component, event, helper){
        helper.deleteTrainingFiles(component, event, helper);
    }*/
    
})