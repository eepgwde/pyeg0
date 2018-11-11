## @file _Functors.py
# @brief Extensions to Python class and object dispatch.
# @author weaves
#
# @details
# This class provides some decorators for classes.
# And a Singleton.
#
# @note
#
# The Singleton includes a implementation that does some date arithmetic.

import logging
from datetime import datetime, date, timedelta
from tempfile import NamedTemporaryFile
from cached_property import cached_property

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
    _hrfmt = "{0:02d}:{1:02d}:{2:02d}.{3:03d}"

    _logger = logging.getLogger('weaves')

    def __init__(self, **kwargs):
        pass

    def dispose(self):
        pass

    def tm2dt(self, tm):
        return datetime.combine(self.epoch, tm)

    @cached_property
    def zulu(self):
        """Zero time"""
        return self.dt2tm1(self.epoch)

    def dtadvance(self, dt, tm):
        return dt + (self.tm2dt(tm) - self.epoch)

    def dofy(self, dt):
        """
        Day of year, indexed from zero.
        """
        d = dt.date() if isinstance(dt, datetime) else dt
        return d.toordinal() - date(d.year, 1, 1).toordinal()

    def dt2tm1(self, d):
        hr0 = self.dofy(d) * 24 + d.hour
        return self._hrfmt.format(hr0, d.minute,
                                  d.second, int(d.microsecond / 1000))

    def dtadvance2(self, **kwargs):
        dt = self.epoch
        return dt + timedelta(**kwargs)

class Singleton(object):
    _impl = None
    
    @classmethod
    def instance(cls):
        if cls._impl is None:
            cls._impl = _Impl()
        return cls._impl
