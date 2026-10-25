@isTest
private class HLPromoCalculatorTest {

    // Helper: pretends to be the OmniScript, and returns the output tray
    private static Map<String, Object> runPromo(Object currentSpeed, Object newSpeed, Object monthlyPrice) {
        Map<String, Object> input = new Map<String, Object>{
            'CurrentSpeed' => currentSpeed,
            'NewSpeed'     => newSpeed,
            'MonthlyPrice' => monthlyPrice
        };
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input'   => input,
            'output'  => output,
            'options' => new Map<String, Object>()
        };
        new HLPromoCalculator().call('calculatePromo', args);
        return output;
    }

    // Test 1: 300 → 1000 is more than double, so the promo applies
    @isTest
    static void promoAppliesWhenSpeedMoreThanDoubles() {
        Map<String, Object> result = runPromo(300, 1000, 79);

        System.assertEquals(true, result.get('PromoApplied'), 'Promo should apply for 300 to 1000');
        System.assertEquals('UPGRADE20', result.get('PromoCode'), 'Promo code should be UPGRADE20');
        System.assertEquals(63.20, (Decimal) result.get('FinalPrice'), 'Price should be 20 percent off 79');
    }

    // Test 2: 1000 → 2000 is EXACTLY double (the boundary), so the promo still applies
    @isTest
    static void promoAppliesWhenSpeedExactlyDoubles() {
        Map<String, Object> result = runPromo(1000, 2000, 109);

        System.assertEquals(true, result.get('PromoApplied'), 'Promo should apply when speed exactly doubles');
        System.assertEquals('UPGRADE20', result.get('PromoCode'), 'Promo code should be UPGRADE20');
        System.assertEquals(87.20, (Decimal) result.get('FinalPrice'), 'Price should be 20 percent off 109');
    }

    // Test 3: 1000 → 1500 is less than double, so NO promo and full price
    @isTest
    static void noPromoWhenSpeedLessThanDouble() {
        Map<String, Object> result = runPromo(1000, 1500, 95);

        System.assertEquals(false, result.get('PromoApplied'), 'Promo should not apply for a small upgrade');
        System.assertEquals('', result.get('PromoCode'), 'Promo code should be empty');
        System.assertEquals(95, (Decimal) result.get('FinalPrice'), 'Price should stay at full price');
    }

    // Test 4: a value is missing (like Kavya's bug), so no crash and no promo
    @isTest
    static void noPromoWhenInputMissing() {
        Map<String, Object> result = runPromo(300, null, 79);

        System.assertEquals(false, result.get('PromoApplied'), 'Promo should not apply when input is missing');
        System.assertEquals('', result.get('PromoCode'), 'Promo code should be empty');
        System.assertEquals(null, result.get('FinalPrice'), 'Final price should be empty when input is missing');
    }
}