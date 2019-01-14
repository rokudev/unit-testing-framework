' ********** Copyright 2017 Roku Corp.  All Rights Reserved. ********** 
 
    
'Populating content for entire channel from external feed.
'==========================================================================
'Please keep in mind, that in general, from external resource you will 
'probably recieve data in format like XML or JSON, that is why 
'it should be parsed to Bright Script Objects and transformed 
'to ContentNode (roSGNode) that can be used by any RSG Node further. 
'GetApiArray() and Utils_ContentList2Node() will help us with that.


'contains Api functions that returns static content and tend to modeling Api calls
function InitApi()
    this = {
        GetChannelContent   :   Api_GetChannelContent
        GetCategoriesMenu   :   Api_GetCategoriesMenu
        GetSubCategoriesMenu:   Api_GetSubCategoriesMenu
        GetSeasonContent    :   Api_GetSeasonContent
    }

    return this
end function

' Part of channel specific logic, where you will work with some 
' external resources, like REST API, etc. You may get raw data from feed, then
' parse it and return as a native BrightScript object(roAA, roArray, etc) 
' with some proper Content Meta-Data structure.
' 
' If you will have a complex parsing process with a lot of external resourses,
' then it will be a good practice to move all logic to separate files.
Function Api_GetChannelContent(event as Object) as Object
    url = CreateObject("roUrlTransfer")
    'External resource
    url.SetUrl("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss")
    rsp = url.GetToString()

    'Utility function for XML parsing.
    'Bassed on native Bright Script XML parser.
    responseXML = Utils_ParseXML(rsp)
    If responseXML <> invalid then
         responseXML   = responseXML.GetChildElements()
         responseArray = responseXML.GetChildElements()
    End if     

    'The result will be roArray object.
    result = []

    'Work with parsed XML and add to roArray some data.
    for each xmlItem in responseArray
        if xmlItem.getName() = "item"
            itemAA = xmlItem.GetChildElements()
            if itemAA <> invalid
                item = {}
                for each xmlItem in itemAA
                    item[xmlItem.getName()] = xmlItem.getText()
                    if xmlItem.getName() = "media:content"
                        item.stream = {url : xmlItem.url}
                        item.url = xmlItem.getAttributes().url
                        item.streamFormat = "mp4"
                        mediaContent = xmlItem.GetChildElements()
                        for each mediaContentItem in mediaContent
                            if mediaContentItem.getName() = "media:thumbnail"
                                item.HDPosterUrl = mediaContentItem.getattributes().url
                                item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                            end if
                        end for
                    end if
                end for
                result.push(item)
            end if
        end if
    end for
    'This is a place where OnContent() function will be triggered(BaseScene.brs)
    'It is triggered, because we added observer call-back function 
    'to field m.request.result in BaseScene.brs:
    '      Code example: m.request.ObserveField("result", "OnContent")
    event.result = Utils_ContentList2Node(result)
End Function

'returns content for main menu label list items
function Api_GetCategoriesMenu(event as Object) as Object
    if TF_Utils__IsValid(event) and TF_Utils__IsAssociativeArray(event.params) and TF_Utils__IsInteger(event.params.category_id) and TF_Utils__IsString(event.params.category_name) then 
        res = [{
                id              : "cat1"
                title           : "Category 1"
                'panel name that will be created when this item will be focused
                nextPanelName   : "MarkupListStubPanel"
            },{
                id              : "cat2"
                title           : "Category 2"
                'panel name that will be created when this item will be focused
                nextPanelName   : "MarkupListPanel"
                'tells if we need to include buttons after panel that will be created after this panel
                includeButtons  : true
            },{
                id              : "cat3"
                title           : "Category 3"
                'panel name that will be created when this item will be focusedі
                nextPanelName   : "MarkupListStubPanel"
            },{
                id              : "cat4"
                title           : "Category 4"
                'panel name that will be created when this item will be focused
                nextPanelName   : "MarkupListStubPanel"
                'tells if seasons button should be available in buttons panel
                isSeasonsAvailable : true
                
            },{
                id              : "search"
                title           : "Search"
                'panel name that will be created when this item will be focused
                nextPanelName   : "SearchPanel"
        }]
     else 
        res = []
     end if   

    'This is a place where OnContent() function will be triggered(CategoriesMenu.brs)
    'It is triggered, because we added observer call-back function 
    'to field m.request.result in CategoriesMenu.brs:
    '      Code example: m.request.ObserveField("result", "OnContent")
    event.result = Utils_ContentList2Node(res)
end function

'returns content for seasons label list items
function Api_GetSeasonContent(event as Object) as Object
    res = [
        {
            id              : "season1"
            title           : "Season 1"
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "season2"
            title           : "Season 2"
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "season3"
            title           : "Season 3"
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "season4"
            title           : "Season 4"
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "season5"
            title           : "Season 5"
            nextPanelName   : "MarkupListPanel"
        }
    ]

    'This is a place where OnContent() function will be triggered(ListMarkupDetailsPanel.brs)
    'It is triggered, because we added observer call-back function 
    'to field m.request.result in ListMarkupDetailsPanel.brs:
    '      Code example: m.request.ObserveField("result", "OnContent")
    event.result = Utils_ContentList2Node(res)
end function

'returns content for subcategory menu label list items
function Api_GetSubCategoriesMenu(event as Object) as Object
    res = [
        {
            id              : "sub1"
            title           : "Subcategory 1"
            'panel name that will be created when this item will be focused
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "sub2"
            title           : "Subcategory 2"
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "sub3"
            title           : "Subcategory 3"
            'panel name that will be created when this item will be focused
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "sub4"
            title           : "Subcategory 4"
            'panel name that will be created when this item will be focused
            nextPanelName   : "MarkupListPanel"
        }
        {
            id              : "sub5"
            title           : "Subcategory 5"
            'panel name that will be created when this item will be focused
            nextPanelName   : "MarkupListPanel"
        }
    ]

    'This is a place where OnContent() function will be triggered(SubcategoriesMenu.brs)
    'It is triggered, because we added observer call-back function 
    'to field m.request.result in SubcategoriesMenu.brs:
    '      Code example: m.request.ObserveField("result", "OnContent")
    event.result = Utils_ContentList2Node(res)
end function