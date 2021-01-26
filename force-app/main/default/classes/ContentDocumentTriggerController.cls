/********************************************************************************************************************************** 
 * CreatedDate: 06/15/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-588 Lightning Note Restrictions; only allow Users to edit Lightning Notes on the creation date - restrict all 
 *              Users from deleting Notes - runs in before update and before delete contexts
 **********************************************************************************************************************************/ 

public class ContentDocumentTriggerController {

    public static void noteEditValidation(Map<Id,ContentDocument> newSObjects, Map<Id,ContentDocument> oldSObjects){
        
        // loop through Trigger.newMap(newSobjects)
        for(ContentDocument cd : newSObjects.values()){
            // convert CreatedDate and LastModDate from DT to Date - these will be used in the If comparison below
            Date createDate = date.newInstance(cd.CreatedDate.year(), cd.CreatedDate.month(), cd.CreatedDate.day());
            Date lastModDate = date.newInstance(cd.LastModifiedDate.year(), cd.LastModifiedDate.month(), cd.LastModifiedDate.day());
            // if the ContentDocument is a Lightning Note that was created before today, prevent Users from editing
            If(cd.CreatedDate < lastModDate && cd.FileType == 'SNOTE' ){
                cd.addError('Sorry, you are not able to edit this Note');
            }
        }
    }
    public static void preventNoteDeletion(Map<Id,ContentDocument> oldMap) {
        // loop through Trigger.oldMap (oldMp)
        for(ContentDocument cd : oldMap.values()){
            // if the ContentDocument is a Lightning Note, prevent Users from deleting these records
            If(cd.FileType != NULL && cd.FileType == 'SNOTE'){
                cd.addError('Per State policy you are not allowed to delete Notes');
            }
        }
    }
}