' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.panelSize = "narrow"
    m.top.hasNextPanel = true
    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.textEditBox.hintText = "Title, Keyword"
    m.keyboard.textEditBox.hintTextColor = "0x777777"
    
    'observe focused child events and set focus to proper node when needed
    'this is very important step when focus is set to this node it will set focus to it's child
    m.top.observeField("focusedChild", "onFocusedChildChange")
    m.keyboard.observeField("text", "onKeyboardTextChange")
    
    m.SearchResults = createObject("roSGNode", "SearchResults")

    m.needToAppend = true

    m.top.addField("content", "node", false)

    'creating new request node to get data from Api
    m.request = createObject("roSGNode", "DataRequest")
    'specifying function that will get proper data
    m.request.name = "GetChannelContent"
    'setting the observer to receive result
    m.request.ObserveField("result", "OnContent")
    'appending request to the main loop request queue
    m.global.requestQueue.appendChild(m.request)
end sub

'get content for this panel
function OnContent() as Object
    m.top.content = m.request.result
end function

'this function is called when this node changes focus or it's child changes it's focus
'set proper overhang text
'here you can also set options label
sub onFocusedChildChange()
    parentPanelSet = Utils_getParent("PanelSet")
    if m.needToAppend
       parentPanelSet.appendChild(m.SearchResults)
       onKeyboardTextChange()
       m.needToAppend = false
    end if
    'check if need to set focus
    if m.top.isInFocusChain()
        m.keyboard.setFocus(true)
    else if parentPanelSet.isGoingBack
        m.needToAppend = true
    end if
end sub

'set text to search to search results panel
sub onKeyboardTextChange()
    if m.SearchResults <> invalid and m.SearchResults.data.text <> m.keyboard.text and m.top.content <> invalid
        data = {
            text    :   m.keyboard.text
            content :   m.top.content
        }
        m.SearchResults.data = data
    end if
end sub

'this is base function for handling keypresses
'@param key [String] string representation of remote key
'@param pressed [boolean] tells if it's a press or release event
'@return boolean, if you return false this function will be called for you parent node 
function OnKeyEvent(key as String, press as Boolean) as boolean
    handled = false
    if press and key = "options"
        ' Option press handler here
    end if
    return handled
end function
