## @file POSet.py
# @brief Partially-ordered sets.
# @author weaves
#
# @details
# This class provides some generators for partially-ordered sets.
#
# @note
# 

import logging
from itertools import permutations, combinations

class _Impl(object):
    """
    Date methods
    """
    _logger = logging.getLogger('weaves')

    _tions = None

    def __init__(self, **kwargs):
        self._tions = lambda xs, n: permutations(xs, n)
        pass

    def strong(self, xs0):
        """
        For a list of symbols, generates all the strong orderings
        """
        s00 = set()
        for i in iter(range(len(xs0))):
            s00 = s00.union(self._tions(xs0, i+1))
        return s00

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
