## @file RandomGenTestCase.py
# @author weaves
# @brief Unittest of GMus0: removes older duplicates
#
# This is a unittest class that can perform some useful work.
# 
# Objects of GMus0 are used to load the songs data.
#
# @note
# Python modules are imported wholesale with the import name
# matching the file name. (And you can use a directory.filename). But
# if you want the class within the module, you need to use the from
# file import class.

from __future__ import print_function
from RandomGen import RandomGen
import sys, logging

from collections import Counter

import random
import unittest

## A test driver for GMus0
#
# @see GMus0
class RandomGenTestCase(unittest.TestCase):
    """
    Test RandomGen
    """
    rndg = None
    gmus0 = None
    nums = [-1, 0, 1, 2, 3]
    freqs = [0.01, 0.3, 0.58, 0.1, 0.01]

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        logging.basicConfig(filename='gmus.log', level=logging.DEBUG)
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup.
    def setUp(self):
        logging.info('setup')
        RandomGenTestCase.rndg = RandomGen(self.nums, self.freqs)

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')

    ## Load.
    def test_00(self):
        self.assertIsNotNone(RandomGenTestCase.rndg)

    ## List.
    def test_01(self):
        self.assertIsNotNone(RandomGenTestCase.rndg._random_nums)
        logging.info(RandomGenTestCase.rndg._random_nums)
        for i,v in enumerate(RandomGenTestCase.rndg._cum0):
            logging.info("i: {0} v: {1}".format(i, v))
        return

    ## Check that artist is BBC Radio
    # Show that the data-frame is a dynamic property based on s0.
    def test_02(self):
        logging.info(RandomGenTestCase.rndg.next_num())
        logging.info(RandomGenTestCase.rndg.next_num(0.999))
        logging.info(RandomGenTestCase.rndg.next_num(0.001))
        return

# The sys.argv line will complain you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and not(sys.argv[0].endswith("ipython")):
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='RandomGenTestCase', verbosity=3, failfast=True, exit=False)
