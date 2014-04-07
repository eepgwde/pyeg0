"""
@author weaves
@brief Removing older duplicates
"""

from gmusicapi import Mobileclient
import ConfigParser, os

cfg = ConfigParser.ConfigParser()

cfg.read(['site.cfg', os.path.expanduser('~/etc/gmusic.cfg')])

api = Mobileclient()

api.login(cfg.get('credentials', 'username'),
          cfg.get('credentials', 'password'))

s0 = api.get_all_songs()

print len(s0)

