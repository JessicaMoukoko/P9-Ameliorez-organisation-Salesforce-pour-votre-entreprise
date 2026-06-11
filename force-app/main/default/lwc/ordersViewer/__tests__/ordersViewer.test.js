// Imports des utilitaires de test LWC
import { createElement } from 'lwc';
import { createApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';

// Import du composant a tester
import OrdersViewer from 'c/ordersViewer';

// Import de la methode Apex mockee
import CalculateTotalAmount from '@salesforce/apex/AccountTotalAmountController.CalculateTotalAmount';

// On enregistre l'adaptateur wire pour pouvoir simuler les reponses Apex
const mockCalculateTotalAmount =
    createApexTestWireAdapter(jest.fn());

// ─────────────────────────────────────────────
// SUITE DE TESTS
// ─────────────────────────────────────────────
describe('c-orders-viewer', () => {

    // Apres chaque test : on nettoie le DOM pour eviter les effets de bord
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    // ── TEST 1 ──────────────────────────────────────────────────────
    // Verifie que le composant se charge sans erreur par defaut
    it('affiche rien par defaut (pas encore de donnees)', () => {
        // Creer le composant et l'ajouter au DOM
        const element = createElement('c-orders-viewer', { is: OrdersViewer });
        document.body.appendChild(element);

        // Au chargement, aucun message ne doit etre visible
        const successBox = element.shadowRoot.querySelector('.slds-theme_success');
        const errorBox   = element.shadowRoot.querySelector('.slds-theme_error');

        expect(successBox).toBeNull();
        expect(errorBox).toBeNull();
    });

    // ── TEST 2 ──────────────────────────────────────────────────────
    // Verifie que le montant total s'affiche quand Apex retourne des donnees
    it('affiche le montant total quand Apex retourne une valeur', async () => {
        const element = createElement('c-orders-viewer', { is: OrdersViewer });
        element.recordId = '001000000000001AAA'; // ID de compte fictif
        document.body.appendChild(element);

        // Simule une reponse Apex avec un montant de 5000
        mockCalculateTotalAmount.emit(5000);

        // Attendre que le DOM se mette a jour
        await Promise.resolve();

        // La boite succes doit etre visible
        const successBox = element.shadowRoot.querySelector('.slds-theme_success');
        expect(successBox).not.toBeNull();

        // La boite erreur ne doit pas etre visible
        const errorBox = element.shadowRoot.querySelector('.slds-theme_error');
        expect(errorBox).toBeNull();
    });

    // ── TEST 3 ──────────────────────────────────────────────────────
    // Verifie que le montant affiche correspond bien a la valeur retournee par Apex
    it('affiche le bon montant retourne par Apex', async () => {
        const element = createElement('c-orders-viewer', { is: OrdersViewer });
        element.recordId = '001000000000001AAA';
        document.body.appendChild(element);

        // Simule Apex qui retourne 12500
        mockCalculateTotalAmount.emit(12500);

        await Promise.resolve();

        const successBox = element.shadowRoot.querySelector('.slds-theme_success');
        // Le texte de la boite doit contenir la valeur 12500
        expect(successBox.textContent).toContain('12500');
    });

    // ── TEST 4 ──────────────────────────────────────────────────────
    // Verifie que le message d'erreur s'affiche quand Apex retourne une erreur
    it('affiche un message d erreur quand Apex echoue', async () => {
        const element = createElement('c-orders-viewer', { is: OrdersViewer });
        element.recordId = '001000000000001AAA';
        document.body.appendChild(element);

        // Simule une erreur Apex
        mockCalculateTotalAmount.error({ message: 'Erreur serveur' });

        await Promise.resolve();

        // La boite erreur doit etre visible
        const errorBox = element.shadowRoot.querySelector('.slds-theme_error');
        expect(errorBox).not.toBeNull();

        // La boite succes ne doit pas etre visible
        const successBox = element.shadowRoot.querySelector('.slds-theme_success');
        expect(successBox).toBeNull();
    });

    // ── TEST 5 ──────────────────────────────────────────────────────
    // Verifie que apres une erreur, si Apex retourne des donnees, le succes s'affiche
    it('affiche le succes apres une erreur si Apex retourne des donnees', async () => {
        const element = createElement('c-orders-viewer', { is: OrdersViewer });
        element.recordId = '001000000000001AAA';
        document.body.appendChild(element);

        // D'abord une erreur
        mockCalculateTotalAmount.error({ message: 'Erreur serveur' });
        await Promise.resolve();

        // Puis une reponse valide (simule un refresh)
        mockCalculateTotalAmount.emit(3000);
        await Promise.resolve();

        // La boite succes doit etre visible
        const successBox = element.shadowRoot.querySelector('.slds-theme_success');
        expect(successBox).not.toBeNull();

        // La boite erreur doit avoir disparu
        const errorBox = element.shadowRoot.querySelector('.slds-theme_error');
        expect(errorBox).toBeNull();
    });

    // ── TEST 6 ──────────────────────────────────────────────────────
    // Verifie que le composant accepte bien une prop recordId
    it('accepte un recordId en propriete', () => {
        const element = createElement('c-orders-viewer', { is: OrdersViewer });
        element.recordId = '001000000000002AAA';
        document.body.appendChild(element);

        // On verifie juste que le composant se charge sans planter
        expect(element.recordId).toBe('001000000000002AAA');
    });

});
