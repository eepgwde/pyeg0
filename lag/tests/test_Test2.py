"""
Test file 

"""
## @file Test2.py
# @author weaves
# @brief Unittest
#
# @note
#
# Relatively complete test.

import sys, logging, os

import unittest

from lag import Part

logfile = os.environ['X_LOGFILE'] if os.environ.get('X_LOGFILE') is not None else "test.log"
logging.basicConfig(filename=logfile, level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

trs0 = os.path.join(os.path.dirname(__file__), "test.txt")

class Test2(unittest.TestCase):
    """
    A source directory dir0 is taken from the environment as SDIR or 
    is tests/media and should contain .m4a files.
    A file tests/p1.lst is also needed. It can list the files in the
    directory.
    """
    queue0 = None

    dir0 = os.getcwd()
    files0 = []
    files = []
    logger = None
    x0 = "empty"

    ## Sets pandas options and logging.
    @classmethod
    def setUpClass(cls):
        global logger
        cls.logger = logger
        cls.logger.info('files: ' + trs0)
    
    ## Logs out.
    @classmethod
    def tearDownClass(cls):
        pass

    ## Null setup.
    def setUp(self):
        self.logger.info('setup')

    ## Null tear down
    def tearDown(self):
        self.logger.info('tearDown')

    ## Constructs
    def test_000(self):
        nbytes=1000
        self.p0 = Part(filename=trs0, nbytes=nbytes)
        self.assertIsNotNone(self.p0)
        self.assertEqual(self.p0.nbytes, nbytes)

    ## Check empty responses
    ## Call prior
    def test_001(self):
        self.test_000()
        it0 = self.p0
        cnt = 0
        for l0 in it0:
            cnt += len(l0)
            self.logger.info('nlines: ' + str(cnt) + "; " + l0[0])

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


