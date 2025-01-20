({
	radiochecked: function(component,event,helper){
        debugger;
        component.find("ClusterSpinner").set("v.class" , 'slds-show');
        var objectName = component.get("v.selObjectNamePrm");
        var recordId = component.get("v.masterRecordId");
        var fields = component.get("v.fields"); 
        var action = component.get("c.fnGetClusterPolishDetails");
        action.setParams({  
            'fieldstoget':fields.join(),
            'MasterRecordId': recordId,
            'ObjectName': objectName
        }); 
        action.setCallback(this,function(response) {
            debugger;
            var state = response.getState();            
            if(state == 'SUCCESS'){
                var retRecords;                
                document.getElementById("PolishData").innerHTML ='';
                var returnvalue = response.getReturnValue();
                retRecords = returnvalue.sObjectrecords;
                var totalrecords = returnvalue.total;
                var arrMasterFieldApiName = [];
                if(returnvalue.total > 0){
                    retRecords.forEach(function(s) {
                        var tableRow = document.createElement("tr");
                        var tableDataSpace = document.createElement("td");
                        tableRow.style = "background-color: rgb(242, 225, 192);  height: 54px;";
                        //tableDataSpace.ondblclick="{!c.inlineEditName}";
                        tableDataSpace.innerHTML = 'New Master Record:';
                        tableDataSpace.style = "background-color: rgb(242, 225, 192); font-weight: bold; font-style: oblique;";
                        tableRow.appendChild(tableDataSpace);
                        fields.forEach(function(field){ 
                            var tableData = document.createElement("td");
                            tableData.style = "background-color: rgb(242, 225, 192);";
                            // Field Value Selection Starts
                            var specificFieldvalName = component.get("v.FieldValUpdateSpecificFieldName");
                            if(specificFieldvalName.length > 0) {
                                var arrUpdateSpecificFieldApiName = component.get("v.FieldValUpdateSpecificFieldName")[0];
                                if(arrUpdateSpecificFieldApiName[field] != undefined && arrUpdateSpecificFieldApiName[field] != null) {
                                    s[field] = arrUpdateSpecificFieldApiName[field];
                                }
                            }
                            // Specific Field Values Starts
                            var fieldvalName = component.get("v.FieldValUpdateFieldName");
                            if(fieldvalName.length > 0) {
                                console.log('@LeadValUpdates: '+component.get("v.FieldValUpdateFieldName")[0]);
                                var arrUpdateFieldApiName = component.get("v.FieldValUpdateFieldName")[0];
                                if(arrUpdateFieldApiName[field] != undefined && arrUpdateFieldApiName[field] != null) {
                                    s[field] = arrUpdateFieldApiName[field];
                                }
                            }
                            var tempFieldName = component.get("v.tempFieldName");
                            if(tempFieldName.length > 0) {
                                tempFieldName.forEach(function(tempFieldVals) {
                                    if(tempFieldVals[field] != undefined) {
                                        s[field] = tempFieldVals[field];
                                    }
                                    else {
                                        if(field == 'Owner.Name'){
                                            s[field] = s['Owner'].Name;
                                        }
                                        if(field == 'Account.Name' && s['Account'] != undefined){
                                            s[field] = s['Account'].Name;
                                        }
                                        if( s[field] == null || s[field] == undefined || s[field] == ''){
                                            s[field] = '-';
                                        }
                                    }
                                });
                            }
                            else {
                                if(field == 'Owner.Name'){
                                    s[field] = s['Owner'].Name;
                                }
                                if(field == 'Account.Name' && s['Account'] != undefined){
                                    s[field] = s['Account'].Name;
                                }
                                if( s[field] == null || s[field] == undefined || s[field] == ''){
                                    s[field] = '-';
                                }
                            }
                            var objTempMasterRec = "";
                            if([field] == 'Owner.Name') {
                                objTempMasterRec = '"ownername"' + ':' + '"' + s[field] + '"';
                            } else if([field] == 'Account.Name') {
                                objTempMasterRec = '"accountname"' + ':' + '"' + s[field] + '"';
                            } else{
                                objTempMasterRec = '"' + [field] + '"' + ':' + '"' + s[field] + '"';
                            }
                            tableData.addEventListener('click', function(){
                                debugger;
                                if(!field.includes('Date') && !field.includes('date') && !field.includes('DATE')) {
                                    component.set("v.iserror",false);
                                    component.set("v.labelColName",field);
                                    component.set("v.txtInlineEditVal",s[field]);
                                    component.set("v.blnShowEditPopup",true);
                                }
                                else {
                                    component.set("v.iserror",true);
                                    component.set("v.errormsg","Can not update date fields.");
                                }
                            });
                            arrMasterFieldApiName.push(objTempMasterRec);
                            component.set("v.arrMasterRecord",arrMasterFieldApiName);
                            tableData.innerHTML = s[field];
                            tableRow.appendChild(tableData);
                        });
                        document.getElementById("PolishData").appendChild(tableRow);
                    });
                }
            }
            component.find("ClusterSpinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);       
    },
    inlineEditName: function(component, event, helper) {
        alert("hello");
    }
})