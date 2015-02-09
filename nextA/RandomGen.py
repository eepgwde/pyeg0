## @file RndDist.py
# @brief Random numbers
# @author weaves
#
# @details
# This class uses no special API.
#
# @note
# 
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
        """

        if l0 is None:
            l0 = random.random()

        logging.info(l0)
        i=next(i for i,v in enumerate(self._cum0) if v > l0)
        return [ l0, i, self._random_nums[i] ]
