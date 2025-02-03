import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    message='Hi iam from child';
    handelsubmit(){
        this.dispatchEvent(new CustomEvent('clickevent', {detail:{msg: this.message},bubbles:true, composed:true}));
    }
}