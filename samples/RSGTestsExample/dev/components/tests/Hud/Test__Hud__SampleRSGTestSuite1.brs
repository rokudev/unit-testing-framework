Function TestSuite__Hud__SampleRSGTestSuite1() as Object
    ' Inherite your test suite from BaseTestSuite
    this = BaseTestSuite()
    
    ' Test suite name for log statistics
    this.Name = "TestSuite__Hud__SampleRSGTestSuite1"
    
    ' Add tests to suite's tests collection
    this.addTest("TestCase__OnOffsetChange", TestCase__OnOffsetChange)
    
    return this
End Function


function TestCase__OnOffsetChange() as Object
	testXOffset = 20
	globalAA = getGlobalAA()
	globalAA.top.offset = [testXOffset, 20]
	
	return m.assertTrue(globalAA.infoGroup.translation[0] = testXOffset)
end function