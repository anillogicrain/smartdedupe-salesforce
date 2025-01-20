({
    doinitHelper : function(component,event,helper){
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
    },
    createSpecificFieldRow: function(component, event,helper) {
        debugger;   
        //var addSpecificRow = component.find("addSpecificRow");
        var RowItemList = component.get("v.SpecificRulelist");
        //console.log("before" + RowItemList.length);            
        RowItemList.push({
            'sobjectType':'SmartDD__ManageRule_Specific_FieldVal__c',                                                                             
            'SmartDD__Specific_Field_Name__c':'',                
            'SmartDD__Specific_Rule_Name__c':'',
            'SmartDD__Specific_Master_Override_Type__c':'Override Master When Blank',
            'SmartDD__Specific_Popup_Field_Values__c':''
        });                  
        // set the updated list to attribute (SpecificRulelist) again    
        component.set("v.SpecificRulelist", RowItemList);
        //console.log("after" + RowItemList.length); 
        /*if( RowItemList.length >= 10 ){
            $A.util.addClass(addSpecificRow,'disablelink');
        }*/
    },
    createExceptionRow: function(component, event, helper) {
        debugger;   
        //var addSpecificRow = component.find("addSpecificRow");
        var RowItemList = component.get("v.ManageRuleExceptionList");
        //console.log("before" + RowItemList.length);            
        RowItemList.push({
            'sobjectType': 'SmartDD__ManageRule_Exception__c',                                                                             
            'SmartDD__Exception_Exclude_Rule__c': '',                
            'SmartDD__Exception_Field_Name__c': '',
            'SmartDD__Run_Exception_Rule__c': '',
            'SmartDD__Exception_Popup_Field_Values__c': ''
        });                   
        // set the updated list to attribute (ManageRuleExceptionList) again    
        component.set("v.ManageRuleExceptionList", RowItemList);
        //console.log("after" + RowItemList.length); 
        /*if( RowItemList.length >= 10 ){
            $A.util.addClass(addSpecificRow,'disablelink');
        }*/
    },
    getRulesList: function(component,event,helper) {
        debugger;
        var selObject = component.find('plstObject').get("v.value");
        var action = component.get("c.getMergeRules");
        action.setParams({
            "selectedObject" : selObject
        });
        var self = this;
        action.setCallback(this, function(actionResult){
            var returnValue = actionResult.getReturnValue();
            if(returnValue != null && returnValue.length >= 10){
                component.set("v.isBln",false);
            }
            else{
                component.set("v.isBln",true);
            } 
            component.set("v.mastermergeRules",returnValue);
            if(component.find("cbox") != undefined) {
                component.find("cbox").set("v.value",false);
            }
            if(component.find("MergeRecSpinner") != undefined) {
                component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    deleteSelected : function(component,event,selctedRec){
        debugger;
        var selObject = component.find('plstObject').get("v.value");
        var action = component.get("c.delSlctRec");
        action.setParams({
            "slctRec": selctedRec,
            "selectedObject" : selObject
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state == "SUCCESS"){
                component.find("MergeRecSpinner").set("v.class" , 'slds-show');
                var result = response.getReturnValue();
                if(result != '' && result != null ) {
                    if(result.length >= 10){
                        component.set("v.isBln",false);
                    }
                    else{
                        component.set("v.isBln",true);
                    }
                    debugger;
                    component.set("v.mastermergeRules",result);
                    component.set("v.showMessage",false);
                    component.find("cbox").set("v.value",false);
                    component.set('v.disbledelebtn',true);
                }
                else {
                    component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
                    component.set("v.showMessage",true);
                    component.set("v.isErrorMessage",true);
                    var getCheckAllId = component.find("cboxRow");
                    if(getCheckAllId.length == selctedRec.length) {
                        component.find("cbox").set("v.value",true);
                    }
                    component.set('v.disbledelebtn',false);
                    component.set("v.Message",'You Can Not Delete Active Record.');
                }
                
                //console.log("Successfully Deleted..");
                component.set("v.isOpenPopUp",false);
                component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
            }else if (state=="ERROR"){
                //console.log(action.getError()[0].message);
                component.set("v.isOpenPopUp",false);
                component.set('v.disbledelebtn',true);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*chkEachFieldValChange: function(component,event,helper) {
        debugger;
        var bln = component.find('chkEachFieldValues').get("v.checked");
        console.log('@@#$bln: '+ bln);
        if(bln == true){
            component.set("v.blnEachValueChk",true);
        }
        else{
            component.set("v.blnEachValueChk",false);    
        }
    },*/
    getExceptionFields : function(component,event,helper) {
        var selObject = component.find('plstObject').get("v.value");
        var action = component.get("c.fetchExceptionFields");
        action.setParams({
            "selectedObject" : selObject
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var returnValue = response.getReturnValue();
                var returnResult = returnValue[0].FieldsList;
                var options = [];
                for(var i=0;i<returnResult.length;i++){
                    var opt = {};
                    opt.label = returnResult[i].fieldLabelName;
                    opt.value = returnResult[i].fieldAPIName ;
                    options.push(opt);
                }
                component.set('v.excFieldDropDown',options);
                
                    
            }
        });
        $A.enqueueAction(action);  
    },
    masterRecordSelectChangeHelper: function(component,event,isEdit) {
        var masterRecordType = component.find('plstmasterRecord').get("v.value");
        var selObject = component.find('plstObject').get("v.value");
        component.set("v.strMstrPopFieldVal",'');
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        if(masterRecordType != 'undefined' && masterRecordType != null && masterRecordType != ''){
            component.set("v.showMasterRecordDetails",true);
        }
        else{
            component.set("v.showMasterRecordDetails",false);
        }
        if(masterRecordType == 'Prioritized on the given field and values'){
            component.set("v.blnPriorityFieldIcon",true);
            component.set("v.blnRecNotInSpecifiedLstIcon",false);
        }
        else if(masterRecordType == 'Record with field value not on specified ignore list'){
            component.set("v.blnRecNotInSpecifiedLstIcon",true);
            component.set("v.blnPriorityFieldIcon",false);
        }
            else{
                component.set("v.blnPriorityFieldIcon",false);
                component.set("v.blnRecNotInSpecifiedLstIcon",false);
            }
        
        if(masterRecordType == 'Highest value in the user-defined field' || masterRecordType == 'Lowest value in the user-defined field' ||
           masterRecordType == 'First record with a value in the user-defined field' || masterRecordType == 'Prioritized on the given field and values' ||
           masterRecordType == 'Newest by the given date field' || masterRecordType == 'Oldest by the given date field' || 
           masterRecordType == 'Record with field value not on specified ignore list'){
            debugger;
            var action = component.get('c.fetchSelectedRecFields');
            action.setParams({
                "selectedObject" : selObject,
                "selectedMarterRecType" : masterRecordType
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    var returnResult = returnValue[0].FieldsList;
                    var options = [];
                    for(var i=0;i<returnResult.length;i++){
                        var opt = {};
                        opt.label = returnResult[i].fieldLabelName;
                        opt.value = returnResult[i].fieldAPIName ;
                        options.push(opt);
                    }
                    component.find("MergeRecSpinner").set("v.class", 'slds-hide');
                    component.set("v.showMstrHighValue",true);
                    component.set('v.masterRecordFields',options);
                    if(isEdit != true){
                        component.find('plstmasterRecordFields').set("v.value",'');
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
            component.set("v.showMstrHighValue",false);
        }
    },
    updateStatus : function(component,event,helper,selctedRecId){
        debugger;
        var selObject = component.find('plstObject').get("v.value");
        var action = component.get("c.updateRecStatus");
        action.setParams({
            "selectedRecord": selctedRecId,
            "selectedObject" : selObject
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            var Response = response.getReturnValue();           
            if(state == "SUCCESS"){
                component.set("v.showMessage",false);
				this.getRulesList(component,event,helper);                 
            }
        });
        $A.enqueueAction(action);
    },
    objectChangeSelectHelper: function(component,event,helper) {
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
            actionObjField.setCallback(this,function(response) {
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
        component.set('v.disbledelebtn',true);
        helper.createSpecificFieldRow(component,event);
        helper.createExceptionRow(component,event);
        component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
    },
    objectChangeSelectHelper: function(component,event,helper) {
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
            actionObjField.setCallback(this,function(response) {
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
        component.set('v.disbledelebtn',true);
        helper.createSpecificFieldRow(component,event);
        helper.createExceptionRow(component,event);
        component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
    }
})