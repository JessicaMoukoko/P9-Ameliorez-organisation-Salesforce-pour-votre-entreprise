import { createElement } from 'lwc';
import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';

import OrdersViewer from 'c/ordersViewer';
import CalculateTotalAmount from '@salesforce/apex/AccountTotalAmountController.CalculateTotalAmount';

const calculateTotalAmountAdapter =
    registerApexTestWireAdapter(CalculateTotalAmount);

const flushPromises = () => Promise.resolve();

describe('c-orders-viewer', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('affiche rien par defaut', () => {
        const element = createElement('c-orders-viewer', {
            is: OrdersViewer
        });

        document.body.appendChild(element);

        expect(
            element.shadowRoot.querySelector('.slds-theme_success')
        ).toBeNull();

        expect(
            element.shadowRoot.querySelector('.slds-theme_error')
        ).toBeNull();
    });

    it('affiche le montant total', async () => {
        const element = createElement('c-orders-viewer', {
            is: OrdersViewer
        });

        element.recordId = '001000000000001AAA';
        document.body.appendChild(element);

        calculateTotalAmountAdapter.emit(5000);

        await flushPromises();

        const successBox =
            element.shadowRoot.querySelector('.slds-theme_success');

        expect(successBox).not.toBeNull();
        expect(successBox.textContent).toContain('5000');
    });

    it('affiche une erreur Apex', async () => {
        const element = createElement('c-orders-viewer', {
            is: OrdersViewer
        });

        element.recordId = '001000000000001AAA';
        document.body.appendChild(element);

        calculateTotalAmountAdapter.error();

        await flushPromises();

        const errorBox =
            element.shadowRoot.querySelector('.slds-theme_error');

        expect(errorBox).not.toBeNull();
    });

    it('accepte recordId', () => {
        const element = createElement('c-orders-viewer', {
            is: OrdersViewer
        });

        element.recordId = '001000000000002AAA';

        expect(element.recordId).toBe(
            '001000000000002AAA'
        );
    });
});