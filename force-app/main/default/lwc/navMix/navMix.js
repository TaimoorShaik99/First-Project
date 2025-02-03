import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunitiesByAccountId from '@salesforce/apex/OpportunityController.getOpportunitiesByAccountId';
export default class NavMix extends LightningElement {
    @api recordId; // Automatically populated with the Account record's ID
    opportunities = [];
    error;
 
    // Fetch opportunities using @wire
    @wire(getOpportunitiesByAccountId, { accountId: '$recordId' })
    wiredOpportunities({ data, error }) {
        if (data) {
            this.opportunities = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.opportunities = [];
        }
    }
 
    // Handle navigation to Opportunity record page
    handleNavigate(event) {
        const opportunityId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: opportunityId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }
}