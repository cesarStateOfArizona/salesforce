({
	sendEvent : function(component,event,helper) {
        let selection = component.get('v.selection').get("v.value");
        var appEvent = $A.get("e.c:DeficiencyPicklistSelected");
        appEvent.setParams({
            "selection" : selection });
        appEvent.fire();
	}
})