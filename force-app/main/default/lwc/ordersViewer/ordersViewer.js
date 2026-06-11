import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import HasErrorMessage from '@salesforce/label/c.HasErrorMessage';
import OrdertotalMessage from '@salesforce/label/c.OrderTotalMessage';
import CalculateTotalAmount from '@salesforce/apex/AccountTotalAmountController.CalculateTotalAmount';
export default class ordersViewer extends LightningElement {

    @api recordId;
    hasError = false;
    hasSuccess = false;
    sumOrdersOfCurrentAccount;
    error;  
    hasErrorMessage = HasErrorMessage;
    ordertotalMessage = OrdertotalMessage;
    wiredOrdersResult;

    connectedCallback() {
        console.log('Orders component loaded');
    }

    @wire(CalculateTotalAmount, { accId: '$recordId' })
    wiredOrders(result) {

        // Sauvegarde du résultat pour refreshApex
        this.wiredOrdersResult = result;

        const { data, error } = result;

        if (data) {

            this.sumOrdersOfCurrentAccount = data;

            this.hasSuccess = true;
            this.hasError = false;

            this.error = undefined;

            console.log('Montant total des commandes : ', data);

        } else if (error) {

            this.error = error;

            this.sumOrdersOfCurrentAccount = undefined;

            this.hasError = true;
            this.hasSuccess = false;

            console.error('Erreur lors du calcul : ', error);
        }
    }

    async refreshData() {
        try {
            await refreshApex(this.wiredOrdersResult);
        } catch (err) {
            console.error('Erreur refresh : ', err);
        }
    }
}