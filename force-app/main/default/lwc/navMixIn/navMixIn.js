import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunitiesByAccount from '@salesforce/apex/OpportunityController.getOpportunitiesByAccountId';
 
export default class navMixIn extends NavigationMixin(LightningElement) {
    @api recordId; 
    opportunities = [];
    error;
 
    @wire(getOpportunitiesByAccount, { accountId: '$recordId' })
    wiredOpportunities({ data, error }) {
        if (data) {
            this.opportunities = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.opportunities = [];
        }
    }
 
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
        }).catch((error) => {
            console.error('Error generating URL:', error);
        });
    }
}