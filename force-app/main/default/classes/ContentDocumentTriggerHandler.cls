/********************************************************************************************************************************** 
 * CreatedDate: 06/15/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-588 Lightning Note Restrictions; call ContentDocumentTriggerController in beforeUpdate and beforeDelete contexts;
 **********************************************************************************************************************************/ 

public class ContentDocumentTriggerHandler extends TriggerHandler {
    /*
    public override void beforeInsert( List<sObject> newSObjects ) {
        system.debug('newSObjects size ' + newSObjects.size());
        list<contentDocument> newCDList = (list<contentDocument>)newSObjects;
        RestrictNotePermissions.beforeInsert(newCDList);
    }
    
    public override void afterInsert( Map<Id, sObject> newSObjects ) {
    }
	*/

    public override void beforeUpdate( Map<Id, sObject> newSObjects, Map<Id, sObject> oldSObjects){
        
        Map<Id,ContentDocument> newMap = (Map<Id,ContentDocument>)newSObjects;
        Map<Id,ContentDocument> oldMap = (Map<Id,ContentDocument>)oldSObjects;
        ContentDocumentTriggerController.noteEditValidation(newMap, oldMap);
    }
    /*
    public override void afterUpdate( Map<Id, sObject> newSObjects, Map<Id, sObject> oldSObjects){
       
    }
    */
    public override void beforeDelete(Map<Id,sObject> oldSObjects) {
        Map<Id,ContentDocument> oldMap = (Map<Id,ContentDocument>)oldSObjects;
        ContentDocumentTriggerController.preventNoteDeletion(oldMap);
    }
    /*
    public override void afterDelete(Map<Id,sObject> oldSObjects) {
    }
    
    public override void afterUnDelete(Map<Id,sObject> newSObjects) {
    }
	*/
}