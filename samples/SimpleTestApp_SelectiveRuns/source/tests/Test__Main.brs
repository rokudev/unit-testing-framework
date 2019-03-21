' @Test
sub Main_Test1()
    UTF_assertTrue(true)
end sub

' @Test
sub Main_Test2()
    UTF_assertTrue(true)
end sub 

' @Test
sub Main_Test3()
    UTF_assertTrue(true)
end sub

' @RepeatedTest(2)
sub Main_RepeatedTest1()
    UTF_assertTrue(true)
end sub

' @RepeatedTest(2)
sub Main_RepeatedTest2()
    UTF_assertTrue(true)
end sub

' @ParameterizedTest
' @MethodSource("stringProvider")
sub Main_ParametrizedTest1(argument = invalid as Dynamic)
    UTF_assertNotInvalid(argument)
end sub

function stringProvider()
    return ["foo", "bar", 1, 0, {}]
end function

' @ParameterizedTest
' @MethodSource("stringProvider")
sub Main_ParametrizedTest2(argument = invalid as Dynamic)
    UTF_assertNotInvalid(argument)
end sub

' @Ignore
sub Main_SkipTest()
    UTF_skip("skipped test")
end sub