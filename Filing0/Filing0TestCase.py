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
    s = 'exampleB_input.csv';

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
        logging.info('setup {0}'.format(os.environ['ARGS']) )
        try:
            self.s = os.environ['ARGS']
        except:
            pass
            
        logging.info('setup {0}'.format(self.s) )
        Filing0TestCase.f0 = Filing0(self.s)

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')

    ## Loaded?
    def test_00(self):
        self.assertIsNotNone(Filing0TestCase.f0)

    ## List.
    def test_01(self):
        self.assertIsNotNone(Filing0TestCase.f0._df)
        self.assertIsNotNone(Filing0TestCase.f0._dnames)
        logging.info(Filing0TestCase.f0._df)
        return

    ## Basic filter
    def test_02(self):
        logging.info("r: count: {0}".format(Filing0TestCase.f0._df.count()) )
        Filing0TestCase.f0.filter0(0)
        logging.info("r: minima: {0}".format(Filing0TestCase.f0._minima))
        logging.info("r: maxima: {0}".format(Filing0TestCase.f0._maxima))
        return

    ## Use the exclusion rule
    def test_03(self):
        Filing0TestCase.f0.filter0(1)
        Filing0TestCase.f0.exclude0()
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0.count()) )
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0) )
        return

    ## Use the exclusion rule and write to file.
    def test_04(self):
        Filing0TestCase.f0.filter0(1)
        Filing0TestCase.f0.exclude0()
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0.count()) )
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0) )
        s1 = self.s;
        s1 = s1.replace("input", "exclude")
        logging.info("df0: name: {0}".format(s1) )
        Filing0TestCase.f0._df0.to_csv(s1, index=False)
        return

    ## use the inclusion rule (and write)
    def test_05(self):
        Filing0TestCase.f0.filter0(1)
        Filing0TestCase.f0.include0()
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0.count()) )
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0) )
        s1 = self.s;
        s1 = s1.replace("input", "include")
        logging.info("df0: name: {0}".format(s1) )
        Filing0TestCase.f0._df0.to_csv(s1, index=False)
        return

    ## use the other inclusion rule (and write)
    def test_05(self):
        Filing0TestCase.f0.filter0(1)
        Filing0TestCase.f0.include1()
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0.count()) )
        logging.info("df0: count: {0}".format(Filing0TestCase.f0._df0) )
        s1 = self.s;
        s1 = s1.replace("input", "jnclude")
        logging.info("df0: name: {0}".format(s1) )
        Filing0TestCase.f0._df0.to_csv(s1, index=False)
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
