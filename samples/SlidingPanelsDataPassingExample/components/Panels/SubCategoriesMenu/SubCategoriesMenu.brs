' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    'setting up this nodes ui 
    m.top.list = m.top.findNode("labelList")
    m.top.hasNextPanel = true
    m.top.panelSize = "narrow"
    m.top.leftOnly = true
    'observing field for creating next panel
    m.top.observeField("createNextPanelIndex", "onCreateNextPanelIndex")
    'observe focused child events and set focus to proper node when needed
    'this is very important step when focus is set to this node it will set focus to it's child
    m.top.observeField("focusedChild", "onFocusedChildChange")
    
    'set fake content before real content will be available
    SetLoadingContent()
    'creating new request node to get data from Api
    m.request = createObject("roSGNode", "DataRequest")
    'specifying function that will get proper data
    m.request.name = "GetSubcategoriesMenu"
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
    data = m.top.data
    data.nextPanel = "ButtonsListPanel"
    data.isSeasonsAvailable = true

    Utils_addNextPanel(m.top.list.content.getChild(m.top.createNextPanelIndex).nextPanelName, data)
end sub

' set fake content on the panel until real content will be populated
Sub SetLoadingContent()
    fakeContent = CreateObject("roSGNode", "ContentNode")
    fakeitem = CreateObject("roSGNode", "ContentNode")
    fakeitem.title = tr("Loading") + "..."
    fakeitem.addField("nextPanelName", "string", false)
    fakeitem.nextPanelName = "Panel"
    fakeContent.appendChild(fakeitem)
    m.top.list.content = fakeContent
End Sub