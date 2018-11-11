## @file Test1.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

from weaves import Singleton
from weaves import __Id__ as weavesId

import sys, logging, os
from unidecode import unidecode

from datetime import datetime, timezone, timedelta, date

from collections import Counter

import unittest

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for GMus0
#
# @see GMus0
class Test1(unittest.TestCase):
    """
    Test
    """

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_01(self):
        self.assertIsNotNone(weavesId)
        logger.info("module: Id: " + weavesId)
        return

    def test_05(self):
        s0 = Singleton.instance().dofy(datetime.today())
        logger.info("dofy: " + str(s0))
        return

    def test_05(self):
        """
        How to get a datetime that is an advance 
        """
        adv = 1.525
        s0 = Singleton.instance().dtadvance2(seconds=adv)
        logger.info("epoch: " + str(adv) + "; " + str(s0))
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
        unittest.main(module='Test1', verbosity=3, failfast=True, exit=False)
