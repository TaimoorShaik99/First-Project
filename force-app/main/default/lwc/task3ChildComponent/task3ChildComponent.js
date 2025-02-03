import { LightningElement, api} from 'lwc';

export default class Task3ChildComponent extends LightningElement {
    @api message;
    @api num;
    @api increment(){
        this.num=this.num+100;
    }
    
}