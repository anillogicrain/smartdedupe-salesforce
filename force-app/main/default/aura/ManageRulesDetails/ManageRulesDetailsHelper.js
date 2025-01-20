({
    createSpecificFieldRow: function(component, event) {
        debugger;   
        //var addSpecificRow = component.find("addSpecificRow");
        var RowItemList = component.get("v.SpecificRulelist");
        console.log("before" + RowItemList.length);            
        RowItemList.push({
            'sobjectType':'SmartDD__ManageRule_Specific_FieldVal__c',                                                                             
            'SmartDD__Specific_Field_Name__c':'',                
            'SmartDD__Specific_Rule_Name__c':'',
            'SmartDD__Specific_Master_Override_Type__c':'',
            'SmartDD__Specific_Popup_Field_Values__c':''
        });                    
        // set the updated list to attribute (SpecificRulelist) again    
        component.set("v.SpecificRulelist", RowItemList);
        console.log("after" + RowItemList.length); 
        /*if( RowItemList.length >= 10 ){
            $A.util.addClass(addSpecificRow,'disablelink');
        }*/
    },
    createExceptionRow: function(component, event) {
        debugger;   
        //var addSpecificRow = component.find("addSpecificRow");
        var RowItemList = component.get("v.ManageRuleExceptionList");
        console.log("before" + RowItemList.length);            
        RowItemList.push({
            'sobjectType':'SmartDD__ManageRule_Exception__c',                                                                             
            'SmartDD__Exception_Exclude_Rule__c':'',                
            'SmartDD__Exception_Field_Name__c':'',
            'SmartDD__Run_Exception_Rule__c':'',
            'SmartDD__Exception_Popup_Field_Values__c':''
        });                    
        // set the updated list to attribute (ManageRuleExceptionList) again    
        component.set("v.ManageRuleExceptionList", RowItemList);
        console.log("after" + RowItemList.length); 
        /*if( RowItemList.length >= 10 ){
            $A.util.addClass(addSpecificRow,'disablelink');
        }*/
    },
    getRulesList: function(component,event,helper) {
        debugger;
        var action = component.get("c.getMergeRules");
        var self = this;
        action.setCallback(this, function(actionResult){
            var returnValue = actionResult.getReturnValue();
            component.set("v.mastermergeRules",returnValue);
        });
        $A.enqueueAction(action);
    },
    deleteSelected : function(component,event,selctedRec){
        var action = component.get("c.delSlctRec");
        action.setParams({
            "slctRec": selctedRec
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state == "SUCCESS")
            {
                component.set("v.mastermergeRules",response.getReturnValue());
                console.log("Successfully Deleted..");
            }else if (state=="ERROR") {
                console.log(action.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    doinitHelper : function(component,event,helper){
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
    },
    masterRecordSelectChangeHelper: function(component,event,helper) {
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
           masterRecordType == 'Newest by the given date field' || masterRecordType == 'Oldest by the given date field' || masterRecordType == 'Record with field value not on specified ignore list'){
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
                    component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
                    component.set("v.showMstrHighValue",true);
                    component.set('v.masterRecordFields',options);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
            component.set("v.showMstrHighValue",false);
        }
    }
})