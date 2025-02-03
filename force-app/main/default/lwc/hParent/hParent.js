import { LightningElement,track, api } from 'lwc';

export default class HParent extends LightningElement {
    @track childStatuses = ['Deselected', 'Deselected', 'Deselected'];
 
    handleChildStateChange(event) {
        const index = event.detail.index;
        const newState = event.detail.state;
 
        // Update the status of the child
        this.childStatuses[index] = newState;
 
        // Notify the Grandparent about the number of selected children
        const selectedCount = this.childStatuses.filter(status => status === 'Selected').length;
        const statusChangeEvent = new CustomEvent('statuschange', {
            detail: { selectedCount }
        });
        this.dispatchEvent(statusChangeEvent);
    }
 
    @api
    resetChildren() {
        // Reset all child statuses
        this.childStatuses = ['Deselected', 'Deselected', 'Deselected'];
 
        // Call the reset method on all child components
        this.template.querySelectorAll('c-h-child').forEach(child => {
            child.resetState();
        });
    }
 
    get childOneStatus() {
        return this.childStatuses[0];
    }
 
    get childTwoStatus() {
        return this.childStatuses[1];
    }
 
    get childThreeStatus() {
        return this.childStatuses[2];
    }




    
}
