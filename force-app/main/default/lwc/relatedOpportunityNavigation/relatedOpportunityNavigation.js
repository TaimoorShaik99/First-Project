/*
 ******************************************************************************************
 * @Name of the Apex   :  relatedOpportunityNavigation
 * @ Description       :  Navigate to Opportunity Record
 * @ Author            :  Taimoor Shaik
 * @ Created Date      :  28-01-2024
 ******************************************************************************************
 * @ Last Modified By         :  Taimoor Shaik
 * @ Last Modified On         :  29-01-2024
 * @ Modification Description : Added extra functionality
 ******************************************************************************************
 */
import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunitiesByAccountId from '@salesforce/apex/OpportunityController.getOpportunitiesByAccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateOpportunityStages from '@salesforce/apex/OpportunityController.updateOpportunityStages';
import getStageNamePicklistValues from '@salesforce/apex/OpportunityController.getStageNamePicklistValues';
import { refreshApex } from '@salesforce/apex';
 
export default class OppWithStageUpdate extends NavigationMixin(LightningElement) {
    @api recordId; // Account ID passed to the component
    opportunities = [];
    error;
    selectedOpportunities = new Set(); // To store selected opportunities
    showModal = false; // Controls the stage selection modal visibility
    showConfirmationModal = false; // Controls the confirmation modal visibility
    selectedStage = ''; // Stores the stage selected in the modal
    stageOptions = [];
    wiredOpportunitiesResult;
 
    // This method will gets the stage values
    @wire(getStageNamePicklistValues)
    wiredStageOptions({ error, data }) {
        if (data) {
            this.stageOptions = data.map(stage => ({
                label: stage,
                value: stage
            }));
        } else if (error) {
            console.error('Error loading stage options:', error);
        }
    }
 
    // This method will gets the opportunity records
    @wire(getOpportunitiesByAccountId, { accountId: '$recordId' })
    wiredOpportunities(result) {
        this.wiredOpportunitiesResult = result;
        if (result.data) {
            this.opportunities = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.opportunities = [];
        }
    }
 
    // When we click on record it will navigate it to new tab
    handleOpportunityClick(event) {
        const opportunityId = event.currentTarget.dataset.id;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: opportunityId,
                actionName: 'view',
            },
        }).then((url) => {
            window.open(url, '_blank');
        });
    }
 
    // Handels checkbox changes
    handleCheckboxChange(event) {
        const opportunityId = event.target.dataset.id;
        if (event.target.checked) {
            this.selectedOpportunities.add(opportunityId);
        } else {
            this.selectedOpportunities.delete(opportunityId);
        }
    }
 
    // Checks weather atleast one record is selected or not and if selected modal will appear
    handleUpdateStage() {
        if (this.selectedOpportunities.size === 0) {
            this.showToast('No Records Selected', 'Please select at least one opportunity to update.', 'warning');
        } else {
            this.showModal = true; // Open the stage selection modal
        }
    }
 
    // The modal will be closed when we click on cross and reset the stage values
    closeModal() {
        this.showModal = false;
        this.selectedStage = ''; // Reset the selected stage
    }
 
    // Confarmation modal will be close when we click on cross
    closeConfirmationModal() {
        this.showConfirmationModal = false;
    }

    // passing stagevalues to stageChnage
    handleStageChange(event) {
        this.selectedStage = event.detail.value;
    }
 
    //If no stage is selected warning message will appear
    confirmStageUpdate() {
        if (!this.selectedStage) {
            this.showToast('No Stage Selected', 'Please select a stage to apply.', 'warning');
            return;
        }
   
        this.showModal = false;
        this.showConfirmationModal = true; // Open the confirmation modal
    }
 
    //applying changes to the records once the stage is selected and toast will popedup and refresh method will be called
    applyStageUpdate() {
        const selectedOpportunityIds = Array.from(this.selectedOpportunities);
   
        updateOpportunityStages({
            opportunityIds: selectedOpportunityIds,
            newStage: this.selectedStage,
        })
            .then(() => {
                this.showToast('Success', 'Opportunities updated successfully.', 'success');
                this.showConfirmationModal = false; // Close the confirmation modal
                this.selectedOpportunities.clear(); // Clear selected opportunities
                this.selectedStage = ''; // Reset the selected stage
                this.uncheckAllCheckboxes();
                return refreshApex(this.wiredOpportunitiesResult); // Refresh opportunities
            })
            .catch((error) => {
                console.error('Error:', error);
                this.showToast('Error', 'Failed to update opportunities.', 'error');
            });
    }
 
    //methid used to uncheck the checkboxes once the stage is selected
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