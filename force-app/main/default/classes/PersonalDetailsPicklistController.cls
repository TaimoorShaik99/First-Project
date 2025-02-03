public with sharing class PersonalDetailsPicklistController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistFields() {
        Map<String, List<String>> picklistFields = new Map<String, List<String>>();
        try {
            // Describe the Personal_Details__c object
            Schema.DescribeSObjectResult personalDetailsDescribe = Schema.SObjectType.Personal_Details__c;
            Map<String, Schema.SObjectField> fieldMap = personalDetailsDescribe.fields.getMap();
            
            // Iterate through all fields
            for(String fieldName : fieldMap.keySet()) {
                Schema.SObjectField field = fieldMap.get(fieldName);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                // Check if the field is a picklist
                if(fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                    List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
                    List<String> picklistValues = new List<String>();

                    // Extract the picklist values
                    for(Schema.PicklistEntry entry : picklistEntries) {
                        picklistValues.add(entry.getLabel());
                    }
                    picklistFields.put(fieldName, picklistValues);
                }
            }
        } catch (Exception e) {
            // Handle any errors
            System.debug('Error fetching picklist fields: ' + e.getMessage());
        }
        System.debug('picklistFields: ' + JSON.serialize(picklistFields));
        return picklistFields;
    }
    
    @AuraEnabled
    public static Id savePersonalDetails(Map<String, Object> formData) {
        system.debug('new record'+ JSON.serialize(formData));
        try {
            Personal_Details__c newRecord = new Personal_Details__c();
            for(String key : formData.keySet()) {
                if(String.isNotBlank(String.valueOf(formData.get(key)))) {
                    // newRecord.put(key, formData.get(key));
                    if (key == 'Date_of_Birth__c') {
                        // Convert string to Date
                        Date birthDate = Date.valueOf(String.valueOf(formData.get(key)));
                        newRecord.put(key, birthDate);
                    } else {
                        newRecord.put(key, formData.get(key));
                    }
                }
            }
            system.debug('new record'+ JSON.serialize(newRecord));
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error inserting record: ' + e.getMessage());
        }
    }
}