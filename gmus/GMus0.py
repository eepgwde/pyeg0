import logging
import ConfigParser, os, logging

from gmusicapi import Mobileclient

paths = ['site.cfg', os.path.expanduser('~/etc/gmusic.cfg')]

class GMus0:
    cfg = ()
    api = Mobileclient()
    s0 = ()
    
    def config0(self, paths):
        self.cfg = ConfigParser.ConfigParser()
        self.cfg.read(paths)
        self.api.login(self.cfg.get('credentials', 'username'),
                       self.cfg.get('credentials', 'password'))
        return
    
    def __init__(self):
        self.config0(paths)
        return

    def in0(self, field, name):
        s1 = [ track for track in self.s0
               if name in track[field] ]
        
        logging.info("songs: filter: {0}".format(len(s1)))
        return s1
    
    def exact0(self, field, name):
        s1 = [ track for track in self.s0
               if track[field] == name ]
        
        logging.info("songs: filter: {0}".format(len(s1)))
        return s1
    
    def songs(self):
        self.s0 = self.api.get_all_songs()
        logging.info("songs: {0}".format(len(self.s0)))
        return self.s0

