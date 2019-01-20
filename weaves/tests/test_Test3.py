## @file Test3.py
# @author weaves
# @brief Unittest of MCast
#
# This module tests the basic operations
# 
# @note
#
# Relatively complete test.

from weaves import MCast, Enqueue

import sys
import logging
import os
import string
import asyncio
import queue

import unittest

logging.basicConfig(filename='test.log', level=logging.DEBUG)
logger = logging.getLogger('Test')
sh = logging.StreamHandler()
logger.addHandler(sh)

## A test driver for MCast
class Test3(unittest.TestCase):
    """
    Test
    """

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
    def test_01(self):
        s0 = MCast.instance().make(socket="mcast")
        logger.info("type: " + type(s0).__name__)

    def test_03(self):
        s0 = MCast.instance().make(socket="mcast")
        logger.info("type: " + type(s0).__name__)

        loop = asyncio.get_event_loop()
        loop.set_debug(True)

        queue0 = queue.Queue();
        listen = loop.create_datagram_endpoint(
            lambda: Enqueue(loop, queue0),
            sock=s0,
        )
        transport, protocol = loop.run_until_complete(listen)

        loop.run_forever()
        loop.close()

    def test_05(self):
        """
        Preferences
        """


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
        unittest.main(module='Test3', verbosity=3, failfast=True, exit=False)
