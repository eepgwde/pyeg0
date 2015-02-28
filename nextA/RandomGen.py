## @file RndDist.py
# @brief Random numbers
# @author weaves
#
# @details
# This class uses no special API.
#
# @note
#
# A better version of this class would implement __next__ and thus be
# iterable and be usable within a for-each.
# It might also be desirable to allow for its use as a list
# comprehension.
#
# @see
# http://
# 

from __future__ import print_function

import logging

import random
import numpy as np

class RandomGen(object):
    """
    Given a set of frequencies and a set of numbers provides
    a stream of randomly chosen numbers from the set with the given
    frequency.
    """
    # Values that may be returned by next_num()

    _random_nums = []

    # Probability of the occurence of random_nums

    _probabilities = []

    _cum0 = []

    def __init__(self, n, p):
        if n == None or p == None:
            return

        # use cumsum for a CDF 
        self._random_nums = n
        self._probabilities = p
        self._cum0 = np.cumsum(self._probabilities, dtype=float)
        return

    def dispose(self):
        pass

    def next_num(self, l0 = None):
        """
        Returns one of the randomNums. When this method is called
        multiple times over a long period, it should return the
        numbers roughly with the initialized probabilities.

        If you pass a l0 value, you can test the extremeties of the range.
        """

        # It is usual to not have l0 set and thus use a random value.
        if l0 is None:
            l0 = random.random()

        # This isn't very efficient, for large lists use blist
        # the enumeration could be made re-used in some way.

        logging.info(l0)
        i=next(i for i,v in enumerate(self._cum0) if v > l0)
        # Use this for tracing, either as return or as log.
        # logging.info([ l0, i,  self._random_nums[i]] )
        return self._random_nums[i]
