## @file GMus0TestCase.py
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
from GMus0 import GMus0
import sys, logging
import pandas as pd
from collections import Counter

import unittest

## A test driver for GMus0
#
# @see GMus0
class GMus0TestCase(unittest.TestCase):
    """
    A test driver for GMus0. If the file songs.json exists, then this class will
    not try to a login.
    """
    # If this file exists, we do not login.
    file0 = 'all-songs.json'
    gmus0 = None
    s1 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        pd.set_option('display.max_rows', 500)
        pd.set_option('display.max_columns', 500)
        pd.set_option('display.max_colwidth', 80)
        pd.set_option('display.width', 1000)
        logging.basicConfig(filename='gmus.log', level=logging.DEBUG)
        cls.gmus0 = GMus0(cls.file0)
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        cls.gmus0.dispose()

    ## Null setup.
    def setUp(self):
        logging.info('setup')

    ## Null setup.
    def tearDown(self):
        logging.info('tearDown')

    ## Login or load from file.
    ## Test singledispatch1 methods.
    def test_00(self):
        self.assertIsNotNone(GMus0TestCase.gmus0)
        self.assertIsNotNone(GMus0TestCase.gmus0.add(1,2))
        x0 = GMus0TestCase.gmus0.add(1,2)
        logging.info('add: ' + str(x0) )
        x0 = GMus0TestCase.gmus0.add("1", "2")
        logging.info('add: ' + x0 )

    ## List songs.
    def test_01(self):
        self.assertIsNotNone(GMus0TestCase.gmus0)
        GMus0TestCase.gmus0.songs()
        self.assertNotEqual(len(GMus0TestCase.gmus0.s0), 0, 'no songs')
        GMus0TestCase.gmus0.write('all-songs.json')
        ## This is broken
        # self.assertEqual(len(GMus0TestCase.gmus0.s0),
        #   len(GMus0TestCase.gmus0.df), 'data-frame invalid')

    ## All these are broken.
    
    ## Check that artist is BBC Radio
    # Show that the data-frame is a dynamic property based on s0.
    def test_02(self):
        GMus0TestCase.gmus0.s0 = GMus0TestCase.gmus0.in0('artist', "BBC Radio")
        self.assertNotEqual(len(GMus0TestCase.gmus0.s0), 0, 'no songs')
        logging.info('s0: ' + str(len(GMus0TestCase.gmus0.s0[0])))
        logging.info('df: ' + str(len(GMus0TestCase.gmus0.df)))
        self.assertEqual(len(GMus0TestCase.gmus0.s0[0]),
                         len(GMus0TestCase.gmus0.df), 'data-frame invalid')
        return

    ## Check that composer is iPlayer
    def test_03(self):
        GMus0TestCase.gmus0.s0 = \
        GMus0TestCase.gmus0.exact0('album_artist', 'BBC Radio')
        self.assertNotEqual(len(GMus0TestCase.gmus0.s0[0]), 0,
                            'no songs')

    ## Test write and read.
    def test_04(self):
        ns0 = len(GMus0TestCase.gmus0.s0)
        GMus0TestCase.gmus0.write('songs.json')
        GMus0TestCase.gmus0.read('songs.json')
        ns1 = len(GMus0TestCase.gmus0.s0)
        self.assertEqual(ns0, ns1, "not equal")

    ## List duplicates and write to file.
    def test_05(self):
        GMus0TestCase.s1 = GMus0TestCase.gmus0.duplicated()
        self.assertTrue(len(GMus0TestCase.s1)>0)
        GMus0TestCase.gmus0.write('dsongs.json', GMus0TestCase.s1)

    ## Get indices from file.
    def test_06(self):
        GMus0TestCase.s1 = GMus0TestCase.gmus0.indices('dsongs.json')
        self.assertTrue(len(GMus0TestCase.gmus0.s0)>0)

    ## Filter based on indices
    def test_07(self):
        i0 =  GMus0TestCase.gmus0.indices('dsongs.json')
        GMus0TestCase.s0 = GMus0TestCase.gmus0.load('dsongs.json',
                                                   source='all-songs.json')
        self.assertEqual(len(GMus0TestCase.gmus0.s0), len(i0))

# The sys.argv line will complain you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and not(sys.argv[0].endswith("ipython")):
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='GMus0TestCase', verbosity=3, failfast=True, exit=False)
