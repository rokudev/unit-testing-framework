' ********** Copyright 2017 Roku Corp.  All Rights Reserved. ********** 
 
 'Channel entry point
 'specify in deep linking parameters parameter RunTests as true, to Run Test Cases
 sub RunUserInterface(args)
    PrintSampleLogo()
    'test
    APPInfo = createObject("roAPPInfo")
    'if channel is in dev mode and in deep linking parameters was specified RunTests parameter as true
    'then we run test cases, that is specified in folder pkg:/source/tests
    
    'screen, scene and port initialization
    m.screen = CreateObject("roSGScreen")
    m.scene = m.screen.CreateScene("BaseScene")
    m.port = CreateObject("roMessagePort")
    'getting acess to global node
    m.global = m.screen.getGlobalNode()

    'Set the roMessagePort to be used for all events from the screen.
    m.screen.SetMessagePort(m.port)

    'Show Scene Graph canvas that displays the contents
    'of a Scene Graph Scene node tree
    m.screen.Show()
    
    ' !!! Note that tests start only AFTER scene is shown
    if APPInfo.IsDev() and args.RunTests = "true" and TF_Utils__IsFunction(TestRunner) then
        Runner = TestRunner()
        Runner.logger.SetVerbosity(2)
        Runner.RUN()
    end if

    'Initializing Api object, that will be used for getting channel content
    m.Api = InitApi()
    'main channel loop
    while true
        msg = wait(200, m.port)

        if msg <> invalid
            print "------------------"
            print "msg = "; msg
        end if
        ' every 200 miliseconds this code will check if ther's any events in the queue;
        ' if so, then we'll get the first element from that queue and call proper Api
        ' function;
        ' after that we'll remove handled event from the queue
        if m.global.requestQueue <> invalid AND m.global.requestQueue.getchildCount() > 0
            event = m.global.requestQueue.getchild(0)
            m.global.requestQueue.removeChildIndex(0)                
            
            if event <> invalid AND event.name <> invalid then
                'this parameters is only used in condition of API GetCategoriesMenu function
                'and in TestCase__OutputResult_GetCategoriesMenu
                'to create usage example of test framework more complicated
                event.params = {
                    category_id : 87
                    category_name : "SomeName"}
                m.Api[event.name](event)
            end if
        end if

        msgType = type(msg)

        if msgType = "roSGScreenEvent"
            'handle exit from channel
            if msg.isScreenClosed() then exit while
        end if

    end while
    
    if m.screen <> invalid then
        m.screen.Close()
        m.screen = invalid
    end if
    
end sub


Sub PrintSampleLogo()
 ?" _   _       _ _     _____         _"
 ?"| | | |_ __ (_) |_  |_   _|__  ___| |_"
 ?"| | | | '_ \| | __|   | |/ _ \/ __| __|"
 ?"| |_| | | | | | |_    | |  __/\__ \ |_"
 ?" \___/|_|_|_|_|\__|___|_|\___||___/\__|"
End Sub