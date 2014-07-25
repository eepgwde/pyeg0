#! /usr/bin/python

# Written by Henry 'Pi' James and Loring Holden
# see LICENSE.txt for license information

from __future__ import print_function
from sys import *
from os.path import *
from sha import *
from BitTorrent.bencode import *

from Bt0 import Bt0

from lxml import etree

NAME, EXT = splitext(basename(argv[0]))
VERSION = '20021207'

print('%s %s - decode BitTorrent metainfo files' % (NAME, VERSION))
print()

if len(argv) == 1:
    print('%s file1.torrent file2.torrent file3.torrent ...' % argv[0])
    exit(2) # common exit code for syntax error

bt0 = Bt0

bt0.read(argv[1])

exit(0)
