import { LightningElement, api, track } from 'lwc';
import fetchAllMetadata from '@salesforce/apex/ObjectMetadataWrapper.fetchAllMetadata';
import createRecords from '@salesforce/apex/ObjectMetadataWrapper.createRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ObjectMetaData extends LightningElement {
    @track metadataList = [];

    // Fields that should be rendered as radio buttons
    radioFields = [
        'Middle_Name__c',
        'Former_Name_or_Maiden_Name__c',
        'Different_First_Maiden_Family_Name__c',
        'Politically_Exposed__c'
    ];

    // Object names to pass to the Apex method
    @api objectNames = ['Personal_Shareholder__c', 'Personal_Shareholder_Address__c'];

    connectedCallback() {
        this.loadMetadata();
    }

    loadMetadata() {
        fetchAllMetadata({ objectNames: this.objectNames })
            .then(data => {
                console.log('Raw metadata:', JSON.stringify(data, null, 2));
                this.metadataList = data.map(field => {
                    let objectName = this.determineObjectName(field.apiName);
                    let isRadioField = this.radioFields.includes(field.apiName);

                    const fieldData = {
                        ...field,
                        objectName: objectName,
                        isText: field.fieldType.toLowerCase() === 'string' && !isRadioField,
                        isRadio: isRadioField,
                        isDate: field.fieldType.toLowerCase() === 'date',
                        isNumber: ['integer', 'double', 'currency'].includes(field.fieldType.toLowerCase()),
                        isPicklist: field.fieldType.toLowerCase().includes('picklist'),
                        required: field.isRequired,
                        fieldType: field.fieldType,
                        radioOptions: isRadioField ? [
                            { label: 'Yes', value: 'true' },
                            { label: 'No', value: 'false' }
                        ] : []
                    };
                    console.log(`Processed field ${field.apiName}:`, JSON.stringify(fieldData, null, 2));
                    return fieldData;
                });
            })
            .catch(error => {
                console.error('Error fetching metadata:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error loading form fields: ' + error.message,
                        variant: 'error'
                    })
                );
            });
    }

    determineObjectName(fieldApiName) {
        const fieldObjectMapping = {
            Personal_Shareholder__c: [
                'Title__c',
                'Family_Name_Surname__c',
                'First_Name__c',
                'Middle_Name__c',
                'Former_Name_or_Maiden_Name__c',
                'Different_First_Maiden_Family_Name__c'
            ],
            Personal_Shareholder_Address__c: [
                'Address_Line_1__c',
                'Address_Line_2__c',
                'Address_Line_3__c',
                'Address_Line_4__c',
                'Postcode__c',
                'Country__c',
                'Date_of_Birth__c',
                'Place_of_Birth__c',
                'Primary_Country_of_Nationality__c',
                'Politically_Exposed__c'
            ]
        };

        for (let objectName in fieldObjectMapping) {
            if (fieldObjectMapping[objectName].includes(fieldApiName)) {
                return objectName;
            }
        }
        console.warn(`No object found for field: ${fieldApiName}`);
        return null;
    }

    handleSubmit() {
        let allValid = true;
        let inputFields = this.template.querySelectorAll('lightning-input, lightning-combobox, lightning-radio-group');
        let objectDataMap = {};

        // Initialize object maps
        this.objectNames.forEach(objName => {
            objectDataMap[objName] = {};
        });

        console.log('Starting form submission...');
        
        inputFields.forEach(field => {
            const fieldApiName = field.dataset.id;
            const objectName = field.dataset.object;
            const fieldType = field.dataset.fieldType;
            let value = field.value;

            console.log(`Processing field: ${fieldApiName}, Object: ${objectName}, Type: ${fieldType}, Value: ${value}`);

            if (!objectName) {
                console.error(`Missing object name for field: ${fieldApiName}`);
                return;
            }

            // Validate required fields
            if (field.required && (value === null || value === undefined || value === '')) {
                field.setCustomValidity('This field is required');
                allValid = false;
                console.log(`Required field missing: ${fieldApiName}`);
            } else {
                field.setCustomValidity('');
            }
            field.reportValidity();

            // Convert values based on field type
            if (fieldType) {
                if (fieldType.toLowerCase() === 'boolean' || this.radioFields.includes(fieldApiName)) {
                    value = value === 'true';
                } else if (['integer', 'double', 'currency'].includes(fieldType.toLowerCase())) {
                    value = value ? Number(value) : null;
                } else if (fieldType.toLowerCase() === 'date') {
                    value = value || null;
                }
            }

            objectDataMap[objectName][fieldApiName] = value;
        });

        console.log('Final Object Data Map:', JSON.stringify(objectDataMap, null, 2));

        if (!allValid) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please fill in all required fields',
                    variant: 'error'
                })
            );
            return;
        }

        createRecords({ objectDataMap })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records created successfully',
                        variant: 'success'
                    })
                );

                // Reset form
                inputFields.forEach(field => {
                    field.value = '';
                });
            })
            .catch(error => {
                console.error('Error creating records:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error creating records: ' + (error.body ? error.body.message : error),
                        variant: 'error'
                    })
                );
            });
    }
}