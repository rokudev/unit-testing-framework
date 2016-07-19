'*****************************************************************
'* Copyright Roku 2011-2016
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'     TestRunner
'     TestRunner__Run
'     TestRunner__SetTestsDirectory
'     TestRunner__SetTestFilePrefix
'     TestRunner__SetTestSuitePrefix
'     TestRunner__SetTestSuiteName
'     TestRunner__SetTestCaseName
'     TestRunner__GetTestSuitesList
'     TestRunner__GetTestFilesList
'     TestRunner__CreateTotalStatistic
'     TestRunner__CreateSuiteStatistic
'     TestRunner__CreateTestStatistic
'     TestRunner__AppendTestStatistic
'     TestRunner__AppendSuiteStatistic
     
'----------------------------------------------------------------
' Main function. Create TestRunner object.
'
' @return A TestRunner object.
'----------------------------------------------------------------
Function TestRunner() as Object
    
    this = {}

    this.verbosityLevel = {
        basic   : 0
        normal  : 1
        verbose : 2   
    }

    this.errorCodes = {
        ERR_NORMAL_END          : &hFC
        ERR_VALUE_RETURN        : &hE2
        ERR_USE_OF_UNINIT_VAR   : &hE9
        ERR_DIV_ZERO            : &h14
        ERR_TM                  : &h18
        ERR_RO2                 : &hF4
        ERR_RO4                 : &hEC
        ERR_SYNTAX              : 2
        ERR_WRONG_NUM_PARAM     : &hF1
    }
    
    this.logger = Logger()
    
    ' Internal properties
    this.testsDirectory         = "pkg:/source/tests"
    this.testFilePrefix         = "Test__"
    this.testSuitePrefix        = "TestSuite__"
    this.testSuiteName          = ""
    this.testCaseName           = ""

    ' Interface
    this.Run                    = TestRunner__Run
    this.setTestsDirectory      = TestRunner__SetTestsDirectory
    this.setTestFilePrefix      = TestRunner__SetTestFilePrefix
    this.setTestSuitePrefix     = TestRunner__SetTestSuitePrefix
    this.setTestSuiteName       = TestRunner__SetTestSuiteName
    this.setTestCaseName        = TestRunner__SetTestCaseName
    
    ' Internal functions
    this.getTestFilesList       = TestRunner__GetTestFilesList
    this.getTestSuitesList      = TestRunner__GetTestSuitesList
    this.createTotalStatistic   = TestRunner__CreateTotalStatistic
    this.createSuiteStatistic   = TestRunner__CreateSuiteStatistic
    this.createTestStatistic    = TestRunner__CreateTestStatistic
    this.appendSuiteStatistic   = TestRunner__AppendSuiteStatistic
    this.appendTestStatistic    = TestRunner__AppendTestStatistic
    
    return this
End Function

'----------------------------------------------------------------
' Run main test loop.
'----------------------------------------------------------------
Sub TestRunner__Run()
    
    alltestCount = 0
    totalStatObj = m.createTotalStatistic()
    testSuitesList = m.getTestSuitesList()
    
    for each testSuite in testSuitesList
        
        testCases = testSuite.testCases
        testCount = testCases.Count()
        alltestCount = alltestCount + testCount
        
        suiteStatObj = m.createSuiteStatistic(testSuite.Name)

        if FW_IsFunction(testSuite.SetUp) then
            testSuite.SetUp()
        end if
        
        for each testCase in testCases
            
            if FW_IsNullOrEmpty(m.testCaseName) or (not FW_IsNullOrEmpty(m.testCaseName) and LCase(testCase.Name) = LCase(m.testCaseName))
            
                testTimer = CreateObject("roTimespan")
                testStatObj = m.createTestStatistic(testCase.Name)
                testSuite.testCase = testCase.Func
                'evalResult = eval("runResult = testSuite.testCase()")
                runResult = testSuite.testCase()
                
                'if evalResult <> m.errorCodes.ERR_NORMAL_END
                '    testStatObj.Result          = "Crash"
                '    testStatObj.Error.Code      = evalResult
                '    testStatObj.Error.Message   = "Test crashed."
                'else 
                if runResult <> ""
                    testStatObj.Result          = "Fail"
                    testStatObj.Error.Code      = 1'evalResult
                    testStatObj.Error.Message   = runResult
                else
                    testStatObj.Result          = "Success"
                end if
                
                testStatObj.Time = testTimer.TotalMilliseconds()
                m.appendTestStatistic(suiteStatObj, testStatObj)
            end if
            
        end for

        if FW_IsFunction(testSuite.TearDown) then
            testSuite.TearDown()
        end if
        
        m.appendSuiteStatistic(totalStatObj, suiteStatObj)
        
    end for
    
    m.logger.printStatistic(totalStatObj)
    
End Sub

'----------------------------------------------------------------
' Set testsDirectory property.
'----------------------------------------------------------------
Sub TestRunner__SetTestsDirectory(testsDirectory as string)
    if testsDirectory <> invalid
        m.testsDirectory = testsDirectory
    end if
End Sub

'----------------------------------------------------------------
' Set setTestFilePrefix property.
'----------------------------------------------------------------
Sub TestRunner__SetTestFilePrefix(setTestFilePrefix as string)
    if setTestFilePrefix <> invalid
        m.setTestFilePrefix = setTestFilePrefix
    end if
End Sub

'----------------------------------------------------------------
' Set testSuitePrefix property.
'----------------------------------------------------------------
Sub TestRunner__SetTestSuitePrefix(testSuitePrefix as string)
    if testSuitePrefix <> invalid
        m.testSuitePrefix = testSuitePrefix
    end if
End Sub

'----------------------------------------------------------------
' Set testSuiteName property.
'----------------------------------------------------------------
Sub TestRunner__SetTestSuiteName(testSuiteName as string)
    if testSuiteName <> invalid
        m.testSuiteName = testSuiteName
    end if
End Sub

'----------------------------------------------------------------
' Set testCaseName property.
'----------------------------------------------------------------
Sub TestRunner__SetTestCaseName(testCaseName as string)
    if testCaseName <> invalid
        m.testCaseName = testCaseName
    end if
End Sub

'----------------------------------------------------------------
' Scan all test files for test suites.
'
' @return An array of test suites.
'----------------------------------------------------------------
Function TestRunner__GetTestSuitesList() as Object
    
    result = []
    testSuiteRegex = CreateObject("roRegex", "^(function|sub)\s(" + m.testSuitePrefix + m.testSuiteName + "[0-9a-z\_]*)\s*\(", "i")
    testFilesList = m.getTestFilesList()

    for each filePath in testFilesList
        code = FW_AsString(ReadAsciiFile(filePath))

        if code <> "" then
            for each line in code.Tokenize(chr(10))
                
                line.Trim()

                if testSuiteRegex.IsMatch(line) then
                    testSuite = invalid
                    functionName = testSuiteRegex.Match(line).Peek()
                    
                    eval("testSuite=" + functionName + "()")
                    
                    if FW_IsAssociativeArray(testSuite) then
                        result.Push(testSuite)
                    end if
                end if
            end for
        end if
    end for

    return result
End Function

'----------------------------------------------------------------
' Scan testsDirectory and all subdirectories for test files.
'
' @param testsDirectory (string) A target directory with test files.
'
' @return An array of test files.
'----------------------------------------------------------------
Function TestRunner__GetTestFilesList(testsDirectory = m.testsDirectory as String) as Object
    
    result = []

    testsFileRegex = CreateObject("roRegex", "^(" + m.testFilePrefix + ")[0-9a-z\_]*\.brs$", "i")

    if testsDirectory <> "" then
        
        fileSystem = CreateObject("roFileSystem")
        listing = fileSystem.GetDirectoryListing(testsDirectory)
        
        for each item in listing
            itemPath = testsDirectory + "/" + item
            itemStat = fileSystem.Stat(itemPath)
            
            if itemStat.type = "directory" then
                result.Append(m.getTestFilesList(itemPath))
            else if testsFileRegex.IsMatch(item) then
                result.Push(itemPath)
            end if
        end for
        
    end if
    
    return result
End Function

'----------------------------------------------------------------
' Create an empty statistic object for totals in output log.
'
' @return An empty statistic object.
'----------------------------------------------------------------
Function TestRunner__CreateTotalStatistic() as object

    statTotalItem = {
        Suites      : []
        Time        : 0
        Total       : 0
        Correct     : 0
        Fail        : 0
        Crash       : 0
    }

    return statTotalItem
End Function

'----------------------------------------------------------------
' Create an empty statistic object for test suite with specified name.
'
' @param name (string) A test suite name for statistic object.
'
' @return An empty statistic object for test suite.
'----------------------------------------------------------------
Function TestRunner__CreateSuiteStatistic(name as string) as object

    statSuiteItem = {
        Name    : name
        Tests   : []
        Time    : 0
        Total   : 0
        Correct : 0
        Fail    : 0
        Crash   : 0
    }

    return statSuiteItem
End Function

'----------------------------------------------------------------
' Create statistic object for test with specified name.
' 
' @param name (string) A test name.
' @param result (string) A result of test running.
' Posible values: "Success", "Fail".
' Default value: "Success"
' @param time (integer) A test running time.
' Default value: 0
' @param errorCode (integer) An error code for failed test.
' Posible values:
'     252 (&hFC) : ERR_NORMAL_END
'     226 (&hE2) : ERR_VALUE_RETURN
'     233 (&hE9) : ERR_USE_OF_UNINIT_VAR
'     020 (&h14) : ERR_DIV_ZERO
'     024 (&h18) : ERR_TM
'     244 (&hF4) : ERR_RO2
'     236 (&hEC) : ERR_RO4
'     002 (&h02) : ERR_SYNTAX
'     241 (&hF1) : ERR_WRONG_NUM_PARAM
' Default value: 0
' @param errorMessage (string) An error message for failed test.
' 
' @return A statistic object for test.
'----------------------------------------------------------------
Function TestRunner__CreateTestStatistic(name as string, result = "Success" as string, time = 0 as integer, errorCode = 0 as integer, errorMessage = "" as string) as object

    statTestItem = {
        Name    : name
        Result  : result
        Time    : time
        Error   : {
            Code    : errorCode
            Message : errorMessage
        }
    }

    return statTestItem
End Function

'----------------------------------------------------------------
' Append test statistic to test suite statistic.
' 
' @param statSuiteObj (object) A target test suite object.
' @param statTestObj (object) A test statistic to append.
'----------------------------------------------------------------
Sub TestRunner__AppendTestStatistic(statSuiteObj as object, statTestObj as object)
        
    if FW_IsAssociativeArray(statSuiteObj) and FW_IsAssociativeArray(statTestObj)
        
        statSuiteObj.Tests.Push(statTestObj)
        
        if FW_IsInteger(statTestObj.time)  
            statSuiteObj.Time = statSuiteObj.Time + statTestObj.Time
        end if
        
        statSuiteObj.Total = statSuiteObj.Total + 1
        
        if lCase(statTestObj.Result) = "success"
            statSuiteObj.Correct = statSuiteObj.Correct + 1
        else if lCase(statTestObj.result) = "fail"
            statSuiteObj.Fail = statSuiteObj.Fail + 1
        else
            statSuiteObj.crash = statSuiteObj.crash + 1
        end if
        
    end if
    
End Sub

'----------------------------------------------------------------
' Append suite statistic to total statistic object.
' 
' @param statTotalObj (object) A target total statistic object.
' @param statSuiteObj (object) A test suite statistic object to append.
'----------------------------------------------------------------
Sub TestRunner__AppendSuiteStatistic(statTotalObj as object, statSuiteObj as object)
    
    if FW_IsAssociativeArray(statTotalObj) and FW_IsAssociativeArray(statSuiteObj)
    
        statTotalObj.Suites.Push(statSuiteObj)
        statTotalObj.Time = statTotalObj.Time + statSuiteObj.Time
        
        if FW_IsInteger(statSuiteObj.Total)  
            statTotalObj.Total = statTotalObj.Total + statSuiteObj.Total
        end if
        
        if FW_IsInteger(statSuiteObj.Correct)
            statTotalObj.Correct = statTotalObj.Correct + statSuiteObj.Correct
        end if
        
        if FW_IsInteger(statSuiteObj.Fail)
            statTotalObj.Fail = statTotalObj.Fail + statSuiteObj.Fail
        end if
        
        if FW_IsInteger(statSuiteObj.Crash)
            statTotalObj.Crash = statTotalObj.Crash + statSuiteObj.Crash
        end if
        
    end if
    
End Sub