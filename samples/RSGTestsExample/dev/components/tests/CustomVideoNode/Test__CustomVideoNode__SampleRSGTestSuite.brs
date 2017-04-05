Function TestSuite__CustomVideoNode__SampleRSGTestSuite() as Object
    ' Inherite your test suite from BaseTestSuite
    this = BaseTestSuite()
    
    ' Test suite name for log statistics
    this.Name = "TestSuite__CustomVideoNode__SampleRSGTestSuite"
    
    ' Add tests to suite's tests collection
    this.addTest("TestCase__OnKeyEvent", TestCase__OnKeyEvent)
    
    return this
End Function


function TestCase__OnKeyEvent() as Object
	return m.assertTrue(onKeyEvent("back", true))
end function