/*
 ******************************************************************************************
 * @Name of the LWC    :  accountTable.js
 * @ Description       :  To get account records
 * @ Author            :  Taimoor Shaik
 * @ Created Date      :  31-01-2024
 ******************************************************************************************
 * @ Last Modified By         :  Taimoor Shaik
 * @ Last Modified On         :  31-01-2024
 * @ Modification Description : Added extra functionality
 ******************************************************************************************
 */
 import { LightningElement, track } from 'lwc';
 import { NavigationMixin } from 'lightning/navigation';
 import getAccounts from '@salesforce/apex/AccountControllerNav.getAccounts';
 
 export default class AccountTable extends NavigationMixin(LightningElement) {
     @track accounts = [];
     @track paginatedAccounts = [];
     @track currentPage = 1;
     pageSize = 5; // Set records per page
 
     totalPages = 0;
     error;
 
     connectedCallback() {
         this.fetchAccounts();
     }
 
     fetchAccounts() {
         getAccounts()
             .then((data) => {
                 this.accounts = data;
                 this.error = undefined;
                 this.calculatePagination();
             })
             .catch((error) => {
                 this.error = error;
                 this.accounts = [];
             });
     }
 
     // Calculate total pages and update the paginated list
     calculatePagination() {
         this.totalPages = Math.ceil(this.accounts.length / this.pageSize);
         this.updatePaginatedAccounts();
     }
 
     // Update accounts for the current page
     updatePaginatedAccounts() {
         const startIndex = (this.currentPage - 1) * this.pageSize;
         const endIndex = startIndex + this.pageSize;
         this.paginatedAccounts = this.accounts.slice(startIndex, endIndex);
     }
 
     // Navigate to previous page
     previousPage() {
         if (this.currentPage > 1) {
             this.currentPage--;
             this.updatePaginatedAccounts();
         }
     }
 
     // Navigate to next page
     nextPage() {
         if (this.currentPage < this.totalPages) {
             this.currentPage++;
             this.updatePaginatedAccounts();
         }
     }
 
     // Check if we are on the first page
     get isFirstPage() {
         return this.currentPage === 1;
     }
 
     // Check if we are on the last page
     get isLastPage() {
         return this.currentPage === this.totalPages;
     }
 
     // Navigate to "View Opportunities" page
     handleViewOpportunities(event) {
        const accountId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'relatedopportunities'  // page name
            },
            state: {
                c__recordId: accountId
            }
        });
    }
 }
 