public with sharing class OrderAmountService {

    public static void calculateNetAmount(List<Order> orders) {

        for(Order ord : orders){

            Decimal total = ord.TotalAmount != null ? ord.TotalAmount : 0;
            Decimal shipment = ord.ShipmentCost__c != null? ord.ShipmentCost__c  : 0;

            ord.NetAmount__c = total - shipment;
        }         
}
 }