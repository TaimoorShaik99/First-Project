import { LightningElement,track } from 'lwc';

export default class HGrandParent extends LightningElement {
    @track selectedCount = 0;
 
    handleStatusChange(event) {
        this.selectedCount = event.detail.selectedCount;
    }
 
    handleReset() {
        // Reset the selected count
        this.selectedCount = 0;
 
        // Call the reset method on the parent component
        this.template.querySelector('c-h-parent').resetChildren();
    }
}