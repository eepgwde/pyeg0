## @file MInfoTestCase.py
# @author weaves
# @brief Unittest of MInfo
#
# This is a unittest class that can perform some useful work.
# 
# @note
#
# Relatively complete test.

from __future__ import print_function
from MInfo import MInfo
import sys, logging
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
    file0 = '01.The_best_is_yet_to_come.m4a'
    test0 = None
    gmus0 = None
    nums = [-1, 0, 1, 2, 3]

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        return
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        MInfoTestCase.test0 = MInfo(l0 = self.file0)
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Loaded?
    def test_00(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        return

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

        logger.info('dofy: ' + str(MInfo.dofy(d)))

        format = "%H:%M:%S.%f"
        s = d.strftime(format)

        logger.info('time-today:' + s)

        hr0 = MInfo.dofy(d) * 24 + d.hour
        s1 = "{0:02d}:{1:02d}:{2:02d}.{3:02d}".format(hr0, d.minute, d.second, int(d.microsecond / 1000))
        
        logger.info('time-today:' + s1)
        logger.info('time-today:' + MInfo.dt2tm1(d) )
        return
    
    def test_03(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        str0 = MInfoTestCase.test0.duration()
        logger.info(str0)

        format0 = "%H:%M:%S.%f"
        d = datetime.strptime(str0, format0)
        logger.info('strptime:' + d.strftime(format0))
        return

    def test_04(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        MInfoTestCase.test0.open(self.file0)
        str0 = MInfoTestCase.test0.duration()
        logger.info(str0)

        format0 = "%H:%M:%S.%f"
        d = datetime.strptime(str0, format0)
        logger.info('strptime:' + d.strftime(format0))
        t0 = datetime.time(d)
        logger.info('time:' + t0.isoformat())

        d0 = MInfo.tm2dt(t0)
        logger.info('d0: ' + d0.isoformat())

        d1 = MInfo.dtadvance(d0, t0)
        logger.info('d1: ' + d1.isoformat())
        d1 = MInfo.dtadvance(d1, t0)
        logger.info('d1: ' + d1.isoformat())
        return

    def test_05(self):
        self.assertIsNotNone(MInfoTestCase.test0)
        d = MInfoTestCase.test0.duration1()
        logger.info("duration1: " + d.isoformat())

        x0 = MInfoTestCase.test0.next(self.file0)
        logger.info("x0: " + '; '.join(x0))
        x0 = MInfoTestCase.test0.next(self.file0)
        logger.info("x0: " + '; '.join(x0))
        x0 = MInfoTestCase.test0.next(self.file0)
        logger.info("x0: " + '; '.join(x0))

        x0 = MInfoTestCase.test0.get()
        logger.info("x0: " + '; '.join(x0))
        
        x0 = MInfoTestCase.test0.reset()
        logger.info("x0: " + '; '.join(x0))

        x0 = MInfoTestCase.test0.get()
        logger.info("x0: " + '; '.join(x0))
        
        return

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
