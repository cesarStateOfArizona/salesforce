import { LightningElement, api, wire, track } from 'lwc';
import fetchMapData from '@salesforce/apex/getCountWarningLetters.getSumWarningLetters';


export default class Warning_Letter_Counter extends LightningElement {
    @api recordId;
    @track mapData= [];

    @wire(fetchMapData, { accountId: '$recordId' })
    
    wiredResult(result) { 
        if (result.data) {
            //mapData = [];
            var conts = result.data;
            for(var key in conts){
                this.mapData.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
            }
        }
    }
}