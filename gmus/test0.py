"""
@author weaves
@brief Removing older duplicates
"""

import GMus0
import sys, logging
import pandas as pd
from collections import Counter

import unittest

gmus0 = None
s1 = None

class GMus0TestCase(unittest.TestCase):
    file0 = 'songs.json'
    gmus0 = None

    @classmethod
    def setUpClass(cls):
        pd.set_option('display.height', 1000)
        pd.set_option('display.max_rows', 500)
        pd.set_option('display.max_columns', 500)
        pd.set_option('display.max_colwidth', 80)
        pd.set_option('display.width', 1000)
        logging.basicConfig(filename='gmus.log', level=logging.DEBUG)
    
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

if __name__ == '__main__':
    unittest.main(sys.argv)
