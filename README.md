# Unit Testing Framework
A tool for automating test suites for Roku channels.

### Scope
The following framework allows developers to run unit tests and collect channel errors.

#### Current Implementation
Current implementation consists of Test Runner which collects all test cases and run them one by one, Base Test Suite contains assertion methods and Item Generator which allows to create different objects by given scheme.

#### Overview 
The Test Runner collects all test suites with their test cases under the given directory. When all test cases are collected, the Test Runner runs them one by one and collects the results. After running all the test cases Test Runner outputs the statistic log with selected level of verbosity. 

Every test suite must extend BaseTestSuite and must contain at least one test case.

* For the full instructions, please refer to the [Instructions](https://github.com/rokudev/unit-testing-framework/blob/master/docs/unit-test-framework.md)
* Please send pull requests and feedback to us in this repo. 

#### Annotation approach
This is a project to show new approach in building unit tests functions.

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

#### Local build and run

* clone project and cd to it.
* build a framework, by using: `./build.sh` or `build.bat`
* import built framework to any sample you want (please use `samples` directory)
* run `import_unit_test_framework.bat` or `./import_unit_test_framework.sh` or
place the UnitTestFramework.brs file to the testFramework folder manually.
* please use README.MD from `samples` directory.

_Thanks for building on the Roku Platform!_
