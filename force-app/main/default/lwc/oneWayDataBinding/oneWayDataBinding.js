import { LightningElement } from 'lwc';
import bankLogo from '@salesforce/resourceUrl/BankLogo';
import cardLogo from '@salesforce/resourceUrl/Card';

export default class OneWayDataBinding extends LightningElement {
     logoUrl = bankLogo;
     cardUrl = cardLogo;
}