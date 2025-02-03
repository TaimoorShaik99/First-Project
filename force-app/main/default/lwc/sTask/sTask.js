import { LightningElement, track } from 'lwc';
 
export default class Assignment extends LightningElement {
    @track accounts = [
        {
            id: 'optimum',
            name: 'Optimum Bank Account',
            description: 'The Optimum current account offers secure 24/7 digital banking and a Visa debit card.',
            currencies: 'GBP, USD, EUR, AUD',
            selected: false,
            badgeColor: '#0033CC', // Blue badge
            className: 'account-card'
        },
        {
            id: 'platinum',
            name: 'Platinum Optimum Bank Account',
            description: 'Open an international bank account with exclusive benefits tailored to private banking clients.',
            currencies: 'GBP, USD, EUR, AUD',
            selected: false,
            badgeColor: '#CC0033', // Red badge
            className: 'account-card'
        },
        {
            id: 'seafarer',
            name: 'Seafarer Bank Account',
            description: 'A Seafarer account is designed specifically for yacht crew who may need to bank in multiple currencies.',
            currencies: 'GBP, USD, EUR, AUD',
            selected: false,
            badgeColor: '#FF9900', // Yellow badge
            className: 'account-card'
        },
        {
            id: 'professional',
            name: 'Professional Demand',
            description: 'A unique international current account available exclusively to Independent Financial Advisors.',
            currencies: 'GBP, USD, EUR, AUD',
            selected: false,
            badgeColor: '#33CC33', // Green badge
            className: 'account-card'
        }
    ];
 
    get disableSubmit() {
        return !this.accounts.some((account) => account.selected);
    }
 
    handleSelection(event) {
        const accountId = event.currentTarget.dataset.id;
        this.updateSelection(accountId);
    }
 
    handleRadioChange(event) {
        const accountId = event.target.value;
        this.updateSelection(accountId);
    }
 
    updateSelection(accountId) {
        this.accounts = this.accounts.map((account) => {
            const isSelected = account.id === accountId;
 
            return {
                ...account,
                selected: isSelected,
                className: `account-card ${isSelected ? 'selected' : ''}`
            };
        });
    }
 
    startApplication() {
        const selectedAccount = this.accounts.find((account) => account.selected);
        if (selectedAccount) {
            console.log('Application started for:', selectedAccount.name);
            alert(`You have selected: ${selectedAccount.name}`);
        }
    }
}