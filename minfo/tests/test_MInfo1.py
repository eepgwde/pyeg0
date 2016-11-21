## @file Test1.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

from minfo import MInfo1
import sys, logging, os
from unidecode import unidecode

from datetime import datetime, timezone, timedelta, date

from collections import Counter

from MediaInfoDLL3 import MediaInfo

import unittest
from test_MInfo import Test

logging.basicConfig(filename='minfo.log', level=logging.DEBUG)
logger = logging.getLogger('Test1')
sh = logging.StreamHandler()
logger.addHandler(sh)

media0 = os.path.join(os.path.dirname(__file__), "media")

## A test driver for GMus0
#
# @see GMus0
class Test1(Test):
    """
    Test MInfo1
    """

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        self.file0, *type(self).files = type(self).files
        self.test0 = MInfo1(l0 = self.file0)
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_000(self):
        self.assertIsNotNone(self.test0)
        self.test0.open(self.file0)
        return

    def test_05(self):
        self.assertIsNotNone(self.test0)
        minfo = self.test0
        d = minfo.duration()
        logger.info("duration: " + d.isoformat())
        return
    
    def test_10(self):
        self.files = []
        for root, dirs, files in os.walk(self.dir0, topdown=True):
            for name in files:
                self.files.append(os.path.join(root, name))

        self.files.sort()
        self.file0, *self.files = self.files
        minfo = MInfo1(l0 = self.file0)
        minfo.set_delegate("duration2")

        for f in self.files:
            logger.info("load: " + f)
            x0 = minfo.next(f)
            logging.info("duration: cum: " + type(x0).__name__ +
                         "; " + "; ".join(x0))

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
        unittest.main(module='Test1', verbosity=3, failfast=True, exit=False)
