## @file Test1.py
# @author weaves
# @brief Unittest of voting.
#
# This checks

from weaves import POSetOps
from pyvote import VoteOps


import sys, logging, os
from unidecode import unidecode

import unittest

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for voting
#
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
        """
        Basic object
        """
        x1 = VoteOps.instance().make(None, graph0=True)
        self.assertIsNotNone(x1)
        logger.info(type(x1))
        return

    def test_05(self):
        """
        Build
        """
        x1 = VoteOps.instance().build(syms="AB")
        self.assertIsNotNone(x1)
        logger.info(type(x1))
        logger.info("{};  {}; {}".format(x1.size(), x1.nodes(), x1.edges()))
        return

    def test_07(self):
        """
        Build
        """
        g1 = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(g1)
        logger.info(type(g1))
        logger.info("{};  {}; {}".format(g1.size(), g1.nodes(), g1.edges()))

        for n in g1.nodes():
            l0 = [x for x in g1[n]]
            logger.info("node: {} ; neighbours: {}".format(n, l0))

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
