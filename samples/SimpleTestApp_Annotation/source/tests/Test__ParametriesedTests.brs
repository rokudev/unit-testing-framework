' @ParameterizedTest
' @MethodSource("stringProvider")
sub testWithSimpleMethodSource(argument = invalid as Dynamic)
    UTF_assertNotInvalid(argument)
end sub

'@Test
sub dummyTest()

end sub

function stringProvider()
    return ["foo", "bar", 1, 0, {}]
end function

' @ParameterizedTest
' @MethodSource("invalidProvider")
sub testWithSimpleMethodSource2(argument = 1 as Dynamic)
    UTF_assertInvalid(argument)
end sub

function invalidProvider()
    return [invalid]
end function

' @ParameterizedTest
' @MethodSource("multipleArgsProvider")
sub testWithSimpleMethodSource3(argument as Dynamic)
    if UTF_assertNotInvalid(argument) then
        if UTF_assertAAHasKeys(argument, ["x", "y"])
            UTF_assertTrue((argument.x + argument.y) >= 0)
        end if
    end if
end sub

function multipleArgsProvider()
    return [{
        x: 1
        y: 1
    }, {
        x: 0
        y: 1
    }, {
        x: 0
        y: 0
    }, {
        x: 1
        y: 0
    }, {
        x: 0
        y: 1
    }, {
        x: 0
        y: 0
    }, {
        x: 1
        y: 0
    }]
end function

'------------------------------------------------------------------
'These functions should not be called as they have wrong anottations
'------------------------------------------------------------------
' @ParameterizedTest
sub invalidTest1(argument = 1 as Dynamic)
    UTF_assertTrue(false, "This function has only one required anottation")
end sub

' @MethodSource("invalidProvider")
sub invalidTest2(argument = 1 as Dynamic)
    UTF_assertTrue(false, "This function has only one required anottation")
end sub

' @ParameterizedTest
' @MethodSource("invalidFunctionThatshouldnotexist")
sub invalidTest3(argument = 1 as Dynamic)
    UTF_assertTrue(false, "This function has invalid provider")
end sub