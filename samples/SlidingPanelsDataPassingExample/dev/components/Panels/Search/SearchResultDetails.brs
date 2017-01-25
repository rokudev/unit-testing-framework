' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

function init()
    m.top.panelSize = "narrow"
    m.details = m.top.findNode("details")
    m.top.hasNextPanel = true
    m.top.observeField("focusedChild","createNextPanel")
end function

function contentUpdate() as void
    'check if we have proper content and update details content
    if m.top.data.content = invalid
        return
    end if
    m.details.content = m.top.data.content
end function

function createNextPanel()
    ? "[SearchResultDetailsPanel] createNextPanel"
    'add panel to panel set
    Utils_addNextPanel("MarkupListPanel",{
                    content     : m.global.sampleContent
                    nextPanel   : "ButtonsListPanel"
                },1,true)
end function