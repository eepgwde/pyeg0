# -*- coding: utf-8 -*-

from weaves._version import __version__, __Id__
from weaves._Functors import singledispatch1
from weaves._Functors import Singleton as TimeOps
from weaves._POSet import Singleton as POSetOps
from weaves._MCast import Singleton as MCast
from weaves._MCast import Enqueue
from weaves._MCast import StoppableThread

__copyright__ = 'Copyright 2016 Walter Eaves'
__license__ = 'GPLv3'
__title__ = 'weaves'

# appease flake8: the imports are purposeful
(__version__)
(__Id__)
