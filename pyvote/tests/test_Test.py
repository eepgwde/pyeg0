## @file Test.py
# @author weaves
# @brief Unittest of pyvote
#
# This checks the linkage with POSetOps
# Use of the graphT0 

import sys, logging, os
from unidecode import unidecode

from weaves import POSetOps
from pyvote import VoteOps

from pygraph.classes.digraph import digraph

import unittest

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for py3vote
#
class Test(unittest.TestCase):
    """
    Test MInfo
    """
    test0 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        pass
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

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
    def test_000(self):
        s0 = POSetOps.instance().strong("ABC")
        logger.info(str(s0))
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_000(self):
        s0 = POSetOps.instance().strong("ABC")
        logger.info(str(s0))
        return

    def test_002(self):
        x0 = POSetOps.instance().adjacency('ABC')
        logger.info("dict: {}".format(x0['m']))
        nodes = tuple(x0['n'])
        logger.info("nodes: {} {}".format(len(nodes), nodes))
        edges = tuple(x0['e'])
        logger.info("edges: {} {}".format(len(edges), edges))
        self.x0 = x0

    def test_004(self):
        self.test_002()
        x1 = POSetOps.instance().remap(adjacency0=self.x0)
        nodes = tuple(x1['nodes'].values())
        logger.info("nodes: {} {}".format(len(nodes), nodes))
        edges = tuple(x1['edges'])
        logger.info("edges: {} {}".format(len(edges), edges))

    def test_006(self):
        # self.test_002()
        g0 = digraph()
        # g0.size()
        logger.info("digraph: {}".format(type(g0)))

        x1 = VoteOps.instance().make(None, graph0=True)

        logger.info("graphT0: {}".format(type(x1)))
        logger.info("graphT0: {}".format(x1.size()))

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
        unittest.main(module='Test', verbosity=3, failfast=True, exit=False)
