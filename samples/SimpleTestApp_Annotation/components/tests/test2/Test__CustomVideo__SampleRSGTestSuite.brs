
sub init()
    Runner = TestRunner()
    Runner.SetFunctions([
        TestCase__OnKeyEggggvent2
        _NewApproach_CreategggRowlistRepeatTest
    ])
end sub

' @Test
function TestCase__OnKeyEggggvent2() as Object
    UTF_assertTrue(CustomVideoNode_OnKeyEvent("back", true))
end function

' @RepeatedTest(3)
sub _NewApproach_CreategggRowlistRepeatTest()
    rowList = CreateObject("roSGNode", "RowList")
    UTF_assertNotInvalid(rowlist.id)
end sub

' ------------------------------------------------------------------
' These functions should not be called as they have wrong anottations
' ------------------------------------------------------------------

' @RepeatedTest
sub _133NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub

' @RepeatedTest
sub _13NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub

' @RepeatedTest
sub _11NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub

' @RepeatedTest
sub __NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub

' @RepeatedTest
sub _1NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub

' @RepeatedTest
sub _2NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub

' @RepeatedTest
sub _3NewApproach_CreateRowlistRepeatTest1()
    UTF_assertTrue(false, "invalid annotation")
end sub


