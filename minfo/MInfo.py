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

from MediaInfoDLL3 import MediaInfo, Stream, Info

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
    _slv = None

    def __init__(self, n):
        if n == None:
            return

        self._slv = MediaInfo()
        logging.info(self._slv.Option_Static("Info_Version", "0.7.7.0;MediaInfoDLL_Example_Python;0.7.7.0"))
        return

    def dispose(self):
        if _slv == None:
            return
        _slv.Close()
        pass

    def open(self, l0 = None):
        """
        """
        if l0 == None:
            return

        self._slv.Open(l0)
        logging.info(l0)
        return

    def duration(self, l0 = None):
        """
        """
        self._slv.Option_Static("Inform", 
                                "Audio;%Duration/String3%")
        return(self._slv.Inform())

    def info(self, l0 = None):
        """
        """
        self._slv.Option_Static("Complete", "1")
        return(self._slv.Inform())


