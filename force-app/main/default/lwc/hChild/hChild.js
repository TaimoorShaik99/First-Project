import { LightningElement, api, track } from 'lwc';

export default class HChild extends LightningElement {
    @api childName;
    @api index;
    @track state = 'Deselected';
 
    get buttonLabel() {
        return this.state === 'Selected' ? 'Deselect' : 'Select';
    }
 
    get buttonClass() {
        return this.state === 'Selected' ? 'slds-button slds-button_destructive' : 'slds-button slds-button_success';
    }
 
    toggleState() {
        // Toggle between 'Selected' and 'Deselected'
        this.state = this.state === 'Selected' ? 'Deselected' : 'Selected';
 
        // Notify the parent about the state change
        const stateChangeEvent = new CustomEvent('statechange', {
            detail: { index: this.index, state: this.state }
        });
        this.dispatchEvent(stateChangeEvent);
    }
 
    @api
    resetState() {
        // Reset the state to 'Deselected'
        this.state = 'Deselected';
    }
}