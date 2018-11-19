## @file Vote.py
# @brief Voting systems
# @author weaves
#
# @details
# This creates voting systems.
#
# @note
# 

import logging

import scipy.special as scis
from functools import partial
from itertools import permutations, combinations, chain
import string
from pygraph.algorithms.accessibility import accessibility, mutual_accessibility
from pygraph.classes.digraph import digraph

from math import sqrt

# from py3votecore.plurality import PluralityAtLarge
# from py3votecore.stv import STV, Quota
# from py3votecore.schulze_by_graph import SchulzeMethodByGraph, SchulzeNPRByGraph

from weaves import POSetOps

# logging.basicConfig(filename='Vote.log', level=logging.DEBUG)
logger = logging.getLogger('Vote')
# sh = logging.StreamHandler()
# logger.addHandler(sh)

class graphT0(digraph):
    def __init__(self):
        """
        Initialize a digraph.
        """
        super(graphT0, self).__init__()

    def faces(self, k=2):
        return []

    def size(self, fmt0=None):
        """graph"""
        return [ len(self.nodes()), len(self.edges()), len(self.faces(k=2)) ]

class _Impl(object):
    """
    Graph and votes methods.
    """
    _logger = logging.getLogger('weaves')

    _tions = None

    def __init__(self, **kwargs):
        self._tions = lambda xs, n: permutations(xs, n)
        pass

    def make(self, type0, graph0=None):
        if not graph0 is None:
            return graphT0()
        return None

    def attribute0(self, gr, node, tag0='struct'):
        a0 = gr.node_attributes(node)
        s0 = next(filter(lambda x: x[0] == tag0, a0))
        return (s0[1])[0]

    def mask(self, gr, node):
        a0 = self.attribute0(gr, node)
        return [ [ 0 for x in a0 ], a0 ]

    def build(self, syms='ABC', remap0=False, len0=sqrt(2)):
        x00 = POSetOps.instance().adjacency(syms)
        graph0 = self.make(graphT0, graph0=True)

        if not remap0:
            candidates = x00['n']
            edges=x00['e']
            graph0.add_nodes(candidates)
            for pair in edges:
                graph0.add_edge(pair, len0)
                graph0.add_edge(reversed(pair), len0)
            return graph0

        x0 = POSetOps.instance().remap(x00)
        candidates = x0['nodes'].values()
        edges=zip(x0['edges'], x00['e'])

        graph0 = self.make(graphT0, graph0=True)
        graph0.add_nodes(candidates)
        d0 = dict(zip(x0['nodes'].values(), zip(x0['nodes'].keys())))
        for node in d0.keys():
            graph0.add_node_attribute(node, ('struct', d0[node]))

        if edges is None:
            return graph0

        # Add forward and backward path
        # graph0.add_edge_attribute(pair, ('struct', attr))
        for edge, q0 in edges:
            graph0.add_edge(edge, len0)
            graph0.add_edge_attribute(edge, ('struct', q0))

            logger.info("edge: {}; attr: {}".format(edge, q0))
            edge = tuple(reversed(edge))
            q0 = tuple(reversed(q0))
            logger.info("edge: {}; attr: {}".format(edge, q0))
            graph0.add_edge(edge, len0)
            graph0.add_edge_attribute(edge, ('struct', q0))

        return graph0

    def weak(self, adjacency0=None):
        """
        For a list of symbols, generates all the strong orderings
        """
        return

    def dispose(self):
        """
        The media info has to be re-created for every file.
        """
        pass


class Singleton(object):
    _impl = None
    
    @classmethod
    def instance(cls):
        if cls._impl is None:
            cls._impl = _Impl()
        return cls._impl
