## @file MInfoTestCase.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

import minfo 

import sys, logging, os
from unidecode import unidecode

from datetime import datetime, timezone, timedelta, date

from collections import Counter

from MediaInfoDLL3 import MediaInfo

import unittest

logging.basicConfig(filename='minfo.log', level=logging.DEBUG)
logger = logging.getLogger('MInfoTestCase')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for GMus0
#
# @see GMus0
class MInfoTestCase(unittest.TestCase):
    """
    Test MInfo
    """
    test0 = None
    gmus0 = None
    nums = [-1, 0, 1, 2, 3]
    dir0 = None
    files = []

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        cls.dir0 = os.environ['SDIR'] if os.environ.get('SDIR') is not None else './media' 
        
        for root, dirs, files in os.walk(cls.dir0, topdown=True):
            for name in files:
                cls.files.append(os.path.join(root, name))

        cls.files.sort()
        logger.info('files: ' + unidecode('; '.join(cls.files)))
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        self.file0, *MInfoTestCase.files = MInfoTestCase.files
        MInfoTestCase.test0 = minfo.MInfo(l0 = self.file0)
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_000(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        return

    def test_003(self):
        logger.info("encoding: " + sys.getfilesystemencoding())
        with self.assertRaises(UnicodeEncodeError):
            filename = 'filename\u4500abc'
            with open(filename, 'w') as f:
                f.write('blah\n')

        logger.info('No UTF-8')

    def test_01(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        str0 = MInfoTestCase.test0.info()
        logger.info(str0)
        return

    def test_02(self):
        format = "%a %b %d %H:%M:%S %Y"

        today = datetime.today()
        logger.info('ISO     :' + str(today))

        s = today.strftime(format)
        logger.info('strftime:' + s)

        d = today
        yday = d.toordinal() - date(d.year, 1, 1).toordinal() + 1
        logger.info('yday: ' + str(yday))

    
    def test_03(self):
        logger.info('test_03')
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        str0 = MInfoTestCase.test0.quality()
        logger.info('str0:' + self.file0 + "; " + str0)

        format0 = "%H:%M:%S.%f"
        d = datetime.strptime(str0, format0)
        logger.info('strptime:' + d.strftime(format0))

#
# The sys.argv line will complain to you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and "ipython" not in sys.argv[0]:
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='MInfoTestCase', verbosity=3, failfast=True, exit=False)
