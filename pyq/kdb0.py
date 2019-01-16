## @author weaves
## @brief Connect to a remote server.

from pyq import q
from datetime import date

import random, time

## Use hsym then hopen

srv = q.hopen(q.hsym('::5016'))

## Use an exec operator passing the command string.
xtq = q('@', srv, "tq")

xtq.show()

## convert a column to a list and get first element.
l1 = list(xtq.size)
l1[0]

## Call a python function from q.

def f(x, y):
  return x + y

q('{[f]f(1;2)}', f)

## append to a python list

res0 = list()

def push0(x):
  res0.append(x)
  pass

## Start q port

## Define a function in q
cmd = """{[t;x]$[t~`trade;
  @[{tq,:x lj q};x;""];
  q,:select by sym from x]}
"""

q.upd = q(cmd)

q.tbls = q("`trade`quote")
q.s = q("`GOOG`IBM`MSFT")  # symbol selection

port0 = random.randint(8889, 65535)

q("\\p " + str(port0))

## Subscribe to a ticker plan
q.h = q.hopen(q.hsym('::5010'))

q.f0 = q('{ h(".u.sub";x;s) }')

## Oddly needs some time to post.
print("waiting")
time.sleep(5)

q.f0.each(q.tbls)

