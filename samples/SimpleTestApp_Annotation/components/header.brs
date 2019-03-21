' Copyright (c) 2017 Roku, Inc. All rights reserved.
' Roku Headers File

' A sub that initialize header
sub header_Init()
    m.top.ChannelTitle = m.top.FindNode("ChannelTitle")
    m.top.CurrentlyPlaying = m.top.FindNode("CurrentlyPlaying")
    m.top.ContentDescription = m.top.FindNode("ContentDescription")
end sub
