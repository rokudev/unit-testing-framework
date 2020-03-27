## Overview

This document describes the architecture and usage of the Roku unit test framework.  This framework allows Roku channel developers to instrument their code with predefined or custom test cases in order to unit test their code.

## System Architecture

### System diagram

![System architecture diagram](../images/system-architecture-diagram.png)
**Figure 1:** System architecture diagram

### Sequence diagram

![Flow diagram](../images/flow-diagram.png)
**Figure 2:** Flow diagram

## Framework Components

### Test Runner
TestRunner is main object in the unit test framework. This object has 6 properties:
* testsDirectory – path to directory which contains all tests.
* testFilePrefix - string to identify all test files in testsDirectory and subdirectories.
* testSuitePrefix - string identifying all test suites in test files.
* testSuiteName – string identifying specific test suite.
* testCaseName - string identifying specific test case.
* logger – object which formats and outputs logs.

TestRunner searches for .brs files with the testFilePrefix in testsDirectory and subdirectories. When the list of files is complete, TestRunner parses these files and extracts all test suites identified by the prefix testSuitePrefix. Every test suite has a list of test cases. TestRunner compiles a single list of all test cases and then runs them one at a time. Set testSuiteName to specify exact test suite to run or testCaseName to specify exact test case.

During a test run TestRunner collects the statistic into a statistic object. After the test run TestRunner passes a statistics object to a Logger instance which outputs a results to a console accessible via telnet port 8085.  The verbosity level can be set by calling the SetVerbosity method of the Logger instance.

### BaseTestSuite
A collection of one or more test cases is called a test suite.  Developers can implement their own test suite types which must be derived from BaseTestSuite. BaseTestSuite implements a set of assertion methods. All these methods have one common argument “msg”. This is an error message returned if the assertion fails.

**Table 1. Assertions list**

| Method Name        | Arguments           | Description  |
| ------------- |:-------------:| -----:|
| Fail      | msg (string) An error message. Default value: "Error". | Fail immediately, with the given message. |
| AssertFalse      | expr (dynamic) An expression to evaluate.      |   Fail the test if the expression is true. |
| AssertTrue | expr (dynamic) An expression to evaluate.      |    Fail the test if the expression is false. |
| AssertEqual | first (dynamic) A first object to compare. second (dynamic) A second      |    Fail if the two objects are unequal as determined by the '<>' operator. |
| AssertNotEqual | first (dynamic) A first object to compare. second (dynamic) A second object to compare.     |    Fail if the two objects are equal as determined by the '=' operator. |
| AssertInvalid | value (dynamic) A value to check.      |    Fail if the value is not invalid. |
| AssertNotInvalid | value (dynamic) A value to check.      |    Fail if the value is invalid. |
| AssertAAHasKey | array (dynamic) A target array. key (string) A key name.     |  Fail if the array doesn't contain the specified key.   |
| AssertAANotHasKey | array (dynamic) A target array. key (string) A key name.      |    Fail if the array contains the specified key. |
| AssertAAHasKeys | array (dynamic) A target associative array. keys (object) A key names array.     |    Fail if the array doesn't contain the specified set of keys. |
| AssertAANotHasKeys | array (dynamic) A target associative array. keys (object) A key names array.       |    Fail if the array contains the specified set of keys. |
| AssertArrayContains | array (dynamic) A target array. value (dynamic) A value to check. key (object) A key name for associative array.    |    Fail if the array doesn't contain the specified item. |
| AssertArrayNotContains | array (dynamic) A target array. value (dynamic) A value to check. key (object) A key name for associative array.    |    Fail if the array contains the specified item. |
| AssertArrayContainsSubset | array (dynamic) A target array. subset (dynamic) An items array to check.     |    Fail if the array doesn't contains the specified subset of items. |
| AssertArrayNotContainsSubset | array (dynamic) A target array. subset (dynamic) A items array to check.     |    Fail if the array contains the specified subset of items. |
| AssertArrayCount | array (dynamic) A target array. count (integer) An expected array items count.     |    Fail if the array item count is not equal to the specified value. |
| AssertArrayNotCount | array (dynamic) A target array. count (integer) An expected array items count.     |    Fail if the array item count is equal to the specified value. |
| AssertEmpty | item (dynamic) An array or string to check.      |    Fail if the item is not empty. |
| AssertNotEmpty | item (dynamic) An array or string to check.      |    Fail if the item is empty. |

### Item Generator

ItemGenerator is an object that generates random items according to a specified scheme.  ItemGenerator is used to create random test data for use as function parameters, etc.  A scheme could be one of simple types (integer, string or float), array or associative array.

For simple types, ItemGenerator generates a random value of this type.

For arrays, the scheme specifies that types of each of the individual array items.

For example:

**scheme:** [“int”, “string”, “string”, “boolean”]

**result:** [5, “ghn56f”, “7sb2td”, true]

An associative array scheme has the following structure:

```
{
       propertyName1: "propertyType1"
       propertyName2: "propertyType2"
       ...
       propertyNameN: "propertyTypeN"
}
```

ItemGenerator will return an associative array object with the specified property names and random values of the specified property types.

For example:

**scheme:**

```
{
    id: "integer"
    name: "string"
    address: {city: “string”, street: “string”}
    active: “boolean”
}
```

**result:**

```
{
    id: 75
    name: "ht7d9nt5zp"
    address: {city : “9gbst5mpw7”, street : “nfdt7ns5p2”}
    active: false
}
```

###	Logger

The Logger object is used to output test results. It takes information from a TestRunner, formats it according to selected verbosity level and outputs to the console. TestRunner calls printStatistic function to print logs. This method has one argument which is a statistic object. The printStatistic function can be overwritten to generate custom log output.

### Annotations

We support some annotations for building unit tests functions.

It's based on JUnit 5 annotations approach

See [JUnit guide ](https://junit.org/junit5/docs/current/user-guide/)


For now we support

* @Test - describes this is a test
* @BeforeAll - function to run before all functions
* @BeforeEach - function to run before each test execution
* @AfterAll - function that will run after all tests in test suite
* @AfterEach - function that will run after each test
* @RepeatedTest(n) - repeats test for n times
* @ParameterizedTest and @MethodSource("argsProviderFunctionName") - parametrized tests
* @Ignore - function that wont be run as test

## Usage

### General

To use the unit test framework in your channel, place the framework files in the directory pkg:/source/testFramework/.

To run your unit tests, follow these instruction:

1)	Create new folder “tests” under source directory of your project: “pkg:/source/tests”.
 * This will be the root folder for all your unit tests. In this folder you can also create subfolders for every test suite collection.

2) Create test files in “tests” folder or subfolders.

Create new .brs files for each test suite. The default prefix for test suite files is “Test\__”. You can use any prefix you want just don’t forget to specify it in the next step using Runner.SetTestFilePrefix function. 
In this new file define a functions for each test case using @Test annotation. Detailed annotation descriptions you could find in Annotations section of this document.

    ' @Test
    function TestCase__Main_CheckDataCount() as String
        return m.assertArrayCount(m.mainData, 15)
    end function
    
    ' @Test
    function Test_CheckDataCountSecondTime() as String
        return m.assertArrayCount(m.mainData, 15)
    end function

***Optional***: Specify SetUp function for your test suite to do any actions before a tests from the suite will be executed:

    ' @BeforeAll
    sub MainTestSuite__SetUp()
        ' Target testing object. To avoid the object creation in each test
        ' we create instance of target object here and use it in tests as m.targetTestObject.
        m.mainData  = GetApiArray()
    end sub

***Optional***: Specify TearDown function for your test suite to do any actions after a tests from the suite has been executed:

    ' @AfterAll
    sub MainTestSuite__TearDown()
        ' Remove all the test data
        m.Delete("mainData")
    end sub

***Optional***: You could specify SetUp and TearDown functions for each test case using @BeforeEach and @AfterEach annotations:

    ' @BeforeEach
    sub TestCase__SetUp()
        m.testObject = {}
    end sub
    
    ' @AfterEach
    sub TestCase__TearDown()
        m.someStorage.Append(m.testObject)
    end sub

You could print some performance data from your test cases using StorePerformanceData function as shown below:

    ' @Test
    function TestCase__Main_CheckDataCount() as String
        ' do some calculations
        memoryUsage = GetMemoryUsage()
        m.StorePerformanceData("memory usage", memoryUsage)

        return m.assertArrayCount(m.mainData, 15)
    end function

3)	Run all your tests.

To run your tests:
* Create instance of TestRunner object (Runner = TestRunner()) and call it’s method Run (Runner.Run()). Embrace this code with such if statement – “args.RunTests = "true" and type(TestRunner) = "Function"”.
* Define all functions using SetFunctions method (Runner.SetFunctions([TestCase__Main_CheckDataCount, Test_CheckDataCountSecondTime])).
* If needed set TestRunner’s properties by calling it's setter methods before calling Run method.
* If you want to add selective tests run option you could add SetIncludeFilter and SetExcludeFilter functions execution.
* Deploy your channel to the device
* POST the following command to the device via ECP:
http://{Roku_box_IP_address}:8060/launch/dev?RunTests=true
* View the test results by opening a telnet console on the device on port 8085:
telnet {Roku box IP address} 8085.


    if APPInfo.IsDev() and args.RunTests = "true" and TF_Utils__IsFunction(TestRunner) then
        Runner = TestRunner()
    
        Runner.SetFunctions([
            TestCase__Main_CheckDataCount
            Test_CheckDataCountSecondTime
            MainTestSuite__SetUp
            MainTestSuite__TearDown
            TestCase__SetUp
            TestCase__TearDown
        ])
  
        if args.IncludeFilter <> invalid
            Runner.SetIncludeFilter(args.IncludeFilter)
        end if
  
        if args.ExcludeFilter <> invalid
            Runner.SetExcludeFilter(args.ExcludeFilter)
        end if
  
        Runner.Logger.SetVerbosity(3)
        Runner.Logger.SetEcho(false)
        Runner.Logger.SetJUnit(false)
        Runner.SetFailFast(true)
        
        Runner.Run()
    end if

### Filtering
To set Include and Exclude filters use SetIncludeFilter and SetExcludeFilter functions. Each function accepts coma-separated names of test cases or array object of strings with test cases names.
If you specify include filter with test case names than ONLY test cases from this list will be executed. Rest of test cases will be skipped.
If you specify exclude filter with test case names than ALL test cases from this filter wont be executed. Exclude filter has higher priority and if you specify some test case in both filters than this test case will be excluded from run.
Include and exclude filters works for @Test, @RepeatedTest and @ParameterizedTest only.

### Logging
To set verbosity level call Runner.logger.SetVerbosity(level). There are four verbosity levels in this framework:
* “0” – basic level
* “1” – normal level
* “2” – detailed only for failed tests, normal for others
* “3” – detailed level.

You can overwrite printStatistic if you like, such as

Runner.logger.printStatistic = customPrintFunction

With basic verbosity level the framework outputs total number of tests, number of passed tests, number of failed tests, number of tests that caused a crash and time spent for running the tests:

![Basic verbosity level](../images/Basic-verbosity-level.png)

**Figure 3:** Basic verbosity level

Normal level includes the list of all tests with their names and results:

![Normal verbosity level](../images/normal-verbosity-level.png)

**Figure 4:** Normal verbosity level


Detailed level shows verbose statistics for every test suite and any error messages for failed tests:

![Detailed verbosity level](../images/detailed-verbosity-level.png)

**Figure 5:** Detailed verbosity level

###RSG

If you want to test RSG nodes you should:

1)	Create new folder "tests" under components directory of your project: "pkg:/components/tests".
 * This will be the root folder for RSG unit tests. In this folder you can also create subfolders for every test suite collection.

2)	Create test suite files in "tests" folder or subfolders.

Create new .xml file for each node you want to test. This .xml file should be a node and it must extend the node you want to test but not the main scene node. The default prefix for test nodes is "Test\__". You can use any prefix you want just don’t forget to specify it using Runner.SetTestFilePrefix function. File name must match node name. For each node you may create as many test suites as you wish. Details on how to create test suites you can find in the previous section. The only difference is that every test suite should have following prefix: TEST\_FILE\_PREFIX + NODE\_NAME + "\__" + TEST\_SUITE\_NAME, where default TEST\_FILE\_PREFIX is "Test\__", NODE\_NAME may be "MyNode" and TEST\_SUITE\_NAME can be "TestSuite1". So the name of a test suite file may look like this: "Test\__MyNode\__TestSuite1". 
Create additional Init.brs file with Init functions and define all functions from previous files using SetFunctions method: 

    sub init()
        Runner = TestRunner()
    
        Runner.SetFunctions([
            RSG_Test1_FromSuite1
            RSG_Test2_FromSuite1
            RSG_Test1_FromSuite2
        ])
    end sub

In every test node (.xml file) you should:
* Add interface function for running tests. This function will be used by framework and must not be addressed in any other way:

		<interface>
			<function name="TestFramework__RunNodeTests"/>
		</interface>

* Import unit test framework:

		<script type="text/brightscript" uri="pkg:/source/testFramework/UnitTestFramework.brs"/>

* Import Init.brs associated with this node.

        <script type="text/brightscript" uri="pkg:/components/tests/Init.brs"/>

* Import all the test suites, associated with this node.

		<script type="text/brightscript" uri="pkg:/components/tests/Test__MyNode__TestSuite1.brs"/>
		<script type="text/brightscript" uri="pkg:/components/tests/Test__MyNode__TestSuite2.brs"/>

Note that if you want to test RSG nodes, you must run tests only after screen is shown. If you had previously set up test runner, move it below screen showing statement.

    m.screen.show()
    
    if runUnitTests
	    runner = TestRunner()
	    runner.run()
    end if

### Annotations

You could use the following annotations to specify your test cases and setup/teardown functions.

**' @Test** - A test case function.

    ' @Test
    sub YourTestCaseName()
        ' access pre created data from setup function
        ? m.testinstance.testData
        
        result = DoSomeWork()
        UTF_assertNotInvalid(result)
    end sub

**' @BeforeAll** - A setup function that should be called before all test cases in suite.

    ' @BeforeAll
    sub ThisFunctionShouldBeCalledBeforeAllTestsInSuite()
        m.testData = {
            "test": "someValue"
        }
    end sub

**' @AfterAll** - A teardown function that should be called after all test cases in suite.

    ' @AfterAll
    sub ThisFunctionShouldBeCalledAfterAllTests()
        m.Delete("testData")
    end sub

**' @ParameterizedTest** - A parametrized test case. Should always be followed by **' @MethodSource("parametersProviderFunctionName")**. The parameter provider function should return an array of parameters. The parametrized test case will be called for each parameter individually.

    function stringProvider()
        return ["foo", "bar", 1, 0, {}]
    end function

    ' @ParameterizedTest
    ' @MethodSource("stringProvider")
    sub testWithSimpleMethodSource(argument = invalid as Dynamic)
        UTF_assertNotInvalid(argument)
    end sub

**' @RepeatedTest(count)** - A repeated test case. The test case will be called a 'count' times.

    ' @RepeatedTest(3)
    sub RepeatTestCase()
        result = DoSomeWork()
        UTF_assertNotInvalid(result)
    end sub

##	Example


Here is an example test suite. For more examples please check a 'samples' folder.

```
'*****************************************************************
'* Copyright Roku 2011-2018
'* All Rights Reserved
'*****************************************************************

'----------------------------------------------------------------
' This function called immediately before running tests of current suite.
' This function called to prepare all data for testing.
'----------------------------------------------------------------
' @BeforeAll
sub MainTestSuite__SetUp()
    ' Target testing object. To avoid the object creation in each test
    ' we create instance of target object here and use it in tests as m.targetTestObject.
    m.mainData  = GetApiArray()
end sub

'----------------------------------------------------------------
' This function called immediately after running tests of current suite.
' This function called to clean or remove all data for testing.
'----------------------------------------------------------------
' @AfterAll
sub MainTestSuite__TearDown()
    ' Remove all the test data
    m.Delete("mainData")
end sub

'----------------------------------------------------------------
' Check if data has an expected amount of items
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @Test
function TestCase__Main_CheckDataCount() as String
    return m.assertArrayCount(m.mainData, 15)
end function

'----------------------------------------------------------------
' Check if first item has mandatory attributes
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @Test 
function TestCase__Main_CheckItemAttributes() as String
    firstItem = m.mainData[0]

    mandatoryAttributes = ["url", "title", "hdposterurl"]

    return m.AssertAAHasKeys(firstItem, mandatoryAttributes)
end function

'----------------------------------------------------------------
' Check if stream format of the item is expected
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @Test
function TestCase__Main_CheckStreamFormatType() as String
    firstItem = m.mainData[0]

    return m.assertEqual(firstItem.streamFormat, "mp4")
end function

'----------------------------------------------------------------
' Generates invalid input object and pass it to function.
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @Test
function TestCase__Main_TestAddPrefixFunction__Failed() as String
    'Create scheme for item generator
    scheme = {
        key1  : "integer"
        key2  : "string"
        key3  : "boolean"
        key4  : {subKey1: "string"}
    }
    inputObject = ItemGenerator(scheme)

    'Pass generated item to your function
    result = AddPrefixToAAItems(inputObject)

    return m.assertNotInvalid(result, "Input data is invalid. All values should be strings.")
end function

'----------------------------------------------------------------
' Generates valid input object and pass it to function.
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @Test
function TestCase__Main_TestAddPrefixFunction__Passed() as string
    'Create scheme for item generator
    scheme = {
        key1  : "string"
        key2  : "string"
        key3  : "string"
        key4  : "string"
    }
    inputObject = ItemGenerator(scheme)

    'Pass generated item to your function
    result = AddPrefixToAAItems(inputObject)

    return m.assertNotInvalid(result, "Input data is invalid. All values should be strings.")
end function

function stringProvider()
    return ["foo", "bar", 1, 0, {}]
end function

'----------------------------------------------------------------
' Validate that input parameters are not invalid.
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @ParameterizedTest
' @MethodSource("stringProvider")
sub testWithSimpleMethodSource(argument = invalid as Dynamic)
    UTF_assertNotInvalid(argument)
end sub

'----------------------------------------------------------------
' Create row list 3 times and check it.
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
' @RepeatedTest(3)
sub NewApproach_CreateRowlistRepeatTest()
    rowList = CreateObject("roSGNode", "RowList")
    UTF_assertNotInvalid(rowlist.id)
end sub
```

### Test node example

Here is shown what a test node for "MyNode" may look like:

	<?xml version="1.0" encoding="UTF-8"?>
	<!--********** Copyright 2018 Roku Corp.  All Rights Reserved. **********-->

	<component name="Test__MyNode" extends="MyNode" xsi:noNamespaceSchemaLocation="https://devtools.web.roku.com/schema/RokuSceneGraph.xsd">

		<interface>
			<function name="TestFramework__RunNodeTests"/>
		</interface>

		<script type="text/brightscript" uri="pkg:/source/testFramework/UnitTestFramework.brs"/>

		<script type="text/brightscript" uri="pkg:/components/tests/Init.brs"/>
		<script type="text/brightscript" uri="pkg:/components/tests/Test__MyNode__TestSuite1.brs"/>
		<script type="text/brightscript" uri="pkg:/components/tests/Test__MyNode__TestSuite2.brs"/>

	</component>
