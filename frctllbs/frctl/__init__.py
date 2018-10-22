# -*- coding: utf-8 -*-

from frctl._version import __version__
from frctl._Stack import Stack
from frctl._Queue import Queue

__copyright__ = 'Copyright 2016 Walter Eaves'
__license__ = 'GPLv3'
__title__ = 'frctl'

# appease flake8: the imports are purposeful
(__version__, Stack, Queue)
