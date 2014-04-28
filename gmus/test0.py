## @file test0.py
# @author weaves
# @brief Unittest of GMus0: removes older duplicates
#
# This is a unittest class that can perform some useful work.
# 
## @package gmusic
# Documentation for this module.
#
# More details.

import GMus0
import sys, logging
import pandas as pd
from collections import Counter

import unittest

class GMus0TestCase(unittest.TestCase):
    file0 = None
    gmus0 = None
    s1 = None

    @classmethod
    def setUpClass(cls):
        pd.set_option('display.height', 1000)
        pd.set_option('display.max_rows', 500)
        pd.set_option('display.max_columns', 500)
        pd.set_option('display.max_colwidth', 80)
        pd.set_option('display.width', 1000)
        logging.basicConfig(filename='gmus.log', level=logging.DEBUG)
    
    @classmethod
    def tearDownClass(cls):
        GMus0TestCase.gmus0.dispose()
    
    def setUp(self):
        logging.info('setup')
        if len(sys.argv) > 1:
            self.file0 = sys.argv[1]

    def tearDown(self):
        logging.info('tearDown')

    def test_00(self):
        GMus0TestCase.gmus0 = GMus0.GMus0(self.file0)
        self.assertIsNotNone(GMus0TestCase.gmus0)

    def test_01(self):
        GMus0TestCase.gmus0.songs()
        self.assertNotEqual(len(GMus0TestCase.gmus0.s0), 0,
                            'no songs')

    def test_02(self):
        GMus0TestCase.gmus0.s0 = GMus0TestCase.gmus0.in0('artist', "BBC Radio")
        self.assertNotEqual(len(GMus0TestCase.gmus0.s0), 0,
                            'no songs')
        return

    def test_03(self):
        GMus0TestCase.gmus0.s0 = GMus0TestCase.gmus0.exact0('composer', 'BBC iPlayer')
        self.assertNotEqual(len(GMus0TestCase.gmus0.s0), 0,
                            'no songs')

    def test_04(self):
        GMus0TestCase.gmus0.write('songs.json')
        GMus0TestCase.gmus0.read('songs.json')

    def test_05(self):
        GMus0TestCase.s1 = GMus0TestCase.gmus0.duplicated()
        self.assertTrue(len(GMus0TestCase.s1)>0)
        GMus0TestCase.gmus0.write('dsongs.json', GMus0TestCase.s1)
        
    def test_06(self):
        GMus0TestCase.s1 = GMus0TestCase.gmus0.indices('dsongs.json')
        self.assertTrue(len(GMus0TestCase.gmus0.s0)>0)
        
if __name__ == '__main__':
    unittest.main(sys.argv)
