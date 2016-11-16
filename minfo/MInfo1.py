#!/usr/bin/env python3
# coding=utf-8
#
## @file MInfo1.py
# @author weaves
# @brief MInfo1
#
# Wrapper module

"""
An upload script for Google Music using https://github.com/simon-weber/gmusicapi.
More information at https://github.com/thebigmunch/gmusicapi-scripts.

Usage:
  gmupload (-h | --help)
  gmupload [-e PATTERN]... [-f FILTER]... [-F FILTER]... [options] [<input>]...

Arguments:
  input                                 Files, directories, or glob patterns to upload.
                                        Defaults to current directory.

Options:
  -h, --help                            Display help message.
  -c CRED, --cred CRED                  Specify oauth credential file name to use/create. [Default: oauth]
  -U ID --uploader-id ID                A unique id given as a MAC address (e.g. '00:11:22:33:AA:BB').
                                        This should only be provided when the default does not work.
  -l, --log                             Enable gmusicapi logging.
  -m, --match                           Enable scan and match.
  -d, --dry-run                         Output list of songs that would be uploaded.
  -q, --quiet                           Don't output status messages.
                                        With -l,--log will display gmusicapi warnings.
                                        With -d,--dry-run will display song list.
  --delete-on-success                   Delete successfully uploaded local files.
  -R, --no-recursion                    Disable recursion when scanning for local files.
                                        This is equivalent to setting --max-depth to 0.
  --max-depth DEPTH                     Set maximum depth of recursion when scanning for local files.
                                        Default is infinite recursion.
                                        Has no effect when -R, --no-recursion set.
  -e PATTERN, --exclude PATTERN         Exclude file paths matching a Python regex pattern.
  -f FILE, --files FILE                 File containing files.
  -F FILTER, --exclude-filter FILTER    Exclude local songs by field:pattern filter (e.g. "artist:Muse").
                                        Songs can match any filter criteria.
                                        This option can be set multiple times.
  -a, --all-includes                    Songs must match all include filter criteria to be included.
  -A, --all-excludes                    Songs must match all exclude filter criteria to be excluded.

Patterns can be any valid Python regex patterns.
"""

import logging
import os
import sys

from docopt import docopt

from MInfo import MInfo

QUIET = 25
logging.addLevelName(25, "QUIET")

logger = logging.getLogger('MInfo1')
sh = logging.StreamHandler()
logger.addHandler(sh)


def main():
    cli = dict((key.lstrip("-<").rstrip(">"), value) for key, value in docopt(__doc__).items())

    enable_logging = cli['log']

    if cli['quiet']:
        logger.setLevel(logging.QUIET)
    else:
        logger.setLevel(logging.INFO)

    for k in cli.items():
        logger.info(k)
        
    files = []
    if cli['files']:
        x0 = cli['files']
        logger.info('files: ' + type(x0).__name__)
        with open(x0[0], encoding="utf-8") as f:
            files = f.read().splitlines()

    logger.info("files: " + '; '.join(files))

    minfo = MInfo()

    logger.info("\nAll done!")

if __name__ == '__main__':
    main()
