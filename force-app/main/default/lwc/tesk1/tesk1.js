import { LightningElement } from 'lwc';

export default class Tesk1 extends LightningElement {
    firstName;
    lastName;
    email;
    mobileNo;
    handelchange(event){
        const field = event.target.name;
        if (field === "firstName") {
          this.firstName = event.target.value;
        } else if (field === "lastName") {
          this.lastName = event.target.value;
        }
        else if (field === "email") {
          this.email = event.target.value;
        }
          else if (field === "mobileNo") {
          this.mobileNo = event.target.value;
        }
    }
    handleSubmit(event){
        console.log("First Name: ",this.firstName);
        console.log("Last Name: ",this.lastName);
        console.log("Email: ", this.email);
        console.log("Mobile No: ", this.mobileNo);
    }

    
}