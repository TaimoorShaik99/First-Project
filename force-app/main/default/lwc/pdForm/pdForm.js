import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPicklistFields from '@salesforce/apex/PersonalDetailsPicklistController.getPicklistFields';
import savePersonalDetails from '@salesforce/apex/PersonalDetailsPicklistController.savePersonalDetails';

export default class PersonalInformation extends LightningElement {
    @track formData = {
        title__c: '',
        First_Name__c: '',
        Surname__c: '',
        Middle_Name__c: '',
        former_name_or_maiden_name__c: '',
        other_name__c: '',
        Other_First_Name__c: '',
        gender__c: '',
        Date_of_Birth__c: '',
        marital_status__c: '',
        country_of_birth__c: '',
        town_city_of_birth__c: '',
        country_of_residence__c: '',
        primary_contact_of_nationality__c: '',
        secondary_country_of_nationality__c: '',
        identification_type__c: '',
        Identification_Number__c: ''
    };

    @track picklistValues = {
        title__c: [],
        former_name_or_maiden_name__c: [],
        other_name__c: [],
        gender__c: [],
        marital_status__c: [],
        country_of_birth__c: [],
        town_city_of_birth__c: [],
        country_of_residence__c: [],
        primary_contact_of_nationality__c: [],
        secondary_country_of_nationality__c: [],
        identification_type__c: []
    };

    @track formErrors = {};

    connectedCallback() {
        this.fetchPicklistValues();
    }

    fetchPicklistValues() {
        getPicklistFields()
            .then((result) => {
                for (const [fieldName, values] of Object.entries(result)) {
                    if (this.picklistValues.hasOwnProperty(fieldName)) {
                        this.picklistValues[fieldName] = values.map((value) => ({
                            label: value,
                            value: value
                        }));
                    }
                }
            })
            .catch((error) => {
                console.error('Error fetching picklist values:', error);
            });
    }

    handleChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;
        this.formData = { ...this.formData, [field]: value };

        // Clear error message when the user modifies the field
        this.formErrors = { ...this.formErrors, [field]: '' };
    }

    handleSubmit() {
        let isValid = true;
        this.formErrors = {}; // Reset previous errors

        const inputs = [...this.template.querySelectorAll('input, select')];

        for (const input of inputs) {
            const field = input.dataset.field;
            const value = this.formData[field];

            if (input.required && !value) {
                isValid = false;
                this.formErrors[field] = `${input.id} is required.`;
            } else if (field === 'Identification_Number__c' && !/^[a-zA-Z0-9]{15}$/.test(value)) {
                isValid = false;
                this.formErrors[field] = 'Identification Number must be exactly 15 alphanumeric characters.';
            }
        }

        // Submit only if the form is valid
        if (isValid) {
            console.log('Form Data:', JSON.stringify(this.formData));

            savePersonalDetails({ formData: this.formData })
                .then((result) => {
                    // Clear the form fields and reset errors
                    this.clearForm();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Record saved successfully!',
                            variant: 'success',
                        })
                    );
                })
                .catch((error) => {
                    console.error('Error saving record:', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Error saving record. Please try again.',
                            variant: 'error',
                        })
                    );
                });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please fill in all required fields correctly.',
                    variant: 'error',
                })
            );
        }
    }

    clearForm() {
        this.formData = {
            title__c: '',
            First_Name__c: '',
            Surname__c: '',
            Middle_Name__c: '',
            former_name_or_maiden_name__c: '',
            other_name__c: '',
            Other_First_Name__c: '',
            gender__c: '',
            Date_of_Birth__c: '',
            marital_status__c: '',
            country_of_birth__c: '',
            town_city_of_birth__c: '',
            country_of_residence__c: '',
            primary_contact_of_nationality__c: '',
            secondary_country_of_nationality__c: '',
            identification_type__c: '',
            Identification_Number__c: ''
        };
        this.formErrors = {}; // Reset errors
        this.template.querySelectorAll('input, select').forEach((field) => {
            field.value = '';
        });
    }
}
