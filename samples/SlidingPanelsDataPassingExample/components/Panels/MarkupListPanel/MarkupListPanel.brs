' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'cashe chidren nodes for future operations
function Init()
    ? "[MarkupListPanel] Init"
    m.top.panelSize = "wide"
    m.top.list = m.top.FindNode("List")
    m.top.list.observeField("itemFocused", "OnItemFocused")
    m.top.observeField("createNextPanelIndex", "onCreateNextPanelIndex")
end function

sub onDataSet()
    ? "[MarkupListPanel] onDataSet"
    m.top.list.content = m.top.data.content
end sub

'function for creating next panels when list item is focused
'@see ListPanel documentation for more info
'next panel should only be set when createNextPanelIndex is triggered, otherwise there could be some problems with navigation
sub onCreateNextPanelIndex()
    ? "[MarkupListPanel] onCreateNextPanelIndex"
    if m.top.data.nextPanel<>invalid
        data = m.top.data
        data.childIndex = m.top.createNextPanelIndex
        Utils_addNextPanel(m.top.data.nextPanel, data)
    end if
end sub

'update hud content
Sub OnItemFocused()
    content = m.top.list.content.getChild(m.top.list.itemFocused)
    m.global.hud.content = content
End Sub