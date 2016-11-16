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
from unidecode import unidecode

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
    _hrfmt = "{0:02d}:{1:02d}:{2:02d}.{3:02d}"
    _dt = None
    _format0 = "%H:%M:%S.%f"
    _logger = logging.getLogger('MInfo')
    
    def __init__(self, l0 = None):
        self._slv = MediaInfo()
        self._logger.info(self._slv.Option_Static("Info_Version", "0.7.7.0;MediaInfoDLL_Example_Python;0.7.7.0"))
        if l0 == None:
            return

        if not isinstance(l0, str):
            return

        self.open(l0 = l0)
        return

    def dispose(self):
        if self._slv is None:
            return
        self._slv.Close()
        pass

    def open(self, l0 = None):
        """
        """
        self.dispose()
        if l0 == None:
            return

        self._slv.Open(l0)
        self._logger.info("file: " + unidecode(l0))
        return

    def duration(self, l0 = "String3"):
        """
        """
        s0 = "Audio;%Duration/{:s}%".format(l0)
        self._slv.Option_Static("Inform", s0)
        return(self._slv.Inform())

    def duration1(self, l0 = None):
        """
        """
        s0 = self.duration()
        if len(s0) <= 0:
            return None
        self._logger.debug("duration: s0: " + s0)
        d = datetime.strptime(s0, MInfo._format0)
        return MInfo.tm2dt(datetime.time(d))

    def next(self, l0 = None):
        d = self.duration1()
        if d is None:
            return None
        
        if self._dt is None:
            self._dt = d
        else:
            self._dt = MInfo.dtadvance(self._dt, datetime.time(d))

        self._cum0.append(self.dt2tm1(self._dt))

        if l0 is not None:
            self.open(l0)
        return self._cum0[-1]

    def get(self, l0 = None):
        return self._cum0

    def reset(self, l0 = None):
        x0 = self._cum0
        self._cum0 = []
        self._dt = None
        return x0

    @classmethod
    def tm2dt(cls, tm):
        return datetime.combine(MInfo.epoch, tm)

    @classmethod
    def dtadvance(cls, dt, tm):
        return dt + (cls.tm2dt(tm) - MInfo.epoch)

    @classmethod
    def dofy(cls, d):
        """
        Day of year, indexed from zero.
        """
        return d.toordinal() - date(d.year, 1, 1).toordinal()

    @classmethod
    def dt2tm1(cls, d):
        hr0 = cls.dofy(d) * 24 + d.hour
        return cls._hrfmt.format(hr0, d.minute,
                                 d.second, int(d.microsecond / 1000))

    def info(self, l0 = None):
        """
        """
        self._slv.Option_Static("Complete", "1")
        return(self._slv.Inform())


