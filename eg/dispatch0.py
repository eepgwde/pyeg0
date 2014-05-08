## @file dispatch0.py
# @author weaves
# @brief Demonstrate extrinisc visitor pattern.
#
# The visitor pattern (or double dispatch) is well-known. In languages
# that support reflection you can use a single dispatch like this
# method.
#
# You can test this package on the command-line with
# <code>python dispatch0.py</code>
# 
# @note
# This implementation uses PEAK. And this can be loaded using the
# python-peak.rules packages. Guido van Nossum (Python originator)
# recommends multimethod. In the posting there is a mention of using
# decorators called @when. This version is similiar and uses a
# standard package.
#
# @note
# Python doesn't have function overloading. It is interpreted and
# loosely typed so the concept isn't applicable, so you can
# can achieve run-time overload resolution based on type (and other
# conditions) using these rules. It is probably a form of late-binding
# similar to that of SmallTalk and CLOS.
#
# @see
# www.artima.com/forums/flat.jsp?forum=106&thread=101605

from __future__ import print_function

from peak.rules import abstract, when, around, before, after

@abstract()
def pprint(ob):
  """A pretty-printing generic function"""

@when(pprint, (list,))
def pprint_list(ob):
  print("pretty-printing a list")

@when(pprint, "isinstance(ob,list) and len(ob)>=4")
def pprint_long_list(ob):
  print("pretty-printing a long list")

if __name__ == '__main__':
  pprint(['this', 'that', 'those'])
  pprint(['this', 'that', 'those', 'these'])
