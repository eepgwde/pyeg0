## @file POSet.py
# @brief Partially-ordered sets.
# @author weaves
#
# @details
# This class provides some generators for partially-ordered sets.
#
# @note
# 

import logging

class _Impl(object):
    """
    Date methods
    """
    _logger = logging.getLogger('weaves')

    def __init__(self, **kwargs):
        pass

    def dispose(self):
        """
        The media info has to be re-created for every file.
        """
        pass


class Singleton(object):
    _impl = None
    
    @classmethod
    def instance(cls):
        if cls._impl is None:
            cls._impl = _Impl()
        return cls._impl
