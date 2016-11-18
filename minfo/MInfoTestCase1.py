## @file MInfoTestCase1.py
# @author weaves
# @brief Unittest of MInfo
#
# This module tests the ancillary operations and the 
# 
# @note
#
# Relatively complete test.

from MInfo1 import MInfo1
import sys, logging, os
from unidecode import unidecode

from datetime import datetime, timezone, timedelta, date

from collections import Counter

from MediaInfoDLL3 import MediaInfo

import unittest

logging.basicConfig(filename='minfo.log', level=logging.DEBUG)
logger = logging.getLogger('MInfoTestCase1')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for GMus0
#
# @see GMus0
class MInfoTestCase1(unittest.TestCase):
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
        self.file0, *MInfoTestCase1.files = MInfoTestCase1.files
        MInfoTestCase1.test0 = MInfo1(l0 = self.file0)
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_000(self):
        self.assertIsNotNone(MInfoTestCase1.test0)
        MInfoTestCase1.test0.open(self.file0)
        return

    def test_003(self):
        logger.info("encoding: " + sys.getfilesystemencoding())
        with self.assertRaises(UnicodeEncodeError):
            filename = 'filename\u4500abc'
            with open(filename, 'w') as f:
                f.write('blah\n')

        logger.info('No UTF-8')

    def test_01(self):
        self.assertIsNotNone(MInfoTestCase1.test0)
        MInfoTestCase1.test0.open(self.file0)
        str0 = MInfoTestCase1.test0.info()
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

        logger.info('dofy: ' + str(MInfo1.dofy(d)))

        format = "%H:%M:%S.%f"
        s = d.strftime(format)

        logger.info('time-today:' + s)

        hr0 = MInfo1.dofy(d) * 24 + d.hour
        s1 = "{0:02d}:{1:02d}:{2:02d}.{3:02d}".format(hr0, d.minute, d.second, int(d.microsecond / 1000))
        
        logger.info('time-today:' + s1)
        logger.info('time-today:' + MInfo1.dt2tm1(d) )
        return
    
    def test_03(self):
        logger.info('test_03')
        self.assertIsNotNone(MInfoTestCase1.test0)
        MInfoTestCase1.test0.open(self.file0)
        str0 = MInfoTestCase1.test0.quality()
        logger.info('str0:' + self.file0 + "; " + str0)

        format0 = "%H:%M:%S.%f"
        d = datetime.strptime(str0, format0)
        logger.info('strptime:' + d.strftime(format0))
        return

    def test_04(self):
        self.assertIsNotNone(MInfoTestCase1.test0)
        minfo = MInfoTestCase1.test0
        minfo.open(self.file0)
        str0 = minfo.quality()
        logger.info(str0)

        format0 = "%H:%M:%S.%f"
        d = datetime.strptime(str0, format0)
        logger.info('strptime:' + d.strftime(format0))
        t0 = datetime.time(d)
        logger.info('time:' + t0.isoformat())

        d0 = type(minfo).tm2dt(t0)
        logger.info('d0: ' + d0.isoformat())

        d1 = type(minfo).dtadvance(d0, t0)
        logger.info('d1: ' + d1.isoformat())
        d1 = type(minfo).dtadvance(d1, t0)
        logger.info('d1: ' + d1.isoformat())
        return

    def test_05(self):
        self.assertIsNotNone(MInfoTestCase1.test0)
        minfo = MInfoTestCase1.test0
        d = minfo.duration()
        logger.info("duration: " + d.isoformat())
        return
    
    def test_10(self):
        self.file0, *MInfoTestCase1.files = MInfoTestCase1.files
        minfo = MInfo1(self.file0)

        for f in MInfoTestCase1.files:
            logger.info("load: " + f)
            minfo.next(f)

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
        unittest.main(module='MInfoTestCase1', verbosity=3, failfast=True, exit=False)
