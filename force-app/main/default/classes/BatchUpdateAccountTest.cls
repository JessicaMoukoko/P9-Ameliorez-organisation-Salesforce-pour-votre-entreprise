@isTest
private class BatchUpdateAccountTest {

    @isTest
    static void testBatch() {

        Account acc = TestDataFactory.createAccount('Acc Batch');
        Product2 prod = TestDataFactory.createProduct('Prod Batch');
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
        Database.executeBatch(new BatchUpdateAccount(), 200);
        Test.stopTest();

        Account result = [
            SELECT Chiffre_d_affaire__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assert(
            result.Chiffre_d_affaire__c != null,
            'Batch doit calculer le CA'
        );
    }
}