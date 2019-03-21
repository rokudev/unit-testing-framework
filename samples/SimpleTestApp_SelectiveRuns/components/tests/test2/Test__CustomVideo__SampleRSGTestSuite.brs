' @Test
sub RSG_Test1()
    UTF_assertTrue(true)
end sub

' @Test
sub RSG_Test2()
    UTF_assertTrue(true)
end sub 

' @Test
sub RSG_Test3()
    UTF_assertTrue(true)
end sub

' @RepeatedTest(2)
sub RSG_RepeatedTest1()
    UTF_assertTrue(true)
end sub

' @RepeatedTest(2)
sub RSG_RepeatedTest2()
    UTF_assertTrue(true)
end sub

function stringProvider()
    return ["foo", "bar", 1, 0, {}]
end function

' @ParameterizedTest
' @MethodSource("stringProvider")
sub RSG_ParametrizedTest1(argument = invalid as Dynamic)
    UTF_assertNotInvalid(argument)
end sub

' @ParameterizedTest
' @MethodSource("stringProvider")
sub RSG_ParametrizedTest2(argument = invalid as Dynamic)
    UTF_assertNotInvalid(argument)
end sub
