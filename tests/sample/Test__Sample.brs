'*****************************************************************
'* Copyright Roku 2011-2016
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'     
'     TestSuite__Sample
'     TestCase__MyApp_TestObjectName_CheckInputItemType
'     TestCase__MyApp_TestObjectName_CheckInputItem
'     TestCase__MyApp_TestObjectName_CheckExpectedItem
     
'----------------------------------------------------------------
' Main setup function.
'
' @return A configured TestSuite object.
'----------------------------------------------------------------
Function TestSuite__Sample() as Object
    
    ' Inherite your test suite from BaseTestSuite
    this = BaseTestSuite()
    
    ' Test suite name for log statistics
    this.Name = "SampleTestSuite"
    
    ' Target testing object. To avoid the object creation in each test 
    ' we create instance of target object here and use it in tests as m.targetTestObject.
    this.targetTestObject  = MyApp__TargetObject()  
    
    ' Add tests to suite's tests collection
    this.addTest("CheckInputItemType", TestCase__MyApp_TestObjectName_CheckInputItemType)
    this.addTest("CheckInputItem", TestCase__MyApp_TestObjectName_CheckInputItem)
    this.addTest("CheckExpectedItem", TestCase__MyApp_TestObjectName_CheckExpectedItem)
    
    return this
End Function

'----------------------------------------------------------------
' Result should be invalid if type of inputObject 
' is not the one we expect.
' 
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
Function TestCase__MyApp_TestObjectName_CheckInputItemType() as string
    
    inputObject = 0
    
    result = m.targetTestObject.SomeFunction(inputObject)
    
    return m.assertInvalid(result)
    
End Function

'----------------------------------------------------------------
' SomeFunction should return not invalid object for 
' any random input associative array.
' 
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
Function TestCase__MyApp_TestObjectName_CheckInputItem() as string
    
    scheme = {
        key1  : "integer"
        key2  : "string"
        key3  : "boolean"
        key4  : {subKey1: "string"}
    }
    
    inputObject = ItemGenerator().getItem(scheme)
    result = m.targetTestObject.SomeFunction(inputObject)
    
    return m.assertNotInvalid(result)
    
End Function

'----------------------------------------------------------------
' SomeFunction should return object equal to expectedItem.
' 
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
Function TestCase__MyApp_TestObjectName_CheckExpectedItem() as string
    
    inputObject = {
        key1  : "Value1"
        key2  : "Value2"
        key3  : "Value3"
        key4  : {subKey1: "subValue1"}
    }
    
    expectedItem = {
        expectedKey1  : "Value1"
        expectedKey2  : "Value2"
        expectedKey3  : "Value3"
        expectedKey4  : {expectedSubKey1: "subValue1"}
    }
    
    resultItem = m.targetTestObject.SomeFunction(inputObject)
    
    return m.assertEqual(expectedItem, resultItem)
    
End Function