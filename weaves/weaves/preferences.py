

from collections import namedtuple

Pair0 = namedtuple('Pair0', ['v'])

class Prefer0(Pair0):
    def __init__(self, a, b):
        super(Prefer0, self).__init__(a, b)

class NoPrefer0(Pair0):
    def __init__(self, a, b):
        super(NoPrefer0, self).__init__(a, b)

