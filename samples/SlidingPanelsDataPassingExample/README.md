1. Run import_unit_test_framework.bat or ./import_unit_test_framework.sh or
   place the UnitTestFramework.brs file to the testFramework folder manually.
2. Sideload the app to the box.
3. To run the tests POST the following command to the device via ECP: 
    http://{Roku_box_IP_address}:8060/launch/dev?RunTests=true

    For example: curl -d '' 'http://192.168.0.90:8060/launch/dev?RunTests=true'

Documentation: https://github.com/rokudev/unit-testing-framework