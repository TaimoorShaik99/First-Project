import { LightningElement, track, wire } from 'lwc';
import fetchAllMetadata from '@salesforce/apex/ObjectMetadataWrapper.fetchAllMetadata';

export default class DynamicFormLWC extends LightningElement {
    @track metadataList = [];
    @track formData = {};
    objectNames = ['Personal_Shareholder__c', 'Personal_Shareholder_Address__c']; // Example object name

    @wire(fetchAllMetadata, { objectNames: '$objectNames' })
    wiredMetadata({ error, data }) {
        console.log('Fetching metadata for:', this.objectNames);
        
        if (data) {
            this.metadataList = data;
            console.log('Fetched Metadata:', JSON.stringify(this.metadataList, null, 2));

            // Initialize form data object with empty values
            this.metadataList.forEach(field => {
                this.formData[field.fieldName] = field.picklistValues ? '' : null;
            });
        } else if (error) {
            console.error('Error fetching metadata:', JSON.stringify(error, null, 2));
        }
    }

    handleInputChange(event) {
        const fieldName = event.target.dataset.id;
        this.formData[fieldName] = event.target.value;
        console.log('Updated form data:', JSON.stringify(this.formData, null, 2));
    }

    handleSubmit() {
        console.log('Final Form Data for Submission:', JSON.stringify(this.formData, null, 2));
        alert('Form submitted! Check the console for details.');
    }
}
