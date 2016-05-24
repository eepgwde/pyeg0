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
import tempfile
import os.path 
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
    tfile = stderr

    def __init__(self, file0, dir0=None, src0=None):
        file1 = file0
        if file0 is None:
            file0 = "Unknown"

        if dir0 is None:
            dir0 = os.getcwd()

        if not(src0 is None):
            self.src0 = src0

        file0 = os.path.basename(file0)
        file0 = Bt1.sweeten(file0)
        self.root = etree.Element('torrent', name=file0)

        if file1 is None:
            return

        if not(src0 is None):
            return

        self.tfile = tempfile.NamedTemporaryFile(suffix='.xml',
                                                 prefix=file0,
                                                 dir=dir0,
                                                 delete=False)
        return

    @classmethod
    def sweeten(cls, s):
        try:
            s = unicode(s, "utf-8")
            s = escape(s)
        except:
            logging.debug("except: {0} {1}".format(len(s), s))
            s = ''
            
        return s

    def locate(self, item0, path):
        if item0 is None:
            return

        t0 = '/'.join([self.src0, path])
        if not(os.path.exists(t0)):
            print(t0, file=self.tfile)
        return

    def xml0(self, item0, path):
        if item0 is None:
            return

        file_length = item0['length']
        child = etree.Element('file', length=str(file_length))
        child.text = Bt1.sweeten(path)

        self.root.append(child)
        return

    def print_(self, s):
        """
        Locale print to file
        """
        logging.debug("tfile: ".format(type(self.tfile)))
        s = etree.tostring(self.root, xml_declaration=True,
                           encoding='utf-8', pretty_print=True)
        print(s, file=self.tfile)
        return

    def dispose(self):
        self.s0 = None
        return
