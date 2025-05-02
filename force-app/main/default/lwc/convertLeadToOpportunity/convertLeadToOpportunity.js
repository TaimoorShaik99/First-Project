import { LightningElement, api, track } from 'lwc';
import convertLeadToOpportunity from '@salesforce/apex/LeadConversionController.convertLeadToOpportunity';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ConvertLeadToOpportunity extends LightningElement {
    @api recordId; // The current Lead record ID
    @track isConverting = false;
    @track message = '';

    handleConvertLead() {
        this.isConverting = true;
        convertLeadToOpportunity({ leadId: this.recordId })
            .then(result => {
                if (result === 'Success') {
                    this.message = 'Lead successfully converted to Opportunity!';
                    this.showToast('Success', this.message, 'success');

                    // Refresh the record page to reflect changes
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    this.message = 'Conversion failed: ' + result;
                    this.showToast('Error', this.message, 'error');
                }
            })
            .catch(error => {
                this.message = 'Error: ' + error.body.message;
                this.showToast('Error', this.message, 'error');
            })
            .finally(() => {
                this.isConverting = false;
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
