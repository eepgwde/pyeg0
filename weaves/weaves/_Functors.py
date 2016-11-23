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

import logging
from datetime import datetime, date
from tempfile import NamedTemporaryFile

import os
import sys

from functools import singledispatch, update_wrapper

def singledispatch1(func):
    """
    This provides a method attribution that allows a single dispatch from an
    object.
    """
    dispatcher = singledispatch(func)
    def wrapper(*args, **kw):
        return dispatcher.dispatch(args[1].__class__)(*args, **kw)
    wrapper.register = dispatcher.register
    update_wrapper(wrapper, dispatcher)
    return wrapper

class _Impl(object):
    """
    Date methods
    """
    epoch = datetime.utcfromtimestamp(0)
    _logger = logging.getLogger('weaves')

    def __init__(self, **kwargs):
        pass

    def dispose(self):
        """
        The media info has to be re-created for every file.
        """
        pass

    def tm2dt(self, tm):
        return datetime.combine(self.epoch, tm)

    def dtadvance(self, dt, tm):
        return dt + (self.tm2dt(tm) - cls.epoch)

    def dofy(self, d):
        """
        Day of year, indexed from zero.
        """
        return d.toordinal() - date(d.year, 1, 1).toordinal()

    def dt2tm1(self, d):
        hr0 = self.dofy(d) * 24 + d.hour
        return self._hrfmt.format(hr0, d.minute,
                                 d.second, int(d.microsecond / 1000))

class Singleton(object):
    _impl = None
    
    @classmethod
    def instance(cls):
        if cls._impl is None:
            cls._impl = _Impl()
        return cls._impl
