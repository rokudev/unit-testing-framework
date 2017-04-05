'IMPORTS=utilities/types utilities/device
'=====================
' Strings
'=====================
Function FW_IsNullOrEmpty(value As Dynamic) As Boolean
    If FW_IsString(value) Then
        Return (value = invalid Or Len(value) = 0)
    Else
        Return Not FW_IsValid(value)
    End If
End Function

Function FW_StartsWith(stringToCheck As Dynamic, valueToCheck As String) As Boolean
    If Not FW_IsNullOrEmpty(stringToCheck) And Not FW_IsNullOrEmpty(valueToCheck) Then
        Return stringToCheck.InStr(valueToCheck) = 0
    End If
    Return False 
End Function 

Function FW_EndsWith(stringToCheck As Dynamic, valueToCheck As String) As Boolean
    If Not FW_IsNullOrEmpty(stringToCheck) And Not FW_IsNullOrEmpty(valueToCheck) Then
        Return stringToCheck.Mid(stringToCheck.Len() - valueToCheck.Len()) = valueToCheck
    End If
    Return False 
End Function 

Function FW_PadLeft(value As String, padChar As String, totalLength As Integer) As String
    While value.Len() < totalLength
        value = padChar + value
    End While
    Return value
End Function

Function FW_WrapText(value As Dynamic, maxCharLength As Integer) As Dynamic
    If FW_IsNullOrEmpty(value) Then Return value
    lines = []
    If value.Len() > maxCharLength Then
        textArray = FW_Split(value, " ")
        currentLine = ""
        For Each text In textArray
            tempLine = (currentLine + " " + text)
            tempLine = tempLine.Trim()
            If tempLine.Len() <= maxCharLength Then 
                currentLine = tempLine
            Else
                If Not FW_IsNullOrEmpty(currentLine) Then
                    lines.Push(currentLine)
                End If
                currentLine = text
            End If
        Next
        If Not FW_IsNullOrEmpty(currentLine) Then
            lines.Push(currentLine)
        End If
    Else
        lines.Push(value)
    End If
    Return FW_Join(lines, Chr(10))
End Function

'=====================
' Replacement
'=====================
Function FW_IsRegexSafe(text As String) As Boolean
    regexSpecials = ["\", "[", "]", "^", "$", ".", "|", "?", "*", "+", "(", ")"]
    For Each special In regexSpecials
        If text.InStr(special) > -1 Then
            Return False
        End If
    Next
    Return True
End Function

Function FW_RegexEscape(text As Dynamic) As Dynamic
    If Not FW_IsString(text) Or FW_IsNullOrEmpty(text) Then Return text
    
    regexSpecials = ["\", "[", "]", "^", "$", ".", "|", "?", "*", "+", "(", ")", "{", "}"]
    For Each special In regexSpecials
        text = FW_Join(FW_Split(text, special), "\" + special)
    Next
    Return text
End Function

Function FW_RegexReplace(text As Dynamic, toReplace As Dynamic, replaceWith As Dynamic, options = "" As String) As Dynamic
    If Not FW_IsString(text) Or FW_IsNullOrEmpty(text) Then Return text
    If Not FW_IsString(toReplace) Or FW_IsNullOrEmpty(toReplace) Then Return text
    If Not FW_IsString(replaceWith) Then Return text

    regex = CreateObject("roRegex", toReplace, options)
    result = regex.ReplaceAll(text, replaceWith)
    Return result
End Function

Function FW_Replace(text As Dynamic, toReplace As Dynamic, replaceWith As Dynamic) As Dynamic
    If Not FW_IsString(text) Or FW_IsNullOrEmpty(text) Then Return text
    If Not FW_IsString(toReplace) Or FW_IsNullOrEmpty(toReplace) Then Return text
    If Not FW_IsString(replaceWith) Then Return text
    If text.InStr(toReplace) = -1 Then Return text
    
    toReplace = FW_RegexEscape(toReplace)
    replaceWith = FW_RegexEscape(replaceWith)
    Return FW_RegexReplace(text, toReplace, replaceWith)
End Function

Function FW_Split(toSplit As String, delim As String, bIncludeEmpties = false As Boolean) As Object
    result = []
    If bIncludeEmpties Then
        If Not FW_IsNullOrEmpty(toSplit) Then
            char = 0
            While char <= toSplit.Len()
                match = toSplit.Instr(char, delim)
                If match = -1 Then
                    result.Push(toSplit.Mid(char))
                    Exit While
                End If
                If match >= char Then
                    result.Push(toSplit.Mid(char, match - char))
                    char = match
                End If
                char = char + delim.Len()
            End While
        End If
    Else
        st = CreateObject("roString")
        st.SetString(toSplit)
        result = st.Tokenize(delim)
    End If
    Return result
End Function

Function FW_Join(array As Object, delim = "" As String) As String
    result = ""
    If FW_IsArray(array) Then
        For i = 0 To array.Count() - 1
            item = array[i]
            If FW_IsNullOrEmpty(item) Then
                item = ""
            End If
            If i > 0 Then
                result = result + delim
            End If
            result = result + item
        Next
    End If
    Return result
End Function

Function FW_CompareAsString(obj1 as Object, obj2 as Object, bCaseSensitive = false as Boolean) as Boolean
    result = false
    str1 = FW_AsString(obj1)
    str2 = FW_AsString(obj2)
    if str1.Len() > 0 AND str2.Len() > 0 then
        if bCaseSensitive then
            result = (str1 = str2)
        else
            result = (LCase(str1) = LCase(str2))
        end if
    end if
    return result 
End Function