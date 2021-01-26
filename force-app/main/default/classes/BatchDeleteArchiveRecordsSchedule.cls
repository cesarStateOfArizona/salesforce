/********************************************************************************************************************************** 
 * CreatedDate: 12/18/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-407 Archive records; Schedulable class to schedule the BatchDeleteArchiveRecords class
 **********************************************************************************************************************************/ 
global class BatchDeleteArchiveRecordsSchedule implements Schedulable {
    global void execute(SchedulableContext SC){
        Database.executeBatch(new BatchDeleteArchiveRecords());
    }
}