import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/WireTest.getAccounts';

export default class WireTest extends LightningElement {
    @wire (getAccounts)
    getAccounts;
}