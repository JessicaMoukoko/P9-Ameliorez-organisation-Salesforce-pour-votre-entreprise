global class SchedulerBatchUpdateAccount implements Schedulable {
 // Cette classe planifie l'exécution du batch BatchUpdateAccount pour mettre à jour les comptes avec le chiffre d'affaires total.
    global void execute(SchedulableContext sc) {

        BatchUpdateAccount batch = new BatchUpdateAccount();
        Database.executeBatch(batch, 200);
    }
}