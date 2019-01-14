' ********** Copyright 2017 Roku Corp.  All Rights Reserved. **********

' Channel entry point
sub RunUserInterface(args)
    screen = CreateObject("roSGScreen")
    m.mainData = {
        scene: screen.CreateScene("Scene")
        screen: screen
    }
    screen.show()
    if true or args.RunTests = "true" and Type(TestRunner) = "Function" then
        Runner = TestRunner()

        Runner.SetFunctions([
            NewApproach__ThisFunctionShouldBeCalledBeforeAllTestsInSuite
            NewApproach__ThisFunctionShouldBeCalledAfterAllTests
            NewApproach_CreateRowlist
            NewApproach_CreateRowlist1
            stringProvider
            dummyTest
            invalidProvider
            multipleArgsProvider
            NewApproach_CreateRowlistRepeatTest

            Utils_setProperValues
            UTILS_checkTestResults
            
            testWithSimpleMethodSource
            testWithSimpleMethodSource2
            testWithSimpleMethodSource3          

            notExistedFunction

            Test_UTF_assertAllTypes
            Test_UTF_assertNotBooleanTypes
            Test_UTF_assertNotInvalidTypes
            Test_UTF_assertNotAATypes
            Test_UTF_assertInvalidKeys
            Test_UTF_assertForEquals
            Test_UTF_assertEmptyItems
            Test_UTF_assertNotEmptyItems
            Test_UTF_assertInvalidEmptyItems

            Test_UTF_fail
            Test_UTF_fail_invalid

            Test_UTF_assertFalse_positive
            Test_UTF_assertFalse_positive_with_message
            Test_UTF_assertFalse_negative
            Test_UTF_assertFalse_negative_with_message
            Test_UTF_assertFalse_negative_parametrized
            Test_UTF_assertFalse_negative_with_message_parametrized
            
            Test_UTF_assertTrue_positive
            Test_UTF_assertTrue_positive_with_message
            Test_UTF_assertTrue_negative
            Test_UTF_assertTrue_negative_with_message
            Test_UTF_assertTrue_negative_parametrized
            Test_UTF_assertTrue_negative_with_message_parametrized
            
            Test_UTF_assertEqual_string_positive
            Test_UTF_assertEqual_string_positive_with_message
            Test_UTF_assertEqual_string_negative_parametrized
            Test_UTF_assertEqual_string_negative_with_message_parametrized
            Test_UTF_assertEqual_integer_positive
            Test_UTF_assertEqual_integer_positive_with_message
            Test_UTF_assertEqual_integer_negative_parametrized
            Test_UTF_assertEqual_integer_negative_with_message_parametrized
            Test_UTF_assertEqual_aa_positive
            Test_UTF_assertEqual_aa_positive_with_message
            Test_UTF_assertEqual_aa_negative_parametrized
            Test_UTF_assertEqual_aa_negative_with_message_parametrized
            Test_UTF_assertEqual_boolean_positive
            Test_UTF_assertEqual_boolean_positive_with_message
            Test_UTF_assertEqual_boolean_negative_parametrized
            Test_UTF_assertEqual_boolean_negative_with_message_parametrized
            Test_UTF_assertEqual_array_positive
            Test_UTF_assertEqual_array_positive_with_message
            Test_UTF_assertEqual_array_negative_parametrized
            Test_UTF_assertEqual_array_negative_with_message_parametrized
    
            Test_UTF_assertNotEqual_string_positive_parametrized
            Test_UTF_assertNotEqual_string_positive_with_message_parametrized
            Test_UTF_assertNotEqual_string_negative
            Test_UTF_assertNotEqual_string_negative_with_message
            Test_UTF_assertNotEqual_integer_positive_parametrized
            Test_UTF_assertNotEqual_integer_positive_with_message_parametrized
            Test_UTF_assertNotEqual_integer_negative
            Test_UTF_assertNotEqual_integer_negative_with_message
            Test_UTF_assertNotEqual_aa_positive_parametrized
            Test_UTF_assertNotEqual_aa_positive_with_message_parametrized
            Test_UTF_assertNotEqual_aa_negative
            Test_UTF_assertNotEqual_aa_negative_with_message
            Test_UTF_assertNotEqual_boolean_positive_parametrized
            Test_UTF_assertNotEqual_boolean_positive_with_message_parametrized
            Test_UTF_assertNotEqual_boolean_negative
            Test_UTF_assertNotEqual_boolean_negative_with_message
            Test_UTF_assertNotEqual_array_positive_parametrized
            Test_UTF_assertNotEqual_array_positive_with_message_parametrized
            Test_UTF_assertNotEqual_array_negative
            Test_UTF_assertNotEqual_array_negative_with_message

            Test_UTF_assertInvalid_positive
            Test_UTF_assertInvalid_positive_with_message
            Test_UTF_assertInvalid_negative_parametrized
            Test_UTF_assertInvalid_negative_with_message_parametrized

            Test_UTF_assertNotInvalid_positive_parametrized
            Test_UTF_assertNotInvalid_positive_with_message_parametrized
            Test_UTF_assertNotInvalid_negative
            Test_UTF_assertNotInvalid_negative_with_message

            Test_UTF_assertAAHasKey_positive
            Test_UTF_assertAAHasKey_positive_with_message
            Test_UTF_assertAAHasKey_negative_parametrized
            Test_UTF_assertAAHasKey_negative_with_message_parametrized

            Test_UTF_assertAANotHasKey_positive
            Test_UTF_assertAANotHasKey_positive_with_message
            Test_UTF_assertAANotHasKey_negative
            Test_UTF_assertAANotHasKey_negative_with_message
            Test_UTF_assertAANotHasKey_negative_invalid_keys_parametrized
            Test_UTF_assertAANotHasKey_negative_invalid_keys_with_message_parametrized

            Test_UTF_assertAAHasKeys_positive
            Test_UTF_assertAAHasKeys_positive_with_message
            Test_UTF_assertAAHasKeys_negative_parametrized
            Test_UTF_assertAAHasKeys_negative_with_message_parametrized

            Test_UTF_assertAANotHasKeys_positive
            Test_UTF_assertAANotHasKeys_positive_with_message
            Test_UTF_assertAANotHasKeys_negative
            Test_UTF_assertAANotHasKeys_negative_with_message
            Test_UTF_assertAANotHasKeys_negative_invalid_keys_parametrized
            Test_UTF_assertAANotHasKeys_negative_invalid_keys_with_message_parametrized

            Test_UTF_assertArrayContains_array_positive
            Test_UTF_assertArrayContains_array_with_key_positive
            Test_UTF_assertArrayContains_array_with_key_and_message_positive
            Test_UTF_assertArrayContains_aa_with_key_positive
            Test_UTF_assertArrayContains_aa_with_key_and_message_positive
            Test_UTF_assertArrayContains_array_negative_parametrized
            Test_UTF_assertArrayContains_array_with_key_negative_parametrized
            Test_UTF_assertArrayContains_array_with_key_and_message_negative_parametrized
            Test_UTF_assertArrayContains_aa_negative_parametrized
            Test_UTF_assertArrayContains_aa_with_existing_key_negative_parametrized
            Test_UTF_assertArrayContains_aa_with_non_existing_key_negative_parametrized
            Test_UTF_assertArrayContains_aa_with_incorrect_key_negative_parametrized
            Test_UTF_assertArrayContains_aa_with_existing_key_and_message_negative_parametrized

            Test_UTF_assertArrayNotContains_array_positive_parametrized
            Test_UTF_assertArrayNotContains_array_with_key_positive_parametrized
            Test_UTF_assertArrayNotContains_array_with_key_and_message_positive_parametrized
            Test_UTF_assertArrayNotContains_aa_positive_parametrized
            Test_UTF_assertArrayNotContains_aa_without_key_positive
            Test_UTF_assertArrayNotContains_aa_with_existing_key_positive_parametrized
            Test_UTF_assertArrayNotContains_aa_with_non_existing_key_positive_parametrized
            Test_UTF_assertArrayNotContains_aa_with_existing_key_and_message_positive_parametrized
            Test_UTF_assertArrayNotContains_array_negative
            Test_UTF_assertArrayNotContains_array_with_key_negative
            Test_UTF_assertArrayNotContains_array_with_key_and_message_negative
            Test_UTF_assertArrayNotContains_aa_with_key_negative
            Test_UTF_assertArrayNotContains_aa_with_key_and_message_negative
            Test_UTF_assertArrayNotContains_aa_with_incorrect_key_negative_parametrized

            Test_UTF_assertArrayContainsSubset_positive
            Test_UTF_assertArrayContainsSubset_positive_with_message
            Test_UTF_assertArrayContainsSubset_negative
            Test_UTF_assertArrayContainsSubset_negative_with_message

            Test_UTF_assertArrayNotContainsSubset_positive
            Test_UTF_assertArrayNotContainsSubset_positive_with_message
            Test_UTF_assertArrayNotContainsSubset_negative
            Test_UTF_assertArrayNotContainsSubset_negative_with_message

            Test_UTF_assertArrayCount_positive
            Test_UTF_assertArrayCount_positive_with_message
            Test_UTF_assertArrayCount_negative_incorrect_count_parametrized
            Test_UTF_assertArrayCount_negative_incorrect_count_with_message_parametrized
            Test_UTF_assertArrayCount_negative_incorrect_array_parametrized
            Test_UTF_assertArrayCount_negative_incorrect_array_with_message_parametrized

            Test_UTF_assertArrayNotCount_positive
            Test_UTF_assertArrayNotCount_positive_with_message
            Test_UTF_assertArrayNotCount_negative
            Test_UTF_assertArrayNotCount_negative_with_message
            Test_UTF_assertArrayNotCount_invalid_count_negative
            Test_UTF_assertArrayNotCount_invalid_count_negative_with_message
            Test_UTF_assertArrayNotCount_invalid_array_negative
            Test_UTF_assertArrayNotCount_invalid_array_negative_with_message

            Test_UTF_assertEmpty_positive_parametrized
            Test_UTF_assertEmpty_positive_with_message_parametrized
            Test_UTF_assertEmpty_negative_parametrized
            Test_UTF_assertEmpty_negative_with_message_parametrized
            Test_UTF_assertEmpty_negative_invalid_items_parametrized
            Test_UTF_assertEmpty_negative_invalid_items_with_message_parametrized

            Test_UTF_assertNotEmpty_positive_parametrized
            Test_UTF_assertNotEmpty_positive_with_message_parametrized
            Test_UTF_assertNotEmpty_negative_parametrized
            Test_UTF_assertNotEmpty_negative_with_message_parametrized
            Test_UTF_assertNotEmpty_negative_invalid_items_parametrized
            Test_UTF_assertNotEmpty_negative_invalid_items_with_message_parametrized
        ])
        Runner.Logger.SetVerbosity(3)
        Runner.Logger.SetEcho(false)
        Runner.Logger.SetJUnit(false)

        Runner.Run()
    end if
end sub

' Part of channel specific logic, where you will work with some
' external resources, like REST API, etc. You may get raw data from feed, then
' parse it and return as a native BrightScript object(roAA, roArray, etc)
' with some proper Content Meta-Data structure.

' If you will have a complex parsing process with a lot of external resourses,
' then it will be a good practice to move all logic to separate files.
function GetApiArray()
    url = CreateObject("roUrlTransfer")
    ' External resource
    url.SetUrl("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss")
    rsp = url.GetToString()

    ' Utility function for XML parsing.
    ' Bassed on native Bright Script XML parser.
    responseXML = Utils_ParseXML(rsp)
    if responseXML <> invalid then
        responseXML = responseXML.GetChildElements()
        responseArray = responseXML.GetChildElements()
    end if

    ' The result will be roArray object.
    result = []

    if responseArray <> invalid and GetInterface(responseArray, "ifArray") <> invalid then
        ' Work with parsed XML and add to roArray some data.
        for each xmlItem in responseArray
            if xmlItem.getName() = "item"
                itemAA = xmlItem.GetChildElements()
                if itemAA <> invalid
                    item = {}
                    for each xmlItem in itemAA
                        if xmlItem.getName() = "media:content"
                            item.stream = { url: xmlItem.getAttributes().url }
                            item.url = xmlItem.getAttributes().url
                            item.streamFormat = "mp4"
                            mediaContent = xmlItem.GetChildElements()
                            for each mediaContentItem in mediaContent
                                if mediaContentItem.getName() = "media:thumbnail"
                                    item.HDPosterUrl = mediaContentItem.getattributes().url
                                    item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                                end if
                            end for
                        else
                            item[xmlItem.getName()] = xmlItem.getText()
                        end if
                    end for
                    result.push(item)
                end if
            end if
        end for
    end if
    return result
end function

' ----------------------------------------------------------------
' Prepends a prefix to every entry in Assoc Array

' @return An Assoc Array with new values if all values are Strings
' or invalid if one or more value is not String.
' ----------------------------------------------------------------
function AddPrefixToAAItems(AssocArray as Object) as Object
    prefix = "prefix__"

    for each key in AssocArray
        ' Get current item
        item = AssocArray[key]

        ' Check if current item is string
        if GetInterface(item, "ifString") <> invalid then
            ' Prepend a prefix to current item
            item = prefix + item
        else
            ' Return invalid if item is not string
            return invalid
        end if
    end for

    return AssocArray
end Function