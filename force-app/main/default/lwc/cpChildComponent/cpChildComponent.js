import { LightningElement, api} from 'lwc';

export default class CpChildComponent extends LightningElement {
    handelsub(){
        const eve = new CustomEvent('subtractevent');
        this.dispatchEvent(eve);
    }

    handeladd(){
        this.dispatchEvent(new CustomEvent('addevent'));
    }
}