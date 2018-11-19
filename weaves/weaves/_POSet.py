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
from functools import partial
import numpy as np

def remap(xs, d1=None):
    return ( d1[x] for x in xs )

def join0(x, s=None):
    if s is None:
        return x
    return s.join(x)

def remapN(xs, remap0=remap):
    for x in xs:
        yield remap0(x)

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

    def partitions(self, set_):
        """
        Set partitions

        This can produce unordered set partitions. Bell Number.

        Or ordered preferences. Order Bell Number.

        @author Thomas Dybdahl Ahle
        """

        ctr0 = lambda: list()
        ext0 = lambda pi, item: pi.append(item)

        if type(set_) is set:
            ctr0 = lambda: set()
            ext0 = lambda pi, item: pi.add(item)

        def partitions_(set_):
            if not set_:
                yield []
                return

            for i in range(int(2**len(set_)/2)):
                parts = [ctr0(), ctr0()]
                for item in set_:
                    # parts[i&1].add(item)
                    ext0(parts[i&1], item)
                    i >>= 1
                for b in partitions_(parts[1]):
                    yield [parts[0]]+b

        if type(set_) is set:
            return partitions_(set_)

        sss = permutations(set_, len(set_))
        return [ s for s in [ partitions_(ss) for ss in sss ] ]

    def reduce_(self, s):
        return

    def sym2basis(self, l0):
        if isinstance(l0, str):
            l0 = tuple(l0)

        if not isinstance(l0, tuple):
            raise ValueError('tuple expected')

        if not l0:
            return []
        return dict(zip(range(len(l0)), l0))

    def adjacency(self, d0, ndiff=2, nX=1):
        """
        Graph vertices

        Find those that near adjacent to one another.
        """
        # Map list to ordinal
        if not isinstance(d0, dict):
            d0 = self.sym2basis(d0)

        l0 = d0.keys()
        # Node addresses n!
        l1 = permutations(l0, len(l0))
        nodes = tuple(l1)
        l1 = map(np.array, nodes)

        l2=tuple(combinations(l1, 2))
        m0 = int(ndiff * nX)
        l3 = map(lambda a: m0 == sum(abs(a[0] - a[1])), l2)
        l4 = [i for i, x in enumerate(tuple(l3)) if x]
        edges = [l2[i] for i in l4]

        f0 = lambda x: ( tuple(np.ndarray.tolist(x[0])), tuple(np.ndarray.tolist(x[1])) )
        edges1 = tuple(map(f0, edges))

        return { 'm': d0, 'n': nodes, 'e': edges1 }

    def remap(self, adjacency0=None, map0=None, nodes0=None,
              edges0=None, sep0=">"):
        if not adjacency0 is None:
            map0=adjacency0['m']
            nodes0=adjacency0['n']
            edges0=adjacency0['e']

        if map0 is None:
            raise ValueError('map0 is required')

        remap1 = partial(remap, d1=map0)
        join1 = partial(join0, s=sep0)

        nodes1 = nodes0
        edges1 = edges0
        if not nodes1 is None:
            nodes1 = dict(iter([ (x, join1(remap1(x))) for x in nodes0 ]))
            if not edges1 is None:
                remap2 = partial(remap, d1=nodes1)
                edges1 = ( tuple(x) for x in remapN(edges0, remap0=remap2) )

        if adjacency0 is None:
            adjacency0 = { 'm': map0, 'n': nodes0, 'e': edges0 }
        d0 = { 'map': map0, 'nodes': nodes1, 'edges':edges1 }
        adjacency0.update(d0)
        return adjacency0

    def dispose(self):
        """
        The media info has to be re-created for every file.
        pass
        """
        return

class Singleton(object):
    _impl = None
    
    @classmethod
    def instance(cls):
        if cls._impl is None:
            cls._impl = _Impl()
        return cls._impl