## @file bt0Test.py
# @author weaves
# @brief Unittest of GMus0: removes older duplicates
#
# This is a unittest class that can perform some useful work.
# 
# Objects of GMus0 are used to load the songs data.
#
# @note
# Python modules are imported wholesale with the import name
# matching the file name. (And you can use a directory.filename). But
# if you want the class within the module, you need to use the from
# file import class.

from __future__ import print_function

from Bt0 import Bt0
from Bt1 import Bt1

import sys, logging
import pandas as pd
from collections import Counter

import unittest

## A test driver for Bt0
#
# @see Bt0
class bt0Test(unittest.TestCase):
    """
    A test driver for Bt0. If the file songs.json exists, then this class will
    not try to a login.
    """
    # If this file exists, we do not login.
    file0 = '/home/weaves/Downloads/archive/Copy/outgoing1/50 years BBC2 Comedy.torrent'
    files0 = 'fls.lst'
    bt0 = None
    s1 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        pd.set_option('display.height', 1000)
        pd.set_option('display.max_rows', 500)
        pd.set_option('display.max_columns', 500)
        pd.set_option('display.max_colwidth', 80)
        pd.set_option('display.width', 1000)
        logging.basicConfig(filename='bt0.log', level=logging.DEBUG)
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        if bt0Test.bt0 is None:
            return
        bt0Test.bt0.dispose()

    ## Null setup.
    def setUp(self):
        logging.info('setup')
        if not(Bt0.is_valid(self.files0)):
            return
        f0 = open(self.files0, "r");
        self.s1 = f0.readlines()

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')

    ## Login or load from file.
    def test_00(self):
        bt0Test.bt0 = Bt0(self.file0)
        self.assertIsNotNone(bt0Test.bt0)

    ## List songs.
    def test_01(self):
        bt0Test.bt0.read(self.file0)

    ## Login or load from file.
    def test_10(self):
        bt0Test.bt0 = Bt1(None)
        self.assertIsNotNone(bt0Test.bt0)

    ## List songs.
    def test_11(self):
        self.assertIsNotNone(self.file0)
        bt0Test.bt0.read(self.file0)

    def test_12(self):
        if self.s1 == None:
            return

        for self.file0 in self.s1:
            self.file0 = self.file0.rstrip()
            logging.debug("file: %s" % self.file0)
            self.test_11()
        return

# The sys.argv line will complain you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and not(sys.argv[0].endswith("ipython")):
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='bt0Test', verbosity=3, failfast=True, exit=False)
