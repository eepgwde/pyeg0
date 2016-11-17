## @file GMus00.py
# @brief Application support class for the Unofficial Google Music API.
# @author weaves
#
# @details
# This class uses @c gmusicapi. 
#
# @note
# An application support class is one that uses a set of driver classes
# to provide a set of higher-level application specific methods.
#
# @see
# https://github.com/simon-weber/Unofficial-Google-Music-API
# http://unofficial-google-music-api.readthedocs.org/en/latest/

from __future__ import print_function

import codecs

import logging
import os, logging

from io import StringIO

from configparser import ConfigParser

import pandas as pd
import json

from gmusicapi_wrapper import MusicManagerWrapper

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

## Set of file paths for the configuration file.
paths = ['site.cfg', os.path.expanduser('~/share/site/.safe/gmusic.cfg')]
  
## Google Music Manager Wrapper login, search and result cache.
#
# The class needs to find a configuration file with these contents. (The
# values of the keys must be a valid Google Play account.)
#
# This is the lowest class. It provides the login and some basic methods.
# Anything specific to a dataset is in GMus0.
#
# <pre>
# [credentials]
# filename=oauth-nb
# uploader-id=0xAABBCCDDEEFF
# </pre>
class GMus00(object):
    """
    The Google Music API login and cache class.
    """
    ## The parsed configuration file.
    # An instance of configparser.ConfigParser
    cfg = None
    ## The \c gmusicapi instance.
    mmw = None
    ## Cached results: dictionary list.
    s0 = None
    ## Cached results: \c pandas data-frame.
    _df = None

    @property
    def df(self, which=0):
        if self.s0 is None or which >= len(self.s0):
            return None
        s1 = self.s0[which]
        ids = [ x['id'] for x in s1 ]
        self._df = pd.DataFrame(s1, index=ids)
        return self._df

    ## The configuration method.
    # Called from the constructor. It uses the input \c paths sets cfg
    # and uses that to login.
    # @param paths usually the GMus00.paths.
    def _config0(self, paths):
        self.cfg = ConfigParser()
        self.cfg.read(paths)
        x0 = self.cfg.get('logging', 'level', fallback=None)
        self.mmw = MusicManagerWrapper(enable_logging=x0)
        x0 = self.cfg.get('credentials', 'filename', fallback="oauth")
        x1 = self.cfg.get('credentials', 'uploader-id', fallback=None)
        self.mmw.login(oauth_filename=x0, uploader_id=x1)
        if not self.mmw.is_authenticated:
            raise RuntimeException('Not authenticated')
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
        if file0 != None and GMus00.is_valid(file0):
            logging.info("init: not-logging-in" )
            self.read(file0)
            return
            
        logging.info("init: logging-in" )
        self._config0(paths)
        return

    def dispose(self):
        self.mmw.logout()
        self.s0 = None

    ## Write out the file to a JSON file.
    #
    # You should be aware that encoding issues are avoided by using
    # the ensure_ascii=True feature - this means, that any
    # non-compliant characters are escaped.
    def write(self, file0, file1=None):
        s1 = self.s0
        if file1 is None:
            pass
        else:
            s1 = file1

        with open(file0, 'w') as outfile:
            json.dump(s1, outfile, sort_keys = True, indent = 4,
                      ensure_ascii=True)

    @singledispatch1
    def add(self, a, b):
        raise NotImplementedError('Unsupported type')
    
 
    @add.register(int)
    def _(self, a, b):
        logging.debug("First argument is of type " + type(a).__name__)
        return a * b
        
    @add.register(str)
    def _(self, a, b):
        logging.debug("First argument is of type " + type(a).__name__)
        return "(\"{0:s}\", \"{1:s}\"".format(a, b)

    @singledispatch1
    def read0(self, file0):
        raise NotImplementedError('Unsupported type')

    @read0.register(str)
    def _(self, file0):
        logging.info("read0: str")
        s0 = None
        with open(file0, 'rb') as infile:
            reader = codecs.getreader("utf-8")
            s0 = json.load(reader(infile))
        
        return s0

    @read0.register(StringIO)
    def _(self, file0):
        logging.info("read0: StringIO")
        return json.load(file0)

    def read(self, file0):
        self.s0 = self.read0(file0)
        return
    
    ## Load up the records given only a JSON file of indices.
    # The file of indices should come from indices()
    # @param file0 is the name of the JSON file containing the indices.
    # @param source is the name of the JSON file of songs from
    # which the indices can be found.
    def load(self, file0, source=None):
        i0 = self.read0(file0)
        if i0 is None:
            return None
            
        if source is not None:
            self.read(source)
        df = self.df;
        # Select only those in the indices.
        df = df[df.index.isin(i0)]

        s = df.to_json(None, orient='records')
        self.read(StringIO(unicode(s)))
        return self.s0

    ## General method to filter by set membership.
    # The name of the field is given by the string 'field'.  Only
    # those songs that have name in song.field are selected.
    # @param field name of the field in each song.
    # @param name a key field to test.
    def in0(self, field, name):
        s1 = [ track for track in self.s0
               if name in track[field] ]
        
        logging.info("in0: filter: {0}".format(len(s1)))
        return s1

    ## General method to filter by an exact match.
    # The name of the field is given by the string field.
    # The value it must match is given with the name.
    def exact0(self, field, name):
        s1 = [ track for track in self.s0
               if track[field] == name ]
        
        logging.info("exact0: filter: {0}".format(len(s1)))
        return s1
        
    ## Retrieve all the songs and cache them.
    # The songs are stored in GMus00.s0
    # If s0 is already loaded then this is not done.
    def songs(self, force=False):
        if self.s0 is not None and len(self.s0) and not(force):
            return self.s0
            
        self.s0 = self.mmw.get_google_songs(include_filters=None, 
                                            exclude_filters=None, 
                                            all_includes=False, 
                                            all_excludes=False,
                                            uploaded=True, 
                                            purchased=True)
        logging.info("songs: {0}".format(len(self.s0)))
        return self.s0

    ## Load a file (or buffer) of indices, filter the caches to just them.
    # 
    def indices(self, file0):
        s1 = self.read0(file0)
        logging.info("indices: {0}".format(len(s1)))
        return s1

    def delete(self, file0):
        with open(file0, 'rb') as infile:
            d0 = json.load(infile)
        logging.info("delete: {0}: {1}".format(file0, len(d0)))
        self.mmw.delete_songs(d0)
        return

    @classmethod
    def main(cls, args):
        cls.args = args
        return
