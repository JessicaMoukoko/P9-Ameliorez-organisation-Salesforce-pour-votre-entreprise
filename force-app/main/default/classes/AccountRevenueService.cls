public class AccountRevenueService {

    public static void updateRevenue(List<Account> accounts) {

        //Récupération des IDs des comptes
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        List<AggregateResult> AggregateResults = [SELECT AccountId accId , SUM(TotalAmount) totalRevenue
                                    FROM Order
                                    WHERE Status = 'Activated'
                                    AND AccountId IN :accountIds
                                    GROUP BY AccountId
        ];

        // Map CA par compte

        Map<Id, Decimal> revenueByAccount = new Map<Id, Decimal>();

        for (AggregateResult ar : AggregateResults) {

            Id accId = (Id) ar.get('accId');
            Decimal totalRevenue = (Decimal) ar.get('totalRevenue');

            revenueByAccount.put(accId,totalRevenue);
        }
    
        //Préparation des updates
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : accounts) {

            Decimal totalRevenue = 0;
            
            if (revenueByAccount.containsKey(acc.Id)) {
                totalRevenue = revenueByAccount.get(acc.Id);
            }
            accountsToUpdate.add(new Account(Id = acc.Id , Chiffre_d_affaire__c = totalRevenue));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}