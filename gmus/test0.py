"""
@author weaves
@brief Removing older duplicates
"""

import logging
import GMus0
import sys
import pandas as pd

from collections import Counter

gmus0 = ()
s1 = ()

def test0():
    global gmus0
    gmus0.songs()
    print gmus0.s0[0]

def test1():
    global gmus0
    gmus0.s0 = gmus0.in0('artist', "BBC Radio")
    print gmus0.s0[0]

def test2():
    global gmus0
    gmus0.s0 = gmus0.exact0('composer', 'BBC iPlayer')
    print gmus0.s0[0]

def test3():
    global gmus0, s1
    s1 = gmus0.occurs0('title')

def main(args):
    global gmus0
    logging.basicConfig(filename='gmus.log', level=logging.DEBUG)
    logging.info('Started')
    file0 = 'songs.json'
    if len(args) > 1:
        file0 = args[1]
    gmus0 = GMus0.GMus0(file0)
    if len(gmus0.s0) > 0:
        test3()
    else:
        test0()
        test1()
        test2()
        gmus0.write(file0)

    logging.info('Finished')

if __name__ == '__main__':
    main(sys.argv)

