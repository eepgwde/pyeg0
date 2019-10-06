# @file GenSim1.py
# @brief Partially-ordered sets.
# @author weaves
#
# @details
# This class provides some generators for partially-ordered sets.
#
# @note:
# 

from gensim.corpora import Dictionary

from os import path
import logging

import numpy as np

# logging.basicConfig(filename='GenSim1.log', level=logging.DEBUG)
LOGGER = logging.getLogger('GenSim1')
# sh = logging.StreamHandler()
# LOGGER.addHandler(sh)


## Helper methods

class Corpora0(object):
    "Local class"

    fd = None

    def __init__(self, **kwargs):
        fname = kwargs['fname']
        if not path.exists(fname):
            raise OSError('{}: does not exist'.format(fname))
        if not path.isfile(fname):
            raise OSError('{}: not a file'.format(fname))

        self.fd = open(fname)
        self.dct = Dictionary(documents=None)

    def __del__(self):
        if self.fd is not None:
            self.fd.close()

    def __iter__(self):
        for line in self.fd:
            # assume there's one document per line, tokens separated by whitespace
            # yield self.dct.doc2bow(line.lower().split())
            yield self.dct.doc2bow(line.lower().split(), allow_update=True)

## End Helper Methods

class Impl(object):
    """
    Miscellaneous gensim methods.

    This is accessed via a Singleton known as GenSim1Ops.
    """

    _LOGGER = LOGGER
    """Interface with logging"""

    args = {}

    def __init__(self, **kwargs):
        self.args = kwargs
        pass

    def build(self, **kwargs):
        """
        Allows the arguments to be re-set.
        """
        if kwargs is not None and len(kwargs) > 0:
            self.args = kwargs
        return Corpora0(**self.args)

class Singleton(object):
    """
    Single instance of L{Impl} this provides access to the implementation.
    """
    _impl = None
    
    @classmethod
    def instance(cls, **kwargs):
        if cls._impl is None:
            cls._impl =  Impl(**kwargs)
        return cls._impl
