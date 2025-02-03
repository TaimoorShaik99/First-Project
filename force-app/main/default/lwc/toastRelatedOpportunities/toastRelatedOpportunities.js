// RelatedOpportunities.js
import { LightningElement, track } from 'lwc';
import updateOpportunityStages from '@salesforce/apex/AccountControllerNav.updateOpportunityStages';

export default class RelatedOpportunities extends LightningElement {
    @track selectedOpportunities = new Set();
    @track selectedStage = '';
    @track showModal = false;
    @track showConfirmationModal = false;

    showToast(message, variant, duration = 3000) {
        // Query the child component
        const toastComponent = this.template.querySelector('c-custom-toast-message');
        if (toastComponent) {
            toastComponent.showToast(message, variant, duration);
        }
    }

    applyStageUpdate() {
        const selectedOpportunityIds = Array.from(this.selectedOpportunities);

        updateOpportunityStages({ opportunityIds: selectedOpportunityIds, newStage: this.selectedStage })
            .then(() => {
                this.showToast('Success', 'Opportunities updated successfully.', 'success');
                this.showConfirmationModal = false;
                // Reset selections
                this.selectedOpportunities = new Set();
                this.selectedStage = '';
            })
            .catch(() => {
                this.showToast('Error', 'Failed to update opportunities.', 'error');
            });
    }
}
