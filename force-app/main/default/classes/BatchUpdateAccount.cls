global class BatchUpdateAccount implements Database.Batchable<SObject> {

// Récupère les comptes ayant au moins une commande Activated    
    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN ( SELECT AccountId FROM Order WHERE Status = 'Activated')]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {

        //1. Récupération des IDs des comptes du scope         
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }
        // 2. Récupération des commandes Activated         
        List<Order> orders = [SELECT Id,AccountId,TotalAmount
                            FROM Order
                            WHERE Status = 'Activated'
                            AND AccountId IN :accountIds];
        // 3. Calcul du CA par compte
        Map<Id, Decimal> revenueByAccount = new Map<Id, Decimal>();

        for (Order ord : orders) {
            // Si le compte n'existe pas encore dans la map
            if (!revenueByAccount.containsKey(ord.AccountId)) {
                revenueByAccount.put(ord.AccountId , ord.TotalAmount);
            } 
            else {
                // Si le compte existe déjà dans la map alors on ajoute au montant existant
                Decimal currentAmount = revenueByAccount.get(ord.AccountId);
                revenueByAccount.put(ord.AccountId , currentAmount + ord.TotalAmount);
            }
        }

        // 4. Préparation des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : scope) {
            Decimal totalRevenue = 0;

            if (revenueByAccount.containsKey(acc.Id)) {
                totalRevenue = revenueByAccount.get(acc.Id);
            }
            accountsToUpdate.add(new Account(Id = acc.Id , Chiffre_d_affaire__c = totalRevenue));
        }

        // 5. Update
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch terminé');
    }
}