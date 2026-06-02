global class BatchUpdateAccount implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {

 // Requête pour récupérer les comptes à mettre à jour
 
        return Database.getQueryLocator(
            [SELECT Id  FROM Account  WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated' )]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {
        AccountRevenueService.updateRevenue(scope);
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch terminé');
    }
}