/********************************************************************************************************************************** 
 * CreatedDate: 10/05/2020
 * Author:      Cesar Bohorquez
 * Description: ROC-491 Warning Letter Counter; this class is used by a LWC, Warning_Letter_Counter. It receives an AccountId 
 *              parameter and uses that value as a binde variable along with Aggregrate Result Functions (SUM) to count the value
 *              of rollup fields on all child complaint records, returning a Map with the Letter Name and count total
 **********************************************************************************************************************************/ 

public class getCountWarningLetters {
    @AuraEnabled(cacheable=true)
    public static Map<String,Integer> getSumWarningLetters(Id accountId) {

        Map<String,Integer> countMap = new Map<String,Integer>();
        
        integer CountAidingAndAbetting = 0;
		integer Building_permit = 0;
		integer Contracting_while_Suspended = 0;
		integer Display_of_License = 0;
		integer Insufficient_Bond = 0;
		integer Contractor_Out_Of_Scope = 0;
		integer Out_of_Scope = 0;
		integer Pool_Contract = 0;
		integer Wrong_Name = 0;
		integer Solar = 0;
		integer Elements_of_Contract = 0;
    
		AggregateResult[] groupedResults = [SELECT SUM(Count_C013b_Aiding_and_Abetting__c)aid,
                                    SUM(Count_C013c_Building_permit__c)permit,
                                    SUM(Count_C013d_Contracting_while_Suspended__c)suspend,
                                    SUM(Count_C013e_Display_of_License_32_1124__c)display,
                                    SUM(Count_C013g_Insufficient_Bond__c)bond,
                                    SUM(Count_C013h_Contractor_Out_Of_Scope__c)scope,
                                    SUM(Count_C013i_Out_of_Scope_32_1154_A_16__c)scope32,
                                    SUM(Count_C013j_Pool_Contract_32_1158_01__c	)pool,
                                    SUM(Count_C013k_Wrong_Name__c)name,
                                    SUM(Count_C013l_Solar_32_1154_A_24__c)solar,
                                    SUM(Count_CC013f_Elements_of_Contract__c)contract
                                     FROM Complaint__c 
                                     WHERE Respondent_Account__c = :accountId
                                     ];
        for(AggregateResult ar : groupedResults ) {
            CountAidingAndAbetting 		= integer.valueof((decimal) ar.get('aid'));
    		Building_permit 			= integer.valueof((decimal) ar.get('permit'));
    		Contracting_while_Suspended = integer.valueof((decimal) ar.get('suspend'));
    		Display_of_License          = integer.valueof((decimal) ar.get('display'));
    		Insufficient_Bond           = integer.valueof((decimal) ar.get('bond'));
    		Contractor_Out_Of_Scope     = integer.valueof((decimal) ar.get('scope'));
    		Out_of_Scope      			= integer.valueof((decimal) ar.get('scope32'));
    		Pool_Contract 				= integer.valueof((decimal) ar.get('pool'));
    		Wrong_Name 					= integer.valueof((decimal) ar.get('name'));
    		Solar 						= integer.valueof((decimal) ar.get('solar'));
    		Elements_of_Contract 		= integer.valueof((decimal) ar.get('contract'));
            }
        countMap.put('Count Aiding and Abetting',CountAidingAndAbetting);
        countMap.put('Building permit',Building_permit);
        countMap.put('Contracting while Suspended',Contracting_while_Suspended);
        countMap.put('Display of License',Display_of_License);
        countMap.put('Insufficient Bond',Insufficient_Bond);
        countMap.put('Contractor Out Of Scope',Contractor_Out_Of_Scope);
        countMap.put('Out of Scope',Out_of_Scope);
        countMap.put('Pool Contract',Pool_Contract);
        countMap.put('Wrong Name',Wrong_Name);
        countMap.put('Solar',Solar);
        countMap.put('Elements of Contract',Elements_of_Contract);
        system.debug(countMap);
        
        Return countMap;
    }

}