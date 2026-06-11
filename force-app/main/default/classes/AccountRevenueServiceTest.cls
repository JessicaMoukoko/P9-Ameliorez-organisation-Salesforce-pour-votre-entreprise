@isTest
private class AccountRevenueServiceTest {

    @isTest
    static void testUpdateRevenue() {

        Account acc = TestDataFactory.createAccount('Acc Test');
        Product2 prod = TestDataFactory.createProduct('Prod Test');

        Id standardPbId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        Order order = TestDataFactory.createOrder(acc.Id);

          OrderItem oi = new OrderItem(
           OrderId = order.Id,
           PricebookEntryId = pbe.Id,
           Quantity = 5,
           UnitPrice = 100
    );
        insert oi;

       order = [SELECT Id FROM Order WHERE Id = :order.Id];

       order.Status = 'Activated';
        update order;

        Test.startTest();
        AccountRevenueService.updateRevenue(new List<Account>{ acc });
        Test.stopTest();

        Account result = [
            SELECT Chiffre_d_affaire__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assert(
            result.Chiffre_d_affaire__c > 0,
            'CA doit être calculé'
        );
    }
}