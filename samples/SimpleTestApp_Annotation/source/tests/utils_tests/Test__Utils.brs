' @BeforeEach
sub Utils_setProperValues()
    m.failedMessage = " test message that should appear"
    m.testFunctionResult = - 1000 ' just to track invalid
    m.shouldFail = false
end sub

' @AfterEach
sub UTILS_checkTestResults()
    ' TODO we need to check if errors array is empty
    ' each test should define if we should fail it or not 

    errors = GetGlobalAA().globalErrorsList

    failedTest = false

    if m.shouldFail then
        if not errors.count() > 0 then
            ' we failed this case
            failedTest = true
            errors.push("Test function expected to fail.")
        end if
    end if

    if GetInterface(m.testFunctionResult, "ifBoolean") = invalid then
        failedTest = true
        errors.push("Test function should return boolean result.")
    else if m.shouldFail = m.testFunctionResult
        msg = "Test function should return proper boolean result:"
        expectedValue = not m.shouldFail
        msg += " expected '" + expectedValue.toStr()
        msg += "' received '" + m.testFunctionResult.toStr() + "'"
        errors.push(msg)
        failedTest = true

        STOP
    end if

    if not failedTest then
        tmp = GetGlobalAA().globalErrorsList.clear()
    end if
end sub

function Test_UTF_assertAllTypes()
    return ["foo", 1, 0, -1, {}, invalid, true, false, [], CreateObject("roAppInfo")]
end function

function Test_UTF_assertNotBooleanTypes()
    return ["foo", 1, 0, -1, {}, invalid, [], CreateObject("roAppInfo")]
end function

function Test_UTF_assertNotInvalidTypes()
    return ["foo", 1, 0, -1, {}, true, false, [], CreateObject("roAppInfo")]
end function

function Test_UTF_assertNotAATypes()
    return ["foo", 1, 0, -1, invalid, []]
end function

function Test_UTF_assertInvalidKeys()
    return [1, 0, -1, {}, true, false, invalid, [], CreateObject("roAppInfo")]
end function

function Test_UTF_assertForEquals()
    return ["foo", 1, {"key": "value"}, true, invalid, ["value"]]
end function

function Test_UTF_assertEmptyItems()
    return [[], {}, ""]
end function

function Test_UTF_assertNotEmptyItems()
    return [[1], {"key": "value"}, "foo"]
end function

function Test_UTF_assertInvalidEmptyItems()
    return [1, 0, -1, true, false, CreateObject("roAppInfo")]
end function

' --------------------------------------------------------------------
' -------------------------- TESTS -----------------------------------
' --------------------------------------------------------------------

' --------------------------------------------------------------------
' -------------------------- Test_UTF_fail ---------------------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_fail()
    m.shouldFail = true
    m.testFunctionResult = UTF_fail(m.failedMessage)
end sub

' @Test FIXME and othe message = invalid
' sub Test_UTF_fail_invalid()
'     m.shouldFail = true
'     m.testFunctionResult = UTF_fail(invalid)
' end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertFalse --------------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertFalse_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertFalse(false)
end sub

' @Test
sub Test_UTF_assertFalse_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertFalse(false, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertFalse_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertFalse(true)
end sub

' @Test
sub Test_UTF_assertFalse_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertFalse(true, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotBooleanTypes")
sub Test_UTF_assertFalse_negative_parametrized(valueToTest)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertFalse(valueToTest)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotBooleanTypes")
sub Test_UTF_assertFalse_negative_with_message_parametrized(valueToTest)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertFalse(valueToTest, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertTrue ---------------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertTrue_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertTrue(true)
end sub

' @Test
sub Test_UTF_assertTrue_positive_with_message()
    m.testFunctionResult = UTF_assertTrue(true, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertTrue_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertTrue(false)
end sub

' @Test
sub Test_UTF_assertTrue_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertTrue(false, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotBooleanTypes")
sub Test_UTF_assertTrue_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertTrue(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotBooleanTypes")
sub Test_UTF_assertTrue_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertTrue(value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertEqual --------------------
' --------------------------------------------------------------------

' String

' @Test
sub Test_UTF_assertEqual_string_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual("test", "test")
end sub

' @Test
sub Test_UTF_assertEqual_string_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual("test", "test", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_string_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual("test", value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_string_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual("test", value, m.failedMessage)
end sub

' Integer

' @Test
sub Test_UTF_assertEqual_integer_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual(0, 0)
end sub

' @Test
sub Test_UTF_assertEqual_integer_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual(0, 0, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_integer_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual(0, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_integer_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual(0, value, m.failedMessage)
end sub

' AA

' @Test
sub Test_UTF_assertEqual_aa_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual({"test": "test"}, {"test": "test"})
end sub

' @Test
sub Test_UTF_assertEqual_aa_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual({"test": "test"}, {"test": "test"}, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_aa_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual({"test": "test"}, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_aa_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual({"test": "test"}, value, m.failedMessage)
end sub

' Boolean

' @Test
sub Test_UTF_assertEqual_boolean_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual(false, false)
end sub

' @Test
sub Test_UTF_assertEqual_boolean_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual(false, false, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_boolean_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual(false, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_boolean_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual(false, value, m.failedMessage)
end sub

' Array

' @Test
sub Test_UTF_assertEqual_array_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual(["test"], ["test"])
end sub

' @Test
sub Test_UTF_assertEqual_array_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEqual(["test"], ["test"], m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_array_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual(["test"], value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertEqual_array_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEqual(["test"], value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertNotEqual -----------------
' --------------------------------------------------------------------

' String

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_string_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual("test", value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_string_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual("test", value, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertNotEqual_string_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual("test", "test")
end sub

' @Test
sub Test_UTF_assertNotEqual_string_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual("test", "test", m.failedMessage)
end sub

' Integer

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_integer_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual(0, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_integer_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual(0, value, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertNotEqual_integer_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual(0, 0)
end sub

' @Test
sub Test_UTF_assertNotEqual_integer_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual(0, 0, m.failedMessage)
end sub

' AA

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_aa_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual({"test": "test"}, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_aa_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual({"test": "test"}, value, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertNotEqual_aa_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual({"test": "test"}, {"test": "test"})
end sub

' @Test
sub Test_UTF_assertNotEqual_aa_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual({"test": "test"}, {"test": "test"}, m.failedMessage)
end sub

' Boolean

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_boolean_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual(false, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_boolean_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual(false, value, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertNotEqual_boolean_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual(false, false)
end sub

' @Test
sub Test_UTF_assertNotEqual_boolean_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual(false, false, m.failedMessage)
end sub

' Array

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_array_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual(["test"], value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertForEquals")
sub Test_UTF_assertNotEqual_array_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEqual(["test"], value, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertNotEqual_array_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual(["test"], ["test"])
end sub

' @Test
sub Test_UTF_assertNotEqual_array_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEqual(["test"], ["test"], m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertInvalid ------------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertInvalid_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertInvalid(invalid)
end sub

' @Test
sub Test_UTF_assertInvalid_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertInvalid(invalid, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotInvalidTypes")
sub Test_UTF_assertInvalid_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertInvalid(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotInvalidTypes")
sub Test_UTF_assertInvalid_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertInvalid(value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertNotInvalid ---------------
' --------------------------------------------------------------------

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotInvalidTypes")
sub Test_UTF_assertNotInvalid_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotInvalid(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotInvalidTypes")
sub Test_UTF_assertNotInvalid_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotInvalid(value, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertNotInvalid_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotInvalid(invalid)
end sub

' @Test
sub Test_UTF_assertNotInvalid_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotInvalid(invalid, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertAAHasKey -----------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertAAHasKey_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAAHasKey({"key": "value"}, "key")
end sub

' @Test
sub Test_UTF_assertAAHasKey_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAAHasKey({"key": "value"}, "key", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAAHasKey_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAAHasKey({"key": "value"}, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAAHasKey_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAAHasKey({"key": "value"}, value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertAANotHasKey --------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertAANotHasKey_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAANotHasKey({"key": "value"}, "foo")
end sub

' @Test
sub Test_UTF_assertAANotHasKey_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAANotHasKey({"key": "value"}, "foo", m.failedMessage)
end sub

' @Test
sub Test_UTF_assertAANotHasKey_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKey({"key": "value"}, "key")
end sub

' @Test
sub Test_UTF_assertAANotHasKey_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKey({"key": "value"}, "key", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAANotHasKey_negative_invalid_keys_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKey({"key": "value"}, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAANotHasKey_negative_invalid_keys_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKey({"key": "value"}, value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertAAHasKeys ----------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertAAHasKeys_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAAHasKeys({"key1": "value1", "key2": "value2"}, ["key1", "key2"])
end sub

' @Test
sub Test_UTF_assertAAHasKeys_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAAHasKeys({"key1": "value1", "key2": "value2"}, ["key1", "key2"], m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAAHasKeys_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAAHasKeys({"key1": "value1", "key2": "value2"}, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAAHasKeys_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAAHasKeys({"key1": "value1", "key2": "value2"}, value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertAANotHasKeys -------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertAANotHasKeys_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAANotHasKeys({"key1": "value1", "key2": "value2"}, ["key3"])
end sub

' @Test
sub Test_UTF_assertAANotHasKeys_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertAANotHasKeys({"key1": "value1", "key2": "value2"}, ["key3"], m.failedMessage)
end sub

' @Test
sub Test_UTF_assertAANotHasKeys_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKeys({"key1": "value1", "key2": "value2"}, ["key1", "key2"])
end sub

' @Test
sub Test_UTF_assertAANotHasKeys_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKeys({"key1": "value1", "key2": "value2"}, ["key1", "key2"], m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAANotHasKeys_negative_invalid_keys_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKeys({"key1": "value1", "key2": "value2"}, value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertAANotHasKeys_negative_invalid_keys_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertAANotHasKeys({"key1": "value1", "key2": "value2"}, value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertArrayContains ------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertArrayContains_array_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContains(["value1", "value2"], "value1")
end sub

' @Test
sub Test_UTF_assertArrayContains_array_with_key_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContains(["value1", "value2"], "value1", "key1")
end sub

' @Test
sub Test_UTF_assertArrayContains_array_with_key_and_message_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContains(["value1", "value2"], "value1", "key1", m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayContains_aa_with_key_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], "value1", "key1")
end sub

' @Test
sub Test_UTF_assertArrayContains_aa_with_key_and_message_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], "value1", "key1", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_array_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains(["value1", "value2"], value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_array_with_key_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains(["value1", "value2"], value, "key1")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_array_with_key_and_message_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains(["value1", "value2"], value, "key1", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_aa_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_aa_with_existing_key_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], value, "key1")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_aa_with_non_existing_key_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], value, "key3")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_aa_with_incorrect_key_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], value, true)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayContains_aa_with_existing_key_and_message_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContains([{"key1": "value1"}, {"key2": "value2"}], value, "key1", m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertArrayNotContains ---------
' --------------------------------------------------------------------

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_array_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains(["value1", "value2"], value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_array_with_key_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains(["value1", "value2"], value, "key1")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_array_with_key_and_message_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains(["value1", "value2"], value, "key1", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_aa_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], value)
end sub

' @Test
sub Test_UTF_assertArrayNotContains_aa_without_key_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], "value1")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_aa_with_existing_key_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], value, "key1")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_aa_with_non_existing_key_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], value, "key3")
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_aa_with_existing_key_and_message_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], value, "key1", m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayNotContains_array_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContains(["value1", "value2"], "value1")
end sub

' @Test
sub Test_UTF_assertArrayNotContains_array_with_key_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContains(["value1", "value2"], "value1", "key1")
end sub

' @Test
sub Test_UTF_assertArrayNotContains_array_with_key_and_message_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContains(["value1", "value2"], "value1", "key1", m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayNotContains_aa_with_key_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], "value1", "key1")
end sub

' @Test
sub Test_UTF_assertArrayNotContains_aa_with_key_and_message_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], "value1", "key1", m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidKeys")
sub Test_UTF_assertArrayNotContains_aa_with_incorrect_key_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContains([{"key1": "value1"}, {"key2": "value2"}], value, true)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertArrayContainsSubset ------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertArrayContainsSubset_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContainsSubset(["value1", "value2", "value3"], ["value2", "value3"])
end sub

' @Test
sub Test_UTF_assertArrayContainsSubset_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayContainsSubset(["value1", "value2", "value3"], ["value2", "value3"], m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayContainsSubset_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContainsSubset(["value1", "value2", "value3"], ["value3", "value4"])
end sub

' @Test
sub Test_UTF_assertArrayContainsSubset_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayContainsSubset(["value1", "value2", "value3"], ["value3", "value4"], m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertArrayContainsSubset ------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertArrayNotContainsSubset_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContainsSubset(["value1", "value2", "value3"], ["value4", "value5"])
end sub

' @Test
sub Test_UTF_assertArrayNotContainsSubset_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotContainsSubset(["value1", "value2", "value3"], ["value4", "value5"], m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayNotContainsSubset_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContainsSubset(["value1", "value2", "value3"], ["value3", "value4"])
end sub

' @Test
sub Test_UTF_assertArrayNotContainsSubset_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotContainsSubset(["value1", "value2", "value3"], ["value3", "value4"], m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertArrayCount ---------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertArrayCount_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayCount(["value1", "value2", "value3"], 3)
end sub

' @Test
sub Test_UTF_assertArrayCount_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayCount(["value1", "value2", "value3"], 3, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertAllTypes")
sub Test_UTF_assertArrayCount_negative_incorrect_count_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayCount(["value1", "value2", "value3"], value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertAllTypes")
sub Test_UTF_assertArrayCount_negative_incorrect_count_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayCount(["value1", "value2", "value3"], value, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertAllTypes")
sub Test_UTF_assertArrayCount_negative_incorrect_array_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayCount(value, 3)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertAllTypes")
sub Test_UTF_assertArrayCount_negative_incorrect_array_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayCount(value, 3, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertArrayNotCount ------------
' --------------------------------------------------------------------

' @Test
sub Test_UTF_assertArrayNotCount_positive()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotCount(["value1", "value2", "value3"], 2)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_positive_with_message()
    m.shouldFail = false
    m.testFunctionResult = UTF_assertArrayNotCount(["value1", "value2", "value3"], 2, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotCount(["value1", "value2", "value3"], 3)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotCount(["value1", "value2", "value3"], 3, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_invalid_count_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotCount(["value1", "value2", "value3"], true)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_invalid_count_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotCount(["value1", "value2", "value3"], true, m.failedMessage)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_invalid_array_negative()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotCount("value1", 1)
end sub

' @Test
sub Test_UTF_assertArrayNotCount_invalid_array_negative_with_message()
    m.shouldFail = true
    m.testFunctionResult = UTF_assertArrayNotCount("value1", 1, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertEmpty --------------------
' --------------------------------------------------------------------

' @ParameterizedTest
' @MethodSource("Test_UTF_assertEmptyItems")
sub Test_UTF_assertEmpty_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEmpty(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertEmptyItems")
sub Test_UTF_assertEmpty_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertEmpty(value, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotEmptyItems")
sub Test_UTF_assertEmpty_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEmpty(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotEmptyItems")
sub Test_UTF_assertEmpty_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEmpty(value, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidEmptyItems")
sub Test_UTF_assertEmpty_negative_invalid_items_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEmpty(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidEmptyItems")
sub Test_UTF_assertEmpty_negative_invalid_items_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertEmpty(value, m.failedMessage)
end sub

' --------------------------------------------------------------------
' -------------------------- Test_UTF_assertNotEmpty -----------------
' --------------------------------------------------------------------

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotEmptyItems")
sub Test_UTF_assertNotEmpty_positive_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEmpty(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertNotEmptyItems")
sub Test_UTF_assertNotEmpty_positive_with_message_parametrized(value)
    m.shouldFail = false
    m.testFunctionResult = UTF_assertNotEmpty(value, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertEmptyItems")
sub Test_UTF_assertNotEmpty_negative_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEmpty(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertEmptyItems")
sub Test_UTF_assertNotEmpty_negative_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEmpty(value, m.failedMessage)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidEmptyItems")
sub Test_UTF_assertNotEmpty_negative_invalid_items_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEmpty(value)
end sub

' @ParameterizedTest
' @MethodSource("Test_UTF_assertInvalidEmptyItems")
sub Test_UTF_assertNotEmpty_negative_invalid_items_with_message_parametrized(value)
    m.shouldFail = true
    m.testFunctionResult = UTF_assertNotEmpty(value, m.failedMessage)
end sub
