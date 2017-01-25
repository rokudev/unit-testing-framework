' ********** Copyright 2017 Roku Corp.  All Rights Reserved. ********** 

'****************************************************************
'Common channel utility functions
'****************************************************************
'contains:
'   - RSG help utilities
'   - string utils functionality
'   - parse functionality
'****************************************************************



'================================================================
'                   RSG help utilities
'================================================================



'*****************************************************************
' Copies all fields from associative array to content node.
' Generally used for transforming parsed conetent from feed
' to special node type that is used by other RSG nodes.
' @param contentList As Object - associative array
' @return As Object - valid ContentNode
'*****************************************************************
function Utils_ContentList2Node(contentList as Object) as Object
    result = createObject("roSGNode","ContentNode")
    
    for each itemAA in contentList
        item = createObject("roSGNode", "ContentNode")
        for each field in itemAA
            if item.hasField(field)
                item[field] = itemAA[field]
            end if
        end for
        result.appendChild(item)
    end for
    
    return result
end function


'*****************************************************************
' Copies ContentNode to anouther ContentNode.
' Generally used for contentNode copying with some filtering.
' @param node As Object - node to copy
' @param nodeType as String - type of new node
' @param fieldsFilterAA as Object - roAA of fields to filter
' @return As Object - copied node
'*****************************************************************
Function Utils_CopyNodeContent(node as Object, nodeType = "ContentNode" as String, fieldsFilterAA = {} as Object)
    item = createObject("roSGNode", nodeType)
    
    if node = invalid then return item

    existingFields = {}
    newFields = {}
    
    'AA of node read-only fields for filtering'
    if fieldsFilterAA = invalid OR fieldsFilterAA.Count() = 0
        fieldsFilterAA = {
            focusedChild    :   "focusedChild"
            change          :   "change"
        }
    end if

    for each field in node.getFields()
        if item.hasField(field) AND NOT fieldsFilterAA.doesExist(field)
            existingFields[field] = node[field]
        else
            newFields[field] = node[field]
        end if
    end for
    
    item.setFields(existingFields)
    item.addFields(newFields)
    
    return item
End Function

'*****************************************************************
' This will return the parent node that goes as parameter
' otherwise return m.top. 
' Used for getting valid parent node of requested node.
' @param nodeName As String - node name
' @return As Object - valid parent Node
'*****************************************************************
function Utils_getParent(nodeName as String) as Object
    node = m.top
    
    while node <> invalid and lCase(node.subtype()) <> lCase(nodeName)
        node = node.getParent()
    end while
    
    return node
end function

'*****************************************************************
' Add next panel to the Sliding Panel
' Simple wrapper function that helps configure and add node 
' for RSG Sliding Panels (classes that allow you set up panels 
' of content that slide on and off the display screen.)
' When the createNextPanlOnItemFocus field is true, 
' the nextPanel field should be set to a Panel node to the next panel to 
' add to the PanelSet in response to the createNextPanelIndex field being set. 
' It must be set immediately in repsonse to createNextPanelIndex field being set.
' @param nextPanelName As Object - name of panel to add
' @param data As Object - data to set in new panel
' @param goBackCount As Object - back functionality
' @param isLeftOnly As Object - check is only left panel
'*****************************************************************
sub Utils_addNextPanel(nextPanelName as Object, data = {} as Object, goBackCount = 1 as Integer,isLeftOnly = invalid as object)
    isSimplePanel = m.top.parentSubtype(m.top.subtype()) = "Panel"
    
    if isSimplePanel and not m.top.hasField("nextPanel")
        m.top.addField("nextPanel", "node", true)
    end if
    
    if type(nextPanelName) = "roString"
        newPanel = createObject("roSGNode", nextPanelName)
        if newPanel <> invalid
            if isLeftOnly <> invalid and type(isLeftOnly) = "roBoolean"
                newPanel.leftOnly = isLeftOnly
            end if
            m.top.nextPanel = newPanel
            if newPanel.hasField("data")
                newPanel.data = data
            end if
            m.top.nextPanel.goBackCount = goBackCount
            if isSimplePanel
                parentPanelSet = Utils_getParent("PanelSet")
                parentPanelSet.appendChild(m.top.nextPanel)
                m.top.setFocus(false)
                m.top.nextPanel.setFocus(true)
            end if
        else
            ?"failed to create new panel"
        end if
    end if
end sub

'*****************************************************************
' Set necessary properties to overhang node
' Wrapper function that helps configurate properlyglobal Overhang node.
' The Overhang node provides a information bar that is displayed at the top of 
' a screen in many Roku channels. The regions occupied by the overhang 
' can be filled with either a solid color or a bitmap.
' @param title As String - title
' @param optionsAvaliable As Object - are options avaliable
' @param showOptions As Object - show avaliable options
'*****************************************************************
sub Utils_setOverhangData(title as String, optionsAvaliable = false as boolean, showOptions = optionsAvaliable as Boolean)
    overhang = m.global.overhang
    if overhang <> invalid
        overhang.showOptions = showOptions
        overhang.optionsAvailable = optionsAvaliable
        overhang.title = title
    end if
end sub


'================================================================
'                   string utils functionality
'================================================================



'*****************************************************************
' Utils_Join - join strings array to string with delimiter
' Returns a new string with all data in array that 
' are separated with delimiter.
' @param array As Object - strings array
' @param delim As String - delimiter
' @return As Dynamic - joined string
'*****************************************************************
Function Utils_Join(array As Object, delim = "" As String) As String
    result = ""
    If type(array) = "roArray" Then
        For i = 0 To array.Count() - 1
            item = array[i]
            If NOT (LCase(type(item)) = "rostring" or LCase(type(item)) = "string") Then
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



'================================================================
'                   parse functionality
'================================================================



'*****************************************************************
' Utils_ParseXML - parse string XML into object
' Checks if input is valid XML String and parse it to 
' valid roXMLElement that can be used to contain an XML tree.' 
' @param str As String - string to parse
' @return As Dynamic - roXmlElement object or invalid
'*****************************************************************
Function Utils_ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml = CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function