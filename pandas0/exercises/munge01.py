# @author weaves
# @brief Mungeing data.
#

import pandas as pd
from pandas import *

## A Series can be concat with others to form a data frame.

s1 = Series([0, 1], index=['a', 'b'])
s2 = Series([2, 3, 4], index=['c', 'd', 'e'])
s3 = Series([5, 6], index=['f', 'g'])

s4 = pd.concat([s1 * 5, s3])

pd.concat([s1, s4], axis=1)

pd.concat([s1, s4], axis=1, join='inner')

# You can use concat to stack()

result = pd.concat([s1, s1, s3], keys=['one', 'two', 'three'])

result.unstack()

## Reshaping

data = DataFrame(np.arange(6).reshape((2, 3)),
                 index=pd.Index(['Ohio', 'Colorado'], name='state'),
                 columns=pd.Index(['one', 'two', 'three'], name='number'))

# This now moves a column name to be an attribute.

data.stack()

## Pivoting

# You can pivot a data frame, so that records with the same key and
# a descriptive tag, can be pivoted so that the descriptive tag becomes
# a column.

## There's a pivot operator' .pivot()

## Binning

ages = [20, 22, 25, 27, 21, 23, 37, 31, 61, 45, 41, 32]

# Let’s divide these into bins of 18 to 25, 26 to 35, 35 to 60, and finally 60 and older. To do so, you have to use cut , a function in pandas:

bins = [18, 25, 35, 60, 100]
cats = pd.cut(ages, bins)

pd.value_counts(cats)

# evenly, and qcut by quantile

data = np.random.rand(20)
cats = pd.cut(data, 4, precision=2)

pd.value_counts(cats)

cats = pd.qcut(data, 4, precision=2)

pd.value_counts(cats)

## The describe method

np.random.seed(12345)
data = DataFrame(np.random.randn(1000, 4))
data.describe()

## Converting to indicator variables
# Being able to convert from text tag to a column with a 0|1 
# indicator can be useful - it's possible to migrate to matrix operations.

# get_dummies can do this.
# It returns a set of indicator vectors - elements set when present

df = DataFrame({'key': ['b', 'b', 'a', 'c', 'a', 'b'],
                'data1': range(6)})
pd.get_dummies(df['key'])

## Indicator variables
# This does the same thing, but uses a different approach.

mnames = ['movie_id', 'title', 'genres']
movies = pd.read_table('movies.dat',
                       sep='::', header=None, names=mnames)

# First, we get all the genres
# Nice use of the "splat" operator here.
# 'Unpacking Argument Lists' in the manual.
# It converts a list into a set of arguments for the function.

genre_iter = (set(x.split('|')) for x in movies.genres)
genres = sorted(set.union(*genre_iter))

# create a data frame with a column for each genre
# and a row for every film: filled with zeroes.
dummies = DataFrame(np.zeros((len(movies), len(genres))), columns=genres)

# Now, iterate through each movie and set entries in each row of dummies to 1:
# Nice use of .ix here we use the column names from the split of the genre.
for i, gen in enumerate(movies.genres):
    dummies.ix[i, gen.split('|')] = 1

# BTW: if you want to see the first of an enumeration use this
next(enumerate(movies.genres))

# Then join the matrices together.
movies_windic = movies.join(dummies.add_prefix('Genre_'))
movies_windic.ix[0]

## Regular expressions
# Support compilation. Split on fields found, and on separators.
# match marking: m.start and m.end
# Another useful feature added is support for dictionaries.

import re

regex = re.compile(r"""
                   (?P<username>[A-Z0-9._%+-]+)
                   @
(?P<domain>[A-Z0-9.-]+)
                   \.
(?P<suffix>[A-Z]{2,4})""", flags=re.IGNORECASE|re.VERBOSE)

m = regex.match('wesm@bright.net')
m.groupdict()

## Vectorized string operations
# Pandas supports many string operations on columns.
# match, get (at i), split, strip and so on.

import json

db = json.load(open('ch07/foods-2011-10-03.json'))
len(db)

# It's a typical JSON list of dictionaries.
# Each item is dict and each dict should have the same keys.

# The keys
db[0].keys()

# You can then see the list's descriptions like this
([x['description'] for x in db])[:10]

# Nutrients entry is more interesting. It is a long list of dictionaries.
# Each dictionary has similar keys.

db[0]['nutrients'][0]

# DataFrame will parse a JSON list of dicts

info_keys = ['description', 'group', 'id', 'manufacturer']
info = DataFrame(db, columns=info_keys)

pd.value_counts(info.group)[:10]

# Process the complicated nutrients in the following way
# Create a list of DataFrame, each is a nutrient record represented as
# a DataFrame. Add the id.
# Append to a list.
# After processing concatenate all the records together.

nutrients = []
for rec in db:
    fnuts = DataFrame(rec['nutrients'])
    fnuts['id'] = rec['id']
    nutrients.append(fnuts)

nutrients0 = pd.concat(nutrients, ignore_index=True)

# There are duplicates

nutrients0.duplicated().sum()
nutrients0.drop_duplicates()

# Name clashes with column names in the product info.

col_mapping = {'description' : 'food',
               'group' : 'fgroup'}
info = info.rename(columns=col_mapping, copy=False)

# Names clashes

col_mapping = {'description' : 'nutrient',
               'group' : 'nutgroup'}

nutrients1 = nutrients0.rename(columns=col_mapping, copy=False)

# Join in the product info to the nutrients - outer join.

ndata = pd.merge(nutrients1, info, on='id', how='outer')

# As an example: plot the Zinc distribution.
result = ndata.groupby(['nutrient', 'fgroup'])['value'].quantile(0.5)
result['Zinc, Zn'].order().plot(kind='barh')

# With a little cleverness, you can find which food is most dense in
# each nutrient:

by_nutrient = ndata.groupby(['nutgroup', 'nutrient'])
get_maximum = lambda x: x.xs(x.value.idxmax())
get_minimum = lambda x: x.xs(x.value.idxmin())
max_foods = by_nutrient.apply(get_maximum)[['value', 'food']]
# make the food a little smaller
max_foods.food = max_foods.food.str[:50]

max_foods.ix['Amino Acids']['food']
