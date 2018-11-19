#!/usr/bin/env python
# coding: utf-8

# weaves
# 
# Rough working: pyvote and Bell Ordinal number calculation

# In[1]:

import os
import datetime

import numpy as np

import scipy.special as scis
from functools import partial
from itertools import permutations, combinations, chain
import string

from weaves import POSetOps
from pyvote import VoteOps

from py3votecore.plurality import PluralityAtLarge
from py3votecore.stv import STV, Quota
from py3votecore.schulze_by_graph import SchulzeMethodByGraph, SchulzeNPRByGraph

# Generate data
input = {
    ('a', 'b'): 4,
    ('b', 'a'): 3,
    ('a', 'c'): 4,
    ('c', 'a'): 3,
    ('b', 'c'): 4,
    ('c', 'b'): 3,
}
judge0 = SchulzeMethodByGraph(input)
output = judge0.as_dict()
output

# Run tests
""" self.assertEqual(output, {
    'candidates': set(['a', 'b', 'c']),
    'pairs': input,
    'strong_pairs': {
        ('a', 'b'): 4,
        ('a', 'c'): 4,
        ('b', 'c'): 4,
    },
    'winner': 'a',
})

"""
""" 3 voters preferring candidate A to B to C
    1 voter preferring candidate B to C to A
    1 voter preferring candidate C to A to B
    1 voter preferring candidate C to B to A

input = {
    ('a', ('b', 'c')): 3,
    ('b', 'c', 'a'): 1,
    ('c', 'a', 'b'): 1,
    ('c', 'b', 'a'): 1,
}
judge0 = SchulzeMethodByGraph(input)
output = judge0.as_dict()
output
"""

# In[16]:

judge0.graph

# In[17]:

def graph_winner(self):
    losing_candidates = set([edge[1] for edge in self.graph.edges()])
    winning_candidates = set(self.graph.nodes()) - losing_candidates
    if len(winning_candidates) == 1:
        self.winner = list(winning_candidates)[0]
    elif len(winning_candidates) > 1:
        self.tied_winners = winning_candidates
        self.winner = self.break_ties(winning_candidates)
    else:
        self.condorcet_completion_method()
            
    return self

# In[18]:

from pygraph.algorithms.accessibility import accessibility, mutual_accessibility
from pygraph.algorithms.traversal import traversal
from pygraph.classes.digraph import digraph

def build(candidates, edges=None):
    graph = digraph()
    graph.add_nodes(candidates)

    if edges is None:
        return graph

    for pair in edges:
        graph.add_edge(pair, 1)
    return graph

d0 = POSetOps.instance().sym2basis('ABC')
d1 = POSetOps.instance().adjacency(d0)

# In[18]:

edges = d1['e']

g0 = build(d1['n'], edges=edges)

# In[18]:

d0 = POSetOps.instance().sym2basis('ABC')
d1 = POSetOps.instance().adjacency(d0)
d2 = POSetOps.instance().remap(d1)

g1 = build(d2['nodes'].values(), edges=d2['edges'])

d2

# get neighbours

g1 = VoteOps.instance().build(syms='ABC', remap0=True)

n0 = g1.nodes()[0]
print([ x for x in g1[n0] ])



for n in g1.nodes():
    print("node: {} ; neighbours: {}".format(n, [x for x in g1[n]]))

print(list(traversal(g1, g1.nodes()[0], 'pre')))

# In[18]:

graph_winner(judge0)

# In[19]:

judge0.winner

# In[21]:

type(judge0)

# In[24]:

judge0.graph.nodes()

# In[25]:

judge0.graph.edges()

# In[ ]:

from math import sin, cos, pi

# How to use a generic function object.
# Like Scala, you have o send it to the interpreter in two phases.

class Calc0(object):
    def __init__(self, f):
        self.f = f

    def __call__(self, x):
        return self.f(x)

f0 = lambda x: rand()

calc = Calc0(f0)

calc(1)


