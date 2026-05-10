global class SchedulerBatchUpdateAccount implements Schedulable {

    global void execute(SchedulableContext sc) {

        BatchUpdateAccount batch = new BatchUpdateAccount();
        Database.executeBatch(batch, 200);
    }
}