import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunitiesByAccountId from '@salesforce/apex/OpportunityController.getOpportunitiesByAccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateOpportunityStages from '@salesforce/apex/OpportunityController.updateOpportunityStages';
import getStageNamePicklistValues from '@salesforce/apex/OpportunityController.getStageNamePicklistValues';
 
export default class UsingImperative extends LightningElement {
    @api recordId; // Account ID passed to the component
    @track opportunities = [];
    error;
    selectedOpportunities = new Set(); // To store selected opportunities
    showModal = false; // Controls the stage selection modal visibility
    showConfirmationModal = false; // Controls the confirmation modal visibility
    selectedStage = ''; // Stores the stage selected in the modal
    stageOptions = [];
 
    connectedCallback() {
        this.fetchOpportunities();
        this.fetchStageOptions();
    }
 
    fetchOpportunities() {
        getOpportunitiesByAccountId({ accountId: this.recordId })
            .then((data) => {
                this.opportunities = data;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.opportunities = [];
            });
    }    
 
    fetchStageOptions() {
        getStageNamePicklistValues()
            .then((data) => {
                this.stageOptions = data.map((stage) => ({
                    label: stage,
                    value: stage,
                }));
            })
            .catch((error) => {
                console.error('Error loading stage options:', error);
            });
    }
 
    handleOpportunityClick(event) {
    const opportunityId = event.currentTarget.dataset.id;

    // Generate the URL and open it synchronously
    this[NavigationMixin.GenerateUrl]({
        type: 'standard__recordPage',
        attributes: {
            recordId: opportunityId,
            actionName: 'view',
        },
    })
    .then((url) => {
        // Ensure the window.open is part of the promise resolution
        window.open(url, '_blank');
    })
    .catch((error) => {
        console.error('Error generating URL:', error);
    });
}
 
    handleCheckboxChange(event) {
        const opportunityId = event.target.dataset.id;
        if (event.target.checked) {
            this.selectedOpportunities.add(opportunityId);
        } else {
            this.selectedOpportunities.delete(opportunityId);
        }
    }
 
    handleUpdateStage() {
        if (this.selectedOpportunities.size === 0) {
            this.showToast('No Records Selected', 'Please select at least one opportunity to update.', 'warning');
        } else {
            this.showModal = true; // Open the stage selection modal
        }
    }
 
    closeModal() {
        this.showModal = false;
        this.selectedStage = ''; // Reset the selected stage
    }
 
    closeConfirmationModal() {
        this.showConfirmationModal = false;
    }
 
    handleStageChange(event) {
        this.selectedStage = event.detail.value;
    }
 
    confirmStageUpdate() {
        if (!this.selectedStage) {
            this.showToast('No Stage Selected', 'Please select a stage to apply.', 'warning');
            return;
        }
 
        this.showModal = false;
        this.showConfirmationModal = true; // Open the confirmation modal
    }
 
    applyStageUpdate() {
        const selectedOpportunityIds = Array.from(this.selectedOpportunities);
 
        updateOpportunityStages({
            opportunityIds: selectedOpportunityIds,
            newStage: this.selectedStage,
        }).then(() => {
                console.log('Opportunities updated successfully.');
                this.showToast('Success', 'Opportunities updated successfully.', 'success');
                this.showConfirmationModal = false; // Close the confirmation modal
                this.selectedOpportunities.clear(); // Clear selected opportunities
                this.selectedStage = ''; // Reset the selected stage
                this.uncheckAllCheckboxes();  // Uncheck all selected checkboxes
                this.fetchOpportunities(); // Refresh opportunities
            })
            .catch((error) => {
                console.log('Error:', error);
                this.showToast('Error', 'Failed to update opportunities.', 'error');
            });
    }
 
    uncheckAllCheckboxes() {
        const checkboxes = this.template.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach((checkbox) => {
            checkbox.checked = false;
        });
    }
 
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}