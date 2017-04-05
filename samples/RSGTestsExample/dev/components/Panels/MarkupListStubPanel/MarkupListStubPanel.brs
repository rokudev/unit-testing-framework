' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'cashe chidren nodes for future operations
function Init()
    ? "[MarkupListStubPanel] Init"
    m.top.panelSize = "wide"
    m.top.list = m.top.FindNode("List")
    m.top.observeField("focusedChild", "createNextPanel")
    m.nextPanelName = "SubCategoriesMenu"
end function

sub onDataSet()
    ? "[MarkupListStubPanel] onDataSet"
    m.top.list.content = m.top.data.content
end sub

'create next panel when this panel is focused
sub createNextPanel()
    ? "[MarkupListStubPanel] createNextPanel"
    Utils_addNextPanel(m.nextPanelName, m.top.data,1,true)
end sub