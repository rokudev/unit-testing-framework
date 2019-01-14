function TestSuite__Hud__SampleRSGTestSuite2() as Object
    ' Inherite your test suite from BaseTestSuite
    this = BaseTestSuite()
    
    ' Test suite name for log statistics
    this.Name = "TestSuite__Hud__SampleRSGTestSuite2"
    
    ' Add tests to suite's tests collection
    this.addTest("TestCase__OnHeightChanged", TestCase__OnHeightChanged)
    
    return this
end function

function TestCase__OnHeightChanged() as Object
	globalAA = getGlobalAA()
	
	testHeight = 50
	globalAA.top.height = testHeight
	
	return m.assertTrue(globalAA.hudGroup.translation[1] = globalAA.background.height - testHeight + 1)
end function