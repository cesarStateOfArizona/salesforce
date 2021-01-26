/********************************************************************************************************************************** 
 * CreatedDate: 06/15/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-588 Lightning Note Restrictions; only allow Users to edit Lightning Notes on the creation date - restrict all 
 *              Users from deleting Notes - runs in before update and before delete contexts
 **********************************************************************************************************************************/ 
@isTest
private class ContentDocumentTriggerHandlerTest {
	// this method confirms that Users can update a Lightning Note on the same day the note was created
    @isTest static void confirmSameDayEditsAllowed(){
		// begin retrieving data to run this test in a different User context
        Id compProfId = [SELECT Id FROM Profile WHERE Name = 'Compliance'].Id;
        User compUser = [SELECT Id FROM User WHERE Profile.Id = :compProfId AND IsActive = True LIMIT 1];
		DateTime today = Date.today();
		// change the User context
        System.runAs(compUser){
			// call TestDataFactory and create 20 Lightning Notes each with a CreatedDate equal to today
        	TestDataFactory.createNotes(20, today);
        	List<ContentVersion> notes = [SELECT Id FROM ContentVersion];
			System.assertEquals(20, notes.size());
			// loop through the ContentVersions and begin modifying the notes
        	for(ContentVersion cv : notes){
            	Blob bodyBlob = Blob.valueOf('Update note body');
            	cv.VersionData = bodyBlob;
            	cv.Title = 'Update title';
        	}
			Test.startTest();
			// although a Try-Catch block is used, no exceptions should be thrown
        	try{
            	update notes;
        	} catch (DMLexception e){
            	system.debug('e ' + e.getMessage());
            	system.debug('e ' + e.getTypeName());
        	} catch (exception e){
            	system.debug('e ' + e.getMessage());
        	}
            Test.stopTest();
        }
	}
	// this method verifies that Notes cannot be edited on a date that is greater than the CreatedDate
    @isTest static void confirmEditPrevention(){
        Id compProfId = [SELECT Id FROM Profile WHERE Name = 'Compliance'].Id;
        User compUser = [SELECT Id FROM User WHERE Profile.Id = :compProfId AND IsActive = True LIMIT 1];
		DateTime oneMonthAgo = Date.today() - 30;
		// change the User context
        System.runAs(compUser){
			// call TestDataFactory and create 20 Lightning Notes with a CreatedDate equal to 30 days ago
        	TestDataFactory.createNotes(20, oneMonthAgo);
        	List<ContentVersion> notes = [SELECT Id FROM ContentVersion];
			System.assertEquals(20, notes.size());
			// loop through the ContextVersions and begin updating the Notes
        	for(ContentVersion cv : notes){
            	Blob bodyBlob = Blob.valueOf('Update note body');
            	cv.VersionData = bodyBlob;
            	cv.Title = 'Update title';
        	}
        	Test.startTest();
        	try{
				// DML update statement should throw an exception
            	update notes;
        	} catch (DMLexception e){
				system.debug('e msg ' + e.getMessage());
            	boolean expectedException = e.getMessage().contains('not able to edit') ? true : false;
            	system.assertEquals(true, expectedException);
        	} catch (exception e){
            	system.debug('e ' + e.getMessage());
        	}
       		Test.stopTest();
        }
	}
	// this method confirms that Users cannot delete any Lightning Note
    @isTest static void testPreventDelete(){
        Id compProfId = [SELECT Id FROM Profile WHERE Name = 'Compliance'].Id;
        User compUser = [SELECT Id FROM User WHERE Profile.Id = :compProfId AND IsActive = True LIMIT 1];
        DateTime today = Date.today();
        // change User context
        System.runAs(compUser){
			// Call TestDataFactory and create 20 Lightning Notes
        	TestDataFactory.createNotes(20, today);
        	List<ContentVersion> notes = [SELECT ContentDocumentId FROM ContentVersion];
        	System.assertEquals(20, notes.size());
			List<Id> contentDocIds = new List<Id>();
			// DML Delete operations are not permitted on ContentVersion, so generate notesToDelete
        	for(ContentVersion cv : notes){
            	contentDocIds.add(cv.ContentDocumentId);
			}
			// query ContentDocuments with a binde variable from all ContentDocument Ids in the notes ContentVersion List
        	List<ContentDocument> notesToDelete = [SELECT Id FROM ContentDocument WHERE Id IN :contentDocIds];	
        	
            Test.startTest();
            try{
				// this DML operation should throw a DML exception
				Delete notesToDelete;
				// catch the exception
            } catch (DMLexception e){
				// verify the error message
				Boolean expectedErrorMsg = e.getMessage().contains('Per State policy you are not allowed to delete Notes') ? true : false;
				system.assertEquals(true, expectedErrorMsg);
            } catch (exception e){
                system.debug('general exception ' + e.getMessage());
            }
            Test.stopTest();
        }
    }
}