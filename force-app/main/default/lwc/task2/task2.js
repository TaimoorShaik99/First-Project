import { LightningElement, track } from 'lwc';
import createOrUpdateAccount from '@salesforce/apex/AccountController.createOrUpdateAccount';
export default class Task2 extends LightningElement {
    @track accountId; 
    @track accountName;
    @track accountNumber;
    @track billingStreet;
    @track billingCity;
    @track billingState;
    @track billingPostalCode;
    @track billingCountry;
    @track description;

    handleInputChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    handleSubmit() {
        this.validationErrors = {}; // Clear previous errors

        // Validation for account number length
        if (this.formDetails.accountNumber && this.formDetails.accountNumber.length > 5) {
            this.validationErrors.accountNumber = 'Account Number must not exceed 5 digits.';
        }

        const fields = {
            Id: this.accountId || null, 
            Name: this.accountName,
            AccountNumber: this.accountNumber.replace(/,/g, ''),
            BillingStreet: this.billingStreet,
            BillingCity: this.billingCity,
            BillingState: this.billingState,
            BillingPostalCode: this.billingPostalCode,
            BillingCountry: this.billingCountry,
            Description: this.description,
        };

        
        createOrUpdateAccount({ accountData })
            .then((result) => {
                alert('Account saved successfully!');
                console.log('Result:', result);

               
                this.accountId = result.Id;
            })
            .catch((error) => {
                console.error('Error:', error);
                alert('An error occurred while saving the account.');
            });
        }
}