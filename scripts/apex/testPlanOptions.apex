Map<String, Object> args = new Map<String, Object>{
    'input'   => new Map<String, Object>(),
    'output'  => new Map<String, Object>(),
    'options' => new Map<String, Object>()
};

new HLPlanOptions().call('getInternetPlans', args);

System.debug(JSON.serializePretty(args.get('output')));