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

# from py3votecore.plurality import PluralityAtLarge
# from py3votecore.stv import STV, Quota
# from py3votecore.schulze_by_graph import SchulzeMethodByGraph, SchulzeNPRByGraph

from weaves import POSetOps

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

    def build(self, syms='ABC', remap0=False):
        graph0 = None
        x00 = POSetOps.instance().adjacency('ABC')
        x0 = POSetOps.instance().remap(x00)

        candidates = x0['nodes'].values()
        edges=x0['edges']

        graph0 = self.make(graphT0, graph0=True)
        graph0.add_nodes(candidates)

        if edges is None:
            return graph0

        for pair in edges:
            graph0.add_edge(pair, 1)

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
