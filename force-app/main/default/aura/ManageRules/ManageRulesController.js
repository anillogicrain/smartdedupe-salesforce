({
    doInit: function(component,event,helper) {
        debugger;
        
        var selObject = component.find('plstObject').set("v.value","Lead");
        helper.objectChangeSelectHelper(component,event,helper);
        helper.doinitHelper(component,event,helper);
        component.set("v.showMstrHighValue",false);
        var action = component.get('c.getMasterRecordSelection');
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS'){
                var returnVal = response.getReturnValue();
                component.set("v.masterRecordDropDown",returnVal);
            }
        });
        $A.enqueueAction(action);
        
        var actionExceptions = component.get('c.getManageRuleExceptions');
        actionExceptions.setCallback(this,function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValue = response.getReturnValue();
                component.set('v.exceptioRulesDropDown',returnValue);
            }
        });
        $A.enqueueAction(actionExceptions);
    },
    objectChangeSelect: function(component,event,helper) {
        debugger;
        helper.objectChangeSelectHelper(component,event,helper);
    },
    priorityGivenFieldOption: function(component,event,helper) {
        var strMstrPopFieldVal = component.get("v.strMstrPopFieldVal");
        if(strMstrPopFieldVal != null && strMstrPopFieldVal != ''){
            component.set("v.lstPriorityPopupVals",strMstrPopFieldVal.split(', '));
        }
        component.set("v.blnPriorityGivenFieldPopup",true);
    },
    RemoveMasterPopRecords: function(component,event,helper) {
        debugger;
        component.set('v.showMessageMasterPri',false);
        component.set('v.isErrorMessageMasterPri',false);
        var masterPopValueList = component.get("v.lstPriorityPopupVals");
        var valToRemove = event.target.getAttribute("data-Id");
        for(var i=0;i<masterPopValueList.length;i++){
            if(masterPopValueList[i] == valToRemove){
                masterPopValueList.splice([i],1);
            }
        }
        component.set("v.lstPriorityPopupVals",masterPopValueList);
    },
    closePriorityGivenFieldPopup: function(component,event,helper) {
        component.set("v.txtPriorityPopupVal",'');
        component.set("v.lstPriorityPopupVals",[]);
        component.set('v.showMessageMasterPri',false);
        component.set('v.isErrorMessageMasterPri',false);
        component.set("v.blnPriorityGivenFieldPopup",false);
    },
    savePriorityPopupVals: function(component,event,helper) {
        debugger;
        var txtPriorityPopupVal = component.get("v.txtPriorityPopupVal");
        if(txtPriorityPopupVal != undefined && txtPriorityPopupVal != null && txtPriorityPopupVal != ''){
            var lst = component.get("v.lstPriorityPopupVals");
            if(lst.length < 10){
                component.set('v.showMessageMasterPri',false);
                component.set('v.isErrorMessageMasterPri',false);
                if(!lst.includes(txtPriorityPopupVal)){
                    lst.push(txtPriorityPopupVal);
                }
                else{
                    component.set('v.showMessageMasterPri',true);
                    component.set('v.isErrorMessageMasterPri',true);
                    component.set('v.MessageMasterPri', 'Value already present in the list.');
                }
            }
            else {
                component.set('v.showMessageMasterPri',true);
                component.set('v.isErrorMessageMasterPri',true);
                component.set('v.MessageMasterPri', 'It can allow to add up to 10 records only.');
            }
            component.set("v.lstPriorityPopupVals",lst);
            component.set("v.txtPriorityPopupVal",'');
        }
    },
    savePriorityFieldvals: function(component,event,helper) {
        debugger;
        var lst = component.get("v.lstPriorityPopupVals");
        var strPriorityVals = lst.join(', ');
        component.set("v.strMstrPopFieldVal",strPriorityVals);
        component.set("v.txtPriorityPopupVal",'');
        component.set("v.lstPriorityPopupVals",[]);
        component.set('v.showMessageMasterPri',false);
        component.set('v.isErrorMessageMasterPri',false);
        component.set("v.blnPriorityGivenFieldPopup",false);
    },
    
    RemoveMasterSpecificPopRec: function(component,event,helper) {
        debugger;
        component.set('v.showMessageMasterSpecific',false);
        component.set('v.isErrorMessageMasterSpecific',false);
        var masterPopValueList = component.get("v.lstNotInSpeciPopupVals");
        var valToRemove = event.target.getAttribute("data-Id");
        for(var i=0;i<masterPopValueList.length;i++){
            if(masterPopValueList[i] == valToRemove){
                masterPopValueList.splice([i],1);
            }
        }
        component.set("v.lstNotInSpeciPopupVals",masterPopValueList);
    },
    recNotInSpecifiedLstOption: function(component,event,helper) {
        var strMstrPopFieldVal = component.get("v.strMstrPopFieldVal");
        if(strMstrPopFieldVal != null && strMstrPopFieldVal != ''){
            component.set("v.lstNotInSpeciPopupVals",strMstrPopFieldVal.split(', '));
        }
        component.set("v.blnRecNotInSpecifiedLstPopup",true);
    },
    closeNotInSpecifiedLstPopup: function(component,event,helper) {
        component.set("v.txtMstrNotInSpecifiedLstVal",'');
        component.set("v.lstNotInSpeciPopupVals",[]);
        component.set('v.showMessageMasterSpecific',false);
        component.set('v.isErrorMessageMasterSpecific',false);
        component.set("v.blnRecNotInSpecifiedLstPopup",false);
    },
    saveNotInSpeciPopupVals: function(component,event,helper) {
        debugger;
        var txtMstrNotInSpecifiedLstVal = component.get("v.txtMstrNotInSpecifiedLstVal");
        if(txtMstrNotInSpecifiedLstVal != undefined && txtMstrNotInSpecifiedLstVal != null && txtMstrNotInSpecifiedLstVal != ''){
            var lst = component.get("v.lstNotInSpeciPopupVals");
            if(lst.length < 10){
                component.set('v.showMessageMasterSpecific',false);
                component.set('v.isErrorMessageMasterSpecific',false);
                if(!lst.includes(txtMstrNotInSpecifiedLstVal)){
                    lst.push(txtMstrNotInSpecifiedLstVal);
                }
                else{
                    component.set('v.showMessageMasterSpecific',true);
                    component.set('v.isErrorMessageMasterSpecific',true);
                    component.set('v.MessageMasterSpecific', 'Value already present in the list.');
                }
            }
            else {
                component.set('v.showMessageMasterSpecific',true);
                component.set('v.isErrorMessageMasterSpecific',true);
                component.set('v.MessageMasterSpecific', 'It can allow to add up to 10 records only.');
            }
            component.set("v.lstNotInSpeciPopupVals",lst);
            component.set("v.txtMstrNotInSpecifiedLstVal",'');
        }
    },
    saveNotInSpeciFieldvals: function(component,event,helper) {
        debugger;
        var lst = component.get("v.lstNotInSpeciPopupVals");
        var strNotInSpecifiedLstVals = lst.join(', ');
        component.set("v.strMstrPopFieldVal",strNotInSpecifiedLstVals);
        component.set("v.txtMstrNotInSpecifiedLstVal",'');
        component.set("v.lstNotInSpeciPopupVals",[]);
        component.set('v.showMessageMasterSpecific',false);
        component.set('v.isErrorMessageMasterSpecific',false);
        component.set("v.blnRecNotInSpecifiedLstPopup",false);
    },
    saveMergeRule: function(component,event,helper) {
        component.set("v.defaultDisabled",false);
        debugger;
        var selObject = component.find('plstObject').get("v.value");
        var varMergeRuleName = component.find("MergeRuleName").get("v.value");
        var varConfidenceScore = '';
        if(component.find("ltstConfidencePt") != undefined) {
            varConfidenceScore = component.find("ltstConfidencePt").get("v.value");
        }
        
        if(varMergeRuleName != null && varMergeRuleName != ''){
            var varDefaultPriority = component.find("plstDefaultSelectionPriority").get("v.value");
            if(varDefaultPriority != null && varDefaultPriority != ''){
                var selMasterRecord = component.find('plstmasterRecord').get("v.value");
                var selFieldAPIName = '';
                if(component.find('plstmasterRecordFields') != undefined){
                    selFieldAPIName = component.find('plstmasterRecordFields').get("v.value");
                }
                var popMasterFieldVals = component.get("v.strMstrPopFieldVal");
                var selMasterOrderBy = component.find('plstMasterOrderBy').get("v.value");
                var selDefaultSelectionPriority = component.find('plstDefaultSelectionPriority').get("v.value");
                var selOverrideMaster = component.find('plstOverrideMaster').get("v.value");
                var lstSpecificFieldValues = component.get("v.SpecificRulelist");
                var lstExceptions = component.get("v.ManageRuleExceptionList");
                var varMasterRecordId = component.get('v.MasterRec.Id');
                var chkEachFieldValues = false; 
                if(component.find('chkEachFieldValues') != undefined && component.find('chkEachFieldValues').get("v.checked") != null && 
                   component.find('chkEachFieldValues').get("v.checked") != ''){
                    chkEachFieldValues = component.find('chkEachFieldValues').get("v.checked");
                }
                var chkIfMasterUpdated = false;
                if(component.find('chkIfMasterUpdated') != undefined && component.find('chkIfMasterUpdated').get("v.checked") != null &&
                   component.find('chkIfMasterUpdated').get("v.checked") != '') {
                    chkIfMasterUpdated = component.find('chkIfMasterUpdated').get("v.checked");
                }
                component.find("MergeRecSpinner").set("v.class" , 'slds-show');
                var action = component.get('c.saveMergeRuleFilters');
                action.setParams({ 
                    "selObject" : selObject,
                    "MergeRuleName" : varMergeRuleName,
                    "ConfidenceScore": varConfidenceScore,
                    "MasterRecord" : selMasterRecord,
                    "MasterRecordId" : varMasterRecordId,
                    "ObjFieldAPIName" : selFieldAPIName,
                    "MasterPopFieldVals" : popMasterFieldVals,
                    "MasterOrderBy" : selMasterOrderBy,
                    "DefaultSelectionPriority" : selDefaultSelectionPriority,
                    //"DefaultEachFieldVal" : chkEachFieldValues,
                    //"DefaultMasterUpdated" : chkIfMasterUpdated,
                    "OverrideMaster" : selOverrideMaster,
                    "SpecificFieldList" : lstSpecificFieldValues,
                    "ExceptionsList" : lstExceptions,
                });
                action.setCallback(this,function(response){
                    var state = response.getState(); 
                    var returnvalue = response.getReturnValue();
                    var error = '';
                    error = returnvalue[0];
                    
                    if(state == 'SUCCESS'){
                        if(error == ''){
                            component.set("v.showMergeSettings",false);
                            component.set("v.showMasterRecordDetails",false);
                            component.set("v.detailespage",true);
                            component.set('v.showMessage',false);
                            component.set('v.isErrorMessage',false);
                            helper.getRulesList(component,event,helper);
                            component.set("v.MasterRec",[]);
                            component.set("v.strMstrPopFieldVal",'');
                            helper.masterRecordSelectChangeHelper(component,event,false);
                            component.set("v.SpecificRulelist",[]);
                            component.set("v.ManageRuleExceptionList",[]);
                            component.set('v.disbledelebtn',true);
                            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
                        }
                        else{
                            component.set('v.showMessage',true);
                            component.set('v.isErrorMessage',true);
                            component.set('v.Message', error);
                            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
                        }
                    }
                });
                $A.enqueueAction(action);
            }
            else{
                component.set('v.showMessage',true);
                component.set('v.isErrorMessage',true);
                component.set('v.Message', 'Please enter Field Value Selection');
            }
        }
        else{
            component.set('v.showMessage',true);
            component.set('v.isErrorMessage',true);
            component.set('v.Message', 'Please enter Merge Rule Name');
        }
    },
    masterRecordSelectChange: function(component,event,helper) {
        helper.masterRecordSelectChangeHelper(component,event,false);
        //helper.chkEachFieldValChange(component,event,helper);
        helper.getExceptionFields(component,event,helper);
    },
    /*changeEachFieldValChk: function(component,event,helper) {
        debugger;
        helper.chkEachFieldValChange(component,event,helper);
    },*/
    deleteSlctd : function(component,event,helper) {
        debugger;
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        var selctedRec = component.get("v.deleteRecordId");
        helper.deleteSelected(component,event,selctedRec);
        component.set("v.blnDeletePopup",false);
        component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
    },
    showDeletePopup : function(component,event,helper) {
        debugger;
        
        var selctedRec = event.target.dataset.id;
        component.set("v.deleteRecordId",selctedRec);
        component.set("v.blnDeletePopup",true);
    },
    CloseDeletePopup: function(component,event,helper) {
        component.set("v.blnDeletePopup",false);
    },
    editSlctd : function(component,event,helper) {
        debugger;
        component.set("v.defaultDisabled",true);
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        var selctedRec = event.target.dataset.id;
        component.set("v.showMergeSettings",true);
        component.set("v.detailespage",false);
        
        var action = component.get("c.editMasterRecord");
        action.setParams({
            "MasterRecid" : selctedRec
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var masterRecords =  response.getReturnValue();
                var specificRecordSize = masterRecords.lstSpecificValCriterias;
                var exceptionRecordSize = masterRecords.lstExceptionRules;
                component.set("v.MasterRec",masterRecords.objMasterRecords);
                var masterRecordType = component.get("v.MasterRec").SmartDD__Master_Record_Type__c;
                helper.masterRecordSelectChangeHelper(component,event,true);
                //helper.chkEachFieldValChange(component,event,helper);
                component.set("v.strMstrPopFieldVal",component.get("v.MasterRec.SmartDD__Master_Popup_Field_Values__c"));
                
                if(specificRecordSize.length == 0){
                    component.set("v.SpecificRulelist",{'sobjectType':'SmartDD__ManageRule_Specific_FieldVal__c',                                                                             
                                                        'SmartDD__Specific_Field_Name__c':'',                
                                                        'SmartDD__Specific_Rule_Name__c':'',
                                                        'SmartDD__Specific_Master_Override_Type__c':'Override Master When Blank',
                                                        'SmartDD__Specific_Popup_Field_Values__c':''});
                }
                else{
                    component.set("v.SpecificRulelist",masterRecords.lstSpecificValCriterias);
                }
                
                if(exceptionRecordSize.length == 0){
                    component.set("v.ManageRuleExceptionList",{'sobjectType':'SmartDD__ManageRule_Exception__c',                                                                             
                                                               'SmartDD__Exception_Exclude_Rule__c':'',                
                                                               'SmartDD__Exception_Field_Name__c':'',
                                                               'SmartDD__Run_Exception_Rule__c':'',
                                                               'SmartDD__Exception_Popup_Field_Values__c':''});
                    
                }
                else{
                    component.set("v.ManageRuleExceptionList",masterRecords.lstExceptionRules);
                }
            }
        }); 
        $A.enqueueAction(action);
        helper.getExceptionFields(component,event,helper);
    },
    createMergeRule: function(component,event,helper) {
        component.set("v.defaultDisabled",true);
        component.set("v.showMergeSettings",true);
        component.set("v.detailespage",false);
        component.set("v.MasterRec",[]);
        component.set("v.showMessage",false);
        component.set("v.isErrorMessage",false);
        component.set("v.strMstrPopFieldVal",'');
        helper.masterRecordSelectChangeHelper(component,event,false);
        component.set("v.SpecificRulelist",[]);
        component.set("v.ManageRuleExceptionList",[]);
        helper.createSpecificFieldRow(component,event,helper);
        helper.createExceptionRow(component,event,helper);
    },
    cancelMergeRule: function(component,event,helper) {
        debugger;
        component.set("v.defaultDisabled",false);
        component.set("v.MasterRec",[]);
        component.set("v.strMstrPopFieldVal",'');
        helper.masterRecordSelectChangeHelper(component,event,false);
        component.set("v.SpecificRulelist",[]);
        component.set("v.ManageRuleExceptionList",[]);
        component.set("v.showMergeSettings",false);
        component.set("v.showMasterRecordDetails",false);
        component.set("v.detailespage",true);
        component.set('v.disbledelebtn',true);
        component.set('v.showMessage',false);
        component.set('v.isErrorMessage',false);
    },
    selectAll: function(component,event, helper){
        var slctCheck = event.getSource().get("v.value");
        var getCheckAllId = component.find("cboxRow");
        if(getCheckAllId != undefined) {
            for (var i = 0; i < getCheckAllId.length; i++) {
                component.find("cboxRow")[i].set("v.value", slctCheck);
                component.set('v.disbledelebtn',!slctCheck);
            }
        }
    },
    
    changeSelectAll:function(component,event, helper){
        debugger;
        var getCheckAllId = component.find("cboxRow");
        if(getCheckAllId != undefined){
            var cboxchekcbln = true;
            var cboxchekcblnfalse = true;
            for (var i = 0; i < getCheckAllId.length; i++) {
                if(getCheckAllId[i].get("v.value") == false){
                    cboxchekcbln = false
                    break;
                }else{
                    cboxchekcblnfalse = false; 
                }
            }
            var count = 0;
            for (var i = 0; i < getCheckAllId.length; i++) {
                if(getCheckAllId[i].get("v.value") == true){
                    count++;
                }
            }
            if(count > 0) {
                component.set('v.disbledelebtn',false);
            }
            else {
                component.set('v.disbledelebtn',true);
            }
            component.find("cbox").set("v.value", cboxchekcbln);
        }
    },
    deletecheckboxSlctd : function(component,event,helper) {
        debugger;
        var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        for (var i = 0; i < getCheckAllId.length; i++) {
            if(getCheckAllId[i].get("v.value") == true ){
                selctedRec.push(getCheckAllId[i].get("v.text")); 
            }
        }
        helper.deleteSelected(component,event,selctedRec);
    },
    showCheckboxdeprecPopoup : function(component,event,helper) {
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        component.set("v.isOpenPopUp",true);
        component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
    },
    CloseCheckboxdeprecPopoup: function(component,event,helper) {
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        component.set("v.isOpenPopUp",false);
        component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
    },
    StatusChange: function(component,event,helper) {
        debugger;
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        var statId = event.target.dataset.id;   
        component.set('v.disbledelebtn',true);
        helper.updateStatus(component,event,helper,statId);
    },
    checkPriority : function(component,event,helper) {
        debugger;
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        var recordId = event.getSource().get("v.name");
        var indexvar = event.getSource().get("v.value");
        var mastermergeRules = component.get("v.mastermergeRules");
        if(indexvar == ""){ 
            component.set('v.showMessage',true);
            component.set('v.isErrorMessage',true);
            component.set('v.Message', 'Please enter Priority');
        }
        /*if(indexvar != "" && mastermergeRules.length < indexvar){
               alert('Please add valid Priority');
        }*/
        
        var action = component.get("c.SwapPriority");
        action.setParams({
            "selectedRecordId" : recordId,
            "selectedPrio" : indexvar
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS'){
                component.set('v.showMessage',false);
            	component.set('v.isErrorMessage',false);
                helper.objectChangeSelectHelper(component,event,helper);
                //component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    handleOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("divHelp"), 'slds-hide');
    },
    handleOnClicks : function(component, event, helper) {
        $A.util.toggleClass(component.find("divHelps"), 'slds-hide');
    },
    handleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseLeaves : function(component, event, helper) {
        $A.util.addClass(component.find("divHelps"), 'slds-hide');
    },
    handleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseEnters : function(component, event, helper) {
        $A.util.removeClass(component.find("divHelps"), 'slds-hide');
    },
    masterRecFieldOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("masterRecField"), 'slds-hide');
    },
    masterRecFieldMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("masterRecField"), 'slds-hide');
    },
    masterRecFieldMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("masterRecField"), 'slds-hide');
    },
    
    masterRecSortOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("masterRecSort"), 'slds-hide');
    },
    masterRecSortMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("masterRecSort"), 'slds-hide');
    },
    masterRecSortMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("masterRecSort"), 'slds-hide');
    },
    
    fieldValOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("fieldVal"), 'slds-hide');
    },
    fieldValMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("fieldVal"), 'slds-hide');
    },
    fieldValMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("fieldVal"), 'slds-hide');
    },
    
    fieldValRecOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("fieldValRec"), 'slds-hide');
    },
    fieldValRecMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("fieldValRec"), 'slds-hide');
    },
    fieldValRecMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("fieldValRec"), 'slds-hide');
    },
    togglePopup: function(component, event, helper) {
        component.set("v.isPopupVisible", true);
    },
        
    closePopup: function(component, event, helper) {
        component.set("v.isPopupVisible", false);
    }
	
})