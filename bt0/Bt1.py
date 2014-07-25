## @file Bt1.py
# @brief Application support class for BitTorrent
# @author weaves
#
# @details
# This class uses @c lxml.
#
# @note
# An application support class is one that uses a set of driver classes
# to provide a set of higher-level application specific methods.
#
# @see
# http://lxml.de/tutorial.html

from __future__ import print_function

import logging
from os.path import basename

from Bt0 import Bt0

## BitTorrent
#
# The class needs to find a configuration file with these contents.
#
class Bt1(Bt0):
    """
    The BitTorrent class
    """

    def __init__(self, file0):
        super(Bt1, self).__init__(file0)
        return

    def display(self):
        """
        XML output
        """
        print('XML metainfo file.: %s' % basename(self.file0))
        return

    def dispose(self):
        self.s0 = None
        return
