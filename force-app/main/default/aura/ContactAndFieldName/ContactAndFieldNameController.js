({

    render : function(component, helper) {
        var ret = this.superRender();

        var Contact = component.get('v.Lead');
        var FieldName = component.get('v.fieldName');
        var outputText = component.find("outputTextId");
        outputText.set("v.value",Contact[FieldName]);

        return ret;
    },

})