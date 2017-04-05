' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'cashe chidren nodes for future operations
function Init()
    ? "[ButtonsListPanel] Init"
	m.top.list = m.top.FindNode("List")
    'enables right arrow on panelset which tells user that there is next panel after this panel
    m.top.hasNextPanel = true
    
    'setup observers for list, @see Handling Node Field Changes 
    m.top.list.observeField("itemSelected", "OnListItemSelected")
    m.top.list.observeField("itemFocused", "OnListItemFocused")
    'observe focused child events and set focus to proper node when needed
    'this is very important step when focus is set to this node it will set focus to it's child
    m.top.observeField("focusedChild", "onFocusedChildChange")
end function

'is triggered whenever this node has focus or it's child changes focus
sub OnFocusedChildChange()
    ?"[ButtonsListPanel] OnFocusedChildChange"
    
    'handle the logic of showing and closing hud when this panel has focus
    if m.top.isinFocusChain() and not m.global.hud.show then
        m.global.hud.show = true
    else if not m.top.isinFocusChain() and m.global.hud.show then
        m.global.hud.show = false
    end if
end sub

'data field is used to pass data between panels, based on it panel knows how to build it's ui 
sub OnDataSet()
    m.buttonListContentAA = getOptionsListContent()
    'convert array of AA content to proper content node  
    m.top.list.content = Utils_ContentList2Node(m.buttonListContentAA)
end sub

'get buttons for this item
function getOptionsListContent() as Object
    buttonsList = [
        {
            id              : "playVideo"
            title           : "Play video"
            'panel name that will be created when this item will be focused
            nextPanelName   : "SubCategoriesMenu"
        }
        {
            id              : "fromBeginning"
            title           : "Second button"
            'panel name that will be created when this item will be focused
            nextPanelName   : "SubCategoriesMenu"
        }
        ]

    if m.top.data.isSeasonsAvailable <> invalid and m.top.data.isSeasonsAvailable=true
        buttonsList.push({
            id              : "seasons"
            title           : "Seasons"
            'panel name that will be created when this item will be focused
            nextPanelName   : "SubCategoriesMenu"
        })
    else if m.top.data.isSeasonsAvailable <> invalid and m.top.data.isSeasonsAvailable=false
        'if we don't have seasons don't show right arrow on panelset
        m.top.hasNextPanel = false
    end if

    buttonsList.push({
        id              : "trailer"
        title           : "Other button"
        'panel name that will be created when this item will be focused
        nextPanelName   : "SubCategoriesMenu"
    })


    return buttonsList
end function

'handles selection of item in list  
sub OnListItemSelected()
    itemSelected = m.buttonListContentAA[m.top.list.itemSelected]
    if itemSelected.id = "seasons"
        Utils_addNextPanel("ListMarkupDetailsPanel", m.top.data)
    else if itemSelected.id = "playVideo"
        'initaialize bool variables to track video playback state and fire events properly'
        InitConstants()
        'get scene for adding video as a child node
        baseScene = Utils_getParent("BaseScene")
        'create custom video player
        m.videoPlayer = CreateObject("roSGNode", "CustomVideoNode")
        m.videoPlayer.id = "videoPlayer"
        'set proper sizes for video player to play
        m.videoPlayer.translation = "[0,0]"
        m.videoPlayer.width = "1280"
        m.videoPlayer.height = "720"
        'add video player to scene
        'this is good practice when you have to observe video player from main thread
        'as in most cases video player is created deeply in channel and it's hard to pass proper reference to it
        baseScene.addField("videoPlayer", "node", true)
        baseScene.videoPlayer = m.videoPlayer
        baseScene.appendChild(m.videoPlayer)
        'set visibility to video player which will show black screen to user so he will know that something is happening
        m.videoPlayer.visible = true
        'set content that should be played
        m.videoPlayer.content = m.top.data.content.getchild(m.top.data.childIndex)
        'setup observers for video player
        m.videoPlayer.observeField("visible", "OnVideoVisibilityChange")
        m.videoPlayer.observeField("state", "OnVideoStateChange")
        'set focus to video player so it will handle all key presses
        m.videoPlayer.setFocus(true)
        'this will start prebuffering and playing video, you should set content before setting this field
        'this should be last field that is set so video player will be initialzed properly
        m.videoPlayer.control = "play"
    end if
end sub

'setting initial values for bool constants for indicating playback state'
sub InitConstants()
    'indicates if playback was paused'
    m.PlaybackPaused = false
end sub

'restore focus when video player is closed
sub OnVideoVisibilityChange()
    if m.videoPlayer.visible = false
        'clear all video data
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        baseScene = Utils_getParent("BaseScene")
        baseScene.videoPlayer = invalid
        baseScene.removeChild(m.videoPlayer)
        m.videoPlayer = invalid
        'restore visibility to panelset 
        parentPanelSet = Utils_getParent("PanelSet")
        parentPanelSet.visible = false
        parentPanelSet.visible = true
        'restore focus to this node
        m.top.setFocus(true)
    end if
end sub

sub OnVideoStateChange()
    if m.videoPlayer<>invalid
        ? m.videoPlayer.state
        if m.videoPlayer.state = "paused"
            m.PlaybackPaused = true
        else if m.videoPlayer.state = "finished"
        else if m.videoPlayer.state = "playing" and m.PlaybackPaused = true
        end if
    end if

    if m.videoPlayer<>invalid and (m.videoPlayer.state = "stopped" or m.videoPlayer.state = "finished" or m.videoPlayer.state = "error")
        'set video player visibility to false, we have proper observer of visibility which will clear the video player
        m.videoPlayer.visible = false
    end if
end sub

'set default video length'
sub SetVideoLength(length as integer)
    m.length = length
end sub


sub OnListItemFocused()
    'handle changing right arrow which tells user that we have next panel
    if m.buttonListContentAA[m.top.list.itemFocused].id = "seasons"
        m.top.hasNextPanel = true
    else
        m.top.hasNextPanel = false
    end if
end sub

'this is base function for handling keypresses
'@param key [String] string representation of remote key
'@param pressed [boolean] tells if it's a press or release event
'@return boolean, if you return false this function will be called for you parent node 
function onKeyEvent(key, press)
    result = false
    if press
        if key="right"
            'check if we are focused on seasons button and add it to panelsset id needed
            if m.buttonListContentAA[m.top.list.itemFocused].id = "seasons"
                'function for adding next panel to list/grid panels 
                Utils_addNextPanel("ListMarkupDetailsPanel", m.top.data)
                'set focus to new panel 
                m.top.nextPanel.setFocus(true)
            end if
            result = true
        else if key="back"
            'check if we are on video player and close it
            if m.videoPlayer <> invalid and m.videoPlayer.visible = true
                'stop video player
                m.videoPlayer.control = "stop"
                'set visibility to false, we should have proper observer for this field that will clear all data and restore focus
                m.videoPlayer.visible = false
                result = true
            end if
        end if
    end if
    return result
end function