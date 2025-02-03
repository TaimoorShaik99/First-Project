// CustomToastMessage.js
import { LightningElement, api, track } from 'lwc';

export default class CustomToastMessage extends LightningElement {
    @api message = '';
    @api variant = 'success'; // 'success', 'warning', 'error'
    @track isVisible = false;

    @api
    showToast(message, variant = 'success', duration = 3000) {
        this.message = message;
        this.variant = variant;
        this.isVisible = true;

        setTimeout(() => {
            this.isVisible = false;
        }, duration);
    }

    handleClose() {
        this.isVisible = false;
    }
}
