# **Roku Unit Testing Framework**
> 01.24.2019

## v.2.0.1

### Bug Fixes

 * Fix bug with scene node verification.
 * Minor bug-fixes and updates.

## v.2.0.0

### Features
 * Major Version Update: NOT Backward compatible!
 * Add environment object to each test suite, so each test suite will have it's own m. 
 * Remove need for test suite constructor function
 * Add BeforeALL, BeforeEach, AfterAll, AfterEach and other JUnit5-like annotations.
 * Add new assert functions
 * Update test suite parsing mechanism (removed eval usage)
 * Add annotation @Test
 * Add don't throw exception for empty test suites: PR #31
 * Add AssertAAContains: PR #26
 * Add SetServer and SendToServer: PR #25

### Bug Fixes

 * Fix crash when testStatObj is undefined because of no test valid test cases
 * FIx Exception when testStatObj is uninitialized
 * Minor bug-fixes and updates.

## v.1.3.0

### Features
 * Add Setup and TearDown functions description (#10)
 * Add StorePerformanceData function. (allows to store and print some performance data from your test cases)

### Bug Fixes
 * Fix SetTestFilePrefix input parameter name #19
 * Update step 3 in Readme.md with proper description for channel samples. #5

## v.1.2.2

### Bug Fixes

 * Add a way to skip tests in the BrightScript Unit Test framework
 * fix EqValues method of BaseTestSuite for arrays. #18 proposed by michallaskowski

## v.1.2.1

### Features
 * added Support of Roku Scene Graph (RSG).
 * added documentation on how to write tests for components.
 * added simple RSG sample channel with tests examples.
 * added additional verbosity level in logger: issue #8
 * added custom comparator functionality for pull request #15)
 * changed naming of utility functions for better consistency and compatibility with other frameworks.

### Bug Fixes
 * fixed issues related to comparison asserts: issue #9
 * fixed mistyping.
 * fixed typo. (pull request #14)

## v.1.1.0

### Features
 * added missing dependencies.
 * packaged framework to single file.
 * added framework versioning.
 * added log messages for Setup/TearDown functions run. Messages will be shown in Verbose logging mode only.
 * added SetUp/TearDown functions support for TestCase objects.
 * added new logger mode "Echo". This mode print statistics for each TestSuite/TestCase when they actually run. Echo use logger verbosity settings and will show full info in Verbose mode only.
 * added new failFast parameter to runner.

## v.1.0.0

### Features
 * initial release.
