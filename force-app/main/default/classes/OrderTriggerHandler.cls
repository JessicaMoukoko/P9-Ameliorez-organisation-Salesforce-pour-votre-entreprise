public with sharing class OrderTriggerHandler {

    public static void handleBefore( List<Order> newOrders) {

 // appel du service pour calculer le montant net de la commande

        OrderAmountService.calculateNetAmount( newOrders );
    }

    public static void handleAfterUpdate( List<Order> newOrders, Map<Id, Order> oldMap) {

        Set<Id> accountIds = new Set<Id>();

        for (Order ord : newOrders) {
            Order oldOrd = oldMap.get(ord.Id);

            if (ord.AccountId != null && ( ord.Status != oldOrd.Status || ord.TotalAmount != oldOrd.TotalAmount)) {

                accountIds.add(ord.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            return;
        }
        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE Id IN :accountIds
        ];
 // appel du service pour mettre à jour le revenu total de chaque compte
        AccountRevenueService.updateRevenue(accounts);
    }
}