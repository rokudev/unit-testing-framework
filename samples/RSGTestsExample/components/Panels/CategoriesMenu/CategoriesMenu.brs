' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.list = m.top.findNode("labelList")
    m.top.hasNextPanel = true
    m.top.panelSize = "narrow"
    m.top.leftOnly = true
    m.top.observeField("createNextPanelIndex", "onCreateNextPanelIndex")
    'observe focused child events and set focus to proper node when needed
    'this is very important step when focus is set to this node it will set focus to it's child
    m.top.observeField("focusedChild", "onFocusedChildChange")

    'set fake content before real content will be available
    SetLoadingContent()
    'creating new request node to get data from Api
    m.request = createObject("roSGNode", "DataRequest")
    'specifying function that will get proper data
    m.request.name = "GetCategoriesMenu"
    'setting the observer to receive result
    m.request.ObserveField("result", "OnContent")
    'appending request to the main loop request queue
    m.global.requestQueue.appendChild(m.request)
end sub

'this function is called when this node changes focus or it's child changes it's focus
'set proper overhang text
'here you can also set options label
sub onFocusedChildChange()
    if m.top.isInFocusChain()
        Utils_setOverhangData("")
    end if
end sub

'get content for this panel
function OnContent() as Object
    m.top.list.content = m.request.result
    if m.top.list.hasFocus() or m.top.hasFocus()
        m.top.list.setFocus(false)
        m.top.list.setFocus(true)
    end if
end function

'function for creating next panels when list item is focused
'@see ListPanel documentation for more info
'next panel should only be set when createNextPanelIndex is triggered, otherwise there could be some problems with navigation
sub onCreateNextPanelIndex()
    if m.top.list.content <> invalid
        focusedItem = m.top.list.content.getChild(m.top.createNextPanelIndex)

        'AA that are in interface fields can't be modified
        'copy data to new AA in order to modify it 
        data = {}
        data.Append(m.top.data)
        'check if we have extra params that should
        if focusedItem.id = "fake"
            'create empty panel so if we are loading content for panel we will focus properly 
            stubPanel = createObject("roSGNode", "Panel")
            stubPanel.hasNextPanel = true
            stubPanel.focusable = false
            focusedItem.addField("nextPanel", "node", false)
            focusedItem.nextPanel = stubPanel
        else
            if focusedItem.isSeasonsAvailable <> invalid
                data.isSeasonsAvailable = focusedItem.isSeasonsAvailable
            end if
            if focusedItem.includeButtons <> invalid AND focusedItem.includeButtons
                data.nextPanel = "ButtonsListPanel"
                data.isSeasonsAvailable = false
            end if
            'add next panel to panelset
            Utils_addNextPanel(focusedItem.nextPanelName, data)
        end if
    end if
end sub

' set fake content on the panel until real content will be populated
Sub SetLoadingContent()
    fakeContent = CreateObject("roSGNode", "ContentNode")
    fakeitem = CreateObject("roSGNode", "ContentNode")
    fakeitem.title = tr("Loading") + "..."
    fakeitem.id = "fake"
    fakeContent.appendChild(fakeitem)
    m.top.list.content = fakeContent
End Sub
