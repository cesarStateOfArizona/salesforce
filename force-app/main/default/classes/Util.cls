/*********************************************************************************************************************** 
 * CreatedDate: 11/17/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-332 Deficiencies - helper class called by DeficiencySnippetController. It has 3 methods - getFieldAPIName,
 *              getMultiSelectPicklists, getPicklistEntries - each of which returns the corresponding information
 ***********************************************************************************************************************/ 

public class Util {
    // a String that is returned by the getFieldAPIName method
    public String fieldAPIName;
    // a Map that is returned by the getPicklistEntries method
    public Map<String, String> entriesMap = new Map<String, String>();
    // a List that is returned by the getPicklistEntries method
    public List<String> multiPicklists = new List<String>();
    // this method accepts an Object's API name and a field's label as parameters, and returns the field's API Name
	public String getFieldAPIName (String objectName, String fieldLabel) {
        SObjectType type = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = type.getDescribe().fields.getMap();
        for(String strField : mfields.keySet()) {
            SObjectField fl = mfields.get(strField);
            if(fieldLabel == fl.getDescribe().getlabel()) {
                fieldAPIName = strField;
            }
        }
        return fieldAPIName;
    }
    // this method accepts an Object's API name as a parameter and returns all multiselect picklist fields
    public List<String> getMultiSelectPicklists(String objAPIName){
        
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
		Schema.SObjectType sobjType = gd.get(objAPIName);
		Schema.DescribeSObjectResult r = sobjType.getDescribe();
		Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        for(String fieldName : MapofField.keySet()) {
            Schema.SObjectField field = MapofField.get(fieldName);            
            Schema.DescribeFieldResult F = field.getDescribe();
            if(F.getType() == Schema.DisplayType.MULTIPICKLIST){
                multiPicklists.add(F.getLabel());
            }
        }
        return multiPicklists;
    }
    // this method accepts a field's API Name and an Object's API name as parameters
    // it returns a Map with the picklist field's label as the key, and API value as the corresponding value      
    public Map<String,String> getPicklistEntries(String fieldAPIName, String objAPIName){

        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
		Schema.SObjectType sobjType = gd.get(objAPIName);
		Schema.DescribeSObjectResult r = sobjType.getDescribe();
		Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        Schema.SObjectField field;
        for(String fieldName : MapofField.keySet()) {
            if(fieldAPIName == fieldName){
                field = MapofField.get(fieldName);
            }          
        }
        
        Schema.DescribeFieldResult F = field.getDescribe();
        List<Schema.PicklistEntry> entries = F.getPicklistValues();
        for(Schema.PicklistEntry entry :entries){
            entriesMap.put(entry.getLabel(), entry.getValue());
        }
        
        Return entriesMap;
    }
}