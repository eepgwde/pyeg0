## @file MInfoTestCase.py
# @author weaves
# @brief Unittest of MInfo
#
# This is a unittest class that can perform some useful work.
# 
# @note
#
# Relatively complete test.

from __future__ import print_function
from MInfo import MInfo
import sys, logging

from collections import Counter

from MediaInfoDLL3 import MediaInfo

import unittest

## A test driver for GMus0
#
# @see GMus0
class MInfoTestCase(unittest.TestCase):
    """
    Test MInfo
    """
    file0 = '01.The_best_is_yet_to_come.m4a'
    test0 = None
    gmus0 = None
    nums = [-1, 0, 1, 2, 3]

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        logging.basicConfig(filename='minfo.log', level=logging.DEBUG)
        return
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup. Create a new one.
    def setUp(self):
        logging.info('setup')
        MInfoTestCase.test0 = MInfo(self.file0)
        return

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')
        return

    ## Loaded?
    def test_00(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        return

    def test_01(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        str0 = MInfoTestCase.test0.info()
        logging.info(str0)
        return

    def test_02(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        str0 = MInfoTestCase.test0.duration()
        logging.info(str0)
        return

#
# The sys.argv line will complain you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and not(sys.argv[0].endswith("ipython")):
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='MInfoTestCase', verbosity=3, failfast=True, exit=False)
