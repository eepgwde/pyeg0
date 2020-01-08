#!/usr/bin/env python
# coding: utf-8

# # Outside Temperature
# 
# Technical Challenge for Data Science Candidates. Prototyping for question 1.
# 
#   - a. What is the average time of hottest daily temperature (over month);
#   - b. What time of the day is the most commonly occurring hottest time;
#   - c. Which are the Top Ten hottest times on distinct days, preferably sorted by date order.
#   
# Sometimes, it difficult to interpret a metric if one doesn't know what it will be used for.
# 
# ## What is the average time of hottest daily temperature (over month)
# 
# "Time" could mean duration as well, then this would be interpreted differently as: how long does the maximum daily temperature persist. This would be a better indicator of the average temperature.
# 
# But the other questions suggest that "Time" means time-of-day. So the question can be interpreted as what is the usual time that the highest daily temperature occurs.
# 
# That is problematic. The same peak temperature could occur at two or more times of the day. And to make sure each day is equally weighted, we should choose just one time for the peak temperature on that day.
# 
# If we average the times for the peak temperatures on any one day. We must hope that each the peak temperature time-slots are contiguous. If they are not, it might be the hot-spots are 11am and 1pm, then the average time is 12pm, which would be wrong.
# 
# An inspection of the data suggests that contiguous periods are usual, so the method is relatively safe.
# 
# I've found the maximum temperature on each day. Found the times at which that occurred and averaged across the times.
# 
# Then I've averaged across all the days for the average monthly temperature.
# 
# ## What time of the day is the most commonly occurring hottest time
# 
# This is simpler to derive. This is the statistical mode and by comparison it shows that the average calculated previously is not inaccurate.
# 
# ## Which are the Top Ten hottest times on distinct days, preferably sorted by date order.
# 
# I've interpreted this as: for the ten distinct days that have the highest temperatures, find the times at which the daily maxima occur.
# 
# Because the maxima can occur in multiple time-slots, this means there are more than ten records.

import numpy as np
import pandas as pd

df0 = pd.read_csv("200606.csv", sep=",")

s0 = df0.Date.map(str) + " " + df0.Time.map(str)
s1 = pd.to_datetime(s0, format="%d/%m/%Y %H:%M")
df0['dttm0'] = s1
df0['m0'] = s1.map(lambda x:x.month)
df0['dy0'] = s1.map(lambda x:x.day)


s2 = df0['m0'].value_counts()
m1 = s2[s2 == max(s2)].index[0]

df1 = df0[df0['m0'] == m1]

df1.to_pickle("200606.pkl")

c0 = df1.columns
idx = c0.map(lambda x: x.startswith('Outside T'))
tag = c0[idx].values[0]


v0 = df1.groupby('m0')['m0'].sum()
v1 = df1.shape[0]

s3 = df1.groupby('dy0')[tag].max()
ef0 = pd.DataFrame(s3).reset_index()


ef1 = ef0.merge(df1, on=['dy0', tag])[['dy0', 'dttm0', tag]]
ef1['ddtm0'] = ef1['dttm0'].map(lambda x: x - x.normalize())


ef2 = ef1.groupby('dy0')['ddtm0'].mean(numeric_only=False)

ef3 = ef1[['dy0', 'dttm0', tag]]
ef3['date'] = ef3['dttm0'].map(lambda x: x.date())
ef4 = ef3.drop(['dttm0'], axis=1).drop_duplicates()
ef5 = ef4.merge(ef2, on='dy0')
ef5.rename(columns={'ddtm0': "Time Average", 'dy0': 'day-of-month'}, inplace=True)

str1 = "q1a: average time of hottest daily temperature of the month (ISO duration format):\n{}"
v0 = ef5['Time Average'].mean()

with open('q1.txt', 'w') as fl:
  fl.write(str1.format(v0.isoformat()))
  fl.write("\n")

ef5['hour'] = ef5['Time Average'].map(lambda x: x.total_seconds() / 60 / 60)

str1 = "q1b: times of the day that are the most commonly occurring hottest times:"

with open('q1.txt', 'a') as fl:
  fl.write(str1)

tdf0 = ef1['ddtm0'].mode().to_frame()
tdf0.to_csv("q1.txt", mode="a", index=False, sep=' ')

ef1['ddtm0'].value_counts().head()

## Top ten hottest times on distinct days
gp0 = ef5.groupby('date')[tag].max()
ef6 = gp0.to_frame().reset_index()

## Date has re-appeared as a string, so
s1 = pd.to_datetime(ef6['date'], format="%Y-%m-%d")
ef6['date'] = s1

ef1['date'] = ef1['dttm0'].map(lambda x: pd.Timestamp(x).normalize())
ff1 = ef1[['date', 'ddtm0']]

## Which are the Top Ten hottest times on distinct days, preferably sorted by date order.
# Not very clearly phrased, but I think it means for 10 distinct days, find the hottest times
ef7 = ef6.merge(ff1, on='date').sort_values(tag, ascending=False)

t10 = ef7['date'].to_frame().drop_duplicates()[:10]

# ## c. Which are the Top Ten hottest times on distinct days, preferably sorted by date order.

with open('q1.txt', 'a') as fl:
  fl.write("q1c: top ten hottest times on distinct days, preferably sorted by date order:")

tdf0 = ff1.merge(t10, on='date').sort_values('date')

tdf0.to_csv('q1.txt', mode='a', index=False, sep=' ')

