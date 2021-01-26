/********************************************************************************************************************************** 
 * CreatedDate: 06/15/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-588 Lightning Note Restrictions; call TriggerFactory in beforeUpdate and beforeDelete contexts;
 **********************************************************************************************************************************/ 

trigger contentDocumentTrigger on ContentDocument (before update,before delete) {
    
    TriggerFactory.createAndExecuteHandler('ContentDocumentTriggerHandler');
   
}