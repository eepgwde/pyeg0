## @file RandomGenTestCase.py
# @author weaves
# @brief Unittest of RandomGen
#
# This is a unittest class that can perform some useful work.
# 
# @note
#
# Relatively complete test.

from __future__ import print_function
from RandomGen import RandomGen
import sys, logging

from collections import Counter

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

    ## Null setup. Create a new one.
    def setUp(self):
        logging.info('setup')
        RandomGenTestCase.rndg = RandomGen(self.nums, self.freqs)

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')

    ## Loaded?
    def test_00(self):
        self.assertIsNotNone(RandomGenTestCase.rndg)

    ## List.
    def test_01(self):
        self.assertIsNotNone(RandomGenTestCase.rndg._random_nums)
        logging.info(RandomGenTestCase.rndg._random_nums)
        for i,v in enumerate(RandomGenTestCase.rndg._cum0):
            logging.info("i: {0} v: {1}".format(i, v))
        return

    ## check next_num() pass a forced value for testing.
    def test_02(self):
        logging.info("r: {0}".format(RandomGenTestCase.rndg.next_num()))
        logging.info(RandomGenTestCase.rndg.next_num(0.999))
        logging.info(RandomGenTestCase.rndg.next_num(0.001))
        return

    ## Changed order (because of enumerate)
    def test_03(self):
        logging.info(RandomGenTestCase.rndg.next_num(0.001))
        logging.info(RandomGenTestCase.rndg.next_num(0.999))
        logging.info("r: {0}".format(RandomGenTestCase.rndg.next_num()))
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
