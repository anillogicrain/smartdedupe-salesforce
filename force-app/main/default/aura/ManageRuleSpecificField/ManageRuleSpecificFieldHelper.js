({
    getSpecificFieldRules : function(component, event, setOptionval) {
        debugger;
        component.set("v.lstSpecificFieldVals",[]);
        component.set("v.strSpecificFinalVal",'');
        if(setOptionval != true) {
            component.find('plstSpecificFieldRules').set("v.value",'');
            component.set("v.SpecificRulePrm.SmartDD__Specific_Popup_Field_Values__c",'');
        }
        component.set("v.popValueSpecific",'');
        component.set('v.blnSpecificFieldValIcon',false);
        var specificFieldVal = component.find('plstObjFields').get("v.value");
        if(specificFieldVal != undefined && specificFieldVal != null && specificFieldVal != '') {
            var specificFieldList = component.get('v.specificFieldListPrm');
            for(var i=0;i<specificFieldList.length;i++){
                if(specificFieldList[i].SmartDD__Field_API_Name__c == specificFieldVal){
                    var specifiedRule = specificFieldList[i].SmartDD__Specific_Field_Rules__c;
                    if(specifiedRule != undefined && specifiedRule != null) {
						component.set('v.lstSpecificFieldRules',specifiedRule.split(';'));                        
                    }
                    break;
                }
            }
            component.get('v.lstSpecificFieldRules').sort();
        }
        else {
            component.set('v.lstSpecificFieldRules',[]);
        }
    },
    setSpecificFieldRulesChange : function(component, event, setOptionval) {
        debugger;
        component.set('v.lstSpecificFieldVals',[]);
        var specificPopIcon = component.get("v.blnSpecificFieldValIcon");
        if(setOptionval == true) {
            var popValues = component.get("v.SpecificRulePrm.SmartDD__Specific_Popup_Field_Values__c");
            component.set('v.strSpecificFinalVal',popValues);
        }
        else {
            component.set('v.strSpecificFinalVal','');
            component.set("v.SpecificRulePrm.SmartDD__Specific_Popup_Field_Values__c",'');
        }
        component.set("v.popValueSpecific",'');
        if(component.find('plstSpecificFieldRules') != undefined && component.find('plstSpecificFieldRules') != ''){
            var selObject = component.get("v.selectedObject");
            var selectedFieldVal = component.find('plstObjFields').get("v.value");
            var action = component.get('c.checkSpecificFieldValueType');
            var selectedRule = component.find('plstSpecificFieldRules').get("v.value");
            var selectedMastrRule =  component.get("v.masterLabelVal");
            action.setParams({
                "ObjectName" : selObject,
                "selSpecificFieldVal" : selectedFieldVal
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    if(returnValue != null){
                        component.set('v.showSpecificPopDropDown',returnValue);
                        component.set('v.showSpecificFieldPopTxt',false);
                    }
                    else{
                        component.set('v.showSpecificFieldPopTxt',true);
                    }
                    if(selectedRule == 'Ignore all values: update to blank or to given value'){
                        component.set('v.blnSpecificFieldValIcon',true);
                        component.set('v.showSpecificListView',false);
                        if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Ignore all values: update to blank or to given value'){
                            var staticLabel = $A.get("$Label.c.IgnoreAllvalues");
                            var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                            component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                        }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Ignore all values: update to blank or to given value' ){
                            var staticLabel = $A.get("$Label.c.IgnoreAllvalues");
                            var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                            component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);    
                        }
                    }
                    //else if(selectedRule == 'Prioritized by values' || selectedRule == 'Override Master Value with value not on ignore list' || selectedRule == 'Preserve Master Value if not on ignore list'){
                    else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Prioritized by values'){
                        component.set('v.blnSpecificFieldValIcon',true);
                        component.set('v.showSpecificListView',true);
                        var staticLabel = $A.get("$Label.c.PrioritizedValues");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Prioritized by values'){
                        component.set('v.blnSpecificFieldValIcon',true);
                        component.set('v.showSpecificListView',true);
                        var staticLabel = $A.get("$Label.c.PrioritizedValues");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if (selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Override Master Value with value not on ignore list'){
                        component.set('v.blnSpecificFieldValIcon',true);
                        component.set('v.showSpecificListView',true);
                        var staticLabel = $A.get("$Label.c.OverrideMasterValues");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if (selectedMastrRule == 'Always Override Master' && selectedRule == 'Override Master Value with value not on ignore list'){
                        component.set('v.blnSpecificFieldValIcon',true);
                        component.set('v.showSpecificListView',true);
                        var staticLabel = $A.get("$Label.c.OverrideMasterValues");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    } else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Most Common'){
                        var staticLabel = $A.get("$Label.c.Most_Common");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Most Common'){
                        var staticLabel = $A.get("$Label.c.Most_Common");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Field with max characters'){
                        var staticLabel = $A.get("$Label.c.FieldWithMaxChar");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Field with max characters'){
                        var staticLabel = $A.get("$Label.c.FieldWithMaxChar");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Newest (ordered by CREATE date)'){
                        var staticLabel = $A.get("$Label.c.NewestCreateDate");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Newest (ordered by CREATE date)'){
                        var staticLabel = $A.get("$Label.c.NewestCreateDate");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Newest (ordered by MODIFIED date)'){
                        var staticLabel = $A.get("$Label.c.NewestModifieDate");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Newest (ordered by MODIFIED date)'){
                        var staticLabel = $A.get("$Label.c.NewestModifieDate");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Oldest (ordered by CREATE date)'){
                        var staticLabel = $A.get("$Label.c.OldestCreateDate");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Oldest (ordered by CREATE date)'){
                        var staticLabel = $A.get("$Label.c.OldestCreateDate");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Override Master When Blank' && selectedRule == 'Oldest (ordered by MODIFIED date)'){
                        var staticLabel = $A.get("$Label.c.OldestModifieDate");
                        var MastrRuleLabel = $A.get("$Label.c.OverrideMaterWhenBlank");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }else if(selectedMastrRule == 'Always Override Master' && selectedRule == 'Oldest (ordered by MODIFIED date)'){
                        var staticLabel = $A.get("$Label.c.OldestModifieDate");
                        var MastrRuleLabel = $A.get("$Label.c.AlwaysOverride");
                        component.set("v.labelval", MastrRuleLabel  + ' ' + staticLabel);
                    }
                        else{
                            component.set('v.blnSpecificFieldValIcon',false);
                        }
                }
            });
            $A.enqueueAction(action);
        }
    },
    createSpecificFieldRow : function(component, event) {
        debugger;   
        var RowItemList = component.get("v.SpecificRulelistPrm");
        RowItemList.push({
            'sobjectType':'SmartDD__ManageRule_Specific_FieldVal__c',                                                                             
            'SmartDD__Specific_Field_Name__c':'',                
            'SmartDD__Specific_Rule_Name__c':'',
            'SmartDD__Specific_Master_Override_Type__c':'Override Master When Blank',
            'SmartDD__Specific_Popup_Field_Values__c':''
        });                    
        // set the updated list to attribute (SpecificRulelist) again    
        component.set("v.SpecificRulelistPrm", RowItemList);
        
        /*if( RowItemList.length >= 10 ){
            $A.util.addClass(addSpecificRow,'disablelink');
        }*/
    },
    removeDeletedRow: function(component,index,dataid) {
        debugger;
        var AllRowsList = component.get("v.SpecificRulelistPrm");
        AllRowsList.splice(index,1);   
        component.set("v.SpecificRulelistPrm", AllRowsList);
        console.log(component.get("v.SpecificRulelistPrm"));                         
    },
    SpecificFieldRulesChangehelper: function(component,event,helper) {
        debugger;
        var setOptionval = true;
        helper.setSpecificFieldRulesChange(component,event,setOptionval);
    }
})