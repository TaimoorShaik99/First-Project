import { LightningElement, track } from 'lwc';

export default class RecordForms extends LightningElement {
    @track formDetails = {
        textField: '',
        textAreaField: '',
        radioField: '',
        checkboxField: false
    };

    @track errors = {};

    // Handle input change for all fields dynamically
    handleInputChange(event) {
        const { name, value, type, checked } = event.target;
        this.formDetails[name] = type === 'checkbox' ? checked : value;

        // Validate the field
        this.validateField(name, value, type, checked);
    }

    // Field validation method
    validateField(name, value, type, checked) {
        switch (name) {
            case 'textField':
                this.errors[name] = value.trim() === '' ? 'Text field is required.' : '';
                break;
            case 'textAreaField':
                this.errors[name] = value.trim() === '' ? 'Textarea is required.' : '';
                break;
            case 'radioField':
                this.errors[name] = value.trim() === '' ? 'Please select a radio option.' : '';
                break;
            case 'checkboxField':
                this.errors[name] = checked ? '' : 'Please check this box.';
                break;
            default:
                break;
        }
    }

    // Form submission method
    handleSubmit() {
        // Validate all fields
        Object.keys(this.formDetails).forEach((key) => {
            const value = this.formDetails[key];
            const type = typeof value === 'boolean' ? 'checkbox' : 'text';
            this.validateField(key, value, type, value);
        });

        // Check for any errors
        const hasErrors = Object.values(this.errors).some((error) => error);

        if (!hasErrors) {
            console.log('Form submitted successfully:', this.formDetails);
        } else {
            console.error('Form validation failed:', this.errors);
        }
    }
}