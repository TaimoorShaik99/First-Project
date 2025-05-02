import { LightningElement, api, wire, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import ACCOUNT_FIELD from "@salesforce/schema/Lead.Account__c";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Account.Name";
import getOpportunities from "@salesforce/apex/LeadAccountController.getOpportunities";
 
export default class LeadAccountDisplay extends LightningElement {
    @api recordId; // Lead Record Id
    accountId;
    accountName;
    @track opportunities = [];
    error;
 
    // Datatable Columns
    columns = [
        {
            label: "Opportunity Name",
            fieldName: "url",
            type: "url",
            typeAttributes: { label: { fieldName: "name" }, target: "_blank" }
        },
        { label: "Stage", fieldName: "stage", type: "text" },
        { label: "Close Date", fieldName: "closeDate", type: "date" }
    ];
 
    // Get the Account Id from Lead
    @wire(getRecord, { recordId: "$recordId", fields: [ACCOUNT_FIELD] })
    wiredLead({ error, data }) {
        if (data) {
            this.accountId = getFieldValue(data, ACCOUNT_FIELD);
        } else if (error) {
            this.error = error.body.message;
        }
    }
 
    // Get Account Name
    @wire(getRecord, { recordId: "$accountId", fields: [ACCOUNT_NAME_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = getFieldValue(data, ACCOUNT_NAME_FIELD);
        } else if (error) {
            this.error = error.body.message;
        }
    }
 
    // Fetch related Opportunities
    @wire(getOpportunities, { accountId: "$accountId" })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data.map(opp => ({
                id: opp.Id,
                name: opp.Name,
                stage: opp.StageName,
                closeDate: opp.CloseDate,
                url: `/lightning/r/Opportunity/${opp.Id}/view`
            }));
        } else if (error) {
            this.error = error.body.message;
        }
    }
 
    // Get Account URL
    get accountUrl() {
        return this.accountId ? `/lightning/r/Account/${this.accountId}/view` : "#";
    }
}
 
 