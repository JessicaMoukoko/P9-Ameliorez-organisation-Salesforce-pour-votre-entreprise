public class AccountRevenueService {

 // Méthode pour mettre à jour le chiffre d'affaires des comptes
 
    public static void updateRevenue(List<Account> accounts) {

        Set<Id> accountIds = new Set<Id>();
        for(Account acc : accounts){
            accountIds.add(acc.Id);
        }
        // Requête agrégée pour calculer le chiffre d'affaires total par compte
        Map<Id, Decimal> revenueByAccount = new Map<Id, Decimal>();

        for(AggregateResult ar : [
            SELECT AccountId accId,   SUM(TotalAmount) total
            FROM Order WHERE Status = 'Activated'
            AND AccountId IN :accountIds GROUP BY AccountId]){
                
            revenueByAccount.put( (Id) ar.get('accId'),(Decimal) ar.get('total') // cast pour éviter les erreurs de type
            );
        }
        List<Account> accountsToUpdate = new List<Account>();

        for(Account acc : accounts){

      // vérifie si l'ID du compte existe dans la map revenueByAccount(si oui, elle récupère son chiffre d'affaires, si non elle attribue la valeur 0 à totalRevenue)
      
            Decimal totalRevenue = revenueByAccount.containsKey(acc.Id)   ? revenueByAccount.get(acc.Id): 0;

            accountsToUpdate.add(new Account(
                Id = acc.Id,
                Chiffre_d_affaire__c = totalRevenue
            ));
        }
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}