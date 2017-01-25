' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.description = m.top.findNode("description")
    m.poster = m.top.findNode("poster")
    m.otherDetailsBlock = m.top.findNode("OtherDetailsBlock")
    m.stars = m.top.findNode("Stars")
    m.director = m.top.findNode("Director")
    m.title = m.top.findNode("title")
end sub
'adjust layout according to received width 
sub onWidthChange()
    if m.top.horizontalStyle
        m.description.width = m.top.width - m.poster.width - 10
        m.stars.width = m.top.width - m.poster.width - 100
        m.director.width = m.top.width - m.poster.width - 115
        m.title.width = m.top.width - m.poster.width - 10
    end if
end sub
'adjust layout according to received image width
sub onPosterWidthChange()
    if m.top.horizontalStyle
        scale = 1.0
        if m.top.posterWidth <> 0 and m.top.posterWidth <> invalid
            scale = m.top.posterWidth / 300
        end if
        m.poster.width = 300 * scale
        m.poster.height = 400 * scale
        m.description.maxLines = (m.poster.height - 200) / 40
        onWidthChange()
    end if
end sub

'change layout if we have horizontalStyle enabled
sub changeStyle()
   detailsGroup = m.top.findNode("detailsGroup")
   if m.top.horizontalStyle
        m.otherDetailsBlock.visible = true
        detailsGroup.layoutDirection = "horiz"
        detailsGroup.translation = [0,60]
        m.description.translation = [0,80]
        m.description.width = 750
        m.title.width = 750
        m.stars.width = 650
        m.director.width = 635
        m.description.maxLines = 5
        m.top.description = "Synopsis: " + m.top.description
   else
        m.otherDetailsBlock.visible = false
        detailsGroup.layoutDirection = "vert"
        detailsGroup.translation = [0,0]
        m.description.translation = [0,0]
        m.description.width = 500
        m.description.maxLines = 4
   end if
end sub

'set all proper data when item is set or changes
sub onContentSet()
    if m.top.content <> invalid
        m.top.posterUrl = m.top.content.HDPosterUrl
        if m.top.content.description.len() > 0
            m.top.description = m.top.content.description
        else
            m.top.description = "Loading..."
        end if
        if m.top.content.title.len() > 0
            m.top.title = m.top.content.title
        end if
        if m.top.content.ReleaseDate.len() > 0
            m.top.year = m.top.content.ReleaseDate
        end if
        if m.top.content.rating.len() > 0
            m.top.rating = m.top.content.rating
        end if
        if m.top.horizontalStyle
            m.top.description = "Synopsis: " + m.top.description
        end if
        m.director.text = Utils_Join(m.top.content.directors,", ")
        m.stars.text = Utils_Join(m.top.content.Actors,", ")
        m.top.duration = m.top.content.length
    end if
end sub