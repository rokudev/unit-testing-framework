'*****************************************************************
'* Roku Unit Testing Framework (BETA)
'* A beta tool for automating test suites for Roku channels.
'*
'* Build Version: 1.1.0
'* Build Date: 1/20/2017
'*
'* Public Documentation is avaliable on GitHub:
'* 		https://github.com/rokudev/unit-testing-framework
'*
'*****************************************************************
'*****************************************************************
'* Copyright Roku 2011-2017
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'     
'     BaseTestSuite
'     BTS__AddTest
'     BTS__CreateTest
'     BTS__Fail
'     BTS__AssertFalse
'     BTS__AssertTrue
'     BTS__AssertEqual
'     BTS__AssertNotEqual
'     BTS__AssertInvalid
'     BTS__AssertNotInvalid
'     BTS__AssertAAHasKey
'     BTS__AssertAANotHasKey
'     BTS__AssertAAHasKeys
'     BTS__AssertAANotHasKeys
'     BTS__AssertArrayContains
'     BTS__AssertArrayNotContains
'     BTS__AssertArrayContainsSubset
'     BTS__AssertArrayNotContainsSubset
'     BTS__AssertArrayCount
'     BTS__AssertArrayNotCount
'     BTS__AssertEmpty
'     BTS__AssertNotEmpty
'     BTS__AssertArrayContainsOnly
'     BTS__EqValues
'     BTS__EqAssocArray
'     BTS__EqArray
     
'----------------------------------------------------------------
' Main function. Create BaseTestSuite object.
'
' @return A BaseTestSuite object.
'----------------------------------------------------------------
function BaseTestSuite()

    this = {}
    this.Name                           = "BaseTestSuite"
    'Test Cases methods
    this.testCases = []
    this.addTest                        = BTS__AddTest
    this.createTest                     = BTS__CreateTest

    'Assertion methods which determine test failure
    this.fail                           = BTS__Fail
    this.assertFalse                    = BTS__AssertFalse
    this.assertTrue                     = BTS__AssertTrue
    this.assertEqual                    = BTS__AssertEqual
    this.assertNotEqual                 = BTS__AssertNotEqual
    this.assertInvalid                  = BTS__AssertInvalid
    this.assertNotInvalid               = BTS__AssertNotInvalid
    this.assertAAHasKey                 = BTS__AssertAAHasKey
    this.assertAANotHasKey              = BTS__AssertAANotHasKey
    this.assertAAHasKeys                = BTS__AssertAAHasKeys
    this.assertAANotHasKeys             = BTS__AssertAANotHasKeys
    this.assertArrayContains            = BTS__AssertArrayContains
    this.assertArrayNotContains         = BTS__AssertArrayNotContains
    this.assertArrayContainsSubset      = BTS__AssertArrayContainsSubset
    this.assertArrayNotContainsSubset   = BTS__AssertArrayNotContainsSubset
    this.assertArrayCount               = BTS__AssertArrayCount
    this.assertArrayNotCount            = BTS__AssertArrayNotCount
    this.assertEmpty                    = BTS__AssertEmpty
    this.assertNotEmpty                 = BTS__AssertnotEmpty
    this.assertArrayContainsOnly        = BTS__AssertArrayContainsOnly

    'Type Comparison Functionality
    this.eqValues                       = BTS__EqValues
    this.eqAssocArrays                  = BTS__EqAssocArray
    this.eqArrays                       = BTS__EqArray

    return this
End Function

'----------------------------------------------------------------
' Add a test to a suite's test cases array.
' 
' @param name (string) A test name.
' @param func (string) A test function name.
'----------------------------------------------------------------
Sub BTS__AddTest(name as String, func as Object, setup = invalid as Object, teardown = invalid as Object)
    m.testCases.Push(m.createTest(name, func, setup, teardown))
End Sub

'----------------------------------------------------------------
' Create a test object.
' 
' @param name (string) A test name.
' @param func (string) A test function name.
'----------------------------------------------------------------
Function BTS__CreateTest(name as String, func as Object, setup = invalid as Object, teardown = invalid as Object) as Object
    return {
        Name: name 
        Func: func
        SetUp: setup
        TearDown: teardown
    }
End Function

'----------------------------------------------------------------
' Assertion methods which determine test failure
'----------------------------------------------------------------

'----------------------------------------------------------------
' Fail immediately, with the given message
' 
' @param msg (string) An error message.
' Default value: "Error".
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__Fail(msg = "Error" as string) as string
    return msg
End Function

'----------------------------------------------------------------
' Fail the test if the expression is true.
' 
' @param expr (dynamic) An expression to evaluate.
' @param msg (string) An error message.
' Default value: "Expression evaluates to true"
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertFalse(expr as dynamic, msg = "Expression evaluates to true" as string) as string
    if not FW_IsBoolean(expr) or expr
        return m.fail(msg)
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail the test unless the expression is true.
' 
' @param expr (dynamic) An expression to evaluate.
' @param msg (string) An error message.
' Default value: "Expression evaluates to false"
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertTrue(expr as dynamic, msg = "Expression evaluates to false" as string) as string
    if not FW_IsBoolean(expr) or not expr then
        return msg
    End if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the two objects are unequal as determined by the '<>' operator.
' 
' @param first (dynamic) A first object to compare.
' @param second (dynamic) A second object to compare.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertEqual(first as dynamic, second as dynamic, msg = "" as string) as string
    if not m.eqValues(first, second)
        if msg = ""
            first_as_string = FW_AsString(first)
            second_as_string = FW_AsString(second)
            msg = first_as_string + " != " + second_as_string 
        end if
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the two objects are equal as determined by the '=' operator.
' 
' @param first (dynamic) A first object to compare.
' @param second (dynamic) A second object to compare.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertNotEqual(first as dynamic, second as dynamic, msg = "" as string) as string
    if m.eqValues(first, second)
        if msg = ""
            first_as_string = FW_AsString(first)
            second_as_string = FW_AsString(second)
            msg = first_as_string + " == " + second_as_string 
        end if
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the value is not invalid.
' 
' @param value (dynamic) A value to check.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertInvalid(value as dynamic, msg = "" as string) as string
    if value <> Invalid
        if msg = ""
            expr_as_string = FW_AsString(value)
            msg = expr_as_string + " <> Invalid"
        end if
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the value is invalid.
' 
' @param value (dynamic) A value to check.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertNotInvalid(value as dynamic, msg = "" as string) as string
    if value = Invalid
        if msg = ""
            expr_as_string = FW_AsString(value)
            msg = expr_as_string + " = Invalid"
        end if
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array doesn't have the key.
' 
' @param array (dynamic) A target array.
' @param key (string) A key name.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertAAHasKey(array as dynamic, key as string, msg = "" as string) as string
    if FW_IsAssociativeArray(array)
        if not array.DoesExist(key)
            if msg = ""
                msg = "Array doesn't have the '" + key + "' key."
            end if
        return msg
        end if
    else
        msg = "Input value is not an Associative Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array has the key.
' 
' @param array (dynamic) A target array.
' @param key (string) A key name.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertAANotHasKey(array as dynamic, key as string, msg = "" as string) as string
    if FW_IsAssociativeArray(array)
        if array.DoesExist(key)
            if msg = ""
                msg = "Array has the '" + key + "' key."
            end if
        return msg
        end if
    else
        msg = "Input value is not an Associative Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array doesn't have the keys list.
' 
' @param array (dynamic) A target associative array.
' @param keys (object) A key names array.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertAAHasKeys(array as dynamic, keys as object, msg = "" as string) as string
    if FW_IsAssociativeArray(array) and FW_IsArray(keys)
        for each key in keys
            if not array.DoesExist(key)
                if msg = ""
                    msg = "Array doesn't have the '" + key + "' key."
                end if
            return msg
            end if
        end for
    else
        msg = "Input value is not an Associative Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array has the keys list.
' 
' @param array (dynamic) A target associative array.
' @param keys (object) A key names array.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertAANotHasKeys(array as dynamic, keys as object, msg = "" as string) as string
    if FW_IsAssociativeArray(array) and FW_IsArray(keys)
        for each key in keys
            if array.DoesExist(key)
                if msg = ""
                    msg = "Array has the '" + key + "' key."
                end if
            return msg
            end if
        end for
    else
        msg = "Input value is not an Associative Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array doesn't have the item.
' 
' @param array (dynamic) A target array.
' @param value (dynamic) A value to check.
' @param key (object) A key name for associative array.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayContains(array as dynamic, value as dynamic, key = invalid as string, msg = "" as string) as string
    if FW_IsAssociativeArray(array) or FW_IsArray(array)
        if not FW_ArrayContains(array, value, key)
            msg = "Array doesn't have the '" + FW_AsString(value) + "' value."
            return msg
        end if
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array has the item.
' 
' @param array (dynamic) A target array.
' @param value (dynamic) A value to check.
' @param key (object) A key name for associative array.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayNotContains(array as dynamic, value as dynamic, key = invalid as string, msg = "" as string) as string
    if FW_IsAssociativeArray(array) or FW_IsArray(array)
        if FW_ArrayContains(array, value, key)
            msg = "Array has the '" + FW_AsString(value) + "' value."
            return msg
        end if
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array doesn't have the item subset.
' 
' @param array (dynamic) A target array.
' @param subset (dynamic) An items array to check.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayContainsSubset(array as dynamic, subset as dynamic, msg = "" as string) as string
    if (FW_IsAssociativeArray(array) and FW_IsAssociativeArray(subset)) or (FW_IsArray(array) and FW_IsArray(subset))
        isAA = FW_IsAssociativeArray(subset)
        for each item in subset
            key = invalid
            value = item
            if isAA
                key = item
                value = item[key]
            end if
            if not FW_ArrayContains(array, value, key)
                msg = "Array doesn't have the '" + FW_AsString(value) + "' value."
                return msg
            end if
        end for
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array have the item from subset.
' 
' @param array (dynamic) A target array.
' @param subset (dynamic) A items array to check.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayNotContainsSubset(array as dynamic, subset as dynamic, msg = "" as string) as string
    if (FW_IsAssociativeArray(array) and FW_IsAssociativeArray(subset)) or (FW_IsArray(array) and FW_IsArray(subset))
        isAA = FW_IsAssociativeArray(subset)
        for each item in subset
            key = invalid
            value = item
            if isAA
                key = item
                value = item[key]
            end if
            if FW_ArrayContains(array, value, key)
                msg = "Array has the '" + FW_AsString(value) + "' value."
                return msg
            end if
        end for
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array items count <> expected count
' 
' @param array (dynamic) A target array.
' @param count (integer) An expected array items count.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayCount(array as dynamic, count as integer, msg = "" as string) as string
    if FW_IsAssociativeArray(array) or FW_IsArray(array)
        if array.Count() <> count
            msg = "Array items count <> " + FW_AsString(count) + "."
            return msg
        end if
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array items count = expected count.
' 
' @param array (dynamic) A target array.
' @param count (integer) An expected array items count.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayNotCount(array as dynamic, count as integer, msg = "" as string) as string
    if FW_IsAssociativeArray(array) or FW_IsArray(array)
        if array.Count() = count
            msg = "Array items count = " + FW_AsString(count) + "."
            return msg
        end if
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the item is not empty array or string.
' 
' @param item (dynamic) An array or string to check.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertEmpty(item as dynamic, msg = "" as string) as string
    if FW_IsAssociativeArray(item) or FW_IsArray(item)
        if item.Count() > 0
            msg = "Array is not empty."
            return msg
        end if
    else if FW_AsString(item) <> ""
        msg = "Input value is not empty."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the item is empty array or string.
' 
' @param item (dynamic) An array or string to check.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertNotEmpty(item as dynamic, msg = "" as string) as string
    if FW_IsAssociativeArray(item) or FW_IsArray(item)
        if item.Count() = 0
            msg = "Array is empty."
            return msg
        end if
    else if FW_AsString(item) = ""
        msg = "Input value is empty."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Fail if the array doesn't contains items of specific type only.
' 
' @param array (dynamic) A target array.
' @param typeStr (string) An items type name.
' @param msg (string) An error message.
' Default value: ""
'
' @return An error message.
'----------------------------------------------------------------
Function BTS__AssertArrayContainsOnly(array as dynamic, typeStr as string, msg = "" as string) as string
    if FW_IsAssociativeArray(array) or FW_IsArray(array)
        methodName = "FW_Is" + typeStr
        for each item in array
            if not methodName(item)
                msg = FW_AsString(item) + "is not a '" + typeStr + "' type."
                return msg
            end if    
        end for
    else
        msg = "Input value is not an Array."
        return msg
    end if
    return ""
End Function

'----------------------------------------------------------------
' Type Comparison Functionality
'----------------------------------------------------------------

'----------------------------------------------------------------
' Compare two arbtrary values to eachother.
' 
' @param Value1 (dynamic) A first item to compare.
' @param Value2 (dynamic) A second item to compare.
'
' @return True if values are equal or False in other case.
'----------------------------------------------------------------
Function BTS__EqValues(Value1 as dynamic, Value2 as dynamic) as Boolean
    ' Workaraund for bug with String boxing
    if type(Value1) = "roString"
        Value1 = FW_AsString(Value1)
    end if
    
    if type(Value2) = "roString"
        Value2 = FW_AsString(Value2)
    end if
    
    'Upcast int to float, if other is float
    if type(Value1) = "roFloat" and type(Value2) = "roInt"
        Value2 = box(Cdbl(Value2))
    else if type(Value2) = "roFloat" and type(Value1) = "roInt"
        Value1 = box(Cdbl(Value1))
    end if

    if type(Value1) <> type(Value2)
        return False
    else
        valtype = type(Value1)
        
        if valtype = "<uninitialized>"
            return False
        else if valtype = "roList"
            return m.eqArrays(Value1, Value2)
        else if valtype = "roAssociativeArray"
            return m.eqAssocArrays(Value1, Value2)
        else if valtype = "roArray"
            return m.eqArrays(Value1, Value2)
        else
            return Value1 = Value2
        end if    
    end if
End Function 

'----------------------------------------------------------------
' Compare to roAssociativeArray objects for equality.
' 
' @param Value1 (object) A first associative array.
' @param Value2 (object) A second associative array.
' 
' @return True if arrays are equal or False in other case.
'----------------------------------------------------------------
Function BTS__EqAssocArray(Value1 as Object, Value2 as Object) as Boolean
    l1 = Value1.Count()
    l2 = Value2.Count()
    
    if not l1 = l2
        return False
    else
        for each k in Value1
            if not Value2.DoesExist(k)
                return False
            else
                v1 = Value1[k]
                v2 = Value2[k]
                if not m.eqValues(v1, v2)
                    return False
                end if
            end if
        end for
        return True
    end if
End Function 

'----------------------------------------------------------------
' Compare to roArray objects for equality.
' 
' @param Value1 (object) A first array.
' @param Value2 (object) A second array.
' 
' @return True if arrays are equal or False in other case.
'----------------------------------------------------------------
Function BTS__EqArray(Value1 as Object, Value2 as Object) as Boolean
    l1 = Value1.Count()
    l2 = Value2.Count()
    
    if not l1 = l2
        return False
    else
        for i = 0 to l1 - 1
            v1 = Value1[i]
            v2 = Value2[i]
            if not m.eqValues(v1, v2) then
                return False
            end if
        end for
        return True
    end if
End Function'*****************************************************************
'* Copyright Roku 2011-2017
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'     ItemGenerator
'     IG_GetItem
'     IG_GetAssocArray
'     IG_GetArray
'     IG_GetSimpleType
'     IG_GetBoolean
'     IG_GetInteger
'     IG_GetFloat
'     IG_GetString
'

'----------------------------------------------------------------
' Main function to generate object according to specified scheme.
'
' @param scheme (object) A scheme with desired object structure. Can be 
' any simple type, array of types or associative array in form 
'     { propertyName1 : "propertyType1"
'       propertyName2 : "propertyType2"
'       ...
'       propertyNameN : "propertyTypeN" }
'
' @return An object according to specified scheme or invalid, 
' if scheme is not valid.
'----------------------------------------------------------------
Function ItemGenerator(scheme as object) as Object
    
    this = {}
    
    this.getItem        = IG_GetItem
    this.getAssocArray  = IG_GetAssocArray
    this.getArray       = IG_GetArray
    this.getSimpleType  = IG_GetSimpleType
    this.getInteger     = IG_GetInteger
    this.getFloat       = IG_GetFloat
    this.getString      = IG_GetString
    this.getBoolean     = IG_GetBoolean
    
    if not FW_IsValid(scheme)
        return invalid
    end if
    
    return this.getItem(scheme)
End Function

' TODO: Create IG_GetInvalidItem function with random type fields

'----------------------------------------------------------------
' Generate object according to specified scheme.
'
' @param scheme (object) A scheme with desired object structure. 
' Can be any simple type, array of types or associative array.
'
' @return An object according to specified scheme or invalid,  
' if scheme is not one of simple type, array or 
' associative array.
'----------------------------------------------------------------
Function IG_GetItem(scheme as object) as object
    
    item = invalid
    
    if FW_IsAssociativeArray(scheme)
        item = m.getAssocArray(scheme)
    else if FW_IsArray(scheme)
        item = m.getArray(scheme)
    else if FW_IsString(scheme) 
        item = m.getSimpleType(lCase(scheme))
    end if    
    
    return item
End Function

'----------------------------------------------------------------
' Generates associative array according to specified scheme.
'
' @param scheme (object) An associative array with desired 
'    object structure in form 
'     { propertyName1 : "propertyType1"
'       propertyName2 : "propertyType2"
'       ...
'       propertyNameN : "propertyTypeN" }
'
' @return An associative array according to specified scheme.
'----------------------------------------------------------------
Function IG_GetAssocArray(scheme as object) as object
    
    item = {}
    
    for each key in scheme
        if not item.DoesExist(key)
            item[key] = m.getItem(scheme[key])
        end if
    end for
    
    return item
End Function

'----------------------------------------------------------------
' Generates array according to specified scheme.
'
' @param scheme (object) An array with desired object types. 
'
' @return An array according to specified scheme.
'----------------------------------------------------------------
Function IG_GetArray(scheme as object) as object
    
    item = []
    
    for each key in scheme
        item.Push(m.getItem(key))
    end for
    
    return item
End Function

'----------------------------------------------------------------
' Generates random value of specified type.
'
' @param typeStr (string) A name of desired object type. 
'
' @return A simple type object or invalid if type is not supported.
'----------------------------------------------------------------
Function IG_GetSimpleType(typeStr as string) as object
    
    item = invalid
    
    if typeStr = "integer" or typeStr = "int" or typeStr = "roint"
        item = m.getInteger()
    else if typeStr = "float" or typeStr = "rofloat"
        item = m.getFloat()
    else if typeStr = "string" or typeStr = "rostring"
        item = m.getString(10)
    else if typeStr = "boolean" or typeStr = "roboolean"
        item = m.getBoolean()
    end if
    
    return item
End Function

'----------------------------------------------------------------
' Generates random boolean value.
'
' @return A random boolean value.
'----------------------------------------------------------------
Function IG_GetBoolean() as boolean
    return FW_AsBoolean(Rnd(2) \ Rnd(2))
End Function

'----------------------------------------------------------------
' Generates random integer value from 1 to specified seed value.
'
' @param seed (integer) A seed value for Rnd function. 
' Default value: 100.
'
' @return A random integer value.
'----------------------------------------------------------------
Function IG_GetInteger(seed = 100 as integer) as integer
    return Rnd(seed)
End Function

'----------------------------------------------------------------
' Generates random float value.
'
' @return A random float value.
'----------------------------------------------------------------
Function IG_GetFloat() as float
    return Rnd(0)
End Function

'----------------------------------------------------------------
' Generates random string with specified length.
'
' @param seed (integer) A string length.
'
' @return A random string value or empty string if seed is 0.
'----------------------------------------------------------------
Function IG_GetString(seed as integer) as string
    
    item = ""
    if seed > 0
        stringLength = Rnd(seed)
        
        for i = 0 to stringLength
            chType = Rnd(3)
            
            if chType = 1       'Chr(48-57) - numbers
                chNumber = 47 + Rnd(10)
            else if chType = 2  'Chr(65-90) - Uppercase Letters
                chNumber = 64 + Rnd(26)
            else                'Chr(97-122) - Lowercase Letters
                chNumber = 96 + Rnd(26)
            end if
            
            item = item + Chr(chNumber)
        end for
    end if
    
    return item
End Function'*****************************************************************
'* Copyright Roku 2011-2017
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'        Logger
'        Logger__SetVerbosity
'        Logger__SetEcho
'        Logger__SetServerURL
'        Logger__PrintStatistic
'        Logger__SendToServer
'        Logger__CreateTotalStatistic
'        Logger__CreateSuiteStatistic
'        Logger__CreateTestStatistic
'        Logger__AppendSuiteStatistic
'        Logger__AppendTestStatistic
'        Logger__PrintSuiteStatistic
'        Logger__PrintTestStatistic
'        Logger__PrintStart
'        Logger__PrintEnd
'        Logger__PrintSuiteSetUp
'        Logger__PrintSuiteStart
'        Logger__PrintSuiteEnd
'        Logger__PrintSuiteTearDown
'        Logger__PrintTestSetUp
'        Logger__PrintTestStart
'        Logger__PrintTestEnd
'        Logger__PrintTestTearDown

'----------------------------------------------------------------
' Main function. Create Logger object.
'
' @return A Logger object.
'----------------------------------------------------------------
function Logger() as Object
    this = {}

    this.verbosityLevel = {
        basic   : 0
        normal  : 1
        verbose : 2   
    }

    ' Internal properties
    this.verbosity              = 1
    this.echoEnabled            = false
    this.serverURL              = invalid

    ' Interface
    this.SetVerbosity           = Logger__SetVerbosity
    this.SetEcho                = Logger__SetEcho
    this.SetServerURL           = Logger__SetServerURL
    this.PrintStatistic         = Logger__PrintStatistic
    this.SendToServer           = Logger__SendToServer

    this.CreateTotalStatistic   = Logger__CreateTotalStatistic
    this.CreateSuiteStatistic   = Logger__CreateSuiteStatistic
    this.CreateTestStatistic    = Logger__CreateTestStatistic
    this.AppendSuiteStatistic   = Logger__AppendSuiteStatistic
    this.AppendTestStatistic    = Logger__AppendTestStatistic

    ' Internal functions
    this.PrintSuiteStatistic    = Logger__PrintSuiteStatistic
    this.PrintTestStatistic     = Logger__PrintTestStatistic
    this.PrintStart             = Logger__PrintStart
    this.PrintEnd               = Logger__PrintEnd
    this.PrintSuiteSetUp        = Logger__PrintSuiteSetUp
    this.PrintSuiteStart        = Logger__PrintSuiteStart
    this.PrintSuiteEnd          = Logger__PrintSuiteEnd
    this.PrintSuiteTearDown     = Logger__PrintSuiteTearDown
    this.PrintTestSetUp         = Logger__PrintTestSetUp
    this.PrintTestStart         = Logger__PrintTestStart
    this.PrintTestEnd           = Logger__PrintTestEnd
    this.PrintTestTearDown      = Logger__PrintTestTearDown

    return this
end function

'----------------------------------------------------------------
' Set logging verbosity parameter.
' 
' @param verbosity (integer) A verbosity level.
' Posible values:
'     0 - basic
'     1 - normal
'     2 - verbose
' Default level: 1
'----------------------------------------------------------------
sub Logger__SetVerbosity(verbosity = 1 as Integer)
    if verbosity >= 0 and verbosity <= 2
        m.verbosity = verbosity
    end if
end sub

'----------------------------------------------------------------
' Set logging echo parameter.
' 
' @param enable (boolean) A echo trigger.
' Posible values: true or false
' Default value: false
'----------------------------------------------------------------
sub Logger__SetEcho(enable = false as Boolean)
    m.echoEnabled = enable
end sub

'----------------------------------------------------------------
' Set storage server URL parameter.
' 
' @param url (string) A storage server URL.
' Default level: invalid
'----------------------------------------------------------------
sub Logger__SetServerURL(url = invalid as String)
    if url <> invalid
        m.serverURL = url
    end if
end sub

'----------------------------------------------------------------
' Set storage server URL parameter.
' 
' @param url (string) A storage server URL.
' Default level: invalid
'----------------------------------------------------------------
sub Logger__SendToServer(statObj as Object)
    if m.serverURL <> invalid
        ' Send log file to server
    end if
end sub

'----------------------------------------------------------------
' Print statistic object with specified verbosity.
' 
' @param statObj (object) A statistic object to print.
'----------------------------------------------------------------
sub Logger__PrintStatistic(statObj as Object)
    if not m.echoEnabled
        m.PrintStart()

        if m.verbosity = m.verbosityLevel.normal
            for each testSuite in statObj.Suites
                for each testCase in testSuite.Tests
                    ? "***   "; testSuite.Name; ": "; testCase.Name; " - "; testCase.Result
                end for
            end for
        else if m.verbosity = m.verbosityLevel.verbose
            for each testSuite in statObj.Suites
                m.PrintSuiteStatistic(testSuite)
            end for
        end if
    end if

    ? "***"
    ? "***   Total  = "; FW_AsString(statObj.Total); " ; Passed  = "; statObj.Correct; " ; Failed   = "; statObj.Fail; " ; Crashes  = "; statObj.Crash;
    ? " Time spent: "; statObj.Time; "ms"
    ? "***"

    m.PrintEnd()
end sub

'----------------------------------------------------------------
' Create an empty statistic object for totals in output log.
'
' @return An empty statistic object.
'----------------------------------------------------------------
function Logger__CreateTotalStatistic() as Object
    statTotalItem = {
        Suites      : []
        Time        : 0
        Total       : 0
        Correct     : 0
        Fail        : 0
        Crash       : 0
    }

    if m.echoEnabled
        m.PrintStart()
    end if

    return statTotalItem
end function

'----------------------------------------------------------------
' Create an empty statistic object for test suite with specified name.
'
' @param name (string) A test suite name for statistic object.
'
' @return An empty statistic object for test suite.
'----------------------------------------------------------------
function Logger__CreateSuiteStatistic(name as String) as Object
    statSuiteItem = {
        Name    : name
        Tests   : []
        Time    : 0
        Total   : 0
        Correct : 0
        Fail    : 0
        Crash   : 0
    }

    if m.echoEnabled
        if m.verbosity = m.verbosityLevel.verbose
            m.PrintSuiteStart(name)
        end if
    end if

    return statSuiteItem
end function

'----------------------------------------------------------------
' Create statistic object for test with specified name.
'
' @param name (string) A test name.
' @param result (string) A result of test running.
' Posible values: "Success", "Fail".
' Default value: "Success"
' @param time (integer) A test running time.
' Default value: 0
' @param errorCode (integer) An error code for failed test.
' Posible values:
'     252 (&hFC) : ERR_NORMAL_END
'     226 (&hE2) : ERR_VALUE_RETURN
'     233 (&hE9) : ERR_USE_OF_UNINIT_VAR
'     020 (&h14) : ERR_DIV_ZERO
'     024 (&h18) : ERR_TM
'     244 (&hF4) : ERR_RO2
'     236 (&hEC) : ERR_RO4
'     002 (&h02) : ERR_SYNTAX
'     241 (&hF1) : ERR_WRONG_NUM_PARAM
' Default value: 0
' @param errorMessage (string) An error message for failed test.
'
' @return A statistic object for test.
'----------------------------------------------------------------
function Logger__CreateTestStatistic(name as String, result = "Success" as String, time = 0 as Integer, errorCode = 0 as Integer, errorMessage = "" as String) as Object
    statTestItem = {
        Name    : name
        Result  : result
        Time    : time
        Error   : {
            Code    : errorCode
            Message : errorMessage
        }
    }

    if m.echoEnabled
        if m.verbosity = m.verbosityLevel.verbose
            m.PrintTestStart(name)
        end if
    end if

    return statTestItem
end function

'----------------------------------------------------------------
' Append test statistic to test suite statistic.
'
' @param statSuiteObj (object) A target test suite object.
' @param statTestObj (object) A test statistic to append.
'----------------------------------------------------------------
sub Logger__AppendTestStatistic(statSuiteObj as Object, statTestObj as Object)
    if FW_IsAssociativeArray(statSuiteObj) and FW_IsAssociativeArray(statTestObj)
        statSuiteObj.Tests.Push(statTestObj)

        if FW_IsInteger(statTestObj.time)
            statSuiteObj.Time = statSuiteObj.Time + statTestObj.Time
        end if

        statSuiteObj.Total = statSuiteObj.Total + 1

        if lCase(statTestObj.Result) = "success"
            statSuiteObj.Correct = statSuiteObj.Correct + 1
        else if lCase(statTestObj.result) = "fail"
            statSuiteObj.Fail = statSuiteObj.Fail + 1
        else
            statSuiteObj.crash = statSuiteObj.crash + 1
        end if

        if m.echoEnabled
            if m.verbosity = m.verbosityLevel.normal
                ? "***   "; statSuiteObj.Name; ": "; statTestObj.Name; " - "; statTestObj.Result
            else if m.verbosity = m.verbosityLevel.verbose
                m.PrintTestStatistic(statTestObj)
            end if
        end if
    end if
end sub

'----------------------------------------------------------------
' Append suite statistic to total statistic object.
'
' @param statTotalObj (object) A target total statistic object.
' @param statSuiteObj (object) A test suite statistic object to append.
'----------------------------------------------------------------
sub Logger__AppendSuiteStatistic(statTotalObj as Object, statSuiteObj as Object)
    if FW_IsAssociativeArray(statTotalObj) and FW_IsAssociativeArray(statSuiteObj)
        statTotalObj.Suites.Push(statSuiteObj)
        statTotalObj.Time = statTotalObj.Time + statSuiteObj.Time

        if FW_IsInteger(statSuiteObj.Total)
            statTotalObj.Total = statTotalObj.Total + statSuiteObj.Total
        end if

        if FW_IsInteger(statSuiteObj.Correct)
            statTotalObj.Correct = statTotalObj.Correct + statSuiteObj.Correct
        end if

        if FW_IsInteger(statSuiteObj.Fail)
            statTotalObj.Fail = statTotalObj.Fail + statSuiteObj.Fail
        end if

        if FW_IsInteger(statSuiteObj.Crash)
            statTotalObj.Crash = statTotalObj.Crash + statSuiteObj.Crash
        end if

        if m.echoEnabled
            if m.verbosity = m.verbosityLevel.verbose
                m.PrintSuiteStatistic(statSuiteObj)
            end if
        end if
    end if
end sub

'----------------------------------------------------------------
' Print test suite statistic.
' 
' @param statSuiteObj (object) A target test suite object to print.
'----------------------------------------------------------------
sub Logger__PrintSuiteStatistic(statSuiteObj as Object)
    if not m.echoEnabled
        m.PrintSuiteStart(statSuiteObj.Name)

        for each testCase in statSuiteObj.Tests
            m.PrintTestStatistic(testCase)
        end for
    end if

    ? "==="
    ? "===   Total  = "; FW_AsString(statSuiteObj.Total); " ; Passed  = "; statSuiteObj.Correct; " ; Failed   = "; statSuiteObj.Fail; " ; Crashes  = "; statSuiteObj.Crash;
    ? " Time spent: "; statSuiteObj.Time; "ms"
    ? "==="

    m.PrintSuiteEnd(statSuiteObj.Name)
end sub

'----------------------------------------------------------------
' Print test statistic.
' 
' @param statTestObj (object) A target test object to print.
'----------------------------------------------------------------
sub Logger__PrintTestStatistic(statTestObj as Object)
    if not m.echoEnabled
        m.PrintTestStart(statTestObj.Name)
    end if

    ? "---   Result:        "; statTestObj.Result
    ? "---   Time:          "; statTestObj.Time

    if LCase(statTestObj.Result) <> "success"
        ? "---   Error Code:    "; statTestObj.Error.Code
        ? "---   Error Message: "; statTestObj.Error.Message
    end if

    m.PrintTestEnd(statTestObj.Name)
end sub

'----------------------------------------------------------------
' Print testting start message.
'----------------------------------------------------------------
sub Logger__PrintStart()
    ? ""
    ? "******************************************************************"
    ? "******************************************************************"
    ? "*************            Start testing               *************"
    ? "******************************************************************"
end sub

'----------------------------------------------------------------
' Print testing end message.
'----------------------------------------------------------------
sub Logger__PrintEnd()
    ? "******************************************************************"
    ? "*************             End testing                *************"
    ? "******************************************************************"
    ? "******************************************************************"
    ? ""
end sub

'----------------------------------------------------------------
' Print test suite SetUp message.
'----------------------------------------------------------------
sub Logger__PrintSuiteSetUp(sName as String)
    if m.verbosity = m.verbosityLevel.verbose
        ? "================================================================="
        ? "===   SetUp "; sName; " suite."
        ? "================================================================="
    end if
end sub

'----------------------------------------------------------------
' Print test suite start message.
'----------------------------------------------------------------
sub Logger__PrintSuiteStart(sName as String)
    ? "================================================================="
    ? "===   Start "; sName; " suite:"
    ? "==="
end sub

'----------------------------------------------------------------
' Print test suite end message.
'----------------------------------------------------------------
sub Logger__PrintSuiteEnd(sName as String)
    ? "==="
    ? "===   End "; sName; " suite."
    ? "================================================================="
End Sub

'----------------------------------------------------------------
' Print test suite TearDown message.
'----------------------------------------------------------------
sub Logger__PrintSuiteTearDown(sName as String)
    if m.verbosity = m.verbosityLevel.verbose
        ? "================================================================="
        ? "===   TearDown "; sName; " suite."
        ? "================================================================="
    end if
end sub

'----------------------------------------------------------------
' Print test setUp message.
'----------------------------------------------------------------
sub Logger__PrintTestSetUp(tName as String)
    if m.verbosity = m.verbosityLevel.verbose
        ? "----------------------------------------------------------------"
        ? "---   SetUp "; tName; " test."
        ? "----------------------------------------------------------------"
    end if
end sub

'----------------------------------------------------------------
' Print test start message.
'----------------------------------------------------------------
sub Logger__PrintTestStart(tName as String)
    ? "----------------------------------------------------------------"
    ? "---   Start "; tName; " test:"
    ? "---"
end sub

'----------------------------------------------------------------
' Print test end message.
'----------------------------------------------------------------
sub Logger__PrintTestEnd(tName as String)
    ? "---"
    ? "---   End "; tName; " test."
    ? "----------------------------------------------------------------"
end sub

'----------------------------------------------------------------
' Print test TearDown message.
'----------------------------------------------------------------
sub Logger__PrintTestTearDown(tName as String)
    if m.verbosity = m.verbosityLevel.verbose
        ? "----------------------------------------------------------------"
        ? "---   TearDown "; tName; " test."
        ? "----------------------------------------------------------------"
    end if
end sub
'*****************************************************************
'* Copyright Roku 2011-2017
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'        TestRunner
'        TestRunner__Run
'        TestRunner__SetTestsDirectory
'        TestRunner__SetTestFilePrefix
'        TestRunner__SetTestSuitePrefix
'        TestRunner__SetTestSuiteName
'        TestRunner__SetTestCaseName
'        TestRunner__SetFailFast
'        TestRunner__GetTestSuitesList
'        TestRunner__GetTestFilesList

'----------------------------------------------------------------
' Main function. Create TestRunner object.
'
' @return A TestRunner object.
'----------------------------------------------------------------
function TestRunner() as Object

    this = {}

    this.logger = Logger()

    ' Internal properties
    this.testsDirectory         = "pkg:/source/tests"
    this.testFilePrefix         = "Test__"
    this.testSuitePrefix        = "TestSuite__"
    this.testSuiteName          = ""
    this.testCaseName           = ""
    this.failFast               = false

    ' Interface
    this.Run                    = TestRunner__Run
    this.SetTestsDirectory      = TestRunner__SetTestsDirectory
    this.SetTestFilePrefix      = TestRunner__SetTestFilePrefix
    this.SetTestSuitePrefix     = TestRunner__SetTestSuitePrefix
    this.SetTestSuiteName       = TestRunner__SetTestSuiteName
    this.SetTestCaseName        = TestRunner__SetTestCaseName
    this.SetFailFast            = TestRunner__SetFailFast

    ' Internal functions
    this.GetTestFilesList       = TestRunner__GetTestFilesList
    this.GetTestSuitesList      = TestRunner__GetTestSuitesList

    return this
end function

'----------------------------------------------------------------
' Run main test loop.
'----------------------------------------------------------------
sub TestRunner__Run()
    alltestCount = 0
    totalStatObj = m.logger.CreateTotalStatistic()
    testSuitesList = m.GetTestSuitesList()

    for each testSuite in testSuitesList
        testCases = testSuite.testCases
        testCount = testCases.Count()
        alltestCount = alltestCount + testCount

        if FW_IsFunction(testSuite.SetUp)
            m.logger.PrintSuiteSetUp(testSuite.Name)
            testSuite.SetUp()
        end if

        suiteStatObj = m.logger.CreateSuiteStatistic(testSuite.Name)

        for each testCase in testCases
            if m.testCaseName = "" or (m.testCaseName <> "" and LCase(testCase.Name) = LCase(m.testCaseName))
                if FW_IsFunction(testCase.SetUp)
                    m.logger.PrintTestSetUp(testCase.Name)
                    testCase.SetUp()
                end if

                testTimer = CreateObject("roTimespan")
                testStatObj = m.logger.CreateTestStatistic(testCase.Name)
                testSuite.testCase = testCase.Func

                runResult = testSuite.testCase()

                if runResult <> ""
                    testStatObj.Result          = "Fail"
                    testStatObj.Error.Code      = 1
                    testStatObj.Error.Message   = runResult
                else
                    testStatObj.Result          = "Success"
                end if

                testStatObj.Time = testTimer.TotalMilliseconds()
                m.logger.AppendTestStatistic(suiteStatObj, testStatObj)

                if FW_IsFunction(testCase.TearDown)
                    m.logger.PrintTestTearDown(testCase.Name)
                    testCase.TearDown()
                end if

                if testStatObj.Result = "Fail" and m.failFast
                    exit for
                end if
            end if
        end for

        m.logger.AppendSuiteStatistic(totalStatObj, suiteStatObj)

        if FW_IsFunction(testSuite.TearDown)
            m.logger.PrintSuiteTearDown(testSuite.Name)
            testSuite.TearDown()
        end if

        if testStatObj.Result = "Fail" and m.failFast
            exit for
        end if
    end for

    m.logger.PrintStatistic(totalStatObj)
end sub

'----------------------------------------------------------------
' Set testsDirectory property.
'----------------------------------------------------------------
sub TestRunner__SetTestsDirectory(testsDirectory as String)
    if testsDirectory <> invalid
        m.testsDirectory = testsDirectory
    end if
end sub

'----------------------------------------------------------------
' Set setTestFilePrefix property.
'----------------------------------------------------------------
sub TestRunner__SetTestFilePrefix(setTestFilePrefix as String)
    if setTestFilePrefix <> invalid
        m.testFilePrefix = setTestFilePrefix
    end if
end sub

'----------------------------------------------------------------
' Set testSuitePrefix property.
'----------------------------------------------------------------
sub TestRunner__SetTestSuitePrefix(testSuitePrefix as String)
    if testSuitePrefix <> invalid
        m.testSuitePrefix = testSuitePrefix
    end if
end sub

'----------------------------------------------------------------
' Set testSuiteName property.
'----------------------------------------------------------------
sub TestRunner__SetTestSuiteName(testSuiteName as String)
    if testSuiteName <> invalid
        m.testSuiteName = testSuiteName
    end if
end sub

'----------------------------------------------------------------
' Set testCaseName property.
'----------------------------------------------------------------
sub TestRunner__SetTestCaseName(testCaseName as String)
    if testCaseName <> invalid
        m.testCaseName = testCaseName
    end if
end sub

'----------------------------------------------------------------
' Set failFast property.
'----------------------------------------------------------------
sub TestRunner__SetFailFast(failFast = false as Boolean)
    m.failFast = failFast
end sub

'----------------------------------------------------------------
' Scan all test files for test suites.
'
' @return An array of test suites.
'----------------------------------------------------------------
function TestRunner__GetTestSuitesList() as Object
    result = []
    testSuiteRegex = CreateObject("roRegex", "^(function|sub)\s(" + m.testSuitePrefix + m.testSuiteName + "[0-9a-z\_]*)\s*\(", "i")
    testFilesList = m.GetTestFilesList()

    for each filePath in testFilesList
        code = FW_AsString(ReadAsciiFile(filePath))

        if code <> ""
            for each line in code.Tokenize(chr(10))
                line.Trim()

                if testSuiteRegex.IsMatch(line)
                    testSuite = invalid
                    functionName = testSuiteRegex.Match(line).Peek()

                    eval("testSuite=" + functionName + "()")

                    if FW_IsAssociativeArray(testSuite)
                        result.Push(testSuite)
                    end if
                end if
            end for
        end if
    end for

    return result
end function

'----------------------------------------------------------------
' Scan testsDirectory and all subdirectories for test files.
'
' @param testsDirectory (string) A target directory with test files.
'
' @return An array of test files.
'----------------------------------------------------------------
function TestRunner__GetTestFilesList(testsDirectory = m.testsDirectory as String) as Object
    result = []
    testsFileRegex = CreateObject("roRegex", "^(" + m.testFilePrefix + ")[0-9a-z\_]*\.brs$", "i")

    if testsDirectory <> ""
        fileSystem = CreateObject("roFileSystem")
        listing = fileSystem.GetDirectoryListing(testsDirectory)

        for each item in listing
            itemPath = testsDirectory + "/" + item
            itemStat = fileSystem.Stat(itemPath)

            if itemStat.type = "directory" then
                result.Append(m.getTestFilesList(itemPath))
            else if testsFileRegex.IsMatch(item) then
                result.Push(itemPath)
            end if
        end for
    end if

    return result
end function
'*****************************************************************
'* Copyright Roku 2011-2017
'* All Rights Reserved
'*****************************************************************
' Common framework utility functions
'*****************************************************************

'*************************************************
' FW_IsXmlElement - check if value contains XMLElement interface
' @param value As Dynamic
' @return As Boolean - true if value contains XMLElement interface, else return false
'*************************************************
function FW_IsXmlElement(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifXMLElement") <> invalid
end function

'*************************************************
' FW_IsFunction - check if value contains Function interface
' @param value As Dynamic
' @return As Boolean - true if value contains Function interface, else return false
'*************************************************
function FW_IsFunction(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifFunction") <> invalid
end function

'*************************************************
' FW_IsBoolean - check if value contains Boolean interface
' @param value As Dynamic
' @return As Boolean - true if value contains Boolean interface, else return false
'*************************************************
function FW_IsBoolean(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifBoolean") <> invalid
end function

'*************************************************
' FW_IsInteger - check if value type equals Integer
' @param value As Dynamic
' @return As Boolean - true if value type equals Integer, else return false
'*************************************************
function FW_IsInteger(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifInt") <> invalid and (Type(value) = "roInt" or Type(value) = "roInteger" or Type(value) = "Integer")
end function

'*************************************************
' FW_IsFloat - check if value contains Float interface
' @param value As Dynamic
' @return As Boolean - true if value contains Float interface, else return false
'*************************************************
function FW_IsFloat(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifFloat") <> invalid
end function

'*************************************************
' FW_IsDouble - check if value contains Double interface
' @param value As Dynamic
' @return As Boolean - true if value contains Double interface, else return false
'*************************************************
function FW_IsDouble(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifDouble") <> invalid
end function

'*************************************************
' FW_IsLongInteger - check if value contains LongInteger interface
' @param value As Dynamic
' @return As Boolean - true if value contains LongInteger interface, else return false
'*************************************************
function FW_IsLongInteger(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifLongInt") <> invalid
end function

'*************************************************
' FW_IsNumber - check if value contains LongInteger or Integer or Double or Float interface
' @param value As Dynamic
' @return As Boolean - true if value is number, else return false
'*************************************************
function FW_IsNumber(value as Dynamic) as Boolean
    return FW_IsLongInteger(value) or FW_IsDouble(value) or FW_IsInteger(value) or FW_IsFloat(value)
end function

'*************************************************
' FW_IsList - check if value contains List interface
' @param value As Dynamic
' @return As Boolean - true if value contains List interface, else return false
'*************************************************
function FW_IsList(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifList") <> invalid
end function

'*************************************************
' FW_IsArray - check if value contains Array interface
' @param value As Dynamic
' @return As Boolean - true if value contains Array interface, else return false
'*************************************************
function FW_IsArray(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifArray") <> invalid
end function

'*************************************************
' FW_IsAssociativeArray - check if value contains AssociativeArray interface
' @param value As Dynamic
' @return As Boolean - true if value contains AssociativeArray interface, else return false
'*************************************************
function FW_IsAssociativeArray(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifAssociativeArray") <> invalid
end function

'*************************************************
' FW_IsSGNode - check if value contains SGNodeChildren interface
' @param value As Dynamic
' @return As Boolean - true if value contains SGNodeChildren interface, else return false
'*************************************************
function FW_IsSGNode(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifSGNodeChildren") <> invalid
end function

'*************************************************
' FW_IsString - check if value contains String interface
' @param value As Dynamic
' @return As Boolean - true if value contains String interface, else return false
'*************************************************
function FW_IsString(value as Dynamic) as Boolean
    return FW_IsValid(value) and GetInterface(value, "ifString") <> invalid
end function

'*************************************************
' FW_IsNotEmptyString - check if value contains String interface and length more 0
' @param value As Dynamic
' @return As Boolean - true if value contains String interface and length more 0, else return false
'*************************************************
function FW_IsNotEmptyString(value as Dynamic) as Boolean
    return FW_IsString(value) and len(value) > 0
end function

'*************************************************
' FW_IsDateTime - check if value contains DateTime interface
' @param value As Dynamic
' @return As Boolean - true if value contains DateTime interface, else return false
'*************************************************
function FW_IsDateTime(value as Dynamic) as Boolean
    return FW_IsValid(value) and (GetInterface(value, "ifDateTime") <> invalid or Type(value) = "roDateTime")
end function

'*************************************************
' FW_IsValid - check if value initialized and not equal invalid
' @param value As Dynamic
' @return As Boolean - true if value initialized and not equal invalid, else return false
'*************************************************
function FW_IsValid(value as Dynamic) as Boolean
    return Type(value) <> "<uninitialized>" and value <> invalid
end function

'*************************************************
' FW_ValidStr - return value if his contains String interface else return empty string
' @param value As Object
' @return As String - value if his contains String interface else return empty string
'*************************************************
function FW_ValidStr(obj as Object) as String
    if obj <> invalid and GetInterface(obj, "ifString") <> invalid
        return obj
    else
        return ""
    end if
end function 

'*************************************************
' FW_AsString - convert input to String if this possible, else return empty string
' @param input As Dynamic
' @return As String - return converted string
'*************************************************
function FW_AsString(input as Dynamic) as String
    if FW_IsValid(input) = false
        return ""
    else if FW_IsString(input)
        return input
    else if FW_IsInteger(input) or FW_IsLongInteger(input) or FW_IsBoolean(input)
        return input.ToStr()
    else if FW_IsFloat(input) or FW_IsDouble(input)
        return Str(input).Trim()
    else
        return ""
    end If
end function

'*************************************************
' FW_AsInteger - convert input to Integer if this possible, else return 0
' @param input As Dynamic
' @return As Integer - return converted Integer
'*************************************************
function FW_AsInteger(input as Dynamic) as Integer
    if FW_IsValid(input) = false
        return 0
    else if FW_IsString(input)
        return input.ToInt()
    else if FW_IsInteger(input)
        return input
    else if FW_IsFloat(input) or FW_IsDouble(input) or FW_IsLongInteger(input)
        return Int(input)
    else
        return 0
    end if
end function

'*************************************************
' FW_AsLongInteger - convert input to LongInteger if this possible, else return 0
' @param input As Dynamic
' @return As Integer - return converted LongInteger
'*************************************************
function FW_AsLongInteger(input as Dynamic) as LongInteger
    if FW_IsValid(input) = false
        return 0
    else if FW_IsString(input)
        return FW_AsInteger(input)
    else if FW_IsLongInteger(input) or FW_IsFloat(input) or FW_IsDouble(input) or FW_IsInteger(input)
        return input
    else
        return 0
    end if
end function

'*************************************************
' FW_AsFloat - convert input to Float if this possible, else return 0.0
' @param input As Dynamic
' @return As Float - return converted Float
'*************************************************
function FW_AsFloat(input as Dynamic) as Float
    if FW_IsValid(input) = false
        return 0.0
    else if FW_IsString(input)
        return input.ToFloat()
    else if FW_IsInteger(input)
        return (input / 1)
    else if FW_IsFloat(input) or FW_IsDouble(input) or FW_IsLongInteger(input)
        return input
    else
        return 0.0
    end if
end function

'*************************************************
' FW_AsDouble - convert input to Double if this possible, else return 0.0
' @param input As Dynamic
' @return As Float - return converted Double
'*************************************************
function FW_AsDouble(input as Dynamic) as Double
    if FW_IsValid(input) = false
        return 0.0
    else if FW_IsString(input)
        return FW_AsFloat(input)
    else if FW_IsInteger(input) or FW_IsLongInteger(input) or FW_IsFloat(input) or FW_IsDouble(input)
        return input
    else
        return 0.0
    end if
end function

'*************************************************
' FW_AsBoolean - convert input to Boolean if this possible, else return False
' @param input As Dynamic
' @return As Boolean
'*************************************************
function FW_AsBoolean(input as Dynamic) as Boolean
    if FW_IsValid(input) = false
        return false
    else if FW_IsString(input)
        return LCase(input) = "true"
    else if FW_IsInteger(input) or FW_IsFloat(input)
        return input <> 0
    else if FW_IsBoolean(input)
        return input
    else
        return false
    end if
end function

'*************************************************
' FW_AsArray - if type of value equals array return value, else return array with one element [value]
' @param value As Object
' @return As Object - roArray
'*************************************************
function FW_AsArray(value as Object) as Object
    if FW_IsValid(value)
        if not FW_IsArray(value)
            return [value]
        else
            return value
        end if
    end if
    return []
end function

'=====================
' Strings
'=====================

'*************************************************
' FW_IsNullOrEmpty - check if value is invalid or empty
' @param value As Dynamic
' @return As Boolean - true if value is null or empty string, else return false
'*************************************************
function FW_IsNullOrEmpty(value as Dynamic) as Boolean
    if FW_IsString(value)
        return Len(value) = 0
    else
        return not FW_IsValid(value)
    end if
end function

'=====================
' Arrays
'=====================

'*************************************************
' FW_FindElementIndexInArray - find an element index in array
' @param array As Object
' @param value As Object
' @param compareAttribute As Dynamic
' @param caseSensitive As Boolean
' @return As Integer - element index if array contains a value, else return -1
'*************************************************
function FW_FindElementIndexInArray(array as Object, value as Object, compareAttribute = invalid as Dynamic, caseSensitive = false as Boolean) as Integer
    if FW_IsArray(array)
        for i = 0 to FW_AsArray(array).Count() - 1
            compareValue = array[i]

            if compareAttribute <> invalid and FW_IsAssociativeArray(compareValue)
                compareValue = compareValue.LookupCI(compareAttribute)
            end If

            if FW_IsString(compareValue) and FW_IsString(value) and not caseSensitive
                if LCase(compareValue) = LCase(value)
                    return i
                end If
            else if compareValue = value
                return i
            end if

            item = array[i]
        next
    end if
    return -1
end function

'*************************************************
' FW_ArrayContains - check if array contains specified value
' @param array As Object
' @param value As Object
' @param compareAttribute As Dynamic
' @return As Boolean - true if array contains a value, else return false
'*************************************************
function FW_ArrayContains(array as Object, value as Object, compareAttribute = invalid as Dynamic) as Boolean
    return (FW_FindElementIndexInArray(array, value, compareAttribute) > -1)
end function
