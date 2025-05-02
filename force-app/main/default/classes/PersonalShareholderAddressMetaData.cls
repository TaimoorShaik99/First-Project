public class PersonalShareholderAddressMetaData {
// Method to fetch metadata of Personal Shareholder custom object
    public static void fetchMetadata() {
        // Get the metadata of the Personal Shareholder custom object
        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Personal_Shareholder_Address__c.fields.getMap();

        // Loop through the fields and print metadata details
        for (String fieldName : fields.keySet()) {
            Schema.SObjectField field = fields.get(fieldName);
            
            // Describe the field to get its metadata
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            // Initialize field details
            String fieldDetails = 'Field Name: ' + fieldDescribe.getName() + ', ' +
                                  'Field Type: ' + fieldDescribe.getType() + ', ' +
                                  'Is Required: ' + !fieldDescribe.isNillable();
            
            // Add field length for applicable field types
            if (fieldDescribe.getType() == Schema.DisplayType.STRING || 
                fieldDescribe.getType() == Schema.DisplayType.PICKLIST ||
                fieldDescribe.getType() == Schema.DisplayType.TEXTAREA) {
                fieldDetails += ', Length: ' + fieldDescribe.getLength();
            }

            // Check for picklist values and add them in (Label: Value) format
            if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
                String picklistDetails = '';
                for (Schema.PicklistEntry picklist : picklistValues) {
                    picklistDetails += picklist.getLabel() + ' (' + picklist.getValue() + '); ';
                }
                fieldDetails += ', Picklist Values: ' + picklistDetails;
            }
            
            // Print all metadata details in one line
            System.debug(fieldDetails);
        }
    }
}