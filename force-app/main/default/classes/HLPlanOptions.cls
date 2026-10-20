global with sharing class HLPlanOptions implements Callable {

     
    // The "reception desk": OmniStudio always comes in through here
    global Object call(String action, Map<String, Object> args) {

        System.debug('INPUT RECEIVED: ' + JSON.serializePretty(args.get('input')));  
        Map<String, Object> output = (Map<String, Object>) args.get('output');

        if (action == 'getInternetPlans') {
            output.put('options', getInternetPlans());
        }
        return true;
    }

    // Builds the list of radio options
    private static List<Map<String, String>> getInternetPlans() {
        List<Map<String, String>> options = new List<Map<String, String>>();

        // TODO 1: query the internet plans
        List<Product2> internetPlans = [SELECT Id, Name, Speed_Mbps__c FROM Product2 WHERE Service_Category__c = 'Internet Plan' AND IsActive = true ORDER BY Speed_Mbps__c];

        
        // TODO 2: loop through them and add one option per plan

        for(Product2 plan : internetPlans){
            
            Map<String, String> option = new Map<String, String>();
            option.put('name', plan.Id);      // the hidden value: the plan's Id
            option.put('value', plan.Name);     // the text the agent sees
            options.add(option);             // add the card to the list
        }

        return options;
    }
}