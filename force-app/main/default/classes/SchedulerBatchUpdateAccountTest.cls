@isTest
private class SchedulerBatchUpdateAccountTest {

    @isTest
    static void testScheduler() {

        Account acc = TestDataFactory.createAccount('Compte Scheduler');
        Product2 prod = TestDataFactory.createProduct('Produit S');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 4, 250); // 1000
        order.Status = 'Activated';
        update order;

        Test.startTest();
        String cronExp = '0 0 0 15 3 ? 2030';
        System.schedule('Test Scheduler Batch', cronExp, new SchedulerBatchUpdateAccount());
        Test.stopTest();

        // Assert — vérification que le batch s'est bien exécuté
        Account result = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1000, result.Chiffre_d_affaire__c, 'Le CA doit être 1000 après le scheduler');
    }
}