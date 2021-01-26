/*********************************************************************************************************************** 
 * CreatedDate: 11/17/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-332 Deficiencies - this class has two AuraEnabled methods. The first, getMultiSelectPicklists, is called
 *              by an Aura component init handler; it retrieves the names of all multiselect picklist fields on Deficiency__c.
 *              The second, getSnippetMetadata, receives a User-selected field label parameter from an Aura component. It queries
 *              Custom Metadata and returns a List<String> with each Picklist entry and corresponding Metadata
 ***********************************************************************************************************************/ 

public class DeficiencySnippetController {
    // This method is called via an init handler on the Aura Component, DeficiencySnippetsPicklist
    // It returns a List of the Names of all Multi-Select Picklist fields on the Deficiency custom object
    @AuraEnabled
    public static List<String> getMultiSelectPicklists() {
        List<String> picklists = new List<String>();
        Util multiPicklists = new Util();
        multiPicklists.getMultiSelectPicklists('Deficiency__c');
        picklists.addAll(multiPicklists.multiPicklists);
        picklists.add('-- Please Select a Deficiency Picklist field');
        picklists.sort();
        Return picklists;
    }
    
    // a Lightning Component, DeficiencySnippets, calls this method upon receiving an Event. It passes in a field label as a parameter
    // and receives the corresponding Deficiency Snippet Custom Metadata in List<String> format
    @AuraEnabled 
    public static List<String> getSnippetMetadata(String label) {
        // metadataRec will be assigned a value below, contingent on label's value
        Deficiency_Snippets__mdt metadataRec;
        // instantiate Util
        Util field = new Util();
        // pass in the Object API name and field label
        field.getFieldAPIName('Deficiency__c', label);
        // instantiate another intance of Util
        Util entries = new Util();
        // pass in the field API name and Object API name
        entries.getPicklistEntries(field.fieldAPIName, 'Deficiency__c');
        // finalSnippets contains all of the picklist entries for the field corresponding to Label - key is the picklist
        // entry label, and the value is the picklist entry API value
        Map<String, String> finalSnippets = new Map<String, String>(entries.entriesMap);
        List<String> snippets = new List<String>();
        
        // BEGIN querying Deficiency_Snippets__mdt, using label as a binde variable -----------------------------------------------------
        If(label == 'Application'){
            metadataRec = [ SELECT Application_Not_Submitted__c, Application_Part_1__c, Application_Part_2__c, Application_Part_3__c,
                											Application_Part_4__c,Application_Part_5__c,Application_Part_6__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'AZCC'){
            metadataRec = [ SELECT AZCC_Not_Active_and_in_Good_Standing__c, AZCC_Other__c, AZCC_Part_1_Name_does_not_match__c,
                											AZCC_Part_1_Number_does_not_match__c,AZCC_Personnel_does_not_match__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Background Check'){
            metadataRec = [ SELECT Background_Check_Expired__c, Background_Check_Not_Submitted__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Bond Corrections 32-1152'){
            metadataRec = [ SELECT X32_1152_Classification_Rider__c, X32_1152_Date_6_Months__c, X32_1152_Name_Incorrect_does_not_match__c,
                											X32_1152_Not_Signed__c,X32_1152_Not_Submitted__c,X32_1152_No_Visible_Seal__c,X32_1152_Other__c,
                                                    		X32_1152_Rider_Needed_for_Amount__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Exam Needed'){
            metadataRec = [ SELECT Exam_Needed_Incorrect_Waiver_Provided__c, Exam_Needed_Missing_SRE__c, Exam_Needed_Missing_Trade__c,
                											Exam_Needed_NASCLA_Transcripts_Denial__c,Exam_Needed_Not_Submitted__c,Exam_Needed_Results_Classification__c,
                                                    		Exam_Needed_Submitted_exam_expired__c,Exam_Needed_Waiver_Denial_Trade__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Experience (32-1122 (E))'){
            metadataRec = [ SELECT X32_1122_E_Commercial__c, X32_1122_E_Description_Not_in_Scope__c, X32_1122_E_Ground_Up_Description__c,
                											X32_1122_E_Insufficient_Description__c,X32_1122_E_Insufficient_Experience__c,X32_1122_E_Not_Submitted__c,
                                                    		X32_1122_E_References__c,X32_1122_E_Residential__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Fees'){
            metadataRec = [ SELECT Fees_NSF_Fee_Needed__c, Fees_Overpayment__c, Fees_Short__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Felony DOCS – 32-1154 (A) (7)'){
            metadataRec = [ SELECT Felony_Docs_Missing__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Gov ID Needed -ARS 32-1122 (E)'){
            metadataRec = [ SELECT Gov_ID_Needed_Expired__c, Gov_ID_Needed_Illegible__c, Gov_ID_Needed_Not_Submitted__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Organization Chart'){
            metadataRec = [ SELECT Org_Chart_Addresses_for_Entity_Needed__c, Org_Chart_Attestation_Needed__c, Org_Chart_Not_Complete__c,
                											Org_Chart_Not_Submitted__c,Org_Chart_Signature_Needed__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Other'){
            metadataRec = [ SELECT Other_1127_Violation__c, Other_Prior_License_Disclosure_Needed__c,
                											Other_Solar_Warranty_Not_Submitted__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        } else if (label == 'Workers\' Compensation'){
            metadataRec = [ SELECT Workers_Comp_Company_Name_and_Policy__c, Workers_Comp_Correct_Disclosures__c,
                											Workers_Comp_Not_Provided__c, Workers_Comp_Proof_Required__c
                									FROM Deficiency_Snippets__mdt 
                									WHERE Label = :label LIMIT 1 ];
        }
        // STOP querying Deficiency_Snippets__mdt, using label as a binde variable ----------------------------------------------------
        // As noted above, finalSnippets contains all picklist entries for the picklist field corresponding to the label parameter
        for(String snip : finalSnippets.keySet()){
                String f = finalSnippets.get(snip); // this is the picklist API value, which is structured to correspond to metadata fields
                String s = string.valueOf(metadataRec.get(f)); 
                Snippets.add(snip + '\n' + s);
            }
        return snippets;
    }
}