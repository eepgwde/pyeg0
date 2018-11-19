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
from pygraph.algorithms.filters.null import null

from pygraph.readwrite import dot

import sys, logging, os, math
from unidecode import unidecode

import unittest

import numpy as np

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

##

class attribute0(null):
    """
    Search for an attribute in a position.
    """

    mask = None
    target = None
    gr = None

    def __init__(self, gr, node, mask):
        super(attribute0, self).__init__()
        self.gr = gr
        self.target = node
        self.mask = mask
        logger.info("attribute0: ctr: mask: {}".format(self.mask))

    def __call__(self, node, parent):
        """
        Decide if the given node should be included in the search process.

        @type  node: node
        @param node: Given node.

        @type  parent: node
        @param parent: Given node's parent in the spanning tree.

        @rtype: boolean

        """
        # if node == self.target:
        #    return True

        a0 = VoteOps.instance().attribute0(self.gr, node)
        a1 = np.array(a0)
        m1 = np.array(self.mask)
        m2 = m1 * a1
        r0 = all(m2 == m1)
        logger.info("attribute0: call: node, parent: {} {}".format(node, parent))
        logger.info("attribute0: call: attributes: {} {} {}".format(a1, m1, m2))
        logger.info("attribute0: call: r0: {}".format(r0))
        return r0

##

class Test1(unittest.TestCase):
    """
    Test
    """

    ctr0 = 0
    ctr1 = 0

    def fname(self, stem0="g", ext0="dot"):
        return "{}{:02d}.{}".format(stem0, self.ctr1, ext0)

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        Test1.ctr0+=1
        self.ctr1 = Test1.ctr0
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
        Check dot
        """
        gr = VoteOps.instance().build(syms="AB", remap0=True)
        descr = dot.write(gr, weighted=False)
        logger.info("filename: {}".format(self.fname()))
        with open(self.fname(), "w") as file0:
            print(f"{descr}", file=file0)

    def test_13(self):
        """
        Check dot
        """
        gr = VoteOps.instance().build(syms="ABC", remap0=True)
        descr = dot.write(gr, weighted=False)
        with open(self.fname(), "w") as file0:
            print(f"{descr}", file=file0)

        node = next(iter(gr))
        mask = VoteOps.instance().mask(gr, node)
        logger.info("node: {}".format(mask))

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

        # from a given root
        st, lo = breadth_first_search(gr, root=root0, filter=radius(math.sqrt(2)))
        logger.info("types: st {}; lo: {}".format(type(st), type(lo)))
        logger.info("types: st {}; lo: {}".format(st, lo))

        # no root, until whole tree is spanned?
        st, lo = breadth_first_search(gr, filter=radius(math.sqrt(2)))
        logger.info("types: st {}; lo: {}".format(type(st), type(lo)))
        logger.info("types: st {}; lo: {}".format(st, lo))

    def test_15(self):
        gr = VoteOps.instance().build(syms="AB", remap0=True)
        self.assertIsNotNone(gr)
        root0 = next(iter(gr))
        logger.info("root0: {}".format(root0))
        mask = VoteOps.instance().mask(gr, root0)
        logger.info("mask: {}".format(mask))
        mask[0][0] = mask[1][0]
        logger.info("mask: {}".format(mask)[0])
        a0 = attribute0(gr, root0, mask[0])
        st, lo = breadth_first_search(gr, root=root0, filter=a0)
        logger.info("st: {}".format(st))
        logger.info("lo: {}".format(lo))

    def test_17(self):
        gr = VoteOps.instance().build(syms="ABC", remap0=True)
        self.assertIsNotNone(gr)
        root0 = next(iter(gr))
        logger.info("root0: {}".format(root0))
        mask = VoteOps.instance().mask(gr, root0)
        logger.info("mask: {}".format(mask))
        mask[0][0] = mask[1][0]
        logger.info("mask: {}".format(mask[0]))
        a0 = attribute0(gr, root0, mask[0])
        st, lo = breadth_first_search(gr, root=root0, filter=a0)
        logger.info("st: {}".format(st))
        logger.info("lo: {}".format(lo))


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
