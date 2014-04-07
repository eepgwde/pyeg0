"""
@author weaves
@brief Removing older duplicates
"""

import logging
import GMus0

gmus0 = ()

def main():
    global gmus0
    logging.basicConfig(filename='gmus.log', level=logging.INFO)
    logging.info('Started')
    gmus0 = GMus0.GMus0()
    logging.info('Finished')

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

if __name__ == '__main__':
    main()
    test0()
    test1()
    test2()


