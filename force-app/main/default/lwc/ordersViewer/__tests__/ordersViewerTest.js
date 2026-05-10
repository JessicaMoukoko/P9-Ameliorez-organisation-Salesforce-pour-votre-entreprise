import { createElement } from 'lwc';
import OrdersViewer from 'c/ordersViewer';

describe('c-orders-Viewer', () => {

    afterEach(() => {

        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should create component', () => {

        const element = createElement('c-orders-Viewer', {
            is: OrdersViewer
        });

        document.body.appendChild(element);

        expect(element).not.toBeNull();
    });
});