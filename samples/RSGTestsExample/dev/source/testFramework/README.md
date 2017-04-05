1. Run import_unit_test_framework.bat or ./import_unit_test_framework.sh or
   place the UnitTestFramework.brs file to the testFramework folder manually.
2. Sideload the app to the box.
3. To run the tests, issue the following ECP command:
	curl -d '' 'http://{Roku Device IP Address}:8060/launch/dev?RunTests=true'

Documentation: https://github.com/rokudev/unit-testing-framework