' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

function init()
    ' m.top.panelSize = "wide"
    m.top.focusable = true
    m.top.data = {text: ""}  'set initial value
    m.top.list = m.top.findNode("results")
    m.top.width = 647
    m.noMatchesLabel = m.top.findNode("noMatchesLabel")
    
    ' starting observing here to avoid invoking callbacks on setting initial values
    m.top.observeField("data", "search")
    m.top.observeField("createNextPanelIndex", "onCreateNextPanelIndex")
    m.top.list.observeField("itemSelected","resultslistItemSelected")
end function

function onCreateNextPanelIndex()
    if m.top.list.content = invalid
        m.top.rightLabel.text = ""
    else
        Utils_addNextPanel("SearchResultDetails",{content:m.top.list.content.getChild(m.top.createNextPanelIndex)})
        m.top.rightLabel.text = str(m.top.createNextPanelIndex + 1) + " of " + str(m.top.list.content.getChildCount()) + " Results"
    end if
end function

function resultslistItemSelected()
    ? "[SearchResults] resultslistItemSelected m.top.list.itemSelected == ";m.top.list.itemSelected
end function

sub search()
    m.top.focusable = false
    m.top.list.content = invalid
    m.top.leftLabel.text = "Searching..."
    m.noMatchesLabel.visible = false
    m.top.rightLabel.text = ""
    
    SearchString = m.top.data.text
    if SearchString = invalid
        SearchString = ""
    end if

    if m.top.data.content <> invalid
        ? "inside"
        searchResultNode = createObject("roSGNode", "ContentNode")
        for i = 0 to m.top.data.content.getChildCount()-1
            itemAA = m.top.data.content.getChild(i)
            if (Instr(1, LCase(itemAA.Title), LCase(SearchString)) > 0 or Instr(1, LCase(itemAA.Description), LCase(SearchString) ) > 0) and SearchString <>""
                item = Utils_CopyNodeContent(itemAA, "ContentNode")
                searchResultNode.appendChild(item)
            end if
        end for
        m.top.list.content = searchResultNode
    
        if searchResultNode.getChildCount() > 0
            m.top.focusable = true
        else
            m.top.focusable = false
        end if
    end if
end sub

'this is base function for handling keypresses
'@param key [String] string representation of remote key
'@param pressed [boolean] tells if it's a press or release event
'@return boolean, if you return false this function will be called for you parent node 
function OnKeyEvent(key as String, press as Boolean) as boolean
    handled = false
    if press
        if key = "options"
            ' Show options dialog here
            handled = true
        else if key = "play"
            ' Show video player here if need
            handled = true
        end if
    end if
    return handled
end function
