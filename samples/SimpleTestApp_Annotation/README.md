1. Run import_unit_test_framework.bat or ./import_unit_test_framework.sh or
   place the UnitTestFramework.brs file to the testFramework folder manually.
2. Sideload the app to the box.
3. To run the tests POST the following command to the device via ECP: 
    http://{Roku_box_IP_address}:8060/launch/dev?RunTests=true

    For example: curl -d '' 'http://192.168.0.90:8060/launch/dev?RunTests=true'

Documentation: https://github.com/rokudev/unit-testing-framework

## Overview
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