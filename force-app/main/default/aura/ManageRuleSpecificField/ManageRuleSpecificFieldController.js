({
    doInit: function(component,event,helper) {
        debugger;
        var selectedMastrRule =  component.find('plstMasterOverrideSpecific').get("v.value");
        component.set("v.masterLabelVal",selectedMastrRule);
        var specificFieldName = component.get('v.SpecificRulePrm.SmartDD__Specific_Field_Name__c');
        var specificFieldRuleName = component.get('v.SpecificRulePrm.SmartDD__Specific_Rule_Name__c');
        if(specificFieldName != null && specificFieldName != '') {
            var setOptionval = true;
            helper.getSpecificFieldRules(component,event,setOptionval);
            if(specificFieldRuleName != null && specificFieldRuleName != '') {
                helper.setSpecificFieldRulesChange(component,event,setOptionval);
            }
        }
    },
    SpecificFieldValChange:  function(component,event,helper) {
        debugger;
        var setOptionval = false;
        helper.getSpecificFieldRules(component,event,setOptionval);
    },
    SpecificFieldRulesChange: function(component,event,helper) {
        debugger;
        var setOptionval = false;
        helper.setSpecificFieldRulesChange(component,event,setOptionval);
    },
    SpecificFieldMasterRulesChange: function(component,event,helper) {
        debugger;
        var selectedMastrRule =  component.find('plstMasterOverrideSpecific').get("v.value");
        component.set("v.masterLabelVal",selectedMastrRule);
        helper.SpecificFieldRulesChangehelper(component,event,helper);
    },
    saveSpecificTmpPopVals: function(component,event,helper) {
        debugger;
        var showSpecificFieldvalPoup = component.get("v.showSpecificFieldPopTxt");
        var txtSpecificTmpPopVal = '';
        if(showSpecificFieldvalPoup == true){
            txtSpecificTmpPopVal = component.get("v.txtSpecificFieldPopVal");
        }
        else{
            txtSpecificTmpPopVal = component.find('SpecificPopDropDownVal').get("v.value");
        }
        if(txtSpecificTmpPopVal != ''){
            var lst = component.get("v.lstSpecificFieldVals");
            if(lst.length < 10){
                component.set('v.showMessageSpecific',false);
                component.set('v.isErrorMessageSpecific',false);
                if(!lst.includes(txtSpecificTmpPopVal)){
                    lst.push(txtSpecificTmpPopVal);
                }
                else{
                    component.set('v.showMessageSpecific',true);
                    component.set('v.isErrorMessageSpecific',true);
                    component.set('v.MessageSpecific', 'Value already present in the list.');
                }
            }
            else {
                component.set('v.showMessageSpecific',true);
                component.set('v.isErrorMessageSpecific',true);
                component.set('v.MessageSpecific', 'It can allow to add up to 10 records only.');
            }
            component.set("v.lstSpecificFieldVals",lst);
            component.set("v.txtSpecificFieldPopVal",'');
        }
    },
    ShowSpecificIgnoreAllPopup: function(component,event,helper) {
        debugger;
        var strSpecificPopFieldVal = component.get("v.strSpecificFinalVal");
        var blnShowTxtInput = component.get("v.showSpecificFieldPopTxt");
        if(strSpecificPopFieldVal != null && strSpecificPopFieldVal != ''){
            if(component.get("v.showSpecificListView") != true){
                if(blnShowTxtInput == true){
                    component.set("v.txtSpecificFieldPopVal",strSpecificPopFieldVal);
                    component.set("v.popValueSpecific",'');
                }
                else{
                    component.set("v.txtSpecificFieldPopVal",'');
                    component.set("v.popValueSpecific",strSpecificPopFieldVal);
                }
            }
            component.set("v.lstSpecificFieldVals",strSpecificPopFieldVal.split(', '));
        }
        component.set("v.blnSpecificFieldValPopup",true);
    },
    CloseSpecificIgnoreAllPopup: function(component,event,helper) {
        debugger;
        component.set("v.txtSpecificFieldPopVal",'');
        component.set("v.popValueSpecific",'');
        component.set("v.lstSpecificFieldVals",[]);
        component.set("v.showMessageSpecific",false);
        component.set("v.isErrorMessageSpecific",false);
        component.set("v.blnSpecificFieldValPopup",false);
    },
    RemoveSpecificRecords: function(component,event,helper) {
        debugger;
        component.set('v.showMessageSpecific',false);
        component.set('v.isErrorMessageSpecific',false);
        var specificValueList = component.get("v.lstSpecificFieldVals");
        var valToRemove = event.target.getAttribute("data-Id");
        for(var i=0;i<specificValueList.length;i++){
            if(specificValueList[i] == valToRemove){
                specificValueList.splice([i],1);
            }
        }
        component.set("v.lstSpecificFieldVals",specificValueList);
    },
    SaveSpecificIgnoreAllVals: function(component,event,helper) {
        debugger;
        component.set('v.showMessageSpecific',false);
        component.set('v.isErrorMessageSpecific',false);
        var showSpecificFieldvalPoup = component.get("v.showSpecificFieldPopTxt");
        var txtSpecificFieldPopVal = '';
        if(showSpecificFieldvalPoup == true){
            txtSpecificFieldPopVal = component.get("v.txtSpecificFieldPopVal");
        }
        else{
            txtSpecificFieldPopVal = component.find('SpecificPopDropDownVal').get("v.value");
        }
        var blnListView = component.get("v.showSpecificListView");
        if(blnListView == true){
            var lst = component.get("v.lstSpecificFieldVals");
            var strSpecifiedFieldVals = lst.join(', ');
            component.set("v.strSpecificFinalVal",strSpecifiedFieldVals);
            component.set("v.SpecificRulePrm.SmartDD__Specific_Popup_Field_Values__c",strSpecifiedFieldVals);
        }
        else{
            component.set("v.strSpecificFinalVal",txtSpecificFieldPopVal);
            component.set("v.SpecificRulePrm.SmartDD__Specific_Popup_Field_Values__c",txtSpecificFieldPopVal);
        }
        component.set("v.txtSpecificFieldPopVal",'');
        component.set("v.popValueSpecific",'');
        component.set("v.blnSpecificFieldValPopup",false);
    },
    addSpecificFieldRow : function(component, event, helper){
        debugger;
        var varPlstObjFields = component.find("plstObjFields").get("v.value");
        var addSpecificRow = component.find("addSpecificRow");
        var RowItemList = component.get("v.SpecificRulelistPrm");
        if(varPlstObjFields != null && varPlstObjFields != '') {
            component.set('v.showMessage',false);
            component.set('v.isErrorMessage',false);
            if(RowItemList.length < 10 ){
                component.set('v.showMessage',false);
                component.set('v.isErrorMessage',false);
                helper.createSpecificFieldRow(component,event,helper);
            }
            else{
                component.set('v.showMessage',true);
                component.set('v.isErrorMessage',true);
                component.set('v.Message', 'You can add upto 10 rows in Specific Field Values section.');
            }
        }
        else {
            component.set('v.showMessage',true);
            component.set('v.isErrorMessage',true);
            component.set('v.Message', 'Please select Field in Specific Field Values section.');
        }
    },
    deleteSpecifiFieldRow : function(component, event, helper){
        debugger;
        var RowItemList = component.get("v.SpecificRulelistPrm");
        var varAddSpecificRow = component.find('addSpecificRow');        
        var self = this;  // safe reference
        var index = event.target.dataset.index;
        var dataid = event.target.dataset.id;
        helper.removeDeletedRow(component,index,dataid);
        if(RowItemList.length < 10 ){
            component.set('v.showMessage',false);
            component.set('v.isErrorMessage',false);
        }
    },
    clearSpecificFieldRow : function(component, event, helper){
        component.find("plstObjFields").set("v.value","");
        component.find("plstSpecificFieldRules").set("v.value","");
        component.find("plstMasterOverrideSpecific").set("v.value","");
        var last  = component.set("v.strSpecificFinalVal", "");
    },
    handleOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    
    OnFieldClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("fieldId"), 'slds-hide');
    },
    OnFieldMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("fieldId"), 'slds-hide');
    },
    OnFieldMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("fieldId"), 'slds-hide');
    },
    
    OnRuleClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("ruleId"), 'slds-hide');
    },
    OnRuleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("ruleId"), 'slds-hide');
    },
    OnRuleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("ruleId"), 'slds-hide');
    },
})