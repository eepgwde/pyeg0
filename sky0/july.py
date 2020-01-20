#!/usr/bin/env python
# coding: utf-8

# # Forecasting for July
# 
# Technical Challenge for Data Science Candidates
# 
# You want to forecast the “Outside Temperature” for the first 9 days of the next month.
# 
# Assume that:
# 
#   - The average temperature for each day of July is constant and equal to 25 degrees;
# 
#   - For the 1st of July, the pattern of the temperatures across the day with respect to the average temperature on that day is similar to the one found on 1st of June, for the 2nd of July is similar to the average on the 2nd of June, etc.
#   
# Produce a “.txt” file with your forecast for July (from 1st July to 9th July) with the sample values for each time for e.g. dd/mm/yyyy, Time, Outside Temperature.
# 
# ## Implementation
# 
# This is easier than it looks. There is some discussion of residuals in the other notebook, but if I apply ratio residuals (instead of absolute ones), then it is functionally the same as multiplying the day in June numbers by the ratio of the expected July average with the day in June average.
# 
# So, for example, if the average for a day in June is 16 degrees, then multiply the day's individual numbers by 22/16 = 1.375 and that gives you the predicted July values.

# In[265]:


import numpy as np
import pandas as pd

df1 = pd.read_pickle("200606.pkl")

## Filter down to first 9 days
ndays=9
tag = 'Outside Temperature'
cut0 = df1.dttm0.min().normalize() + pd.DateOffset(days=ndays)
df2 = df1[ df1['dttm0'] < cut0]
df3 = df2[['dttm0', 'dy0', tag]]


## Day averages in June

july0 = 22.0
m0 = df3.groupby('dy0')[tag].mean().to_frame()

m1 = (july0 / m0[tag]).to_frame()
m1.rename(columns={ tag: 'm1'}, inplace=True)


df4 = df3.merge(m1, on='dy0')
df4[tag] = df4[tag] * df4['m1']
df4['dttm0'] = df4['dttm0'] + pd.DateOffset(months=1)
df4['Date'] = df4['dttm0'].map(lambda x: x.date())
df4['Time'] = df4['dttm0'].map(lambda x: x.time())
df4.drop(columns=['dy0', 'm1', 'dttm0'], inplace=True)

df4.to_csv("q3.txt", columns=['Date', 'Time', tag], index=False, sep=' ')

