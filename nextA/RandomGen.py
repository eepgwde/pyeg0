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

    def __init__(self, n, p):
        if n == None || p == None
            return
            
        return

    def dispose(self):
        pass

    def next_num(self):
        """
        Returns one of the randomNums. When this method is called
        multiple times over a long period, it should return the
        numbers roughly with the initialized probabilities.
        """
        pass

