Function TestSuite__API() as Object
    
    ' Inherite your test suite from BaseTestSuite
    this = BaseTestSuite()
    
    ' Test suite name for log statistics
    this.Name = "SampleTestSuite"
    
    ' Target testing object. To avoid the object creation in each test 
    ' we create instance of target object here and use it in tests as m.targetTestObject.
    this.targetTestObject  = InitApi()
    
    'custom asserts for sdk2.0 style 2 template
    'This may be placed in baseTestSuite object!!!
    this.assertContentListNode          = BTS__AssertContentListNode
    this.assertContentNode              = BTS__AssertContentNode
    this.assertContentNodeFlowLogic     = BTS__AssertContentNodeFlowLogic
    
    ' Add tests to suite's tests collection
    this.addTest("Check Input GetCategoriesMenu", TestCase__InputResult_GetCategoriesMenu)
    this.addTest("Check Output GetCategoriesMenu", TestCase__OutputResult_GetCategoriesMenu)
    this.addTest("Check GetSeasonContent", TestCase__GetSeasonContent)
    this.addTest("Check GetSubCategoriesMenu", TestCase__GetSubCategoriesMenu)
    this.addTest("Check GetChannelContent", TestCase__GetChannelContent)
    
    
    return this
End Function

'this test case tests GetChannelContent function of API module
Function TestCase__GetChannelContent() as String
    'as argument we pass AA because it is enough for holding result field, 
    'but also as input may be SomeNode with field "result" of type node.
    inputObject = {}
    
    m.targetTestObject.GetChannelContent(inputObject)
    
    result = inputObject.result
    
    'Result of this function should be Content List Node
    'that is valid for Label Node, MarkupList etc. 
    return m.AssertContentListNode(result)    
End Function

'This test checks output of Api function GetChannelContent
Function TestCase__OutputResult_GetCategoriesMenu() as string
    
    'Scheme object is used by ItemGenerator()
    'that generates object with proper field value types
    scheme = {
        params : { 
            category_id : "integer"
            category_name : "string"
        }
    }
    
    'Returns value with some random category_id and category_name  
    inputObject = ItemGenerator(scheme)
    
    'this function modify inputObject with setting value for result field
    m.targetTestObject.GetCategoriesMenu(inputObject)
    
    result = inputObject.result
   
    'Result of this function should be Content List Node
    'that is valid for LabelNode, MarkupList etc.
    return m.AssertContentListNode(result) 
End Function


'This test checks input of Api function GetChannelContent
'as result of this function is used for LabelList or MarkupList
'so this condition is declared by AssertContentNode function
Function TestCase__InputResult_GetCategoriesMenu() as string

    'wrong input test
    'in this test if don't pass category_id and category_name values
    'than GetCategoriesMenu should return empty ContentListNode
    inputObject = {}
    
    m.targetTestObject.GetCategoriesMenu(inputObject)
    
    result = inputObject.result
    'AssertContentNode it is the same as empty ContentListNode
    msgOfEmptyInput = m.AssertContentNode(result)
    
    'valid input test
    'Scheme object is used by ItemGenerator()
    'that generates object with proper field value types
    scheme = { 
        params : { 
            category_id : "integer"
            category_name : "string"
        }
    }
    
    'Returns value with some random category_id and category_name
    inputObject = ItemGenerator(scheme)
    
    'this function modify inputObject with setting value for result field
    m.targetTestObject.GetCategoriesMenu(inputObject)
    
    result = inputObject.result
    
    'Result of this function should be Content List Node
    'that is valid for LabelNode, MarkupList etc.
    msgOfNormalInput = m.AssertContentNode(result)
    
    'if result object pass two asserts than we have empty strings, otherwise
    'assert return string that explains source of trouble
    return msgOfEmptyInput + msgOfNormalInput
End Function

'this test case tests GetSeasonContent function of API module
Function TestCase__GetSeasonContent() as string
    'as argument we pass AA because it is enough for holding result field, 
    'but also as input may be SomeNode with field "result" of type node.
    inputObject = {}
    'call API method GetSeasonContent
    m.targetTestObject.GetSeasonContent(inputObject)
    
    result = inputObject.result
    
    'Result of this function should be Content List Node
    'that is valid for Label Node, MarkupList etc.
    return m.AssertContentListNode(result)
End Function

'this test case tests GetSubCategoriesMenu function of API module
Function TestCase__GetSubCategoriesMenu() as string
    'as argument we pass AA because it is enough for holding result field, 
    'but also as input may be SomeNode with field "result" of type node.
    inputObject = {}
    
    m.targetTestObject.GetSubCategoriesMenu(inputObject)
    
    result = inputObject.result
    'Result of this function should be Content List Node
    'that is valid for Label Node, MarkupList etc.
    return m.AssertContentListNode(result)
End Function


'This may be placed in baseTestSuite object!!!
'----------------------------------------------------------------
' Assertion methods which determine test failure
'----------------------------------------------------------------

'AssertContentNodeFlowLogic checks is input expression a Content Node and does it
'have mandatory field for panel sliding logic as nextPanelName
Function BTS__AssertContentNodeFlowLogic(expr as Dynamic, msg = "Expression doesn't have flow logic") as String
    if FW_IsValid(expr) and type(expr) = "roSGNode" and expr.subtype() = "ContentNode" then
        if expr.nextPanelName <> invalid or expr.nextPanelName <> "" then
            return ""
        end if
    end if
    return msg
End Function


'AssertContentNode checks is input expression a ContentNode
Function BTS__AssertContentNode(expr as Dynamic, msg = "Expression isn't valid content npode") as String
    if FW_IsValid(expr) and type(expr) = "roSGNode" and expr.subtype() = "ContentNode" then
        msg = ""
    end if
    return msg
End Function


'this function checks input expression on is it Content Node and does it have children of ContentNode (by AssertContentNodeFlowLogic function)   
Function BTS__AssertContentListNode(expr as Dynamic, msg = "Expression isn't list of content nodes") as String
    if FW_IsValid(expr) and type(expr) = "roSGNode" and expr.subtype() = "ContentNode" and expr.getChildCount() > 0 then
        for i = 0 to expr.getChildCount() - 1
            child = expr.getChild(i)
            msg = m.AssertContentNodeFlowLogic(child)
            
            if msg <> "" exit for
            
        end for
    end if
    return msg
End Function