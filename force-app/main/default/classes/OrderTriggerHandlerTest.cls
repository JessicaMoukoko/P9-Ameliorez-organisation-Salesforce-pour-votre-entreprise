@isTest
private class OrderTriggerHandlerTest {

    @isTest
    static void testActivationTrigger() {

        Account acc = TestDataFactory.createAccount('Acc Trigger');
        Product2 prod = TestDataFactory.createProduct('Prod Trigger');

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
        order.Status = 'Activated';
        update order;
        Test.stopTest();

        Account result = [
            SELECT Chiffre_d_affaire__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assert( result.Chiffre_d_affaire__c > 0, 'CA doit être mis à jour par trigger');
    }

    @isTest
    static void testNoChangeDoesNotRecalculate() {

        Account acc = TestDataFactory.createAccount('Acc No Change');
        Product2 prod = TestDataFactory.createProduct('Prod');
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

        Id TestStandardPbId = Test.getStandardPricebookId();

        Account beforeAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];

        Test.startTest();
        order.Description = 'no change trigger';
        update order;
        Test.stopTest();

        Account afterAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];

        System.assertEquals( beforeAcc.Chiffre_d_affaire__c, afterAcc.Chiffre_d_affaire__c, 'CA ne doit pas changer si statut inchangé');
    }
}