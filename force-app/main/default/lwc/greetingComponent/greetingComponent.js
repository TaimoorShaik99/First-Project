import { LightningElement, track } from 'lwc';

export default class GreetingComponent extends LightningElement {
    @track userName = ''; // To hold the value of the input field
    @track greetingMessage = ''; // To hold the greeting message

    // Handle input change and update the greeting message
    handleInputChange(event) {
        this.userName = event.target.value;
        if (this.userName) {
            this.greetingMessage = `Hello, ${this.userName}!`;
        } else {
            this.greetingMessage = '';
        }
    }
}
