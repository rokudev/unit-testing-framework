' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

'singleton that initializes global request node to handle data requests
sub init()
    if m.global.requestQueue = invalid
    	' add request node to global node to have a possibility to
    	' handle requests in main loop
        m.global.addField("requestQueue", "node", false)
        m.global.observeField("requestQueue", m.port)
        m.global.requestQueue = createObject("roSGNode", "Node")
    end if
end sub