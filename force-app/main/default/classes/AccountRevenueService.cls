public class AccountRevenueService {

    public static void updateRevenue(List<Account> accounts) {

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : accounts) {
            Decimal totalRevenue = 0;

            if (acc.Orders != null) {
                for (Order order : acc.Orders) {
                    totalRevenue += order.TotalAmount != null ? order.TotalAmount : 0;
                }
            }

            accountsToUpdate.add(new Account(
                Id = acc.Id,
                Chiffre_d_affaire__c = totalRevenue
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}