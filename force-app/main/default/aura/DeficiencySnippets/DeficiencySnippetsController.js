({  
    handleUpdateSelection : function(component,event,helper){
        var selection = event.getParam("selection");
        var action = component.get("c.getSnippetMetadata");
        action.setParams({
            "label" : selection
        })
        action.setCallback( this, function( response ) {
            var state = response.getState();
            if( state === "SUCCESS") {
                console.log( response.getReturnValue() );
                component.set( "v.appMetadata", response.getReturnValue() );
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
    }
})