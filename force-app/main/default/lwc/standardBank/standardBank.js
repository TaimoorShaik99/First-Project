import { LightningElement, wire, track } from 'lwc';
import getContacts from "@salesforce/apex/ContactController.getContacts";
import banklogo from '@salesforce/resourceUrl/banklogo';
import card2 from '@salesforce/resourceUrl/card2';

export default class StandardBankPage extends LightningElement {
    logoUrl = banklogo;
    card2logo = card2;
    @track contacts = [];
    @track paginatedContacts = [];
    currentPage = 1;
    pageSize = 5;
    totalPages = 0;
    error;

    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
            this.calculatePagination();
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    calculatePagination() {
        this.totalPages = Math.ceil(this.contacts.length / this.pageSize);
        this.updatePaginatedContacts();
    }

    updatePaginatedContacts() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.paginatedContacts = this.contacts.slice(startIndex, endIndex);
    }

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedContacts();
        }
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedContacts();
        }
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }
}