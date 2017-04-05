' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    ?"[HomeScene] Init"
    'setup global hud node so it can be shown on any panel
    m.global.addField("Hud", "node", false)
    m.global.hud = m.top.findNode("Hud")
    
    m.PanelSet = m.top.findNode("PanelSet")
End sub

sub OnChangeContent()
    categoriesMenu = createObject("roSGNode", "CategoriesMenu")
    if m.PanelSet <> invalid and categoriesMenu <> invalid
        'setting data field in menu panel
        ' this is custom field for passing different data between panels,
        'each panel observes it and knows when it's shown 
        categoriesMenu.data = {content : m.top.content}
        'appending this panel to panelset in order for it to be shown
        'panels set handles key presses and if we receive back event it means that we need to exit the scene
        m.panelSet.appendChild(categoriesMenu)
    end if   
end sub
