#!/usr/bin/env python3
# coding=utf-8
#
## @file Frctl0
# @author weaves
# @brief Frctl0
#
# CLI to Frctl itself an interface to MediaInterface

"""
An command-line stack and queue

Usage:
  lag (-h | --help)
  lag [-e PATTERN]... [-f FILTER]... [-F FILTER]... [options] [<input>]...

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

from lag import Stack, Queue

QUIET = 25
logging.addLevelName(25, "QUIET")


logging.basicConfig(filename='lag.log', level=QUIET)
logger = logging.getLogger('Frctl')
sh = logging.StreamHandler()
logger.addHandler(sh)

lag = None
cli = None

def main():
    global cli
    cli = dict((key.lstrip("-<").rstrip(">"), value)
               for key, value in docopt(__doc__).items())

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
        raise RuntimeError('a file of files is a required argument')

    if cli['command']:
        chapter(files)

    return

def chapter(files):
    global cli

    ## The new split operator
    h0, *t0 = files

    logger.info("files: " + unidecode('; '.join(t0)))

    stack0 = Stack()

    print(stack0.is_empty())

    for f in t0:
        if cli['dry-run']:
            logger.info("file: f: " + unidecode(f))
            continue
        stack0.push(f)

    print(stack0.size())
    print(stack0.is_empty())

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
