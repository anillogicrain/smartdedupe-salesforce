({
    doInit : function(component, event, helper) {
        debugger;
        component.set("v.labelColName","");
        component.set("v.txtInlineEditVal","");
        var arrFieldApiName = component.get("v.tempFieldName");
        helper.radiochecked(component,event,helper);
    },
    CancelEditRecord: function(component,event,helper) {
        component.set("v.labelColName","");
        component.set("v.txtInlineEditVal","");
        component.set("v.blnShowEditPopup",false);
    },
    SaveInlineRecord: function(component,event,helper) {
        var arrFieldApiName = component.get("v.tempFieldName");
        if(arrFieldApiName == undefined) {
            arrFieldApiName = [];
        }
        var detailtemp = {};
        var inlineEditCol = component.get("v.labelColName");
        var inlineEditVal = component.get("v.txtInlineEditVal");
        detailtemp = { [inlineEditCol]: inlineEditVal};
        arrFieldApiName.push(detailtemp);
        component.set("v.tempFieldName",arrFieldApiName);
        helper.radiochecked(component,event,helper);
        component.set("v.blnShowEditPopup",false);
    }
})