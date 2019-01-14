' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'cashe chidren nodes for future operations
function Init()
   m.proportion = 0.4
   
   m.cover = m.top.findNode("cover")
   m.background = m.top.findNode("background")
   m.title          = m.top.findNode("title")
   m.description    = m.top.findNode("description")
 end function

'triggers content change and update layout properly
sub OnItemContentChanged()

    item = m.top.itemContent
    if item = invalid then return
    
    m.cover.uri = item.HDPOSTERURL
    
    releaseDate = item.ReleaseDate
    if releaseDate <> invalid and type(releaseDate) = "roString" then
        if releaseDate = "" then releaseDate="no date available"
    end if 

    title = item.title
    if title <> invalid        
        m.title.text = title + "(" + releaseDate + ")"
    end if
    
    itemInfoArray = []
    
    description = item.description
    if description <> invalid then
        if description = "" then description="no description available"
    end if 
    m.description.text = description
    
    UpdateLayout()
end sub

'update layout on width change
function OnWidthChanged()
    UpdateLayout()
end function

'update layout on height change
function OnHeightChanged()
    UpdateLayout()
end function

'tune size of all subelements according to item size
function UpdateLayout()
    
    firstWidth               = m.top.width * m.proportion
    secondWidth              = m.top.width * (1 - m.proportion)
    border                   = 10
    
    m.cover.height           = m.top.height
    m.cover.width            = firstWidth
    
    m.background.width       = secondWidth 
    m.background.height      = m.top.height
    m.background.translation = [firstWidth - 1, 0]
        
    m.title.width            = secondWidth - 2 * border
    m.title.height           = m.top.height / 4
    m.title.translation      = [firstWidth + border, (m.top.height - m.title.height) / 2]

    m.Description.width      = secondWidth - 2 * border
    m.Description.height     = m.top.height / 3
    m.Description.translation = [firstWidth + border, m.top.height - m.description.height]
    
end function
