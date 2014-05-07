## @file GMus0.py
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

import logging
import ConfigParser, os, logging
import pandas as pd
import json

from gmusicapi import Mobileclient

## Set of file paths for the configuration file.
paths = ['site.cfg', os.path.expanduser('~/share/site/.safe/gmusic.cfg')]
  
## Google Music API login, search and result cache.
#
# The class needs to a configuration file with these contents. (The
# values of the keys must be a valid Google Play account.)
#
# <pre>
# [credentials]
# username=username\@gmail.com
# password=SomePassword9
# </pre>
class GMus0:
    """
    Max Headroom
    """
    ## The parsed configuration file.
    # An instance of ConfigParser.ConfigParser
    cfg = None
    ## The \c gmusicapi instance.
    api = Mobileclient()
    ## Cached results: dictionary list.
    s0 = None
    ## Cached results: \c pandas data-frame.
    df = None

    ## The configuration method.
    # Called from the constructor. It uses the input \c paths sets cfg
    # and uses that to login.
    # @param paths usually the GMus0.paths.
    def _config0(self, paths):
        self.cfg = ConfigParser.ConfigParser()
        self.cfg.read(paths)
        self.api.login(self.cfg.get('credentials', 'username'),
                       self.cfg.get('credentials', 'password'))
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
        if file0 != None and GMus0.is_valid(file0):
            logging.info("init: not-logging-in" )
            self.read(file0)
            return
            
        logging.info("init: logging-in" )
        self._config0(paths)
        return

    def dispose(self):
        self.api.logout()
        self.s0 = None

    def write(self, file0, file1=None):
        s1 = self.s0
        if file1 is None:
            pass
        else:
            s1 = file1
            
        with open(file0, 'w') as outfile:
            json.dump(s1, outfile, sort_keys = True, indent = 4,
                      ensure_ascii=False)

    def read(self, file0):
        with open(file0, 'rb') as infile:
            self.s0 = json.load(infile)
        ids = [ x['id'] for x in self.s0 ]
        self.df = pd.DataFrame(self.s0, index=ids)
        return

    def in0(self, field, name):
        s1 = [ track for track in self.s0
               if name in track[field] ]
        
        logging.info("in0: filter: {0}".format(len(s1)))
        return s1
    
    def exact0(self, field, name):
        s1 = [ track for track in self.s0
               if track[field] == name ]
        
        logging.info("exact0: filter: {0}".format(len(s1)))
        return s1
        
    def duplicated(self):
       # self.df = self.df.sort(['album', 'title', 'creationTimestamp'],
       #                       ascending=[1, 1, 0])
       df = self.df[list(['title', 'album', 'creationTimestamp'])]
       df['n0'] = df['title'] + '|' + df['album']
       df = df.sort(['n0','creationTimestamp'], ascending=[1, 0])
       # Only rely on counts of 2.
       s0 = pd.Series(df.n0)
       s1 = s0.value_counts()
       s2 = set( (s1[s1.values >= 2]).index )
       df1 = df[df.n0.isin(s2)]
       df1['d'] = df1.duplicated('n0')
       s3 = list(df1[df1.d].index)
       return s3

    ## Retrieve all the songs and cache them.
    # The songs are stored in GMus0.s0
    # If s0 is already loaded then this is not done.
    def songs(self, force=False):
        if self.s0 is not None and len(self.s0) and not(force):
            return self.s0
            
        self.s0 = self.api.get_all_songs()
        logging.info("songs: {0}".format(len(self.s0)))
        return self.s0

    ## Load a file of indices, filter the caches to just them.
    # 
    def indices(self, file0):
        s1 = None
        with open(file0, 'rb') as infile:
            s1 = json.load(infile)
        logging.info("indices: {0}".format(len(s1)))
        return s1

    def delete(self, file0):
        with open(file0, 'rb') as infile:
            d0 = json.load(infile)
        logging.info("delete: {0}: {1}".format(file0, len(d0)))
        self.api.delete_songs(d0)
        return
