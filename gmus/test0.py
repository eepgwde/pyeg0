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

if __name__ == '__main__':
    main()
    test0()


