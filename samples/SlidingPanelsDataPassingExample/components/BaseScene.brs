' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'If the <script> element contains the definition of a function named init() 
'that has no parameters, that function will be invoked after the XML file 
'has been parsed and the nodes contained in the file have been created and had 
'their fields set to the values in the XML. 
'Typical uses of the init() function are to cache roSGNode values in the 
'script's global variable that will be frequently used in other functions 
'in the script, and to set up field observers that will call 
'other BrightScript functions when the observed field changes value.
sub init()
    'Specifies a graphic image file to be used for the Scene node background.
    m.top.backgroundURI = "pkg:/images/background.jpg" 

    'set fake content before real content will be available
    SetLoadingContent()
    'creating new request node to get data from Api
    m.request = createObject("roSGNode", "DataRequest")
    'specifying function that will get proper data
    m.request.name = "GetChannelContent"
    'setting the observer to receive result
    m.request.ObserveField("result", "OnContent")
    'appending request to the main loop request queue
    m.global.requestQueue.appendChild(m.request)
End sub

'This is a call-back function that is called when we set parsed and valid content
'to content field of the scene that is observed. (m.scene.Content = ...)
'Here we can check if our custom SlidingTemplate component is initialized and
'set it content.
Sub OnContent()
    ?"Initilization of SlidingTemplate"
    m.top.content = m.request.result
    m.SlidingTemplate = m.top.findNode("SlidingTemplate")
    if m.SlidingTemplate <> invalid then
        m.SlidingTemplate.content = m.top.content
        'adding this contnet as stub content that will be used in other places, 
        'such as search screen
        m.global.addField("sampleContent", "node", false)
        m.global.sampleContent = m.top.content
        m.SlidingTemplate.setFocus(true)
    end if

end Sub

'this is base function for handling keypresses
'@param key [String] string representation of remote key
'@param pressed [boolean] tells if it's a press or release event
'@return boolean,if you return false this function will be called for you parent node 
function OnKeyEvent(key as String, pressed as boolean) as boolean
    ?"OnKeyEvent [BaseScene]"
    handled = false

    if pressed
        if key = "options"
            'show global options dialog 
            showOptionsDialog()
            handled = true
        end if
    end if

    return handled
end function

'function for showing options dialog
sub showOptionsDialog()
    dialog = CreateObject("roSGNode","Dialog")
    dialog.title = "Options"
    dialog.message = "This is options dialog"
    dialog.buttons = ["Close"]
    dialog.observeField("buttonSelected","onOptionsDialogButtonSelected")
    'in order for dialog to work properly you have to set it to dialog field of scene
    m.top.dialog = dialog
end sub

'handle dialog close 
sub onOptionsDialogButtonSelected()
    'check if we have close button pressed
    if lcase(m.top.dialog.buttonGroup.buttons[m.top.dialog.buttonSelected]) = "close"
        m.top.dialog.close = true
    end if
end sub

' set fake content on the panel until real content will be populated
Sub SetLoadingContent()
    fakeContent = CreateObject("roSGNode", "ContentNode")
    fakeitem = CreateObject("roSGNode", "ContentNode")
    fakeitem.title = tr("Loading") + "..."
    fakeitem.id = "fake"
    fakeContent.appendChild(fakeitem)
    m.top.content = fakeContent
End Sub

