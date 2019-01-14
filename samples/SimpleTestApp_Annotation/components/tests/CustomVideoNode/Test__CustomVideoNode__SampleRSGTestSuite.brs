sub init()
    Runner = TestRunner()
    Runner.SetFunctions([
        TestSuite__CustomVideoNode__SampleRSGTestSuite
        TestCase__OnKeyEvent2
        _NewApproach_CreateRowlistRepeatTest
    ])
end sub

function TestSuite__CustomVideoNode__SampleRSGTestSuite() as Object
    ' Inherite your test suite from BaseTestSuite
    this = BaseTestSuite()

    ' Test suite name for log statistics
    this.Name = "TestSuite__CustomVideoNode__SampleRSGTestSuite"

    ' Add tests to suite's tests collection
    this.addTest("TestCase__OnKeyEvent", TestCase__OnKeyEvent)

    return this
end function

function TestCase__OnKeyEvent() as Object
    return m.assertTrue(CustomVideoNode_OnKeyEvent("back", true))
end function