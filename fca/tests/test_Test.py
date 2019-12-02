## @file Test.py
# @author weaves
# @brief Unittest
#
# @note
#

from fca import Utility

import sys, logging, os

import pandas as pd

import unittest

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for rvlt
#
# @see rvlt
class Test(unittest.TestCase):
    """
    Test MInfo
    """
    test0 = None

    df0 = None
    i0 = None

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        fl2 = 'stats.pickle'
        df = pd.read_pickle(fl2)
        df[df.select_dtypes(['object']).columns] = df.select_dtypes(['object']).apply(lambda x: x.astype('category'))
        cls.df0 = df
        cls.i0 = Utility.instance()
        pass
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup. Create a new one.
    def setUp(self):
        logger.info('setup')
        return

    ## Null setup.
    def tearDown(self):
        logger.info('tearDown')
        return

    ## Loaded?
    ## Is utf-8 available as a filesystemencoding()
    def test_000(self):
        self.assertIsNotNone(self.df0)
        self.df0.info()
        self.assertIsNotNone(self.i0)
        return

    def test_002(self):
        df = self.i0.simplify0(self.df0)
        df.info()
        return

    def test_004(self):
        print(next(self.i0.seq0()))
        print(next(self.i0.seq0()))
        return

    def test_006(self):
        fmt = lambda t0: "x cache/bak/cpta-{:02d}.csv".format(t0)

        print(next(self.i0.seq0(fmt=fmt)))
        print(next(self.i0.seq0(fmt=fmt)))
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
        unittest.main(module='Test', verbosity=3, failfast=True, exit=False)
