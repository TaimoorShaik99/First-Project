import { LightningElement, track, api ,wire} from 'lwc';
import getAccounts from '@salesforce/apex/WireTest.getAccounts';
export default class Practice extends LightningElement {

    @api recordId;

    message="Hello World";

    @track greetings;

    handelClick(event){
        this.greetings=event.target.value;
    }

    @track isShow=false;
    handelOnClick(){
        this.isShow=true;
    }
    handeloffClick(){
        this.isShow=false;
    }


    contacts=[];
    error;
    @wire(getAccounts)
    getAccounts
       /*if(data){
            this.contacts=data;
            this.error=undefined;
        }
        if(error){
            this.error=error;
            this.contacts=undefined;
        }
    }*/
}