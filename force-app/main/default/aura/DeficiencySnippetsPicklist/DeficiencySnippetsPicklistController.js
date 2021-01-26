({
    doInit : function(component, event, helper) {
        var action = component.get("c.getMultiSelectPicklists");
        action.setCallback( this, function( response ) {
            var state = response.getState();
            if( state === "SUCCESS") {
                console.log( response.getReturnValue() );
                component.set( "v.options", response.getReturnValue() );
            }
            else if (state === "INCOMPLETE") {
            	alert('Error in the response');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction( action );  
    },
	setSelection : function(component, event, helper) {
		var selection = component.find("select");
        component.set("v.selection", selection);
        var updatedVal = component.get('v.selection')
        helper.sendEvent(component);
	}
})