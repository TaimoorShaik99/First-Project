import { LightningElement } from 'lwc';

export default class Task3ParentComponent extends LightningElement {
    parentmessage = "Hello i am from parent";
    number=0;
    handelchange(event){
        this.number= parseInt(event.target.value);
    }
    handelclick(event){
        this.template.querySelector('c-task3-child-component').increment();
    }
}