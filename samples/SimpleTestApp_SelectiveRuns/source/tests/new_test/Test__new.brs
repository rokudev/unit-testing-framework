' @BeforeAll
sub NewTest__BeforeAllTests()
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
sub NewTest__AfterAllTests()
    ' Remove all the test data
    m.Delete("mainData")
end sub

' @Test
sub New_Test()
    UTF_assertTrue(true)
end sub