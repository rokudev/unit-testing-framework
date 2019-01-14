sub init()
    Runner = TestRunner()
    Runner.SetFunctions([
        TestSuite__CustomVideoNode__SampleRSGTestSuite
    ])
end sub