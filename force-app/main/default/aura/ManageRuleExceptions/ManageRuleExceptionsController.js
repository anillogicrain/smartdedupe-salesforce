({
    doInit: function(component,event,helper) {
        debugger;
        var excludeRule = component.get('v.ManageRuleExceptionPrm.SmartDD__Exception_Exclude_Rule__c');
        if(excludeRule != null && excludeRule != '') {
            var setOptionval = true;
            helper.excpetionRulesChange(component,event,setOptionval);
        }
    },	
    SelectExceptionChange: function(component,event,helper) {
        debugger;
        var setOptionval = false;
        helper.excpetionRulesChange(component,event,setOptionval);
    },
    exceptionPopupClick :function(component,event,helper) {
        debugger;
        helper.showExceptionPopup(component,event);
    },
    exceptionPopupClose : function(component,event,helper) {
        debugger;
        helper.CloseExceptionPopup(component,event,helper);
    },
    SaveExceptionVals : function(component, event, helper) {
        debugger;
        helper.SaveExceptionPopVals(component,event,helper);
    },
    decreaseByOne : function(component, event, helper) {
        debugger;
        var exceptionRuleName = component.find('plstExceptionRule').get("v.value");
        var intpercentVal = component.get('v.intPercentVal');
        if(exceptionRuleName == 'Group when record has less than X% of the fields with values') {
            if(parseFloat(intpercentVal) > 0.01){
                intpercentVal = parseFloat(intpercentVal) - 0.01;
            }
            else{
                intpercentVal = 0.00;
            }
        }
        else{
            if(intpercentVal > 0){
                intpercentVal = intpercentVal - 1;
            }
        }
        component.set("v.intPercentVal",intpercentVal);
    },
    increaseByOne : function(component, event, helper) {
        debugger;
        var exceptionRuleName = component.find('plstExceptionRule').get("v.value");
        var intpercentVal = component.get('v.intPercentVal');
        if(exceptionRuleName == 'Group when record has less than X% of the fields with values') {
            if(intpercentVal < 100.00){
                intpercentVal = intpercentVal + 0.01;
            }
        }
        else{
            if(intpercentVal < 2000000000){
                intpercentVal = intpercentVal + 1;
            }
        }
        component.set("v.intPercentVal",Math.round(intpercentVal * 100) / 100);
    },
    addExceptionRow : function(component, event, helper) {
        debugger;
        var varPlstExceptionRule = component.find("plstExceptionRule").get("v.value");
        var RowItemList = component.get("v.ManageRuleExceptionListPrm");
        if(varPlstExceptionRule != null && varPlstExceptionRule != '') {
            component.set('v.showMessage',false);
            component.set('v.isErrorMessage',false);
            if( RowItemList.length < 10 ) {
                component.set('v.showMessage',false);
                component.set('v.isErrorMessage',false);
                helper.createExceptionRow(component,event,helper);
            }
            else {
                component.set('v.showMessage',true);
                component.set('v.isErrorMessage',true);
                component.set('v.Message', 'You can add upto 10 rows in Exceptions section.');
            }
        }
        else {
            component.set('v.showMessage',true);
            component.set('v.isErrorMessage',true);
            component.set('v.Message', 'Please select Exclude under Exceptions section.');
        }
    },
    deleteExceptionRow : function(component, event, helper) {
        debugger;
        var RowItemList = component.get("v.ManageRuleExceptionListPrm");
        var self = this;  // safe reference
        var index = event.target.dataset.index;
        var dataid = event.target.dataset.id;
        helper.removeExceptionRow(component,index,dataid);
        var RowItemList = component.get("v.ManageRuleExceptionListPrm");
        if(RowItemList.length < 10 ){
            component.set('v.showMessage',false);
            component.set('v.isErrorMessage',false);
        }
    },
    clearExceptionRow : function(component, event, helper) {
        if(component.find("plstExceptionRule") != undefined) {
            component.find("plstExceptionRule").set("v.value","");
        }
        if(component.find("plstExceptionField") != undefined) {
        	component.find("plstExceptionField").set("v.value","");    
        }
        if(component.find("plstRecordType") != undefined) {
        	component.find("plstRecordType").set("v.value","");    
        }
        component.set('v.strExceptionFinalPopVal', '');
    }
    
})