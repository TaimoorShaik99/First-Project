import { LightningElement } from 'lwc';

export default class SldsExample extends LightningElement {
    handleSubmit() {
        const firstName = this.template.querySelector('#firstName').value;
        const lastName = this.template.querySelector('#lastName').value;
        const email = this.template.querySelector('#email').value;
        const phone = this.template.querySelector('#phone').value;

        console.log(`First Name: ${firstName}`);
        console.log(`Last Name: ${lastName}`);
        console.log(`Email: ${email}`);
        console.log(`Phone Number: ${phone}`);
    }
}