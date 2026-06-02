public with sharing class OrderTriggerHandler {

    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {

        Set<Id> accountIds = new Set<Id>();

        // 1. Récupérer les comptes concernés
        for (Order ord : newOrders) {
            if (ord.AccountId != null && ord.Status == 'Activated' && oldMap.get(ord.Id).Status != 'Activated') {
                accountIds.add(ord.AccountId);
            }
        }
        // 2. Récupérer les comptes
        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]
        );
        // 3. Calcul du CA
        for (Order ord : newOrders) {
            Order oldOrd = oldMap.get(ord.Id);

            // Vérifier changement de statut vers Activated
            if (ord.Status == 'Activated' && oldOrd.Status != 'Activated') {

                if (accMap.containsKey(ord.AccountId)) {
                    Account acc = accMap.get(ord.AccountId);

                    Decimal oldCA = acc.Chiffre_d_affaire__c != null ? acc.Chiffre_d_affaire__c : 0;

                    acc.Chiffre_d_affaire__c = oldCA + ord.TotalAmount;
                }
            }
        }
        // 4. Update des comptes
        if (!accMap.isEmpty()) {
            update accMap.values();
        }
    }


}