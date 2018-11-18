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

import weaves

class graphT0(digraph):
    def __init__(self):
        """
        Initialize a digraph.
        """
        super(graphT0, self).__init__()


class _Impl(object):
    """
    Date methods
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

    def weak(self, adjacency0=None):
        """
        For a list of symbols, generates all the strong orderings
        """
        return

    def size(h0):
        """graph"""
        return [ len(h0.nodes()), len(h0.edges()), len(h0.faces(k=2)) ]

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
