import logging
import ConfigParser, os, logging
import pandas as pd
import json

from gmusicapi import Mobileclient

paths = ['site.cfg', os.path.expanduser('~/etc/gmusic.cfg')]
  
class GMus0:
    cfg = ()
    api = Mobileclient()
    s0 = ()
    df = ()
    
    def config0(self, paths):
        self.cfg = ConfigParser.ConfigParser()
        self.cfg.read(paths)
        self.api.login(self.cfg.get('credentials', 'username'),
                       self.cfg.get('credentials', 'password'))
        return

    def is_valid(self, fpath):
        logging.debug("fpath: {0}; {1} {2}".
                      format(fpath, os.path.isfile(fpath),
                             (os.path.getsize(fpath) if os.path.isfile(fpath) else 0) ))
        return (os.path.isfile(fpath) and (os.path.getsize(fpath) > 0))
    
    def __init__(self, file0):
        if file0 != None and self.is_valid(file0):
            self.read(file0)
            return
            
        self.config0(paths)
        return

    def dispose(self):
        self.api.logout()
        self.s0 = None

    def write(self, file0):
        with open(file0, 'w') as outfile:
            json.dump(self.s0, outfile, sort_keys = True, indent = 4,
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
        
        logging.info("songs: filter: {0}".format(len(s1)))
        return s1
    
    def exact0(self, field, name):
        s1 = [ track for track in self.s0
               if track[field] == name ]
        
        logging.info("songs: filter: {0}".format(len(s1)))
        return s1

    def occurs0(self, field):
        s1 = dict([ (t['id'], "{0}|{1}".format(t['album'], t[field])) for t in self.s0 ])
        logging.info("songs: occurs: {0}".format(len(s1)))
        return s1
    
    def songs(self):
        self.s0 = self.api.get_all_songs()
        logging.info("songs: {0}".format(len(self.s0)))
        return self.s0

    def delete(self, file0):
        with open(file0, 'rb') as infile:
            d0 = json.load(infile)
        logging.info("delete: {0}: {1}".format(file0, len(d0)))
        self.api.delete_songs(d0)
        return
    
