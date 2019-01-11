# -*- coding: utf-8 -*-

from lag._version import __version__
from lag._Stack import Stack
from lag._Queue import Queue
from lag._Part import Part

__copyright__ = 'Copyright 2016 Walter Eaves'
__license__ = 'GPLv3'
__title__ = 'lag'

# appease flake8: the imports are purposeful
(__version__, Stack, Queue)
