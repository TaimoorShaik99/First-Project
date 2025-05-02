public with sharing class ObjectMetadataWrapper {
    // Wrapper class to store field metadata
    public class FieldMetadata {
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldType;
        @AuraEnabled public Boolean isRequired;
        @AuraEnabled public Integer fieldLength;
        @AuraEnabled public List<PicklistValue> picklistValues;
        @AuraEnabled public String apiName;
        @AuraEnabled public String objectName; // Added to track the object this field belongs to

        // Constructor
        public FieldMetadata(String name, String label, String type, Boolean required, Integer length, String apiName, List<PicklistValue> picklistValues, String objectName) {
            this.fieldLabel = label != null ? label : '';
            this.fieldType = type != null ? type : '';
            this.isRequired = required != null ? required : false;
            this.fieldLength = length;
            this.apiName = apiName != null ? apiName : '';
            this.picklistValues = (picklistValues != null && !picklistValues.isEmpty()) ? picklistValues : null;
            this.objectName = objectName;
        }
    }

    // Class to represent a picklist value
    public class PicklistValue {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        // Constructor
        public PicklistValue(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    // Expose the method to be callable from LWC
    @AuraEnabled(cacheable=true)
    public static List<FieldMetadata> fetchAllMetadata(List<String> objectNames) {
        try {
            List<FieldMetadata> metadataList = new List<FieldMetadata>();
           
            if (objectNames == null || objectNames.isEmpty()) {
                throw new AuraHandledException('Object names list cannot be empty');
            }

            for (String objName : objectNames) {
                if (String.isBlank(objName)) continue;
               
                // Get the object type
                Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
                if (objType == null) {
                    System.debug('Object not found: ' + objName);
                    continue;
                }

                // Get field map
                Map<String, Schema.SObjectField> fields = objType.getDescribe().fields.getMap();
               
                // Process each field
                for (String fieldName : fields.keySet()) {
                    if (fieldName.endsWith('__c')) {
                        Schema.DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
                       
                        // Calculate field length for applicable types
                        Integer fieldLength = null;
                        Schema.DisplayType fieldType = fieldDescribe.getType();
                        if (fieldType == Schema.DisplayType.STRING ||
                            fieldType == Schema.DisplayType.PICKLIST ||
                            fieldType == Schema.DisplayType.TEXTAREA) {
                            fieldLength = fieldDescribe.getLength();
                        }

                        // Handle picklist values
                        List<PicklistValue> picklistValues = new List<PicklistValue>();
                        if (fieldType == Schema.DisplayType.PICKLIST) {
                            for (Schema.PicklistEntry entry : fieldDescribe.getPicklistValues()) {
                                if (entry.isActive()) {
                                    picklistValues.add(new PicklistValue(entry.getLabel(), entry.getValue()));
                                }
                            }
                        }

                        // Create field metadata instance
                        FieldMetadata fieldMetadata = new FieldMetadata(
                            fieldDescribe.getName(),
                            fieldDescribe.getLabel(),
                            String.valueOf(fieldType),
                            !fieldDescribe.isNillable(),
                            fieldLength,
                            fieldDescribe.getName(),
                            picklistValues.isEmpty() ? null : picklistValues,
                            objName // Add object name
                        );
                       
                        metadataList.add(fieldMetadata);
                    }
                }
            }
           
            return metadataList;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching metadata: ' + e.getMessage());
        }
    }
   
    @AuraEnabled
public static Map<String, Id> createRecords(Map<String, Map<String, String>> objectDataMap) {
    try {
        System.debug('Received objectDataMap: ' + JSON.serialize(objectDataMap));

        Map<String, Id> createdRecordIds = new Map<String, Id>();  // Stores inserted record IDs
        Map<String, SObject> objectsToInsert = new Map<String, SObject>();  // Holds objects before insert
        List<SObject> parentRecords = new List<SObject>();
        List<SObject> childRecords = new List<SObject>();

        // First pass: Prepare SObjects
        for (String objectName : objectDataMap.keySet()) {
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
            if (objType == null) {
                System.debug('Invalid object name: ' + objectName);
                throw new AuraHandledException('Invalid object name: ' + objectName);
            }

            SObject record = objType.newSObject();
            Map<String, String> fieldValues = objectDataMap.get(objectName);
            Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();

            for (String fieldName : fieldValues.keySet()) {
                if (!fieldMap.containsKey(fieldName)) {
                    System.debug('WARNING: Field not found in schema: ' + fieldName);
                    continue;
                }

                Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName).getDescribe();
                String fieldValue = fieldValues.get(fieldName);

                if (String.isBlank(fieldValue) && !fieldDesc.isNillable() && fieldDesc.isCreateable() && !fieldDesc.isAutoNumber()) {
                    throw new AuraHandledException('Required field missing: ' + fieldDesc.getLabel());
                }

                if (String.isBlank(fieldValue)) {
                    continue;
                }

                Schema.DisplayType fieldType = fieldDesc.getType();

                // Convert and assign field values
                if (fieldType == Schema.DisplayType.BOOLEAN) {
                    record.put(fieldName, fieldValue.equalsIgnoreCase('true') || fieldValue.equalsIgnoreCase('yes'));
                } else if (fieldType == Schema.DisplayType.DATE) {
                    try {
                        record.put(fieldName, Date.valueOf(fieldValue));
                    } catch (Exception e) {
                        throw new AuraHandledException('Invalid date format for ' + fieldDesc.getLabel() + ': ' + fieldValue);
                    }
                } else if (fieldType == Schema.DisplayType.DATETIME) {
                    try {
                        record.put(fieldName, Datetime.valueOf(fieldValue));
                    } catch (Exception e) {
                        throw new AuraHandledException('Invalid datetime format for ' + fieldDesc.getLabel() + ': ' + fieldValue);
                    }
                } else if (fieldType == Schema.DisplayType.INTEGER) {
                    try {
                        record.put(fieldName, Integer.valueOf(fieldValue));
                    } catch (Exception e) {
                        throw new AuraHandledException('Invalid integer format for ' + fieldDesc.getLabel() + ': ' + fieldValue);
                    }
                } else if (fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.CURRENCY) {
                    try {
                        record.put(fieldName, Decimal.valueOf(fieldValue));
                    } catch (Exception e) {
                        throw new AuraHandledException('Invalid decimal format for ' + fieldDesc.getLabel() + ': ' + fieldValue);
                    }
                } else if (fieldType == Schema.DisplayType.REFERENCE) {
                    if (fieldValue.length() == 15 || fieldValue.length() == 18) {
                        record.put(fieldName, fieldValue);
                    }
                } else {
                    record.put(fieldName, fieldValue);
                }
            }

            objectsToInsert.put(objectName, record);

            // Categorize parent vs. child records
            if (objectName == 'Personal_Shareholder__c') {
                parentRecords.add(record);
            } else if (objectName == 'Personal_Shareholder_Address__c') {
                childRecords.add(record);
            }
        }

        // Insert parent records first
        if (!parentRecords.isEmpty()) {
            insert parentRecords;
            for (SObject parent : parentRecords) {
                createdRecordIds.put('Personal_Shareholder__c', parent.Id);
            }
        }

        // Update child records with parent ID and insert them
        if (!childRecords.isEmpty() && createdRecordIds.containsKey('Personal_Shareholder__c')) {
            for (SObject child : childRecords) {
                child.put('Personal_Shareholder__c', createdRecordIds.get('Personal_Shareholder__c'));
            }
            insert childRecords;
            for (SObject child : childRecords) {
                createdRecordIds.put('Personal_Shareholder_Address__c', child.Id);
            }
        }

        return createdRecordIds;

    } catch (Exception e) {
        System.debug('Error creating records: ' + e.getMessage() + '\n' + e.getStackTraceString());
        throw new AuraHandledException('Error creating records: ' + e.getMessage());
    }
}
}