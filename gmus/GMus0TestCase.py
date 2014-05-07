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

from GMus0 import GMus0
import sys, logging
import pandas as pd
from collections import Counter

import unittest

class GMus0TestCase(unittest.TestCase):
    file0 = 'songs.json'
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

    def tearDown(self):
        logging.info('tearDown')

    def test_00(self):
        GMus0TestCase.gmus0 = GMus0(self.file0)
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

# The sys.argv line will complain you if you run it with ipython
# emacs. The ipython arguments are passed to unittest.main.

if __name__ == '__main__':
    if len(sys.argv) and not(sys.argv[0].endswith("ipython")):
        # If this is not ipython, run as usual
        unittest.main(sys.argv)
    else:
        # If not remove the command-line arguments.
        sys.argv = [sys.argv[0]]
        unittest.main(module='GMus0TestCase', exit=False)    
