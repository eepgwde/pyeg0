## @file Bt0.py
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

from io import StringIO

import json

## Set of file paths for the configuration file.
paths = ['bt0.cfg', os.path.expanduser('~/share/site/.safe/bt0.cfg')]

## Google Music API login, search and result cache.
#
# The class needs to find a configuration file with these contents.
#
# This is the lowest class. It provides the login and some basic methods.
#
# <pre>
# [credentials]
# username=username\@gmail.com
# password=SomePassword9
# </pre>
class Bt0(object):
    """
    The BitTorrent class
    """
    ## The parsed configuration file.
    # An instance of ConfigParser.ConfigParser
    cfg = None
    ## Cached results: dictionary list.
    s0 = None
    ## Cached results: \c pandas data-frame.
    _df = None

    @property
    def df(self):
        if self.s0 is None or len(self.s0) <= 0:
            return None
            ids = [ x['id'] for x in self.s0 ]
            self._df = pd.DataFrame(self.s0, index=ids)
            return self._df

    ## The configuration method.
    # Called from the constructor. It uses the input \c paths sets cfg
    # and uses that to login.
    # @param paths usually the Bt0.paths.
    def _config0(self, paths):
        self.cfg = ConfigParser.ConfigParser()
        self.cfg.read(paths)
        return

    ## Check if a path is a file and is non-zero.
    # @param fpath a path string.
    @classmethod
    def is_valid(cls, fpath):
        logging.debug("fpath: {0}; {1} {2}".
                      format(fpath, os.path.isfile(fpath),
                             (os.path.getsize(fpath) if os.path.isfile(fpath) else 0) ))
        return (os.path.isfile(fpath) and (os.path.getsize(fpath) > 0))
        
    def __init__(self, file0):
        if file0 != None and Bt0.is_valid(file0):
            logging.info("init: not-logging-in" )
            self.read(file0)
            return
            
        logging.info("init: logging-in" )
        self._config0(paths)
        return

    file0 = None;

    def read(self, file0):
        file1 = open(file0, 'rb')
        if file1.read(11) != 'd8:announce':
            print('%s: Not a BitTorrent metainfo file' % file0)
            return

        file1.seek(0)
        metainfo = bdecode(file1.read())
        file1.close()
        announce = metainfo['announce']
        info = metainfo['info']
        info_hash = sha(bencode(info))
        display()
        return

    def display(self, file0):
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
