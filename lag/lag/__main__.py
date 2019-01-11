#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
Redact words from document

Usage:
  lag (-h | --help)
  lag [options] <filename1> <filename2>

Arguments:
  filename1                             A text file of words and phrases, one per line.
  filename2                             A text file with text to be redacted.

Options:
  -h, --help                            Display help message.
  -l, --log                             Enable logging.
  -d, --dry-run                         Output options and files
  -q, --quiet                           Don't output status messages.
  --tmp DIR                             Pass this directory to use for 
                                        temporary files (otherwise use TMPDIR and then TMP)
  -v, --verbose                         Output status messages.
                                        With -l,--log will display warnings.
                                        With -d,--dry-run will show parameters.

Commands:

 Redacts words

Note:

 The document file can process large files. The file is processed in 10 MByte blocks.

"""

from lag import Part, Redact

from docopt import docopt

import os
import sys
import glob

import logging

QUIET = 25
logging.addLevelName(25, "QUIET")
logging.basicConfig(filename='redacter.log', level=QUIET)
global logger
logger = logging.getLogger('Test')

def main():
    global cli
    global logger

    argv = sys.argv
    
    cli = dict((key.lstrip("-<").rstrip(">"), value) for key, value in docopt(__doc__).items())

    enable_logging = cli['log']
    if cli['quiet']:
        logger.setLevel(QUIET)
    else:
        logger.setLevel(logging.INFO)

    if enable_logging:
        logger.setLevel(logging.DEBUG)
        if cli['verbose']:
            sh = logging.StreamHandler()
            logger.addHandler(sh)
        logger.debug('cli: ' + type(cli).__name__)

    redr0 = Redact(filename=cli['filename2'])
    part0 = Part(filename=cli['filename1'])

    for lines in part0:
        lines1 = redr0.apply(lines)
        print(lines1)
