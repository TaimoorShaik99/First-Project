import { LightningElement } from 'lwc';

export default class CpParentComponent extends LightningElement {
    num=0;
    handelsubtractevent(event){
     
        this.num=this.num-1;
    }

    handeladdevent(event){
        this.num=this.num+1;
    }
}