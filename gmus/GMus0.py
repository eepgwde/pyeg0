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

from __future__ import print_function
from GMus00 import GMus00
import logging
import configparser, os, logging
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
class GMus0(GMus00):

    def _login(self):
        self._logger.info("GMus00: login")
        x0 = self.cfg.get('logging', 'level', fallback=False)
        self.mmw = Mobileclient(debug_logging=x0, 
                                validate=False, verify_ssl=False)
        self._logger.info("mmw: " + type(self.mmw).__name__)
        x0 = self.cfg.get('credentials', 'username', fallback=None)
        x1 = self.cfg.get('credentials', 'password', fallback=None)
        self._logger.info("creds: " + x0 + "; " + x1)
        self.mmw.login(x0,x1,Mobileclient.FROM_MAC_ADDRESS)
        if not self.mmw.is_authenticated:
            raise RuntimeError('Not authenticated')

    def songs(self, force=False):
        if self.s0 is not None and len(self.s0) and not(force):
            return self.s0

        self.s0 = [ self.mmw.get_all_songs() ]
            
        self._logger.info("songs: {0}".format(len(self.s0)))
        return self.s0

    ## Ad-hoc method to find the indices of duplicated entries.
    def duplicated(self):
        # self._df = self._df.sort(['album', 'title', 'creationTimestamp'],
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
