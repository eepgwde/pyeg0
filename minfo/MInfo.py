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

class MInfo(object):
    """
    Given a set of frequencies and a set of numbers provides
    a stream of randomly chosen numbers from the set with the given
    frequency.
    """
    # Values that may be returned by next_num()


    # Probability of the occurence of random_nums


    _cum0 = []

    def __init__(self, n):
        if n == None:
            return

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

        # This isn't very efficient, for large lists use blist
        # the enumeration could be made re-used in some way.

        logging.info(l0)
        return 0
