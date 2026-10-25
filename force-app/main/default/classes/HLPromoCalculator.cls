global with sharing class HLPromoCalculator implements Callable {

    // The "reception desk": OmniStudio comes in through here
    global Object call(String action, Map<String, Object> args) {
        Map<String, Object> input  = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');

        if (action == 'calculatePromo') {
            calculatePromo(input, output);
        }
        return true;
    }

    // The pricing desk: works out the promo
    private static void calculatePromo(Map<String, Object> input, Map<String, Object> output) {

        // Guard: if anything is missing, don't calculate, just say "no promo"     ← NEW
        if (input.get('CurrentSpeed') == null || input.get('NewSpeed') == null|| input.get('MonthlyPrice') == null) {   
            output.put('PromoApplied', false);                                    
            output.put('PromoCode', '');                                          
            output.put('FinalPrice', null);                                        
            return;                                                                
        }                                                                          

        // TODO 1: read the three numbers from input
        Decimal currentSpeed = Decimal.valueOf(String.valueOf(input.get('CurrentSpeed')));
        Decimal newSpeed = Decimal.valueOf(String.valueOf(input.get('NewSpeed')));
        Decimal monthlyPrice = Decimal.valueOf(String.valueOf(input.get('MonthlyPrice')));
        // TODO 2: decide whether the promo applies
        Boolean promoApplied = false;
        String promoCode = '';
        Decimal finalPrice = monthlyPrice;
        if ( newSpeed >= (currentSpeed * 2) ) {
            promoApplied = true;
            promoCode = 'UPGRADE20';
            finalPrice = (monthlyPrice * 0.8).setScale(2);
        }
        // TODO 3: put the results into output
        output.put('PromoApplied', promoApplied);
        output.put('PromoCode', promoCode);
        output.put('FinalPrice', finalPrice);
    }
}