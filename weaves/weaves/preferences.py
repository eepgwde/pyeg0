## @author weaves
##
## 

class Pair0(object):
    v = None

    def __init__(self, a, b):
        if a is b:
            raise ValueError('a may not be identical to b')
        if a == b:
            raise ValueError('a may not be equal to b')
        if len(a) == 0:
            raise ValueError('a must have a length')
        if len(b) == 0:
            raise ValueError('b must have a length')

        self.v = [ a, b ]

    def __eq__(self, other):
        """Overrides the default implementation"""
        if isinstance(other, Pair0):
            return self.v == other.v
        return False

    def __repr__(self):
        return type(self).__name__ + ": " + str(self.v)

class Prefer0(Pair0):
    def __init__(self, a, b):
        super(Prefer0, self).__init__(a, b)

class NoPrefer0(Pair0):
    def __init__(self, a, b):
        super(NoPrefer0, self).__init__(a, b)

