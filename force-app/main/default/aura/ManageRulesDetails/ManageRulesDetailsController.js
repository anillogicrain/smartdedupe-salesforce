({
    doInit: function(component,event,helper) {
        debugger;
        helper.doinitHelper(component,event,helper);
        component.set("v.showMstrHighValue",false);
        component.set("v.showMstrFrstRecVal",false);
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
        var selObject = component.find('plstObject').get("v.value");
        component.set("v.selectedObject",selObject);
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        
        if(selObject != undefined && selObject != null && selObject != '') {
            component.set("v.showMergeSettings",false);
            component.set("v.detailespage",true);
            helper.getRulesList(component,event,helper);
            
            var actionObjField = component.get('c.getObjFields');
            actionObjField.setParams({
                "selectedObject" : selObject
            });
            actionObjField.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    component.set('v.specificFieldList',returnValue);
                }
            });
            $A.enqueueAction(actionObjField);
        }
        else {
            component.set("v.showMergeSettings",false);
            component.set("v.detailespage",false);
        }
        helper.createSpecificFieldRow(component,event);
        helper.createExceptionRow(component,event);
        component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
    },
    priorityGivenFieldOption: function(component,event,helper) {
        component.set("v.strMstrPopFieldVal",'');
        component.set("v.blnPriorityGivenFieldPopup",true);
    },
    closePriorityGivenFieldPopup: function(component,event,helper) {
        component.set("v.txtPriorityPopupVal",'');
        component.set("v.lstPriorityPopupVals",[]);
        component.set("v.blnPriorityGivenFieldPopup",false);
    },
    savePriorityPopupVals: function(component,event,helper) {
        debugger;
        var txtPriorityPopupVal = component.get("v.txtPriorityPopupVal");
        if(txtPriorityPopupVal != undefined && txtPriorityPopupVal != null && txtPriorityPopupVal != ''){
            var lst = component.get("v.lstPriorityPopupVals");
            lst.push(txtPriorityPopupVal);
            component.set("v.lstPriorityPopupVals",lst);
            component.set("v.txtPriorityPopupVal",'');
        }
	},
    savePriorityFieldvals: function(component,event,helper) {
        debugger;
        var lst = component.get("v.lstPriorityPopupVals");
        var strPriorityVals = lst.toString();
        component.set("v.strMstrPopFieldVal",strPriorityVals);
        component.set("v.txtPriorityPopupVal",'');
        component.set("v.lstPriorityPopupVals",[]);
        component.set("v.blnPriorityGivenFieldPopup",false);
    },
    
    recNotInSpecifiedLstOption: function(component,event,helper) {
        component.set("v.strMstrPopFieldVal",'');
        component.set("v.blnRecNotInSpecifiedLstPopup",true);
    },
    closeNotInSpecifiedLstPopup: function(component,event,helper) {
        component.set("v.txtMstrNotInSpecifiedLstVal",'');
        component.set("v.lstNotInSpeciPopupVals",[]);
        component.set("v.blnRecNotInSpecifiedLstPopup",false);
    },
    saveNotInSpeciPopupVals: function(component,event,helper) {
        debugger;
        var txtMstrNotInSpecifiedLstVal = component.get("v.txtMstrNotInSpecifiedLstVal");
        if(txtMstrNotInSpecifiedLstVal != undefined && txtMstrNotInSpecifiedLstVal != null && txtMstrNotInSpecifiedLstVal != ''){
            var lst = component.get("v.lstNotInSpeciPopupVals");
            lst.push(txtMstrNotInSpecifiedLstVal);
            component.set("v.lstNotInSpeciPopupVals",lst);
            component.set("v.txtMstrNotInSpecifiedLstVal",'');
        }
	},
    saveNotInSpeciFieldvals: function(component,event,helper) {
        debugger;
        var lst = component.get("v.lstNotInSpeciPopupVals");
        var strNotInSpecifiedLstVals = lst.toString();
        component.set("v.strMstrPopFieldVal",strNotInSpecifiedLstVals);
        component.set("v.txtMstrNotInSpecifiedLstVal",'');
        component.set("v.lstNotInSpeciPopupVals",[]);
        component.set("v.blnRecNotInSpecifiedLstPopup",false);
    },
    saveMergeRule: function(component,event,helper) {
    	debugger;
        var selObject = component.find('plstObject').get("v.value");
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
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        var action = component.get('c.saveMergeRuleFilters');
        action.setParams({ 
            "selObject" : selObject,
            "MasterRecord" : selMasterRecord,
            "ObjFieldAPIName" : selFieldAPIName,
            "MasterPopFieldVals" : popMasterFieldVals,
            "MasterOrderBy" : selMasterOrderBy,
            "DefaultSelectionPriority" : selDefaultSelectionPriority,
            "OverrideMaster" : selOverrideMaster,
            "SpecificFieldList" : lstSpecificFieldValues,
            "ExceptionsList" : lstExceptions,
        });
        action.setCallback(this,function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS'){
                component.set("v.showMergeSettings",false);
                component.set("v.showMasterRecordDetails",false);
                component.set("v.detailespage",true);
                helper.getRulesList(component,event,helper);
                component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    masterRecordSelectChange: function(component,event,helper) {
        helper.masterRecordSelectChangeHelper(component,event,helper);
    },
    changeEachFieldValChk: function(component,event,helper) {
        debugger;
    	var bln = component.find('chkEachFieldValues').get("v.checked");
        console.log('@@#$bln: '+ bln);
        if(bln == true){
            component.set("v.blnEachValueChk",true);
        }
        else{
            component.set("v.blnEachValueChk",false);    
        }
    },
    deleteSlctd : function(component,event,helper) {
        debugger;
        var selctedRec = event.target.dataset.id;
        helper.deleteSelected(component,event,selctedRec);
    },
    editSlctd : function(component,event,helper) {
        debugger;
        var selctedRec = event.target.dataset.id;
        console.log(selctedRec);
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
                var recordsize = masterRecords.lstSpecificValCriterias;                
                component.set("v.MasterRec",masterRecords.objMasterRecords);
                var masterRecordType = component.get("v.MasterRec").SmartDD__Master_Record_Type__c;
                 helper.masterRecordSelectChangeHelper(component,event,helper);
                
                if(recordsize.length == 0){
                    component.set("v.SpecificRulelist",{'sobjectType':'SmartDD__ManageRule_Specific_FieldVal__c',                                                                             
                                                        'SmartDD__SmartDD__Specific_Field_Name__c':'',                
                                                        'SmartDD__Specific_Rule_Name__c':'',
                                                        'SmartDD__Specific_Master_Override_Type__c':'',
                                                        'SmartDD__Specific_Popup_Field_Values__c':''});
                }
                else{
                    
                    component.set("v.SpecificRulelist",masterRecords.lstSpecificValCriterias);
                }
            }
        }); 
        $A.enqueueAction(action);
    },
    createMergeRule: function(component,event,helper) {
        component.set("v.showMergeSettings",true);
        component.set("v.detailespage",false);
    }
})