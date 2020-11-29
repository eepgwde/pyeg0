"""
Demonstrates gensim
"""
## weaves

## Keyed tables

# This illustrates a typical operation. You have a set of records some have the same key
# but different values. You want a keyed table with a list against the key.

from helper import CorpOps

from collections import defaultdict

s = [('yellow', 1), ('blue', 2), ('yellow', 3), ('blue', 4), ('red', 1)]

d = defaultdict(list)
# the argument is the default factory, list - invoked as list() return an empty list.

for k, v in s:
  d[k].append(v)

d.items()

# The equivalent method is to use the setdefault() method in the regular dictionary.

d = {}                          # a regular dictionary
for k, v in s:
  d.setdefault(k, []).append(v)

d.items()

## Counting bags.

s = 'mississippi'
d = defaultdict(int)
# the constructor argument is int() which returns 0.
for k in s:
  d[k] += 1

d.items()

# This defaultdict is used to produce frequency counts and words that only appear once are
# removed. Then a corpora.Dictionary() is created.
# A corpora can produce a bag of words. This is a representation of a set of texts where
# each word is replaced by a unique identifier and each text is a set of the identifiers used.

i0 = CorpOps.instance(fname='mycorpus.txt')

t0 = i0.build()

j0 = next(iter(t0))

# There are then utilities to convert these bag of words to matrix formats
# and back.

# And then we can apply the TF-IDF Term Frequency and Inverse Document Frequency.

# And then Latent Semantic Indexing - constructs a two clause statement. Where
# each clause is a weighted sum of the proportions for each word. It may be
# that the clauses are present/not-present.

# Then an LSI can be constructed over that to simplify the choice of clauses.

# There's a Random Projection model.

