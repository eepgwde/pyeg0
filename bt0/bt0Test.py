## @file bt0Test.py
# @author weaves
# @brief Unittest of Bt0
#
# This is a unittest class it can perform some useful work.
# 
# @note
# Python modules are imported wholesale with the import name
# matching the file name. (And you can use a directory.filename). But
# if you want the class within the module, you need to use the from
# file import class.

from __future__ import print_function

from Bt0 import Bt0
from BtXml import BtXml

import sys, logging

import unittest

## A test driver for Bt0
#
# @see Bt0
class bt0Test(unittest.TestCase):
    """
    A test driver for Bt0.
    """
    # If this file exists, we do not login.
    file0 = '/home/weaves/Downloads/archive/Copy/outgoing1/50 years BBC2 Comedy.torrent'
    # List of files to process
    files0 = 'fls.lst'
    bt0 = None
    s1 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        logging.basicConfig(filename='bt0.log', level=logging.DEBUG)
    
    ## Finish
    @classmethod
    def tearDownClass(cls):
        if bt0Test.bt0 is None:
            return
        bt0Test.bt0.dispose()

    ## Null setup: load any files
    def setUp(self):
        logging.info('setup')
        if not(Bt0.is_valid(self.files0)):
            return
        f0 = open(self.files0, "r");
        self.s1 = f0.readlines()

    ## Clear up.
    def tearDown(self):
        logging.info('tearDown')

    ## Test constructor.
    def test_00(self):
        bt0Test.bt0 = Bt0(None)
        self.assertIsNotNone(bt0Test.bt0)
        bt0Test.bt0.read(self.file0)

    ## List contents.
    def test_01(self):
        self.assertIsNotNone(self.file0)
        bt0Test.bt0.read(self.file0)
        f0 = BtXml(self.file0, suffix0=".txt")
        bt0Test.bt0.iterate(f0.txt0)
        return

    def test_02(self):
        if self.s1 == None:
            return

        for self.file0 in self.s1:
            self.file0 = self.file0.rstrip()
            logging.debug("file: %s" % self.file0)
            self.test_01()
        return

    ## Test constructor for Bt1.
    def test_10(self):
        bt0Test.bt0 = Bt0(None)
        self.assertIsNotNone(bt0Test.bt0)
        bt0Test.bt0.read(self.file0)

    ## List contents in XML.
    def test_11(self):
        self.assertIsNotNone(self.file0)
        bt0Test.bt0.read(self.file0)
        f0 = Bt1(self.file0)
        bt0Test.bt0.iterate(f0.xml0)
        self.assertIsNotNone(f0.root)
        f0.print_(None)
        return

    def test_12(self):
        if self.s1 == None:
            return

        for self.file0 in self.s1:
            self.file0 = self.file0.rstrip()
            logging.debug("file: %s" % self.file0)
            self.test_11()
        return

    ## Locate
    def test_20(self):
        bt0Test.bt0 = Bt0(None)
        self.assertIsNotNone(bt0Test.bt0)
        bt0Test.bt0.read(self.file0)

    ## List contents in XML.
    def test_21(self):
        self.assertIsNotNone(self.file0)
        bt0Test.bt0.read(self.file0)
        f0 = BtXml(self.file0, src0=bt0Test.bt0.cfg.get("sources", "source"))
        bt0Test.bt0.iterate(f0.locate)
        self.assertIsNotNone(f0.root)
        return

    ## List contents in XML.
    def test_22(self):
        if self.s1 == None:
            return

        for self.file0 in self.s1:
            self.file0 = self.file0.rstrip()
            logging.debug("file: %s" % self.file0)
            self.test_21()
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
