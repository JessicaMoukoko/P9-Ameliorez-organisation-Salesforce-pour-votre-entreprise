@isTest
private class OrderTriggerHandlerTest {

    @isTest
    static void testHandleAfterUpdate_activationCommande() {

        Account acc = TestDataFactory.createAccount('Compte Trigger');
        Product2 prod = TestDataFactory.createProduct('Produit T');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 5, 200); // 1000

        // On passe le statut à Activated pour déclencher le trigger
        Test.startTest();
        order.Status = 'Activated';
        update order;
        Test.stopTest();

        // Vérification que le CA de l'account est bien mis à jour à 1000 via le trigger
        Account result = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1000, result.Chiffre_d_affaire__c, 'Le CA doit être mis à jour via le trigger');
    }

    @isTest
    static void testHandleAfterUpdate_dejaActive_pasDeMaj() {
        // Arrange — commande déjà Activated, pas de changement de statut
        Account acc = TestDataFactory.createAccount('Compte Déjà Activé');
        Product2 prod = TestDataFactory.createProduct('Produit D');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 2, 100); // 200
        order.Status = 'Activated';
        update order;

        // Reset CA à 0 pour vérifier qu'il ne bouge pas
        acc.Chiffre_d_affaire__c = 0;
        update acc;

        // Act — update sans changement de statut
        Test.startTest();
        order.Description = 'Modification neutre';
        update order;
        Test.stopTest();

        // Assert — CA ne doit pas changer
        Account result = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, result.Chiffre_d_affaire__c, 'Le CA ne doit pas changer si statut inchangé');
    }
}