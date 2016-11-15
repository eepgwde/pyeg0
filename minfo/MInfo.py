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
from datetime import datetime, date

class MInfo(object):
    """
    Given a set of frequencies and a set of numbers provides
    a stream of randomly chosen numbers from the set with the given
    frequency.
    """
    # Values that may be returned by next_num()
    epoch = datetime.utcfromtimestamp(0)

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

    @classmethod
    def tm2dt(cls, tm):
        return datetime.combine(MInfo.epoch, tm)

    @classmethod
    def dtadvance(cls, dt, tm):
        return dt + (cls.tm2dt(tm) - MInfo.epoch)

    @classmethod
    def dofy(cls, d):
        return d.toordinal() - date(d.year, 1, 1).toordinal() + 1

    @classmethod
    def dt2tm1(cls, d):
        hr0 = MInfo.dofy(d) * 24 + d.hour
        return "{0:02d}:{1:02d}:{2:02d}.{3:02d}".format(hr0, d.minute, d.second, int(d.microsecond / 1000))

    def info(self, l0 = None):
        """
        """
        self._slv.Option_Static("Complete", "1")
        return(self._slv.Inform())


