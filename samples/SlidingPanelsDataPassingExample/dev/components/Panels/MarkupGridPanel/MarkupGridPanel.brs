' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'cashe chidren nodes for future operations
function Init()
    ? "[MarkupGridPanel] Init"
    m.top.panelSize = "wide"
    m.top.grid = m.top.FindNode("Grid")
    m.top.grid.observeField("itemFocused", "OnItemFocused")
    m.top.observeField("createNextPanelIndex", "onCreateNextPanelIndex")
    'observe focused child events and set focus to proper node when needed
    'this is very important step when focus is set to this node it will set focus to it's child
    m.top.observeField("focusedChild", "onFocusedChildChange")
    
end function

'this function is called when this node changes focus or it's child changes it's focus
'set proper overhang text
'here you can also set options label
sub onFocusedChildChange()
    ? "[MarkupGridPanel] onFocusedChildChange"
end sub

sub onDataSet()
    ? "[MarkupGridPanel] onDataSet"
    m.top.grid.content = m.top.data.content
end sub

'function for creating next panels when list item is focused
'@see ListPanel documentation for more info
'next panel should only be set when createNextPanelIndex is triggered, otherwise there could be some problems with navigation
sub onCreateNextPanelIndex()
    if m.top.data.nextPanel <> invalid
        data = m.top.data
        data.childIndex = m.top.createNextPanelIndex
        Utils_addNextPanel(m.top.data.nextPanel, data)
    end if
end sub

'change hud content when new item is focused
Sub OnItemFocused()
    content = m.top.grid.content.getChild(m.top.grid.itemFocused)
    m.global.hud.content = content
End Sub