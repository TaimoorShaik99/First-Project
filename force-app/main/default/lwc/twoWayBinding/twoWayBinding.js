import { LightningElement, track } from 'lwc';

export default class TwoWayBinding extends LightningElement {
   @track message

   handelChange(event){
    this.message=event.target.value;
   }
    
}