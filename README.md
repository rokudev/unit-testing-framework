# Unit Testing Framework (BETA)
A beta tool for automating test suites for Roku channels.

### Scope
The following beta framework allows developers to run unit tests and collect channel errors.

#### Current Implementation
Current implementation consists of Test Runner which collects all test cases and run them one by one, Base Test Suite contains assertion methods and Item Generator which allows to create different objects by given scheme.

#### Overview 
The Test Runner collects all test suites with their test cases under the given directory. When all test cases are collected, the Test Runner runs them one by one and collects the results. After running all the test cases Test Runner outputs the statistic log with selected level of verbosity. 

Every test suite must extend BaseTestSuite and must contain at least one test case.

* For the full instructions, please refer to the [Instructions](https://github.com/rokudev/unit-testing-framework/blob/master/docs/unit-test-framework.md)
* Please send pull requests and feedback to us in this repo. 

_Thanks for building on the Roku Platform!_
