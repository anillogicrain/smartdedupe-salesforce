({
	displayObjectColumns: function(component, event, helper) {
        
        component.set('v.displaySave',false);
        component.find("Search_spinner").set("v.class" , 'slds-show');
        var selectedObjectName = component.find("viewObjectfilter").get("v.value");
        if(selectedObjectName === 'Lead'){
            component.set('v.displaySave',true);
        }
        if(selectedObjectName !== undefined || selectedObjectName !== null || selectedObjectName !== ''){
            var actionAllObjectColumns = component.get("c.fetchDedupeSearchCols");
            actionAllObjectColumns.setParams({ 
                "ObjectName" : selectedObjectName
            });
            actionAllObjectColumns.setCallback(this, function(response){
                debugger;
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    var returnResult = returnValue[0].FieldsList;
                    var rvwPolishResult = returnValue[0].ReviewPolishFieldsList;
                    var options = [];
                    for(var i=0; i<returnResult.length; i++){
                        var opt = {};
                        opt.label = returnResult[i].fieldLabelName;
                        opt.value = returnResult[i].fieldApiName ;
                        options.push(opt);
                    }
                    component.set('v.options',options);
                    
                    var ColumnOptions = [];
                    for(var i=0; i<returnResult.length; i++){
                        var opt = {};
                        opt.label = returnResult[i].fieldLabelName;
                        opt.value = returnResult[i].fieldApiName ;
                        ColumnOptions.push(opt);
                    }
                    component.set('v.dedupeDisplayOption',options);
                    
                    var rvwPlshOptions = [];		
                    for(var j=0; j<rvwPolishResult.length; j++){		
                        var contactRVWOption = {};	
                        contactRVWOption.label = rvwPolishResult[j].fieldLabelName;		
                        contactRVWOption.value = rvwPolishResult[j].fieldApiName ;		
                        rvwPlshOptions.push(contactRVWOption);		
                    }
                    component.set('v.rvwPolishOptions',rvwPlshOptions);
                    component.find("Search_spinner").set("v.class" , 'slds-hide');
                }
            });
            $A.enqueueAction(actionAllObjectColumns);
            
            var actionSetAllObjectVals = component.get("c.fetchSelectedFieldsCols");
            actionSetAllObjectVals.setParams({ 
                "objectName" : selectedObjectName
            });
            actionSetAllObjectVals.setCallback(this, function(response){
                debugger;
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    if(returnValue !== '' && returnValue !== null){
                        if(returnValue[0].SmartDD__Search_Object_Fields__c !== '' && returnValue[0].SmartDD__Search_Object_Fields__c !== null){
                            component.set('v.fieldValues',returnValue[0].SmartDD__Search_Object_Fields__c.split(','));
                        }
                        if(returnValue[0].SmartDD__Search_Column_Fields__c !== '' && returnValue[0].SmartDD__Search_Column_Fields__c !== null){
                            component.set('v.columnValues',returnValue[0].SmartDD__Search_Column_Fields__c.split(','));
                            component.set('v.prevColumnValues',returnValue[0].SmartDD__Search_Column_Fields__c.split(','));
                        }
                        if(returnValue[0].SmartDD__Review_Polish_Display_Columns__c !== '' && returnValue[0].SmartDD__Review_Polish_Display_Columns__c !== null){
                            component.set('v.rvwPlshValues',returnValue[0].SmartDD__Review_Polish_Display_Columns__c.split(','));
                            component.set('v.prevRvwPlshValues',returnValue[0].SmartDD__Review_Polish_Display_Columns__c.split(','));
                        }
                    }
                }
            });
            $A.enqueueAction(actionSetAllObjectVals);
        }
    },
})