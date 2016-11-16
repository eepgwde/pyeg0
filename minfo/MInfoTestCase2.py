## @file MInfoTestCase2.py
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
from datetime import datetime, timezone, timedelta, date

from collections import Counter

from MediaInfoDLL3 import MediaInfo
import os
from unidecode import unidecode

import unittest

logging.basicConfig(filename='minfo.log', level=logging.DEBUG)
logger = logging.getLogger('MInfoTestCase2')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for GMus0
#
# @see GMus0
class MInfoTestCase2(unittest.TestCase):
    """
    Test MInfo
    """
    dir0 = './media1'
    test0 = None
    gmus0 = None
    nums = [-1, 0, 1, 2, 3]
    files = []

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        for root, dirs, files in os.walk(cls.dir0, topdown=True):
            for name in files:
                cls.files.append(os.path.join(root, name))

        cls.files.sort()
        logger.info('files: ' + unidecode('; '.join(cls.files)))
        return
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        self.test0 = MInfo()
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Open one
    def test_00(self):
        self.assertIsNotNone(self.test0)
        self.test0.open(MInfoTestCase2.files[0])
        return

    ## Open two 
    def test_03(self):
        logger.info("test_03")
        self.assertIsNotNone(self.test0)
        self.test0.open(MInfoTestCase2.files[0])
        self.test0 = MInfo()
        self.test0.open(MInfoTestCase2.files[1])
        return

    ## Open two
    def test_04(self):
        logger.info("test_03")
        self.assertIsNotNone(self.test0)
        self.test0.open(MInfoTestCase2.files[0])
        self.test0.open(MInfoTestCase2.files[1])
        return

    def test_05(self):
        logger.info("test_05")
        self.assertIsNotNone(self.test0)
        for f in MInfoTestCase2.files:
            try:
                self.test0.open(f)
            except:
                raise
            
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
        unittest.main(module='MInfoTestCase2', verbosity=3, failfast=True, exit=False)
