/********************************************************************************************************************************** 
 * CreatedDate: 11/30/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-407 Archive records; this class is scheduled to run daily. It queries ROC Archive & ROC Child Archive records.
 *              It first insert a ROC Graveyard record. It then performs Dynamic SOQL queries to return records that need to be 
 *              deleted. Each Archive and Child Archive record is linked back to the Graveyard record, before the sObjects are deleted
 **********************************************************************************************************************************/ 

public class BatchDeleteArchiveRecords implements Database.Batchable<sObject>, Database.Stateful {
    Date today = date.today();
    // Per requirements, create a String to store a concatenated value of all deleted record names
    String deletedRecordNames = '';
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return database.getQueryLocator(
            'SELECT ID,Name,Object_Type__c,Object_API_Name__c,Record_Id__c,' +
            '(SELECT Id,Name,Object_API_Name__c,Record_Id__c FROM ROC_Child_Archives__r)' +
            'FROM ROC_Archive__c WHERE Scheduled_Deletion_Date__c = :today'
        );
    }
    public void execute(Database.BatchableContext bc, List<ROC_Archive__c> records){
        // Create a ROC Graveyard record
        ROC_Graveyard__c logDeletion = new ROC_Graveyard__c(Deletion_Date__c = today);
		// insert the ROC Graveyard record
	    insert logDeletion;        
        
        // Create a Map collection to store the ID of records that need to be deleted as the Key, and the corresponding
        // ROC Archive record as the value
        Map<Id, sObject> archiveMap = new Map<Id, sObject>();
        // Create a Set collection to store a unique set of Object API Names that require archives
        Set<String> objTypes = new Set<String>();
        // Create an sObject List collection 
        List<sObject> recordsToDelete = new List<sObject>();
        // create an Id List collection variable
        List<Id> recordIds = new List<Id>();
        // create an sObject collection variable to update both Archive and child Archive records
        List<sObject> archivesToUpdate = new List<sObject>();
        // loop through the Archive records that were retrieved by the Query locator
        for(ROC_Archive__c ra : records){
            // link each ROC Archive record to the newly created ROC Graveyard record
            ra.ROC_Graveyard__c = logDeletion.id;
            // add the updated ROC Archive record to a collection variable to bulkify the update
            archivesToUpdate.add(ra);
            // add the name of each record to a string variable named deletedRecordNames
            deletedRecordNames += ra.Name + '; ';
            // populate the archiveMap collection
            archiveMap.put(ra.Record_Id__c, ra);
            // add the Id of sObjects records that need to be archived to the List collection named recordIds
            recordIds.add(ra.Record_Id__c);
            // add the Object API Names to the Set collection named objTypes
            objTypes.add(ra.Object_API_Name__c);
            If(ra.ROC_Child_Archives__r.size() > 0) {
                for(ROC_Child_Archive__c child : ra.ROC_Child_Archives__r){
                    // link each ROC Child Archive record to the newly created ROC Graveyard record
            		child.ROC_Graveyard__c = logDeletion.id;
                    // add the updated child record to an sObject collection variable to bulkify the update
                    archivesToUpdate.add(child);
                    deletedRecordNames += child.Name + '; ' ;
                    archiveMap.put(child.Record_Id__c, child);
                    recordIds.add(child.Record_Id__c);
                    objTypes.add(child.Object_API_Name__c);
                }
            }
        }
        // loop through the Set collection, objTypes, and perform Dynamic SOQL Queries
        // objTypes' max size is 25, sp no concern of exceeding a governor limit here
        for(String obj : objTypes){
            // create a dynamic SOQL query string for each object in objTypes
            String queryString = 'SELECT Id,Name FROM ' + obj + ' WHERE ID IN :recordIds';
            // query the database using queryString and add the records to the sObject collection variable, recordsToDelete
            recordsToDelete.addAll(Database.query(queryString));
        }
        // Begin retreiving Lightning Notes by querying the ContentDocumentLink object
        If(recordIds.size() > 0) {
            
            List<ContentDocumentLink> cdlList = [SELECT Id,ContentDocument.Title, LinkedEntityId,ContentDocumentId
                                    FROM ContentDocumentLink
                                    WHERE LinkedEntityId IN :recordIds];
			// Create a collection variable to store all of the ContentDocumentIds
			List<Id> noteIds = new List<Id>();
        	// Loop through the ContentDocumentLink records that were queried above
			for(ContentDocumentLink cdl : cdlList){
                system.debug('cdl contentDocumentId ' + cdl.ContentDocumentId);
            	// for each ContentDocumentLink record, add the ContentDocumentId to the noteIds collection variable
    			noteIds.add(cdl.ContentDocumentId);
			}
			// Query the ContentNote directly by utilizing the ContentDocumentIds stored in noteIds
			List<ContentNote> notes = [SELECT Id FROM ContentNote WHERE Id IN :noteIds];
            system.debug('notes size ' + notes.size());
			// bulkify the Note deletion operation
			Database.Delete(notes);
        }
        
        // bulk update both ROC Archive and ROC Child Archive records; the all or nothing parameter is set to False
		Database.update(archivesToUpdate,false);
        // create a ROC Log collection variable to insert delete errors in bulk
        List<ROC_Log__c> logs = new List<ROC_Log__c>();
        // bulk delete records from the database; the all or nothing parameter is set to False
        Database.DeleteResult[] deleteResults = Database.delete(recordsToDelete, false);
        // loop through the delete results
        for(Database.DeleteResult dr : deleteResults){
            if(dr.isSuccess()){
             
            } else {
                for(Database.Error err : dr.getErrors()){
                    ROC_Log__c roclog = new ROC_Log__c();
                	roclog.Process_Name__c = 'BatchDeleteArchiveRecords failure notification';
                    roclog.Message__c      = 'Error message: ' + err.getMessage() + '\n' +
                                             'Fields involved: ' + err.getFields() + '\n' +
                                             'Status code: ' + err.getStatusCode();
                    logs.add(rocLog);
                }
            }
        }
        // insert ROC Logs in bulk to record any record deletion errors
        insert logs;
    }
    public void finish(Database.BatchableContext bc){
        IF(deletedRecordNames != '' && deletedRecordNames != NULL){
            ROC_Graveyard__c logDeletion = [SELECT Id FROM ROC_Graveyard__c WHERE Deletion_Date__c = :today LIMIT 1];
        	logDeletion.Deleted_Record_Names__c = deletedRecordNames;
        	Update logDeletion;
        }
	}
}