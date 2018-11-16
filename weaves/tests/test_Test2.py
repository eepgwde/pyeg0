## @file Test2.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

from weaves import POSetOps
from weaves.preferences import Pair0, Prefer0, NoPrefer0

import sys, logging, os

import unittest

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for POSetOps
class Test2(unittest.TestCase):
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
        s0 = POSetOps.instance().strong("")
        logger.info("strong: " + str(s0))
        return

    def test_03(self):
        s0 = POSetOps.instance().strong("ABCD")
        logger.info("strong: " + str(s0))
        return

    def test_05(self):
        """
        Preferences
        """
        with self.assertRaises(ValueError) as context:
            Pair0('A', 'A')
        self.assertIs(type(context.exception),ValueError) 

        with self.assertRaises(ValueError) as context:
            Pair0('A', '')
        self.assertIs(type(context.exception),ValueError) 

        with self.assertRaises(ValueError) as context:
            Pair0('', 'B')
        self.assertIs(type(context.exception),ValueError) 

        r0 = Pair0('A', 'B')
        with self.assertRaises(ValueError) as context:
            Pair0(r0, r0)
        self.assertIs(type(context.exception),ValueError) 

        r0 = Pair0('A', 'B')
        r1 = Pair0('A', 'B')
        with self.assertRaises(ValueError) as context:
            Pair0(r0, r1)
        self.assertIs(type(context.exception),ValueError) 

        return

    def test_07(self):
        """
        Preferences
        """
        r0 = Pair0('A', 'B')
        p1 = Prefer0('A', 'B')
        np1 = NoPrefer0('A', 'B')
        self.assertTrue(p1 == np1)
        self.assertFalse(p1 != np1)

        self.assertFalse(p1.isKindOf(np1))
        self.assertTrue(p1.isKindOf(p1))

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
        unittest.main(module='Test2', verbosity=3, failfast=True, exit=False)
