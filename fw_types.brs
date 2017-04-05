'IMPORTS=
'=====================
' Types
'=====================
Function FW_IsType(value As Dynamic, typeStr As String) As Boolean
  if typeStr="XmlElement" then return FW_IsXmlElement(value)
  if typeStr="Function" then return FW_IsFunction(value)
  if typeStr="Boolean" then return FW_IsBoolean(value)
  if typeStr="Integer" then return FW_IsInteger(value)
  if typeStr="Float" then return FW_IsFloat(value)
  if typeStr="List" then return FW_IsList(value)
  if typeStr="Array" then return FW_IsArray(value)
  if typeStr="AssociativeArray" then return FW_IsAssociativeArray(value)
  if typeStr="String" then return FW_IsString(value)
  if typeStr="DateTime" then return FW_IsDateTime(value)
  return false
End Function

Function FW_IsXmlElement(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifXMLElement") <> invalid
End Function

Function FW_IsFunction(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifFunction") <> invalid
End Function

Function FW_IsBoolean(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifBoolean") <> invalid
End Function

Function FW_IsInteger(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifInt") <> invalid And (Type(value) = "roInt" Or Type(value) = "roInteger" Or Type(value) = "Integer")
End Function

Function FW_IsFloat(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifFloat") <> invalid
End Function

Function FW_IsList(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifList") <> invalid
End Function

Function FW_IsArray(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifArray") <> invalid
End Function

Function FW_IsAssociativeArray(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifAssociativeArray") <> invalid
End Function

Function FW_IsString(value As Dynamic) As Boolean
    Return FW_IsValid(value) And GetInterface(value, "ifString") <> invalid
End Function

Function FW_IsDateTime(value As Dynamic) As Boolean
    Return FW_IsValid(value) And (GetInterface(value, "ifDateTime") <> invalid Or Type(value) = "roDateTime")
End Function

Function FW_IsValid(value As Dynamic) As Boolean
    Return Type(value) <> "<uninitialized>" And value <> invalid
End Function

Function FW_ValidStr(obj As Object) As String
    if obj <> invalid and GetInterface(obj, "ifString") <> invalid
        return obj
    else
        return ""
    endif
End Function 

Function FW_AsString(input As Dynamic) As String
    If FW_IsValid(input) = False Then
        Return ""
    Else If FW_IsString(input) Then
        Return input
    Else If FW_IsInteger(input) Then
        Return input.ToStr()
    Else If FW_IsFloat(input) Then
        Return Str(input).Trim()
    Else If FW_IsBoolean(input) Then
        Return FW_IIF(input, "true","false")
    Else
        Return ""
    End If
End Function

Function FW_AsInteger(input As Dynamic) As Integer
    If FW_IsValid(input) = False Then
        Return 0
    Else If FW_IsString(input) Then
        Return input.ToInt()
    Else If FW_IsInteger(input) Then
        Return input
    Else If FW_IsFloat(input) Then
        Return Int(input)
    Else
        Return 0
    End If
End Function

Function FW_AsFloat(input As Dynamic) As Float
    If FW_IsValid(input) = False Then
        Return 0.0
    Else If FW_IsString(input) Then
        Return input.ToFloat()
    Else If FW_IsInteger(input) Then
        Return (input / 1)
    Else If FW_IsFloat(input) Then
        Return input
    Else
        Return 0.0
    End If
End Function

Function FW_AsBoolean(input As Dynamic) As Boolean
    If FW_IsValid(input) = False Then
        Return False
    Else If FW_IsString(input) Then
        Return LCase(input) = "true"
    Else If FW_IsInteger(input) Or FW_IsFloat(input) Then
        Return input <> 0
    Else If FW_IsBoolean(input) Then
        Return input
    Else
        Return False
    End If
End Function

Function FW_AsArray(value As Object) As Object
    If FW_IsValid(value)
        If Not FW_IsArray(value) Then
            Return [value]
        Else
            Return value
        End If
    End If
    Return []
End Function

Function FW_ValidAA(obj As Object, keys as Object, delim = "." as String) as Boolean
    'All keys on level 0
    if obj = invalid then
        return false
    end if
    for each key in Keys     
        subKeys = FW_Split(key, delim)
        aa_check = obj
        'go down the hierarchy key.subkey.subsubkey...
        for each subkey in subKeys
            if aa_check[subkey] <> invalid then
                aa_check = aa_check[subkey]
            else
                print "Key::"; key
                print "subkey::"; subkey
                printAA(obj)
                return false
                
            end if
        end for
        
    end for
    return true
end Function

function FW_GetSubElement(element as Dynamic, subElementTree as Dynamic) as Dynamic
    if FW_IsValid(element) = false or FW_IsValid(subElementTree) = false then
        return invalid
    end if

    subElementTreeArray = []
    result = element
    
    if FW_IsString(subElementTree) then
       subElementTreeArray = FW_Split(subElementTree, ".")
    else if FW_IsArray(subElementTree) then
       subElementTreeArray = subElementTree
    end if
    
    for each field in subElementTreeArray
        if FW_IsAssociativeArray(result) then
            result = result.LookupCI(FW_AsString(field))        'use case-insensitive lookup for AAs
        else if FW_IsArray(result) then
            index = FW_AsInteger(field)
            if (index = 0 and FW_AsString(field) <> "0") or index < 0 or index >= result.Count() then     'index is not an integer or out of range?
                result = invalid
                exit for
            end if
            result = result[index]
        else
            result = invalid
            exit for
        end if
    end for
    
    return result
end function