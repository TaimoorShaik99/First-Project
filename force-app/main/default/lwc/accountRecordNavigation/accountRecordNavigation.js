import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccounts from '@salesforce/apex/AccountControllerNav.getAccounts';

const COLUMNS = [
    { label: 'Account Name', fieldName: 'Name', type: 'text' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Website', fieldName: 'Website', type: 'url', typeAttributes: { target: '_blank' } },
    { label: 'Type', fieldName: 'Type', type: 'text' },
    { label: 'Billing City', fieldName: 'BillingCity', type: 'text' },
    {
        label: 'View Opportunities',
        type: 'button',
        initialWidth: 150,
        typeAttributes: { label: 'Open', name: 'view_opportunities', variant: 'brand' }
    }
];

export default class AccountTable extends NavigationMixin(LightningElement) {
    accounts = [];
    columns = COLUMNS;

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'view_opportunities') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordRelationshipPage',
                attributes: {
                    recordId: row.Id,
                    objectApiName: 'Account',
                    relationshipApiName: 'Opportunities', // This navigates to the related Opportunities
                    actionName: 'view'
                }
            });
        }
    }
}
