public class DynamicSOQLUtility {
    
    public static List<SObject> fetchRecords(String objectName, Map<String, Object> filters) {
        String query = buildQuery(objectName, filters);
        System.debug('Generated Query: ' + query); // Added debug
        return Database.query(query);
    }
    private static String buildQuery(String objectName, Map<String, Object> filters) {
        if (String.isEmpty(objectName)) {
            throw new QueryException('Object name cannot be empty');
        }
        String query = 'SELECT Id, Name FROM ' + String.escapeSingleQuotes(objectName);
        if (filters != null && !filters.isEmpty()) {
            query += ' WHERE ';
            List<String> conditions = new List<String>();
            for (String field : filters.keySet()) {
                String condition = buildCondition(field, filters.get(field));
                if (condition != null) {
                    conditions.add(condition);
                }
            }
            query += String.join(conditions, ' AND ');
        }
        return query;
    }
    private static String buildCondition(String field, Object value) {
        String escapedField = String.escapeSingleQuotes(field);
        if (value instanceof String) {
            return escapedField + ' = \'' + String.escapeSingleQuotes((String)value) + '\'';
        }
        return null;
    }
    public class QueryException extends Exception {}
}