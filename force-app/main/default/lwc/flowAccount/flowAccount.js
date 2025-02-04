import { LightningElement, track, api } from 'lwc';
import getAccounts from '@salesforce/apex/AccountControllerNav.getAccounts';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

const COLUMNS = [
    { label: 'Account Name', fieldName: 'Name', type: 'text' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Type', fieldName: 'Type', type: 'text' },
    {
        type: 'button',
        typeAttributes: {
            label: 'View opportunities',
            name: 'view_opportunities',
            variant: 'brand',
            onclick: 'handleRowAction'
        }
    }
];

export default class AccountTable extends LightningElement {
    @track accounts = [];
    @track paginatedAccounts = [];
    @track currentPage = 1;
    pageSize = 5; // Set records per page
    totalPages = 0;
    error;
    columns = COLUMNS;
    @api selectedAccountId; // Exposed to Flow

    connectedCallback() {
        this.fetchAccounts();
    }

    fetchAccounts() {
        getAccounts()
            .then((data) => {
                this.accounts = data;
                this.calculatePagination();
            })
            .catch((error) => {
                this.error = error;
                this.accounts = [];
            });
    }

    calculatePagination() {
        this.totalPages = Math.ceil(this.accounts.length / this.pageSize);
        this.updatePaginatedAccounts();
    }

    updatePaginatedAccounts() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.paginatedAccounts = this.accounts.slice(startIndex, endIndex);
    }

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedAccounts();
        }
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedAccounts();
        }
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }

    // Handle navigation within Flow
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view_opportunities') {
            this.selectedAccountId = row.Id;
            const valueChangeEvent = new CustomEvent('valuechange', {
                detail: { value: this.selectedAccountId }
            });
            this.dispatchEvent(valueChangeEvent);
            this.dispatchEvent(new FlowNavigationNextEvent());
        }
    }
    
}
