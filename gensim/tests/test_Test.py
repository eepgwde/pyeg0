## @file Test.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

import sys, logging, os
from unidecode import unidecode

import unittest

from helper import CorpOps

logging.basicConfig(filename='test.log', level=logging.DEBUG)
LOGGER = logging.getLogger('Test')
SH = logging.StreamHandler()
LOGGER.addHandler(SH)

## A test driver 
#
# @see GMus0
class Test(unittest.TestCase):
    """
    Test
    """
    test0 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        pass
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup. Create a new one.
    def setUp(self):
        LOGGER.info('setup')
        return

    ## Null setup.
    def tearDown(self):
        LOGGER.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_000(self):

        return

#
# The sys.argv line will complain to you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and "ipython" not in sys.argv[0]:
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='Test', verbosity=3, failfast=True, exit=False)
