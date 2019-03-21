sub init()
    Runner = TestRunner()
    
    Runner.SetFunctions([
        RSG_Test1,
        RSG_Test2,
        RSG_Test3,
        RSG_RepeatedTest1,
        RSG_RepeatedTest2,
        stringProvider,
        RSG_ParametrizedTest1,
        RSG_ParametrizedTest2
    ])
end sub
