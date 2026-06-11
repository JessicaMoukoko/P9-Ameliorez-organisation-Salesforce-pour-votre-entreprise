@isTest
private class OrderAmountServiceTest {

    @isTest
    static void testCalculateNetAmount() {

        Account acc = TestDataFactory.createAccount('Acc Test');
        Product2 prod = TestDataFactory.createProduct('Prod Test');

        Id stdPbId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPbId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;
        Order ord = TestDataFactory.createOrder(acc.Id);
        ord.ShipmentCost__c = 50;
        update ord;

        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 10,
            UnitPrice = 100
        );
        insert oi;

        ord = [
            SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c
            FROM Order
            WHERE Id = :ord.Id
        ];

        Test.startTest();
        OrderAmountService.calculateNetAmount(new List<Order>{ ord });
        Test.stopTest();

        Order result = [SELECT NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id = :ord.Id];

        System.assertEquals( result.TotalAmount - result.ShipmentCost__c, result.NetAmount__c, 'NetAmount doit être Total - ShipmentCost' );
    }

    @isTest
    static void testCalculateNetAmountWithNullShipment() {

        Account acc = TestDataFactory.createAccount('Acc Null');
        Id stdPbId = Test.getStandardPricebookId();
        Product2 prod = TestDataFactory.createProduct('Prod Null');

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPbId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        Order ord = TestDataFactory.createOrder(acc.Id);

        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 5,
            UnitPrice = 100
        );
        insert oi;

        ord = [SELECT Id, TotalAmount FROM Order WHERE Id = :ord.Id];

        ord.ShipmentCost__c = null;
        update ord;

        Test.startTest();
        OrderAmountService.calculateNetAmount(new List<Order>{ ord });
        Test.stopTest();

        Order result = [SELECT NetAmount__c, TotalAmount FROM Order WHERE Id = :ord.Id];

        System.assertEquals( result.TotalAmount, result.NetAmount__c,'Si Shipment null, NetAmount = TotalAmount');
    }
}