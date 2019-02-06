import unittest
from sys import argv
from sys import exit

from test_functions import cleanup_check


if __name__ == '__main__':
    tests = unittest.TestSuite()

    def addTestModule(m):
        newtests = unittest.defaultTestLoader.loadTestsFromModule(m)
        tests.addTests(newtests)

    # add test modules here
    import first_time_setup
    addTestModule(first_time_setup)
    

    runner = unittest.TextTestRunner()
    result = runner.run(tests)
    print(result)
    # do final check after all tests have run
    cleanup_check()

    # if any tests failed, exit with code one
    if len(result.failures) != 0 or len(result.errors) != 0:
        exit(1)
