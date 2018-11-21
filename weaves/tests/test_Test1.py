## @file Test1.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

from weaves import TimeOps
from weaves import POSetOps
from weaves import __Id__ as weavesId
import string

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

    N = 6
    ss = None

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        self.ss = map(lambda n: string.ascii_letters[0:n], range(1,self.N+1))
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
        s0 = TimeOps.instance().dofy(datetime.today())
        logger.info("dofy: " + str(s0))
        return

    def test_05(self):
        """
        How to get a datetime that is an advance 
        """
        adv = 1.525
        s0 = TimeOps.instance().dtadvance2(seconds=adv)
        logger.info("epoch: " + str(adv) + "; " + str(s0))
        return

    def test_11(self):
        """
        POSet Counts

        Check the Stirling second kind for partitions.
        """
        p0 = POSetOps.instance()
        logger.info("bell: {}".format(p0.unordered_Bell(3)))

        f0 = lambda n: (n, len(n),
                        p0.unordered_Bell(len(n)),
                        p0.partitions(set(n)) )
        x = f0(next(self.ss))
        logger.info("x: {}".format(x))

        for s in self.ss:
            n0 = p0.unordered_Bell(len(s))
            n1 = len(tuple(p0.partitions(set(s))))
            # self.assertEqual(n0, n1)
            logger.info("partitions: {}: {} == {}".format(len(s), n0, n1))

    def test_13(self):
        """
        POSet Counts

        Check the ordered bell count for weak orderings.
        """
        p0 = POSetOps.instance()
        logger.info("bell: {}".format(p0.ordered_Bell(3)))

        f0 = lambda n: (n, len(n),
                        p0.ordered_Bell(len(n)),
                        len(tuple(p0.weak_orderings(syms=n))) )
        x = f0(next(self.ss))
        logger.info("x: {}".format(x))

        for s in self.ss:
            n0 = p0.ordered_Bell(len(s))
            n1 = len(tuple(p0.weak_orderings(syms=s)))
            self.assertEqual(n0, n1)
            logger.info("ordered Bell: {}: {} == {}".format(len(s), n0, n1))

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
