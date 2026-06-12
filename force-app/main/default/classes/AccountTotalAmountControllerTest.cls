@isTest
private class AccountTotalAmountControllerTest {
    @isTest
    static void testController() {

        Account acc = TestDataFactory.createAccount('Acc Controller');
        Product2 prod = TestDataFactory.createProduct('Prod Controller');
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
        Decimal total = AccountTotalAmountController.CalculateTotalAmount(acc.Id);
        Test.stopTest();
        System.assert(total > 0, 'Controller doit retourner un total' );
    }
    @isTest
    static void testControllerEmpty() {

        Account acc = TestDataFactory.createAccount('Empty Acc');

        Test.startTest();
        Decimal total = AccountTotalAmountController.CalculateTotalAmount(acc.Id);
        Test.stopTest();

        System.assertEquals( 0, total, 'Doit retourner 0 si aucune commande' );
    }
}