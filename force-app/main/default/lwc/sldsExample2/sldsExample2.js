import { LightningElement } from 'lwc';

export default class SldsExample2 extends LightningElement {

    getFirstName(event){
        console.log('First Name: ',event.target.value);
    }

    handleSubmit(event) {
        const firstName = this.template.querySelector('#text-input-id-46').value;
        const lastName = this.template.querySelector('#text-input-id-47').value;
        const email = this.template.querySelector('#text-input-id-48').value;
        const mobileNo = this.template.querySelector('#text-input-id-49').value;

        // Log the values to the console
        console.log(this.firstName);
        console.log(`Last Name: ${lastName}`);
        console.log(`Email Id: ${email}`);
        console.log(`Mobile No: ${mobileNo}`);
    }
}