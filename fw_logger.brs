'*****************************************************************
'* Copyright Roku 2011-2016
'* All Rights Reserved
'*****************************************************************

' Functions in this file:
'     Logger
'     Logger__Run
     
'----------------------------------------------------------------
' Main function. Create Logger object.
'
' @return A Logger object.
'----------------------------------------------------------------
Function Logger() as Object
    
    this = {}

    this.verbosityLevel = {
        basic   : 0
        normal  : 1
        verbose : 2   
    }

    ' Internal properties
    this.verbosity              = 1
    this.serverURL              = invalid
    
    ' Interface
    this.setVerbosity           = Logger__SetVerbosity
    this.setServerURL           = Logger__SetServerURL
    this.printStatistic         = Logger__PrintStatistic
    this.sendToServer           = Logger__SendToServer
    
    ' Internal functions
    this.printSuiteStatistic    = Logger__PrintSuiteStatistic
    this.printTestStatistic     = Logger__PrintTestStatistic
    this.printStart             = Logger__PrintStart
    this.printEnd               = Logger__PrintEnd
    this.printSuiteStart        = Logger__PrintSuiteStart
    this.printSuiteEnd          = Logger__PrintSuiteEnd
    this.printTestStart         = Logger__PrintTestStart
    this.printTestEnd           = Logger__PrintTestEnd
    
    return this
End Function

'----------------------------------------------------------------
' Set logging verbosity parameter.
' 
' @param verbosity (integer) A verbosity level.
' Posible values:
'     0 - basic
'     1 - normal
'     2 - verbose
' Default level: 1
'----------------------------------------------------------------
Sub Logger__SetVerbosity(verbosity = 1 as integer)
    if verbosity >= 0 and verbosity <= 2
        m.verbosity = verbosity
    end if
End Sub

'----------------------------------------------------------------
' Set storage server URL parameter.
' 
' @param url (string) A storage server URL.
' Default level: invalid
'----------------------------------------------------------------
Sub Logger__SetServerURL(url = invalid as string)
    if url <> invalid
        m.serverURL = url
    end if
End Sub

'----------------------------------------------------------------
' Set storage server URL parameter.
' 
' @param url (string) A storage server URL.
' Default level: invalid
'----------------------------------------------------------------
Sub Logger__SendToServer(statObj as object)
    if m.serverURL <> invalid
        ' Send log file to server
    end if
End Sub

'----------------------------------------------------------------
' Print statistic object with specified verbosity.
' 
' @param statObj (object) A statistic object to print.
'----------------------------------------------------------------
Sub Logger__PrintStatistic(statObj as object)
    
    m.printStart()
    
    if m.verbosity = m.verbosityLevel.normal
        for each testSuite in statObj.Suites
            for each testCase in testSuite.Tests
                ? "***   "; testSuite.Name; ": "; testCase.Name; " - "; testCase.Result
            end for
        end for
    else if m.verbosity = m.verbosityLevel.verbose
        for each testSuite in statObj.Suites
            m.printSuiteStatistic(testSuite)
        end for
    end if
    
    ? "***"
    ? "***   Total  = "; FW_AsString(statObj.Total); " ; Passed  = "; statObj.Correct; " ; Failed   = "; statObj.Fail; " ; Crashes  = "; statObj.Crash;
    ? " Time spent: "; statObj.Time; "ms"
    ? "***"
    
    m.printEnd()
    
End Sub

'----------------------------------------------------------------
' Print test suite statistic.
' 
' @param statSuiteObj (object) A target test suite object to print.
'----------------------------------------------------------------
Sub Logger__PrintSuiteStatistic(statSuiteObj as object)
    
    m.printSuiteStart(statSuiteObj.Name)
    
    for each testCase in statSuiteObj.Tests
        m.printTestStatistic(testCase)
    end for
    
    ? "==="
    ? "===   Total  = "; FW_AsString(statSuiteObj.Total); " ; Passed  = "; statSuiteObj.Correct; " ; Failed   = "; statSuiteObj.Fail; " ; Crashes  = "; statSuiteObj.Crash;
    ? " Time spent: "; statSuiteObj.Time; "ms"
    ? "==="
    
    m.printSuiteEnd(statSuiteObj.Name)
    
End Sub

'----------------------------------------------------------------
' Print test statistic.
' 
' @param statTestObj (object) A target test object to print.
'----------------------------------------------------------------
Sub Logger__PrintTestStatistic(statTestObj as object)
    
    m.printTestStart(statTestObj.Name)
    
    ? "---   Result:        "; statTestObj.Result
    ? "---   Time:          "; statTestObj.Time
    
    if LCase(statTestObj.Result) <> "success"
        ? "---   Error Code:    "; statTestObj.Error.Code
        ? "---   Error Message: "; statTestObj.Error.Message
    end if
    
    m.printTestEnd(statTestObj.Name)
    
End Sub

'----------------------------------------------------------------
' Print testting start message.
'----------------------------------------------------------------
Sub Logger__PrintStart()
    ? ""
    ? "******************************************************************"
    ? "******************************************************************"
    ? "*************            Start testing               *************"
    ? "******************************************************************"
End Sub

'----------------------------------------------------------------
' Print testing end message.
'----------------------------------------------------------------
Sub Logger__PrintEnd()
    ? "******************************************************************"
    ? "*************             End testing                *************"
    ? "******************************************************************"
    ? "******************************************************************"
    ? ""
End Sub

'----------------------------------------------------------------
' Print test suite start message.
'----------------------------------------------------------------
Sub Logger__PrintSuiteStart(sName as String)
    ? "================================================================="
    ? "===   Start "; sName; " suite:"
    ? "==="
End Sub

'----------------------------------------------------------------
' Print test suite end message.
'----------------------------------------------------------------
Sub Logger__PrintSuiteEnd(sName as String)
    ? "==="
    ? "===   End "; sName; " suite."
    ? "================================================================="
End Sub

'----------------------------------------------------------------
' Print test start message.
'----------------------------------------------------------------
Sub Logger__PrintTestStart(tName as String)
    ? "----------------------------------------------------------------"
    ? "---   Start "; tName; " test:"
    ? "---"
End Sub

'----------------------------------------------------------------
' Print test end message.
'----------------------------------------------------------------
Sub Logger__PrintTestEnd(tName as String)
    ? "---"
    ? "---   End "; tName; " test."
    ? "----------------------------------------------------------------"
End Sub