## @file test0.py
# @author weaves
# @brief Controller script for GMus0TestCase
#
# This script is used within ipython on Emacs to perform interactive
# editing.
#
# Don't use a dedicated process for the GMus0TestCase when you send
# that buffer and then this buffer can be sent too.
# 
## @package gmusic
# The gmusic module is used for manipulating Google Play Music libraries.
# This is a sample script for use within ipython.
# @see GMus0TestCase

import unittest
import matplotlib.pyplot as plt
from GMus0TestCase import GMus0TestCase
from __future__ import print_function

# You can run these again, but you the object is emptied by the dispose method.

suite = unittest.TestLoader().loadTestsFromTestCase(GMus0TestCase)
unittest.TextTestRunner(verbosity=2).run(suite)

g0=GMus0TestCase.gmus0
print("g0.s0: {0}".format(g0.s0 is None))


