({
    addRow : function(component, event, helper){
        //Execute the AddRowEvent Lightning Event 
        component.getEvent("AddRowEvent").fire();     
    },
     
    deleteRow : function(component, event, helper){
        //Execute the DeleteRowEvent Lightning Event and pass the deleted Row Index to Event attribute
        component.getEvent("DeleteRowEvent").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
     
})