' @BeforeAll
sub NewApproach__ThisFunctionShouldBeCalledBeforeAllTestsInSuite()
    ' Target testing object. To avoid the object creation in each test
    ' we create instance of target object here and use it in tests as m.targetTestObject.
    screen = CreateObject("roSGScreen")
    m.mainData = {
        scene: screen.CreateScene("Scene")
        screen: screen
    }
    screen.show()
end sub

' @AfterAll
sub NewApproach__ThisFunctionShouldBeCalledAfterAllTests()
    ' Remove all the test data
    m.Delete("mainData")
end sub

' @Test
sub NewApproach_CreateRowlist()
    rowList = CreateObject("roSGNode", "RowList")
    if UTF_assertNotInvalid(rowlist) then
        UTF_assertNotInvalid(rowlist.id)
    end if
end sub 