import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    msgfromchild='';
    handelclcikevent(event){
        this.msgfromchild=event.detail.msg; 
    }
    handelclcikeventdiv(event){
        this.msgfromchild='Hi iam from parent div';
    }

}