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
    """The timestamp at 0 milliseconds."""

    _hrfmt = "{0:02d}:{1:02d}:{2:02d}.{3:03d}"
    """Hours, minutes, and seconds and milliseconds format."""

    _logger = logging.getLogger('weaves')
    """Local logger."""

    def __init__(self, **kwargs):
        """
        No special constructor.
        """
        pass

    def tm2dt(self, tm):
        """
        Converts a timestamp to a datetime by appending it to the epoch start-time.
        """
        return datetime.combine(self.epoch, tm)

    @cached_property
    def zulu(self):
        """Zero time"""
        return self.dt2tm1(self.epoch)

    def dtadvance(self, dt, tm):
        """
        Advance a date by a time.
        """
        return dt + (self.tm2dt(tm) - self.epoch)

    def dofy(self, dt):
        """
        Day of year, indexed from zero.
        """
        d = dt.date() if isinstance(dt, datetime) else dt
        return d.toordinal() - date(d.year, 1, 1).toordinal()

    def dt2tm1(self, d):
        """Returns the time as a string."""
        hr0 = self.dofy(d) * 24 + d.hour
        return self._hrfmt.format(hr0, d.minute,
                                  d.second, int(d.microsecond / 1000))

    def dtadvance2(self, **kwargs):
        """Advances the time by a delta."""
        dt = self.epoch
        return dt + timedelta(**kwargs)

class Singleton(object):
    """
    Singleton for L{Impl}, this is known as TimeOps.
    """
    _impl = None
    
    @classmethod
    def instance(cls):
        if cls._impl is None:
            cls._impl = _Impl()
        return cls._impl
