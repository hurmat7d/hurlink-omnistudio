// Pretend to be the OmniScript: Arjun upgrading 300 → 1000 at 79/month
Map<String, Object> args = new Map<String, Object>{
        'input'   => new Map<String, Object>{
        'CurrentSpeed' => 300,
        'NewSpeed'     => 1000,
        'MonthlyPrice' => 79
    },
    'output'  => new Map<String, Object>(),
    'options' => new Map<String, Object>()
};

new HLPromoCalculator().call('calculatePromo', args);

System.debug(JSON.serializePretty(args.get('output')));