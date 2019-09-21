## weaves

## Keyed tables

# This illustrates a typical operation. You have a set of records some have the same key
# but different values. You want a keyed table with a list against the key.

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


