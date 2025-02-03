import { LightningElement , wire, track} from 'lwc';
import getContacts from "@salesforce/apex/ContactController.getContacts";
import banklogo from '@salesforce/resourceUrl/banklogo';
import card2 from '@salesforce/resourceUrl/card2';
 

 
export default class Ths extends LightningElement {
    logoUrl = banklogo;
    card2logo = card2;
    contacts;
    error;
    @track dataToPaginate =[];
    @track currentPage = 1;
    @track pageSize = 5;
    @track totalItems = 0;
    @track totalPages = 0;
    

    pageSizeOptions = [
        { label: '1', value: '1' },
        { label: '5', value: '5' },
        { label: '10', value: '10' },
        { label: '15', value: '15' },
        { label: '20', value: '20' },
    ];

    

    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }
    updateTabData() {
            this.dataToPaginate=this.contacts;
            this.totalItems = this.dataToPaginate.length;
            this.totalPages = Math.ceil(this.totalItems / this.pageSize);
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }

    get updatePaginatedCases() {
        let start = (this.currentPage - 1) * this.pageSize;
        let end = start + this.pageSize;
        return this.dataToPaginate.slice(start, end);
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;
        }
    }

    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
        }
    }

    handlePageSizeChange(event) {
        this.pageSize = parseInt(event.detail.value, 10);
        this.currentPage = 1;
        this.updateTabData();
    }
}