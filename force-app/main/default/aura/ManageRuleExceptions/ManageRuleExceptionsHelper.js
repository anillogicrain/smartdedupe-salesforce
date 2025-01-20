({
	excpetionRulesChange: function(component,event,setOptionval){
        debugger;
        var exceptionRuleName = component.find('plstExceptionRule').get("v.value");
        var selObject = component.get("v.selectedObject");
        
        component.find("MergeRecSpinner").set("v.class" , 'slds-show');
        
        // To Check whether it is edit case or not.
        if(setOptionval == true) {
            var popValues = component.get("v.ManageRuleExceptionPrm.SmartDD__Exception_Popup_Field_Values__c");
            component.set("v.strExceptionFinalPopVal",popValues);
        }
        else{
            component.set("v.strExceptionFinalPopVal",'');
            component.set("v.ManageRuleExceptionPrm.SmartDD__Exception_Popup_Field_Values__c",'');
            component.set('v.ManageRuleExceptionPrm.SmartDD__Run_Exception_Rule__c','');
        }
        if(exceptionRuleName == 'Group when NO value exists for any record in group for field' || 
           exceptionRuleName == 'Group when Specified Value exists in more than one record' || 
           exceptionRuleName == 'Record when Non Master Record has any value in field' || 
           exceptionRuleName == 'Record when Non Master Record has specified value in field' || 
           exceptionRuleName == 'Record when Value does not match master record for field' || 
           exceptionRuleName == 'Record when Value does not match master record (Blank value matched)' || 
           exceptionRuleName == 'Group when Value exists in more than one record') {
            
            debugger;
            if(exceptionRuleName != 'Group when NO value exists for any record in group for field' && 
              exceptionRuleName != 'Record when Non Master Record has any value in field' && 
              exceptionRuleName != 'Group when Value exists in more than one record') {
                component.set("v.blnExceptionPopIcon",true); 
                component.set("v.showExceptionPercentPop",false);
                component.set("v.exceptionMstrRecNotmatch",false);
                if(exceptionRuleName == 'Group when Specified Value exists in more than one record' || 
                   exceptionRuleName == 'Record when Non Master Record has specified value in field') {
                    if(exceptionRuleName == 'Record when Non Master Record has specified value in field') {
                        component.set("v.blnBeforeMasterRec",false); 
                    }
                    else{
                        component.set("v.blnBeforeMasterRec",true); 
                    }
                    component.set("v.showExceptionPopTxt",true);
                    component.set("v.exceptionMstrRecNotmatch",false);
                }
                else if(exceptionRuleName == 'Record when Value does not match master record for field' || 
                        exceptionRuleName == 'Record when Value does not match master record (Blank value matched)') {
                    component.set("v.blnBeforeMasterRec",false);
                    component.set("v.showExceptionPopTxt",false);
                    component.set("v.exceptionMstrRecNotmatch",true);
                }
                else{
                    component.set("v.blnBeforeMasterRec",true);
                    component.set("v.showExceptionPopTxt",false); 
                    component.set("v.exceptionMstrRecNotmatch",false);
                } 
            }
            else {
                if(exceptionRuleName == 'Record when Non Master Record has any value in field') {
                    component.set("v.blnBeforeMasterRec",false); 
                }
                else {
                    component.set("v.blnBeforeMasterRec",true);
                }
                component.set("v.blnExceptionPopIcon",false); 
            }
            component.set("v.blnFieldsException",true);
            if(setOptionval != true) {
                component.set('v.ManageRuleExceptionPrm.SmartDD__Exception_Field_Name__c','');
                component.set('v.ManageRuleExceptionPrm.SmartDD__Run_Exception_Rule__c','');
            }
            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
        } else if(exceptionRuleName == 'Group when record has less than X% of the fields with values' || 
                  exceptionRuleName == 'Group when its size is <= X' || exceptionRuleName == 'Group when its size is >= X'){
            component.set("v.blnBeforeMasterRec",true);
            if(exceptionRuleName == 'Group when record has less than X% of the fields with values'){
                component.set("v.exceptionDecimalVal",'0.00');
            }
            else{
                component.set("v.exceptionDecimalVal",'0');
            }
            component.set("v.showExceptionPercentPop",true);
            component.set("v.blnFieldsException",false);
            component.set("v.blnExceptionPopIcon",true);
            component.set("v.showExceptionPopTxt",false);
            component.set("v.exceptionMstrRecNotmatch",false);
            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
        } else if(exceptionRuleName == 'Record when Non Master Record is protected') {
            component.set("v.blnBeforeMasterRec",false);
            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
        } else {
            component.set("v.blnFieldsException",false);
            component.set("v.blnExceptionPopIcon",false); 
            component.set("v.blnBeforeMasterRec",true);
            component.find("MergeRecSpinner").set("v.class" , 'slds-hide');
        }
    },
    showExceptionPopup : function(component,event) {
        debugger;
        
        var strExceptionPopFieldVal = component.get("v.strExceptionFinalPopVal");
        var popUpTxt = component.get("v.showExceptionPopTxt");
        var popUpPercentval = component.get("v.showExceptionPercentPop");
        var popUpTrueFalse = component.get("v.exceptionMstrRecNotmatch");
        if(strExceptionPopFieldVal != null && strExceptionPopFieldVal != ''){
            if(popUpTxt == true){
                component.set("v.txtExceptionPopVal", strExceptionPopFieldVal);
            }
            if(popUpPercentval == true){
                component.set("v.intPercentVal", parseFloat(strExceptionPopFieldVal));
            }
            if(popUpTrueFalse == true){
                component.set("v.popMstrNotmatch", strExceptionPopFieldVal);
            }
        }
        component.set("v.blnExceptionPopupModal",true);
    },
    CloseExceptionPopup: function(component,event,helper) {
        debugger;
        var exceptionRuleName = component.find('plstExceptionRule').get("v.value");
		if(exceptionRuleName == 'Group when record has less than X% of the fields with values') {
        	component.set("v.intPercentVal",0.00);
        }
        else if(exceptionRuleName == 'Group when its size is <= X' || exceptionRuleName == 'Group when its size is >= X'){
            component.set("v.intPercentVal",0);
        }
        if(component.get("v.exceptionMstrRecNotmatch") == true) {
            if(component.find('exceptionTrueFalse') != undefined) {
                component.find('exceptionTrueFalse').set("v.value",'');
            }
        }
        component.set("v.txtExceptionPopVal",'');
        component.set("v.blnExceptionPopupModal",false);
    },
    SaveExceptionPopVals: function(component,event,helper) {
        debugger;
        var blnExceptionValPop = component.get("v.showExceptionPopTxt");
        var blnExceptionPercentPop = component.get("v.showExceptionPercentPop");
        var blnMstrNotMatch = component.get("v.exceptionMstrRecNotmatch");
        var txtExceptionPopVal = '';
        if(blnExceptionValPop == true) {
            txtExceptionPopVal = component.get("v.txtExceptionPopVal");
        }
        else if(blnExceptionPercentPop == true) {
            txtExceptionPopVal = component.get("v.intPercentVal");
        }
        else if(blnMstrNotMatch == true) {
        	txtExceptionPopVal = component.find("exceptionTrueFalse").get("v.value");        
        }
        component.set("v.strExceptionFinalPopVal",txtExceptionPopVal);
        component.set("v.ManageRuleExceptionPrm.SmartDD__Exception_Popup_Field_Values__c",txtExceptionPopVal.toString());
        var exceptionRuleName = component.find('plstExceptionRule').get("v.value");
		if(exceptionRuleName == 'Group when record has less than X% of the fields with values') {
        	component.set("v.intPercentVal",0.00);
        }
        else if(exceptionRuleName == 'Group when its size is <= X' || exceptionRuleName == 'Group when its size is >= X'){
            component.set("v.intPercentVal",0);
        }
        component.set("v.txtExceptionPopVal",'');
        component.set("v.blnExceptionPopupModal",false);
    },
    createExceptionRow: function(component, event) {
        debugger;   
        var RowItemList = component.get("v.ManageRuleExceptionListPrm");
        RowItemList.push({
            'sobjectType':'SmartDD__ManageRule_Exception__c',                                                                             
            'SmartDD__Exception_Exclude_Rule__c':'',                
            'SmartDD__Exception_Field_Name__c':'',
            'SmartDD__Run_Exception_Rule__c':'',
            'SmartDD__Exception_Popup_Field_Values__c':''
        });                    
        // set the updated list to attribute (ManageRuleExceptionListPrm) again    
        component.set("v.ManageRuleExceptionListPrm", RowItemList);
    }, 
    removeExceptionRow: function(component,index,dataid) {
        var AllRowsList = component.get("v.ManageRuleExceptionListPrm");
        AllRowsList.splice(index,1);         
        component.set("v.ManageRuleExceptionListPrm", AllRowsList);
        console.log(component.get("v.ManageRuleExceptionListPrm"));                         
    }
})