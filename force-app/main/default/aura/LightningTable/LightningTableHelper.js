({
    getsObjectRecords : function(component,page) {
        debugger;
        if(component.get("v.searchActiveParam") != true){
            var page = page || 1;
        }    
        else{
            var page = 1;
        }
        var action = component.get("c.fetchLead");
        var fields = component.get("v.fields");
        if(component.get("v.filterId") == undefined || component.get("v.filterId") == null || component.get("v.filterId") == ''){
            var selectedFilterId = '';
        }
        else {
            var selectedFilterId = component.get("v.filterId");
        }
        action.setParams({
            'ObjectName' : component.get("v.object"),
            'fieldstoget' : fields.join(),
            'sortField': component.get("v.selectedTabsort"),
            'searchKey': component.get("v.searchKey"),
            'isAsc': component.get("v.isAsc"),
            'pageNumber' : page,
            'pageSize' : component.get("v.pageSize"),
            'filterId' : selectedFilterId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                document.getElementById("data").innerHTML ='';
                component.set("v.latestRecords",response.getReturnValue());
                if(component.get("v.searchActiveParam") != true){
                    component.set("v.page",page);
                }    
                else{
                    component.set("v.page",1);
                }
                var retResponse = response.getReturnValue();
                var totalrecords = retResponse.total;
                var pageSize = component.get("v.pageSize");
                component.set("v.total",totalrecords);
                if(totalrecords <= 0 && component.get("v.searchActiveParam") == true){
                    component.set("v.searchResultAvailParam",true);
                }
                else{
                    component.set("v.searchResultAvailParam",false);
                }
                var totalPages =  Math.ceil(totalrecords/pageSize); 
                if(totalPages != undefined && totalPages != null && totalPages != ''){
                    component.set("v.pages",totalPages);
                }
                var retRecordsforsplit = retResponse.sObjectrecords;
                var retRecords;
                if(component.get("v.searchKey") != '' && component.get("v.searchKey") != undefined){
                    var recStringfy = JSON.stringify(retRecordsforsplit);
                    var duplicateRecStringfy = JSON.stringify(retRecordsforsplit).toLowerCase();
                    var serchKeyResults =[];
                    var serchKeyString = component.get("v.searchKey").trim();
                    var dupserchKeyString = (component.get("v.searchKey").trim()).toLowerCase();
                    while(duplicateRecStringfy.indexOf(dupserchKeyString) != -1){
                        var indexvalue = recStringfy.substring(0,duplicateRecStringfy.indexOf(dupserchKeyString)) + "<span style='background: yellow;'>" + recStringfy.substring(duplicateRecStringfy.indexOf(dupserchKeyString),duplicateRecStringfy.indexOf(dupserchKeyString)+serchKeyString.length) +  "</span>" ; 
                        serchKeyResults.push(indexvalue);
                        var strReplace = recStringfy.substring(0,duplicateRecStringfy.indexOf(dupserchKeyString)) + recStringfy.substring(duplicateRecStringfy.indexOf(dupserchKeyString),duplicateRecStringfy.indexOf(dupserchKeyString)+serchKeyString.length)
                        recStringfy = recStringfy.replace(strReplace,'');
                        duplicateRecStringfy = duplicateRecStringfy.replace(strReplace.toLowerCase(),'');
                    }
                    serchKeyResults.push(recStringfy);
                    //recStringfy= recStringfy.split(component.get("v.searchKey")).join('<span style=\'background: yellow;\'>' + component.get("v.searchKey") + '</span>');
                    //retRecords  = JSON.parse(recStringfy);
                    retRecords  = JSON.parse(serchKeyResults.join(''))
                }else{
                    retRecords  = retResponse.sObjectrecords;
                }
                component.find("chSpinner").set("v.class" , 'slds-hide');
                var myEvent = component.getEvent("BindDataFromFilter");
                if(retResponse.total > 0){
                    myEvent.setParams({ "isAvailable": true});
                    component.set("v.isShowTable",true);
                    retRecords.forEach(function(s) {
                        var tableRow = document.createElement('tr');
                        //tableRow.style.border = "0.5px";
                        tableRow.style.background="rgb(230, 230, 230) !important";
                        //tableRow.style.padding=".2rem";
                        tableRow.style.backgroundColor="#f9f9f9";
                        //tableRow.style.borderBottomStyle="ridge";
                        fields.forEach(function(field){ 
                            var tableData = document.createElement('td');
                            //tableData.style.border = "0.1px";
                            tableData.style.background="rgb(230, 230, 230) !important";
                            //tableData.style.padding=".2rem";
                            debugger;
                            if(field == 'Owner.Name') {
                                s[field] = s['Owner'].Name;
                            }
                            if(field == 'Account.Name' && s['Account'] != undefined) {
                                s[field] = s['Account'].Name;
                            }
                            if( s[field] == null || s[field] == undefined || s[field] == ''){
                                s[field] = '-';
                            }
                            //var tableDataNode = document.createTextNode(s[field]);
                            tableData.innerHTML = s[field];
                            
                            
                            
                            tableRow.appendChild(tableData);
                        });
                        document.getElementById("data").appendChild(tableRow);
                    });
                }else{
                    component.set("v.isShowTable",false);
                    myEvent.setParams({ "isAvailable": false});
                }
                myEvent.fire();
            }else if (state === "ERROR") {
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    
    sortHelper: function(component, event) {
        var currentDir = component.get("v.arrowDirection");
        var page = component.get("v.pageTemp") || 1;
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }
        // call the onLoad function for call server side method with pass sortFieldName 
        this.getsObjectRecords(component,page);
    },
    findByName: function(component,event) {  
        debugger;
        var page = component.get("v.pageTemp") || 1;
        this.getsObjectRecords(component,page);  
    },
    getRecordSize: function(component,event) { 
        debugger;
        var page = component.get("v.pageTemp") || 1;
        var action = component.get('c.GetPerPageRecordSize');
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var returnVal = response.getReturnValue();
                var recordSizeVal = returnVal.SmartDD__Per_Page_Record__c;
                component.set("v.pageSize",recordSizeVal);
                this.getsObjectRecords(component,page);  
            }
            else{
                component.find("chSpinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    }
})