#!/usr/bin/env python3
# coding=utf-8
#
## @file MInfo0
# @author weaves
# @brief MInfo0
#
# CLI to MInfo itself an interface to MediaInterface

"""
An upload script for Google Music using https://github.com/simon-weber/gmusicapi.
More information at https://github.com/thebigmunch/gmusicapi-scripts.

Usage:
  minfo (-h | --help)
  minfo [-e PATTERN]... [-f FILTER]... [-F FILTER]... [options] [<input>]...

Arguments:
  input                                 Files, directories, or glob patterns to upload.
                                        Defaults to current directory.

Options:
  -h, --help                            Display help message.
  -l, --log                             Enable gmusicapi logging.
  -d, --dry-run                         Output list of songs that would be uploaded.
  -q, --quiet                           Don't output status messages.
                                        With -l,--log will display warnings.
                                        With -d,--dry-run will parameters.
  -f FILE, --files FILE                 File containing files.
  -c COMMAND, --command COMMAND         What to do: chapters

Patterns can be any valid Python regex patterns.
"""

import logging, os, sys, re

from unidecode import unidecode
from docopt import docopt

from MInfo1 import MInfo1

QUIET = 25
logging.addLevelName(25, "QUIET")

logging.basicConfig(filename='minfo.log', level=QUIET)
logger = logging.getLogger('MInfo')
sh = logging.StreamHandler()
logger.addHandler(sh)

minfo = None
cli = None

def main():
    global cli
    cli = dict((key.lstrip("-<").rstrip(">"), value) for key, value in docopt(__doc__).items())

    enable_logging = cli['log']

    if cli['quiet']:
        logger.setLevel(QUIET)
    else:
        logger.setLevel(logging.INFO)

    if enable_logging:
        logger.setLevel(logging.DEBUG)

    for k in cli.items():
        logger.info(k)
        
    files = []
    if cli['files']:
        x0 = cli['files']
        logger.info('files: ' + type(x0).__name__)
        with open(x0[0], encoding="utf-8") as f:
            files = f.read().splitlines()

    if len(files) <= 0:
        raise RuntimeError('files is a required argument')

    if cli['command']:
        chapter(files)

    return

def chapter(files):
    global cli

    ## The new split operator
    h0, *t0 = files

    logger.info("files: " + unidecode('; '.join(t0)))

    minfo = MInfo1(l0 = h0, delegate0="duration2")

    for f in t0:
        if cli['dry-run']:
            logger.info("file: f: " + unidecode(f))
            continue
        x0 = minfo.next(f)
        for x in x0:
            print(x)

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
