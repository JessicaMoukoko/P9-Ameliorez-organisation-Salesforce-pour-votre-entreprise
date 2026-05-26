@isTest
private class AccountRevenueServiceTest {

    @isTest
    static void testUpdateRevenue_avecCommandesActivated() {
        
        Account acc = TestDataFactory.createAccount('Compte Test');
        Product2 prod = TestDataFactory.createProduct('Chemise');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 10, 150);  // 1500 valeur totale de la commande
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 5, 200);   // 1000 valeur totale de la commande

        // Activation de la commande
        order.Status = 'Activated';
        update order;

        
        List<Account> accounts = [
            SELECT Id, (SELECT TotalAmount FROM Orders WHERE Status = 'Activated')
            FROM Account
            WHERE Id = :acc.Id
        ];

        Test.startTest();
        AccountRevenueService.updateRevenue(accounts);
        Test.stopTest();

        // Vérification que le CA est bien la somme des TotalAmount des commandes activées
        Account result = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2500, result.Chiffre_d_affaire__c, 'Le CA doit être 2500');
    }

    @isTest
    static void testUpdateRevenue_sansCommande() {

        Account acc = TestDataFactory.createAccount('Compte Sans Commande');

        List<Account> accounts = [
            SELECT Id, (SELECT TotalAmount FROM Orders WHERE Status = 'Activated')
            FROM Account
            WHERE Id = :acc.Id
        ];

        Test.startTest();
        AccountRevenueService.updateRevenue(accounts);
        Test.stopTest();

        // Vérification que le CA est 0 si aucune commande activée 
        Account result = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, result.Chiffre_d_affaire__c, 'Le CA doit être 0 sans commande');
    }
 // Test pour vérifier que le service gère correctement plusieurs comptes avec des commandes activées
    @isTest
    static void testUpdateRevenue_plusieursComptes() {

        Account acc1 = TestDataFactory.createAccount('Compte A');
        Account acc2 = TestDataFactory.createAccount('Compte B');
        Product2 prod = TestDataFactory.createProduct('Produit X');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);

        Order order1 = TestDataFactory.createOrder(acc1.Id);
        TestDataFactory.createOrderItem(order1.Id, pbe.Id, 2, 500); // 1000
        order1.Status = 'Activated';
        update order1;

        Order order2 = TestDataFactory.createOrder(acc2.Id);
        TestDataFactory.createOrderItem(order2.Id, pbe.Id, 4, 250); // 1000
        order2.Status = 'Activated';
        update order2;

        List<Account> accounts = [
            SELECT Id, (SELECT TotalAmount FROM Orders WHERE Status = 'Activated')
            FROM Account
            WHERE Id IN :new List<Id>{acc1.Id, acc2.Id}
        ];

       
        Test.startTest();
        AccountRevenueService.updateRevenue(accounts);
        Test.stopTest();

        // Vérification que les deux comptes ont le CA correct
        Map<Id, Account> results = new Map<Id, Account>(
            [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :new List<Id>{acc1.Id, acc2.Id}]
        );
        System.assertEquals(1000, results.get(acc1.Id).Chiffre_d_affaire__c, 'CA Compte A = 1000');
        System.assertEquals(1000, results.get(acc2.Id).Chiffre_d_affaire__c, 'CA Compte B = 1000');
    }
}