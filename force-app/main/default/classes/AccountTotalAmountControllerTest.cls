@isTest
private class AccountTotalAmountControllerTest {

    @isTest
    static void testCalculateTotalAmount_avecCommandes() {
        
        // appel de la méthode de test pour configurer un compte avec une commande et des items
        Account acc = TestDataFactory.createAccount('Compte Controller');
        Product2 prod = TestDataFactory.createProduct('Produit C');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 10, 100); // 1000 valeur totale de la commande

        order.Status = 'Activated';

        update order;

        // appel de la méthode à tester
        Test.startTest();
        Decimal total = AccountTotalAmountController.CalculateTotalAmount(acc.Id);
        Test.stopTest();

        System.assertEquals(1000, total, 'Le total doit être 1000');
    }

    @isTest
    static void testCalculateTotalAmount_sansCommande() {

        Account acc = TestDataFactory.createAccount('Compte Vide');

        // Appel de la méthode à tester
        Test.startTest();
        Decimal total = AccountTotalAmountController.CalculateTotalAmount(acc.Id);
        Test.stopTest();

        System.assertEquals(0, total, 'Le total doit être 0 sans commande');
    }
}