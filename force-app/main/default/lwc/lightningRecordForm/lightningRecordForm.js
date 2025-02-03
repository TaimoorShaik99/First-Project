import { LightningElement } from 'lwc';

export default class LightningRecordForm extends LightningElement {

    fields=['First Name', 'Last Name'];
    handelsubmit(event){
        event.preventDefault();
        const fields=event.detail.fields;
        this.template.querySelector('Lightning-record-form').submit(fields);
    }
    handelerror(event){
        console.error('error creating record: ', event.detail);
    }
}