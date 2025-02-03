import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccounts from '@salesforce/apex/AccountControllerNav.getAccounts';
import getRelatedOpportunities from '@salesforce/apex/AccountControllerNav.getRelatedOpportunities';

export default class AccountOpportunityViewer extends NavigationMixin(LightningElement) {
    @track accounts = [];
    @track opportunities = [];
    @track selectedAccountName;
    @track selectedAccountId;
    @track showModal = false;

    // Account table columns
    accountColumns = [
        {
            label: 'Account Name',
            fieldName: 'nameUrl',
            type: 'url',
            typeAttributes: {
                label: { fieldName: 'Name' },
                target: '_blank'
            }
        },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Industry', fieldName: 'Industry', type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text' },
        { label: 'Rating', fieldName: 'Rating', type: 'text' },
        { label: 'Annual Revenue', fieldName: 'AnnualRevenue', type: 'currency' },
        {
            label: 'View Opportunities',
            type: 'button',
            initialWidth: 150,
            typeAttributes: { label: 'Open', name: 'view_opportunities', variant: 'brand' }
        }
    ];

    // Opportunity table columns
    opportunityColumns = [
        { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
        { label: 'Stage', fieldName: 'StageName', type: 'text' },
        { label: 'Amount', fieldName: 'Amount', type: 'currency' },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date' },
        { label: 'Probability', fieldName: 'Probability', type: 'percent' }
    ];

    // Fetch Accounts
    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data.map(account => ({
                ...account,
                nameUrl: `/lightning/r/Account/${account.Id}/view`
            }));
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    // Handle Row Click - Navigate to Related Opportunities
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'view_opportunities') {
            this.selectedAccountId = row.Id;
            this.selectedAccountName = row.Name;
            console.log('Selected Account ID:', this.selectedAccountId);

            // Open Related Opportunities in a New Tab
            const baseURL = 'https://canscendo-dev-ed.develop.builder.salesforce-experience.com/opportunityPage'; // Replace with actual URL
            const fullURL = `${baseURL}?accountId=${this.selectedAccountId}`;
            console.log('Navigating to:', fullURL);
            window.open(fullURL, '_blank');
        }
    }

    // Fetch Opportunities when page loads (for Related Opportunities page)
    connectedCallback() {
        const params = new URLSearchParams(window.location.search);
        this.selectedAccountId = params.get('accountId');

        if (this.selectedAccountId) {
            console.log('Extracted Account ID:', this.selectedAccountId);
            this.fetchOpportunities();
        }
    }

    fetchOpportunities() {
        getRelatedOpportunities({ accountId: this.selectedAccountId })
            .then(result => {
                this.opportunities = result;
                console.log('Fetched Opportunities:', result);
            })
            .catch(error => {
                console.error('Error fetching opportunities:', error);
            });
    }
}
