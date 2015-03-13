## @file Filing0TestCase.py
# @author weaves
# @brief Unittest of Filing0
#
# This is a unittest class that can perform some useful work.
# 
# @note
#
# Relatively complete test.

from __future__ import print_function
from Filing0 import Filing0
import os, sys, logging

from collections import Counter

import unittest

## A test driver for GMus0
#
# @see GMus0
class Filing0TestCase(unittest.TestCase):
    """
    Test Filing0
    """

    f0 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        logging.basicConfig(filename='Filing0.log', level=logging.DEBUG)
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup.
    # We use an environment variable. 
    def setUp(self):
        logging.info('setup {0}'.format(' '.join(sys.argv)) )
        logging.info('setup {0}'.format(os.environ['HOME']) )
        s = os.environ['ARGS']
        if s is None:
            s = 'exampleA_input.csv';
        logging.info('setup {0}'.format(s) )
        Filing0TestCase.f0 = Filing0(s)

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')

    ## Loaded?
    def test_00(self):
        self.assertIsNotNone(Filing0TestCase.f0)

    ## List.
    def test_01(self):
        self.assertIsNotNone(Filing0TestCase.f0._df)
        logging.info(Filing0TestCase.f0._df)
        return

    ## check next_num() pass a forced value for testing.
    def test_02(self):
        logging.info("r: {0}".format(Filing0TestCase.f0._df.count()) )
        return

# The sys.argv line will complain you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and not(sys.argv[0].endswith("ipython")):
        unittest.main()
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='Filing0TestCase',
                      verbosity=3, failfast=True, exit=False)
