'*****************************************************************
'* Copyright Roku 2011-2016
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
Function BaseTestSuite()
    
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
Sub BTS__AddTest(name as string, func as object)
    m.testCases.Push(m.createTest(name, func))
End Sub

'----------------------------------------------------------------
' Create a test object.
' 
' @param name (string) A test name.
' @param func (string) A test function name.
'----------------------------------------------------------------
Function BTS__CreateTest(name as string, func as object) as object
    return {Name: name, Func: func}
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
End Function