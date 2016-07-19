'*****************************************************************
'* Copyright Roku 2011-2016
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
End Function