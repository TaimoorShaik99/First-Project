/*
 ******************************************************************************************
 * @Name of the LWC    :  rlatedOpportunity.js
 * @ Description       :  To get opportunity records and to update stage field 
 * @ Author            :  Taimoor Shaik
 * @ Created Date      :  31-01-2024
 ******************************************************************************************
 * @ Last Modified By         :  Taimoor Shaik
 * @ Last Modified On         :  31-01-2024
 * @ Modification Description : Added extra functionality
 ******************************************************************************************
 */

 // GitTest....... .
 import { LightningElement, track } from 'lwc';
 import { NavigationMixin } from 'lightning/navigation';
 import getOpportunities from '@salesforce/apex/AccountControllerNav.getOpportunities';
 import updateOpportunityStages from '@salesforce/apex/AccountControllerNav.updateOpportunityStages';
 import getStageNamePicklistValues from '@salesforce/apex/AccountControllerNav.getStageNamePicklistValues';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
 export default class RelatedOpportunities extends NavigationMixin(LightningElement) {
     @track accountId;
     @track opportunities = [];
     @track paginatedOpportunities = [];
     @track selectedOpportunities = new Set();
     @track showModal = false;
     @track showConfirmationModal = false;
     @track selectedStage = '';
     @track stageOptions = [];
     
     @track currentPage = 1;
     pageSize = 2; // Set records per page to 2
     totalPages = 0;
 
     connectedCallback() {
         this.getAccountIdFromUrl();
         this.fetchOpportunities();
         this.fetchStageOptions();
     }
 
     getAccountIdFromUrl() {
         const currentPageRef = window.location.href;
         const urlParams = new URLSearchParams(new URL(currentPageRef).search);
         this.accountId = urlParams.get('c__recordId');
     }
 
     fetchOpportunities() {
         if (!this.accountId) return;
 
         getOpportunities({ accountId: this.accountId })
             .then((data) => {
                 this.opportunities = [...data]; // Ensures reactivity
                 this.calculatePagination();
             })
             .catch(() => {
                 this.opportunities = [];
             });
     }
 
     fetchStageOptions() {
         getStageNamePicklistValues()
             .then((data) => {
                 this.stageOptions = data.map(stage => ({ label: stage, value: stage }));
             })
             .catch(() => {
                 this.stageOptions = [];
             });
     }
 
     calculatePagination() {
         this.totalPages = Math.ceil(this.opportunities.length / this.pageSize);
         this.updatePaginatedOpportunities();
     }
 
     updatePaginatedOpportunities() {
         const startIndex = (this.currentPage - 1) * this.pageSize;
         const endIndex = startIndex + this.pageSize;
         this.paginatedOpportunities = this.opportunities.slice(startIndex, endIndex);
     }
 
     previousPage() {
         if (this.currentPage > 1) {
             this.currentPage--;
             this.updatePaginatedOpportunities();
         }
     }
 
     nextPage() {
         if (this.currentPage < this.totalPages) {
             this.currentPage++;
             this.updatePaginatedOpportunities();
         }
     }
 
     get isFirstPage() {
         return this.currentPage === 1;
     }
 
     get isLastPage() {
         return this.currentPage === this.totalPages;
     }
 
     // handleOpportunityClick(event) {
     //     const opportunityId = event.currentTarget.dataset.id;
     //     this[NavigationMixin.GenerateUrl]({
     //         type: 'standard__recordPage',
     //         attributes: { recordId: opportunityId, actionName: 'view' },
     //     }).then(url => {
     //         window.open(url, '_blank');
     //     });
     // }
 
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
             this.showModal = true;
         }
     }
 
     closeModal() {
         this.showModal = false;
         this.selectedStage = '';
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
         this.showConfirmationModal = true;
     }
 
     applyStageUpdate() {
        // Convert selected opportunities (stored in a Set) to an array
        const selectedOpportunityIds = Array.from(this.selectedOpportunities);
    
        // Create an array of promises for updating each opportunity
        const updatePromises = selectedOpportunityIds.map(opportunityId => {
            return updateOpportunityStages({ opportunityIds: [opportunityId], newStage: this.selectedStage })
                .then(() => {
                    // Update the stage for the current opportunity in the local state (map)
                    this.opportunities = this.opportunities.map(opp =>
                        opp.Id === opportunityId
                            ? { ...opp, StageName: this.selectedStage }
                            : opp
                    );
                });
        });
    
        // Wait for all update operations to complete using Promise.all
        Promise.all(updatePromises)
            .then(() => {
                this.showToast('Success', 'Opportunities updated successfully.', 'success');
                this.showConfirmationModal = false;
    
                // Update paginated opportunities to reflect changes in the UI
                this.updatePaginatedOpportunities();
    
                // Reset selections and close modals
                this.selectedOpportunities.clear();
                this.selectedStage = '';
                this.uncheckAllCheckboxes();
            })
            .catch(() => {
                this.showToast('Error', 'Failed to update opportunities.', 'error');
            });
    }
    
 
     uncheckAllCheckboxes() {
         const checkboxes = this.template.querySelectorAll('.checkboxes');
         checkboxes.forEach(checkbox => {
             checkbox.checked = false;
         });
         this.selectedOpportunities = new Set(); // Ensure reactivity
     }
 
     showToast(title, message, variant) {
         this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
     }
 }
 