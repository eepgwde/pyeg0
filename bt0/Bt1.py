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
import ConfigParser, os, logging

from Bt0 import Bt0

from io import StringIO

import json

## BitTorrent
#
# The class needs to find a configuration file with these contents.
#
class Bt1(Bt0):
    """
    The BitTorrent class
    """

    def __init__(self, file0):
        super(Child, self).__init__(file0)
        return

    def display(self):
        """
        XML output
        """
        print('metainfo file.: %s' % basename(file0))
        print('info hash.....: %s' % info_hash.hexdigest())
        piece_length = info['piece length']
        if info.has_key('length'):
            # let's assume we just have a file
            print('file name.....: %s' % info['name'])
            file_length = info['length']
            name ='file size.....:'
            return

        # let's assume we have a directory structure
        print('directory name: %s' % info['name'])
        print('files.........: ')
        file_length = 0;
        for file in info['files']:
            path = ''
            for item in file['path']:
                if (path != ''):
                    path = path + "/"
                    path = path + item
                    print('   %s (%d)' % (path, file['length']))
                    file_length += file['length']
                    name = 'archive size..:'
                    piece_number, last_piece_length = divmod(file_length, piece_length)
                    print('%s %i (%i * %i + %i)' % (name,file_length, piece_number, piece_length, last_piece_length))
                    print('announce url..: %s' % announce)
                    print
        return

    def dispose(self):
        self.s0 = None
        return
