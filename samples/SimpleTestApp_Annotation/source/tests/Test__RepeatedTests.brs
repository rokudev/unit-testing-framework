' @RepeatedTest(3)
sub NewApproach_CreateRowlistRepeatTest()
    rowList = CreateObject("roSGNode", "RowList")
    UTF_assertNotInvalid(rowlist.id)
end sub 



'------------------------------------------------------------------
'These functions should not be called as they have wrong anottations
'------------------------------------------------------------------


' @RepeatedTest
sub NewApproach_CreateRowlistRepeatTest1()
     UTF_assertTrue(false, "invalid annotation")
end sub 

' @RepeatedTest(a1)
sub NewApproach_CreateRowlistRepeatTest2()
     UTF_assertTrue(false, "invalid annotation")
end sub 

' @RepeatedTest(az)
sub NewApproach_CreateRowlistRepeatTest3()
     UTF_assertTrue(false, "invalid annotation")
end sub 

' RepeatedTest(az)
sub NewApproach_CreateRowlistRepeatTest4()
     UTF_assertTrue(false, "invalid annotation")
end sub 
