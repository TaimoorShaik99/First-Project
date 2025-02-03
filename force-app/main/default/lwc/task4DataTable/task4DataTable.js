import { LightningElement, track, wire } from 'lwc';
import getAccountList from '@salesforce/apex/DataTable.getAccountList';

export default class Task4DataTable extends LightningElement {

    @track data;
    
    @track columsList = [
        {label: 'Name', fieldName: 'Name', type: 'text'},
        {label: 'Phone', fieldName: 'Phone', type: 'Phone'}
    ];

    // @track datList =[];
    

    @wire(getAccountList) wiredAccounts ({ error, data }) {
        console.log(data);
        if (data) {
            this.data = data; 
       } else if (error) { 
           this.error = error;  
      }   }
    }

