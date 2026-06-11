public with sharing class AccountTotalAmountController {

    @AuraEnabled(cacheable=true)
    public static Decimal CalculateTotalAmount(Id accId) {

        try {

            AggregateResult result = [
                SELECT SUM(TotalAmount) total
                FROM Order
                WHERE AccountId = :accId AND Status = 'Activated'
            ];

            Decimal montantFinal = (Decimal) result.get('total');

            System.debug('Montant final : ' + montantFinal);

            return montantFinal != null ? montantFinal : 0;

        } catch (Exception e) {

            System.debug(LoggingLevel.ERROR,
                'Erreur CalculateTotalAmount : ' + e.getMessage()
            );

            throw new AuraHandledException(e.getMessage());
        }
    }
}