import { LightningElement, track, api } from 'lwc';
import getOpportunities from '@salesforce/apex/AccountControllerNav.getOpportunities';
import updateOpportunityStages from '@salesforce/apex/AccountControllerNav.updateOpportunityStages';
import getStageNamePicklistValues from '@salesforce/apex/AccountControllerNav.getStageNamePicklistValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationBackEvent } from 'lightning/flowSupport';

export default class RelatedOpportunities extends LightningElement {
    @api accountId; // Received from Flow
    @track opportunities = [];
    @track paginatedOpportunities = [];
    @track selectedOpportunities = new Set();
    @track showModal = false;
    @track showConfirmationModal = false;
    @track selectedStage = '';
    @track stageOptions = [];
    
    @track currentPage = 1;
    pageSize = 2;
    totalPages = 0;

    connectedCallback() {
        if (this.accountId) {
            this.fetchOpportunities();
            this.fetchStageOptions();
        }
    }

    fetchOpportunities() {
        getOpportunities({ accountId: this.accountId })
            .then((data) => {
                this.opportunities = [...data];
                this.calculatePagination();
            })
            .catch(() => {
                this.opportunities = [];
            });
    }

    fetchStageOptions() {
        getStageNamePicklistValues()
            .then((data) => {
                this.stageOptions = data.map(stage => ({ label: stage, value: stage }));
            })
            .catch(() => {
                this.stageOptions = [];
            });
    }

    calculatePagination() {
        this.totalPages = Math.ceil(this.opportunities.length / this.pageSize);
        this.updatePaginatedOpportunities();
    }

    updatePaginatedOpportunities() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.paginatedOpportunities = this.opportunities.slice(startIndex, endIndex);
    }

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedOpportunities();
        }
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedOpportunities();
        }
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }

    handleGoBack() {
        this.dispatchEvent(new FlowNavigationBackEvent()); // Navigate back in Flow
    }
}
