## @file MInfo.py
# @brief Media Info fetching.
# @author weaves
#
# @details
# This class uses the MediaInfo library for Python.
#
# @note
#
# The library has a limitation that it cannot handle UTF-8 names very
# well. To side-step that, I make a temporary symlink using the 'os'
# module and then use MediaInfo on that.
#
# 

from __future__ import print_function
from unidecode import unidecode

from MediaInfoDLL3 import MediaInfo, Stream, Info

import logging
from datetime import datetime, date
from tempfile import NamedTemporaryFile

import os
import sys

class MInfo(object):
    """
    Given a set of frequencies and a set of numbers provides
    a stream of randomly chosen numbers from the set with the given
    frequency.
    """
    # Values that may be returned by next_num()
    epoch = datetime.utcfromtimestamp(0)

    _cum0 = []
    _slv = None
    _hrfmt = "{0:02d}:{1:02d}:{2:02d}.{3:02d}"
    _dt = None
    _logger = logging.getLogger('MInfo')
    _loaded = False
    _delegate = None

    format0 = "%H:%M:%S.%f"
    quality0 = "Audio;%Duration/String3%"

    @property
    def delegate(self):
        return self._delegate

    @property
    def delegate(self):
        return self._delegate

    @delegate.setter
    def delegate(self, name0):
        self._delegate = getattr(self, name0)
    
    def __init__(self, l0 = None):
        self._delegate = "duration1"
        
        self._slv = MediaInfo()
        self._logger.info(self._slv.Option_Static("Info_Version", "0.7.7.0;MediaInfoDLL_Example_Python;0.7.7.0"))
        if l0 == None:
            return

        if not isinstance(l0, str):
            return

        try:
            self.open(l0)
        except:
            raise
        
        return

    def dispose(self):
        """
        The media info has to be re-created for every file.
        """
        if self._slv is None:
            return
        self._slv.Close()
        return


    def duration(self):
        """
        If the quality has been correctly set, update a time
        used the format.
        """
        s0 = self.quality()
        if len(s0) <= 0:
            return None
        self._logger.debug("duration: s0: " + s0)
        d = datetime.strptime(s0, self.format0)
        return MInfo.tm2dt(datetime.time(d))

    def duration1(self):
        """
        Maintain a cumulative duration
        """
        s0 = self.quality()
        if len(s0) <= 0:
            return None
        self._logger.debug("duration: s0: " + s0)
        d = datetime.strptime(s0, self.format0)
        return MInfo.tm2dt(datetime.time(d))

    def next(self, l0 = None):
        d = self._delegate()
        
        if self._dt is None:
            self._dt = d
        else:
            self._dt = MInfo.dtadvance(self._dt, datetime.time(d))

        self._cum0.append(self.dt2tm1(self._dt))

        if l0 is not None:
            self.open(l0)
        return self._cum0[-1]

    def get(self, l0 = -1):
        return self._cum0[l0]

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

