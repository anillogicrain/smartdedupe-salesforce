({
	doInit : function(component, event, helper) {
        component.find("chSpinner").set("v.class" , 'slds-show');
        helper.getRecordSize(component);
	},
    pageChange: function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        var recordSize = event.getParam("recordSize");
        page = direction === "previous" ? (page - 1) : (direction === "first" ? (1) : (direction === "last" ? (component.get("v.pages")) : (direction === "next" ? (page + 1) : "")));
        if(component.get("v.searchActiveParam") == true && (direction == "previous" || direction == "first" || direction == "next" || direction == "last")){
            component.set("v.searchActiveParam", false);
        }
        
        component.set("v.pageTemp",page);
        component.set("v.pageSize",recordSize);
        
        component.find("chSpinner").set("v.class" , 'slds-show');
        helper.getsObjectRecords(component,page);
        //this.sortColumns(component, event, helper);
    },
    onChangeFilterEvent : function(component, event, helper) {
        debugger;
        component.find("chSpinner").set("v.class" , 'slds-show');
        component.set("v.searchKey","");
        helper.getRecordSize(component);
	},
    sortColumns: function(component, event, helper) {
        debugger;
        component.find("chSpinner").set("v.class" , 'slds-show');
        var sortingColName = event.target.getAttribute("data-Id");
		// set current selected header field on selectedTabsort attribute.     
        component.set("v.selectedTabsort", sortingColName);
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event);
    },
    searchKeyChange : function(component, event, helper){
        debugger;
        component.find("chSpinner").set("v.class" , 'slds-show');
        var strSearchKey = component.get("v.searchKey");
        if(strSearchKey != undefined && strSearchKey != null && strSearchKey != '' ){
            helper.findByName(component,event);
        }
        else{
            component.find("chSpinner").set("v.class" , 'slds-hide');
        }
    }
})