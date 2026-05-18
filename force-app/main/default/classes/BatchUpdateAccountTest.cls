@isTest
private class BatchUpdateAccountTest {

    @isTest
    static void testBatchUpdateAccount() {

       
        Account acc = TestDataFactory.createAccount('Compte Batch');
        Product2 prod = TestDataFactory.createProduct('Produit Batch');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 3, 300); // 900 valeur totale de la commande
        order.Status = 'Activated';
        update order;

        
        Test.startTest();
        BatchUpdateAccount batch = new BatchUpdateAccount();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Vérification que le CA de l'account est bien mis à jour à 900
        Account result = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(900, result.Chiffre_d_affaire__c, 'Le CA doit être 900 après le batch');
    }
}