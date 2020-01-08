#!/usr/bin/env python
# coding: utf-8

# # Hi- and Low- Temperature
# 
# Technical Challenge for Data Science Candidates
# 
# Using the ‘Hi Temperature’ values produce a “.txt” file containing all of the Dates and Times
# where the “ Hi Temperature” was within +/- 1 degree of 22.3 or the “ Low Temperature ” was
# within +/- 0.2 degree higher or lower of 10.3 over the first 9 days of June
# 
# ## Implementation
# 
# This is a very clear task. 
# 
# I've used a pickle of the data file with a few extra columns.
# 
# I used some date arithmetic for the first 9 days.
# 
# I've used a wrapper object for the bounds that also holds the column name as tag.
# 
# And I've used numpy operators for performance.

import numpy as np
import pandas as pd

df1 = pd.read_pickle("200606.pkl")

## Filter down to first 9 days
ndays=9
cut0 = df1.dttm0.min().normalize() + pd.DateOffset(days=ndays)
df2 = df1[ df1['dttm0'] < cut0]


## A bag to make invoking the functions easier.
class Range0:
    def __init__(self, b0, n0, tag):
        self.b = b0
        self.l = b0 - n0
        self.u = b0 + n0
        self.tag = tag
        
    def __str__(self):
        return "{} {} {} {}".format(self.b, self.l, self.u, self.tag)

## Set-up the bags
u0 = Range0(22.3, 1, 'Hi Temperature')
l0 = Range0(10.3, 0.2, 'Low Temperature')

## using numpy is faster
def extract0(df, r0):
    x0 = df[r0.tag].values
    return np.logical_and(x0 < r0.u, x0 > r0.l)

# So this is relatively fast and simple to invoke
df3 = df2.iloc[np.where(np.logical_or(extract0(df2, u0), extract0(df2, l0)))]

df3.to_csv("q2.txt", columns=['Date', 'Time'], index=False, sep=' ')


