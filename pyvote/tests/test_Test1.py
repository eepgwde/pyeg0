## @file Test1.py
# @author weaves
# @brief Unittest of voting.
#
# This checks

from weaves import POSetOps
from pyvote import VoteOps

from pygraph.algorithms.searching import depth_first_search, breadth_first_search
from pygraph.classes.graph import graph

from pygraph.algorithms.filters.radius import radius
from pygraph.algorithms.filters.find import find

import sys, logging, os, math
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
        Build graph
        """
        g1 = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(g1)
        logger.info(type(g1))
        logger.info("{};  {}; {}".format(g1.size(), g1.nodes(), g1.edges()))

        for n in g1.nodes():
            l0 = [x for x in g1[n]]
            logger.info("node: {} ; neighbours: {}".format(n, l0))

    def test_09(self):
        """
        Check node attributes
        """
        g1 = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(g1)
        logger.info(type(g1))
        logger.info("{};  {}; {}".format(g1.size(), g1.nodes(), g1.edges()))

        for n in g1.nodes():
            l0 = g1.node_attributes(n)
            logger.info("node: {} ; attributes: {}".format(n, l0))

    def test_11(self):
        """
        Check edge attributes
        """
        g1 = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(g1)
        logger.info(type(g1))
        logger.info("{};  {}; {}".format(g1.size(), g1.nodes(), g1.edges()))

        for n in g1.edges():
            l0 = g1.edge_attributes(n)
            logger.info("edge: {} ; attributes: {}".format(n, l0))

    def test_11(self):
        """
        Check edge attributes
        """
        g1 = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(g1)

    def test_bfs_in_empty_graph(self):
        gr = graph()
        st, lo = breadth_first_search(gr, filter=find(5))
        assert st == {}
        assert lo == []

    def test_bfs_in_digraph(self):
        gr = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(gr)
        root0 = next(iter(gr))
        logger.info("root0: {}".format(root0))

        st, lo = breadth_first_search(gr, root=root0, filter=radius(math.sqrt(2)))
        logger.info("types: st {}; lo: {}".format(type(st), type(lo)))
        logger.info("types: st {}; lo: {}".format(st, lo))
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
