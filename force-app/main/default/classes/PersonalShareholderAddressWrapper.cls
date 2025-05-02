public class PersonalShareholderAddressWrapper {
 // Wrapper class to store field metadata
    public class FieldMetadata {
        public String fieldName { get; set; }
        public String fieldType { get; set; }
        public Boolean isRequired { get; set; }
        public Integer fieldLength { get; set; }
        public List<String> picklistValues { get; set; }

        // Constructor
        public FieldMetadata(String name, String type, Boolean required, Integer length) {
            this.fieldName = name;
            this.fieldType = type;
            this.isRequired = required;
            this.fieldLength = length;
            this.picklistValues = new List<String>();
        }
    }

    // Method to fetch metadata of Personal Shareholder Address custom object
    public static void fetchMetadata() {
        // Get the metadata of the Personal Shareholder Address custom object
        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Personal_Shareholder_Address__c.fields.getMap();

        // List to store metadata details
        List<FieldMetadata> metadataList = new List<FieldMetadata>();

        // Loop through the fields and collect metadata
        for (String fieldName : fields.keySet()) {
            Schema.SObjectField field = fields.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            // Create metadata object
            FieldMetadata metaData = new FieldMetadata(
                fieldDescribe.getName(),
                String.valueOf(fieldDescribe.getType()),
                !fieldDescribe.isNillable(),
                (fieldDescribe.getType() == Schema.DisplayType.STRING ||
                 fieldDescribe.getType() == Schema.DisplayType.PICKLIST ||
                 fieldDescribe.getType() == Schema.DisplayType.TEXTAREA) ? 
                 fieldDescribe.getLength() : null
            );

            // Add picklist values if applicable
            if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                for (Schema.PicklistEntry picklist : fieldDescribe.getPicklistValues()) {
                    metaData.picklistValues.add(picklist.getLabel() + ' (' + picklist.getValue() + ')');
                }
            }

            // Add to list
            metadataList.add(metaData);
        }

        // Print metadata in debug logs
        for (FieldMetadata meta : metadataList) {
            System.debug('Field Name: ' + meta.fieldName +
                         ', Field Type: ' + meta.fieldType +
                         ', Is Required: ' + meta.isRequired +
                         (meta.fieldLength != null ? ', Length: ' + meta.fieldLength : '') +
                         (meta.picklistValues.isEmpty() ? '' : ', Picklist Values: ' + String.join(meta.picklistValues, '; ')));
        }
    }
}