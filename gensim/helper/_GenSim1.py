# @file GenSim1.py
# @brief Partially-ordered sets.
# @author weaves
#
# @details
# This class provides some generators for partially-ordered sets.
#
# @note:
# 

from typing import NamedTuple

import logging

import numpy as np

# logging.basicConfig(filename='GenSim1.log', level=logging.DEBUG)
LOGGER = logging.getLogger('GenSim1')
# sh = logging.StreamHandler()
# LOGGER.addHandler(sh)


## Helper methods

class Corpora0(NamedTuple):
    uri: str

## End Helper Methods

class Impl(object):
    """
    Miscellaneous gensim methods.

    This is accessed via a Singleton known as GenSim1Ops.
    """

    _LOGGER = logging.getLogger('weaves')
    """Interface with logging"""

    args = {}

    def __init__(self, **kwargs):
        self.args = kwargs
        pass

    def build(self):
        return Corpora0(self.args('fname', ''))

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
