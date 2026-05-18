@isTest
public class TestDataFactory {

    //  Méthode pour créer un compte test
    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }
   // Méthode pour créer un produit test
    public static Product2 createProduct(String name) {
        Product2 prod = new Product2(Name = name , IsActive = true);
        insert prod;
        return prod;
    }
   // Méthode  pour créer une PricebookEntry test
    public static PricebookEntry createPricebookEntry(Id productId, Decimal unitPrice) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }
   // Méthode pour créer une commande test
    public static Order createOrder(Id accountId) {
        Order order = new Order(
            AccountId = accountId,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert order;
        return order;
    }
   // Méthode pour créer un OrderItem test
    public static OrderItem createOrderItem(Id orderId, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
        OrderItem orderItem = new OrderItem(
            OrderId = orderId,
            PricebookEntryId = pricebookEntryId,
            Quantity = quantity,
            UnitPrice = unitPrice
        );
        insert orderItem;
        return orderItem;
    }
}