global class BatchUpdateAccount implements Database.Batchable<SObject> {

// Récupère les comptes ayant au moins une commande Activated    
    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN ( SELECT AccountId FROM Order WHERE Status = 'Activated')]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {
        AccountRevenueService.updateRevenue(scope);
    }


    global void finish(Database.BatchableContext bc) {
        System.debug('Batch terminé');
    }
}