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

## BitTorrent
#
# The class needs to find a configuration file with these contents.
#
class Bt1(object):
    """
    The XML class as a functor.
    """

    root = None;

    def __init__(self, file0):
        self.root = etree.Element('torrent')
        return

    def item(self, item0, path):
        if item0 is None:
            return

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

    tfile = stderr

    def print_(self, s):
        """
        Locale print to file
        """
        logging.debug("tfile: ".format(type(self.tfile)))
        s = etree.tostring(self.root, pretty_print=True)
        print(s, file=self.tfile)
        return

    def display(self):
        """
        XML output
        """
        # create XML 
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
        self.print_(s)
        return

    def dispose(self):
        self.s0 = None
        return
