import { LightningElement, track } from 'lwc';

export default class FormValidation extends LightningElement {
    @track formDetails = {
        name: '',
        address: '',
        checkbox: false,
        radio: null,
    };

    @track errors = {};

    // Handle input changes dynamically
    handleInputChange(event) {
        const { name, value, type, checked } = event.target;

        // Update formDetails based on the field type
        if (type === 'checkbox') {
            this.formDetails[name] = checked;
        } else if (type === 'radio') {
            this.formDetails.radio = value;
        } else {
            this.formDetails[name] = value.trim();
        }

        // Validate the field as the user types
        this.validateField(name);
    }

    // Field validation
    validateField(name) {
        const value = this.formDetails[name];

        if (name === 'checkbox') {
            this.errors.checkbox = !value ? 'This checkbox must be selected.' : '';
        } else if (name === 'radio') {
            this.errors.radio = !this.formDetails.radio ? 'A radio option must be selected.' : '';
        } else {
            this.errors[name] = value === '' ? `The ${name} field is required.` : '';
        }
    }

    // Handle form submission
    handleSubmit() {
        // Validate all fields
        Object.keys(this.formDetails).forEach((key) => {
            this.validateField(key);
        });

        // Check for validation errors
        const hasErrors = Object.values(this.errors).some((error) => error);

        if (!hasErrors) {
            // Log formDetails if no errors
            console.log('Form submitted successfully:', JSON.stringify(this.formDetails, null, 2));

            // Reset formDetails to clear the fields
            this.formDetails = {
                name: '',
                address: '',
                checkbox: false,
                radio: null,
            };

            // Reset errors
            this.errors = {};
        } else {
            console.error('Form validation failed:', this.errors);
        }
    }
}