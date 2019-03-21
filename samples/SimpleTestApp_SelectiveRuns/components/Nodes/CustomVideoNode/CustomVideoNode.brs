' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

Sub CustomVideoNode_Init()
    ? "[CustomVideoNode] Init"
End Sub

'this is base function for handling keypresses
'@param key [String] string representation of remote key
'@param pressed [boolean] tells if it's a press or release event
'@return boolean, if you return false this function will be called for you parent node 
Function CustomVideoNode_OnKeyEvent(key, press)
    result = false
    if press
        if key = "back"
            m.top.visible = false
            result = true
        end if
    end if
    return result
End Function

