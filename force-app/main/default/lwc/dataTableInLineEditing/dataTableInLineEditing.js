// accountDataTable.js
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountDataTableController.getAccounts';
import updateAccounts from '@salesforce/apex/AccountDataTableController.updateAccounts';

const columns = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
        editable: true,
        typeAttributes: {
            required: true
        }
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone',
        editable: true
    },
    {
        label: 'Industry',
        fieldName: 'Industry',
        type: 'text',
        editable: true
    },
    {
        label: 'Rating',
        fieldName: 'Rating',
        type: 'text',
        editable: true
    }
];

export default class AccountDataTable extends LightningElement {
    @track accounts = [];
    @track originalAccounts = [];
    @track filteredAccounts = [];
    @track showConfirmDialog = false;
    @track isSaveDisabled = true;
    @track draftValues = [];
    @track changedFields = [];
    @track searchTerm = '';
    @track isLoading = false;

    columns = columns;

    get hasRecords() {
        return this.filteredAccounts.length > 0;
    }

    connectedCallback() {
        this.loadAccounts();
    }

    loadAccounts() {
        this.isLoading = true;

        getAccounts()
            .then((data) => {
                this.accounts = JSON.parse(JSON.stringify(data));
                this.originalAccounts = JSON.parse(JSON.stringify(data));
                this.filteredAccounts = [...this.accounts];                
                this.isLoading = false;
            })
            .catch(() => {
                this.isLoading = false;
                this.showToast('Error', 'Error loading accounts', 'error');
            })
            
    }

    handleSearch(event) {
        this.searchTerm = event.target.value.toLowerCase();
        this.filterAccounts();
    }

    filterAccounts() {
        if (!this.searchTerm) {
            this.filteredAccounts = [...this.accounts];
            return;
        }

        this.filteredAccounts = this.accounts.filter(account => {
            return (
                (account.Name && account.Name.toLowerCase().includes(this.searchTerm)) ||
                (account.Phone && account.Phone.toLowerCase().includes(this.searchTerm)) ||
                (account.Industry && account.Industry.toLowerCase().includes(this.searchTerm)) ||
                (account.Rating && account.Rating.toLowerCase().includes(this.searchTerm))
            );
        });
    }

    handleCellChange(event) {
        const draftValues = event.detail.draftValues;
        this.draftValues = draftValues;

        this.changedFields = [];
        let hasRealChanges = false;

        draftValues.forEach(draftValue => {
            const originalAccount = this.originalAccounts.find(acc => acc.Id === draftValue.Id);

            Object.keys(draftValue).forEach(field => {
                if (field !== 'Id') {
                    const newValue = draftValue[field];
                    const oldValue = originalAccount[field];

                    if (newValue !== oldValue) {
                        hasRealChanges = true;
                        this.changedFields.push({
                            id: `${draftValue.Id}-${field}`,
                            field: field,
                            oldValue: oldValue || 'Empty',
                            newValue: newValue || 'Empty'
                        });
                    }
                }
            });
        });

        this.isSaveDisabled = !hasRealChanges;
    }

    handleSaveClick() {
        if (this.changedFields.length > 0) {
            this.showConfirmDialog = true;
        }
    }

    closeModal() {
        this.showConfirmDialog = false;
    }

    saveChanges() {
        // Prepare updated records
        const updatedAccounts = this.accounts.map(acc => {
            const draftValue = this.draftValues.find(draft => draft.Id === acc.Id);
            return draftValue ? { ...acc, ...draftValue } : acc;
        });

        updateAccounts({ accountsToUpdate: updatedAccounts })
            .then(() => {
                this.accounts = JSON.parse(JSON.stringify(updatedAccounts));
                this.originalAccounts = JSON.parse(JSON.stringify(updatedAccounts));
                this.filterAccounts();
                this.draftValues = [];
                this.changedFields = [];
                this.isSaveDisabled = true;
                this.showConfirmDialog = false;

                // Refresh the table
                this.template.querySelector('lightning-datatable').draftValues = [];

                this.showToast('Success', 'Accounts updated successfully', 'success');
            })
            .catch(() => {
                this.showToast('Error', 'Error updating accounts', 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}
