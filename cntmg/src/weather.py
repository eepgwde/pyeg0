#!/usr/bin/env python
# coding: utf-8

# # Weather

# In[9]:


import pandas as pd
import numpy as np
import requests
import io

import sys, getopt


# In[10]:


url = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/cambridgedata.txt"


# In[11]:
def repl0(x):
    if x.endswith("*"):
        return x[:-1]
    return x

def main(argv, verbose=True):
    global url
    url0=url
    outf=None

    n = len(argv)

    if n >= 1:
        url0 = argv[0]
    if n >= 2:
        outf = argv[1]

    if verbose:
        print(n)
        print(url)
        print(url0)
        print(outf)

    return fweather(url=url0, outf=None)

def fweather(url=url, outf=None):
    """
    Given a URL from Met Office write a CSV file.

    Optional map of starred values.
    """
    notes = []

    if url is None:
        notes.append("no url")
        return notes

    if outf is None:
        outf = "weather.csv"

    s = requests.get(url).content
    cols = [ "yr", "mn", "tmax", "tmin", "af", "rain", "sun", "notes" ]

    c = pd.read_table(io.StringIO(s.decode("utf-8")), sep='\s+',
                      skiprows=8, names=cols, index_col=(0, 1), na_values="---")

    d=c.copy()
    cX = d.applymap(lambda x: x.endswith('*'), na_action="ignore")
    cX = cX.applymap( lambda x: ( x == True ))

    if cX.any().values.any():
        cX.to_csv("starred.csv")
        notes.append("starred.csv")

    c1 = d.applymap(lambda x: repl0(x), na_action="ignore")
    ncols = [ "tmax", "tmin", "af", "rain", "sun" ]

    itr = iter(ncols)
    while (x:=next(itr, None)) is not None:
        c1[x] = pd.to_numeric(c1[x])

    c1.dtypes

    c1.to_csv(outf)
    return notes

if __name__ == "__main__":
    main(sys.argv[1:])

