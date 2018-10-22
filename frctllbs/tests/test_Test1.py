## @file Test1.py
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

from datetime import datetime, timezone, timedelta, date

from collections import Counter

from frctl import Stack

import unittest
from tests.test_Test import Test

## A test driver for GMus0
#
# @see GMus0
class Test1(Test):
    """
    Test MInfo1
    """

    ## Null setup. Create a new one.
    def setUp(self):
        super(Test1, self).setUp()
        return

    ## Null setup.
    def tearDown(self):
        self.logger.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a unittest.TestCasefilesystemencoding()
    def test_000(self):
        self.assertIsNotNone(self.test0)
        return

    def test_05(self):
        self.assertIsNotNone(self.test0)
        minfo = MInfo1(l0 = self.file0, delegate0 = "duration2")
        d = minfo.duration()
        self.logger.info("duration: " + d.isoformat())
        return
    
    def test_10(self):
        self.files = []
        for root, dirs, files in os.walk(self.dir0, topdown=True):
            for name in files:
                self.files.append(os.path.join(root, name))

        self.files.sort()
        if not type(self).files:
            type(self).files = type(self).files0
        self.file0, *self.files = self.files
        minfo = MInfo1(l0 = self.file0, delegate0 = "duration2")
        minfo.set_delegate("duration2")

        for f in self.files:
            self.logger.info("load: " + f)
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
