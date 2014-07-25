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

from xml.sax.saxutils import escape
import logging
from os.path import basename
from sys import stderr

from lxml import etree

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

    def item(self, item0, path):
        file_length = item0['length']
        child = etree.Element('file', length=str(file_length))
        child.text = ''
        try:
            path = unicode(path, "utf-8")
            child.text = escape(path)
        except:
            logging.debug("except: {0} {1}".format(len(path), path))

        self.root.append(child)
        return

    root = None;

    def display(self):
        """
        XML output
        """
        # create XML 
        self.root = etree.Element('torrent')

        if self.info.has_key('length'):
            self.item(self.info, self.info['name'])
        else:
            # let's assume we have a directory structure
            d0 = self.info['name']
            n0 = len(self.info['files'])
            logging.debug("%s: %d".format(d0, n0))
            for file in self.info['files']:
                path = d0;
                for item in file['path']:
                    if len(item) <= 0: continue
                    path = path + "/" + item

                self.item(file, path)

        # pretty string
        s = etree.tostring(self.root, pretty_print=True)
        print(s, file=stderr)
        return

    def dispose(self):
        self.s0 = None
        return
