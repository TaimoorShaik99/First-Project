import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ValidationForm extends LightningElement {
    @track formData = {
        firstName: '',
        lastName: '',
        email: '',
        mobileNumber: '',
        registrationId:' ',
        description: '',
        checkbox: [],
        radio: ''
    };

    @track errors = {};

    handleChange(event) {
        const { name, value, type, checked } = event.target; 

        if (type === 'checkbox') {
            let options = [this.formData.checkbox];
            if (checked) {
                options.push(value);
            } else {
                options = options.filter(option => option !== value);
            }
            this.formData.checkbox = options;
        } else if (type === 'radio') {
            this.formData.radio = value;
        } else {
            this.formData[name] = value;
            // this.formData = {...this.formData, [name]: value};
        }

        this.errors[name] = ''; 
    }

    // /handleChange(event) {
    //     const { name, value, type, checked } = event.target; 

    //     if (type === 'checkbox') {
    //         let options = [...this.formData.checkbox];
    //         if (checked) {
    //             options.push(value);
    //         } else {
    //             options = options.filter(option => option !== value);
    //         }
    //         this.formData = { ...this.formData, [name]: options };
    //     } else if (type === 'radio') {
    //         this.formData = { ...this.formData, [name]: value };
    //     } else {
    //         this.formData = { ...this.formData, [name]: value };
    //     }

    validateForm() {
        const errors = {};
        const { firstName, lastName, email, mobileNumber, description,registrationId, checkbox, radio } = this.formData;

        if (!firstName) errors.firstName = 'First Name is required.';
        if (!lastName) errors.lastName = 'Last Name is required.';
        if (!email) {
            errors.email = 'Email is required.';
        } else if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$/.test(email)) {
            errors.email = 'Enter a valid email address.';
        }
        if (!mobileNumber) {
            errors.mobileNumber = 'Mobile Number is required.';
        } else if (!/^\d{10}$/.test(mobileNumber)) {
            errors.mobileNumber = 'Mobile Number must be 10 digits.';
        }
        if (!description) {
            errors.description = 'Description is required.';
        } else if (description.length < 10) {
            errors.description = 'Description must be at least 20 characters long.';
        }
        if (checkbox.length === 0) errors.checkbox = 'At least one checkbox must be selected.';
        if (!radio) errors.radio = 'A rating must be selected.';

        if (!registrationId) {
            errors.registrationId = 'Registration ID is required.';
        } else if (!/^[a-zA-Z0-9]{10}$/.test(registrationId)) {
            errors.registrationId = 'Registration ID must be alphanumeric and exactly 10 characters long.';
        }

        this.errors = errors;
        return Object.keys(errors).length === 0;
    }

    handleSubmit() {
        if (this.validateForm()) {
            this.showToast('Success', 'Form submitted successfully!', 'success');
            console.log('Form Data:', JSON.stringify(this.formData));
        } 
        // else {
        //     this.showToast('Error', 'Please fix the errors in the form.', 'error');
        //     console.error('Validation errors:', JSON.stringify(this.errors));
        // }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}
