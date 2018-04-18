#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
# Test that I passed on codility.com for TopTal company
#

import numpy as np

# Task #1
def binary_gap(N):
    '''
    A binary gap within a positive integer N is any maximal
    sequence of consecutive zeros that is surrounded by ones
    at both ends in the binary representation of N.

    Args:
      - N: integer within the range [1..2,147,483,647]
    '''
    bin_representation = bin(N)[2:]
    max_gap = 0
    gap_counter = 0
    gap_started = False
    for symbol in bin_representation:
        if symbol == '1':
            if gap_counter > max_gap:
                max_gap = gap_counter
            gap_counter = 0
            gap_started = True
        elif gap_started:
            gap_counter += 1
    return max_gap

print(binary_gap(1041))


def bvec(N):
    '''
    Create a binary array of type integer representing the number
    '''
    return [int(x) for x in bin(N)[2:]]

neg0 = lambda a: 0 if (a > 0) else 1

a0 = [ 1, 0, 0, 1, 0, 0]

h0 = a0
t0 = list(map(neg0, h0))



def bgap(N):
    '''
    Returns the binary gap

    The largest sequence of zeroes between two ones in the binary representation of 
    an integer.
    '''
    x0=bvec(N)
    if sum(x0) < 2:            # we need at least two ones.
        return 0
    x1=list(map(neg0, x0))
    # This doesn't work if the ones are adjacent.
    xs=np.array_split(np.array(x1), np.nonzero(array(x0))[0])
    return max([ sum(x) for x in xs ])


# Task #2
def count_div(A, B, K):
    '''
    Returns the number of integers within the range [A..B] that are divisible by K.

    Used generators to save memory on large amounts of data.

    Args:
      - A: is an integer within the range [0..2,000,000,000]
      - B: is an integer within the range [0..2,000,000,000] and A <= B
      - K: is an integer within the range [1..2,000,000,000]
    '''
    divs_count = 0
    for x in range(A, B + 1):
        if (x % K) == 0:
            divs_count += 1
    return divs_count

print(count_div(1, 200000000, 1000))


# Task #3
def triangle(A):
    '''
    Calculate triangle of integers, where a tuple of numbers P, Q, R
    correspond to next rules:
     - P + Q > R
     - Q + R > P
     - R + P > Q

    Args:
      - A: list of integers, where we will search triangle

    Return: 1 - if triangle exists, and 0 - otherwise
    '''
    A = tuple(enumerate(A))
    for p, P in A:
        for q, Q in A[p + 1:]:
            for r, R in A[q + 1:]:
                if (P + Q > R) and (Q + R > P) and (R + P > Q):
                    return 1 
    return 0

print(triangle([10, 2, 5, 1, 8, 20]))

t0 = lambda p,q,r: 1 if (p+q>r) else 0

def ttest0(p,q,r):
    return t0(p,q,r) * t0(q,r,p) * t0(r, p, q)


a0 = [1, 3, 6, 4, 1, 2]
print(min(a0))

def solution(A):
    # write your code in Python 3.6
    A = [ x for x in A if x > 0]
    if len(A) <= 0:
        return 1
    if len(A) == 1 & A[0] == 1:
        return 2
    if len(A) == 1:
        return 1
    
    min0=min(A)
    max0=max(A)
    r0=list(range(min0, max0+1))
    if set(A) == set(r0):
        return 1
    d0=list(set(r0) - set(A))
    if min(d0) > 1:
        return 1
    return(min(d0))

def solution1(A):
    # write your code in Python 3.6
    A = [ x for x in A if x > 0]
    if len(A) <= 0:
        return 1
    if len(A) == 1 & A[0] == 1:
        return 2
    if len(A) == 1:
        return 1
    
    min0=min(A)
    max0=max(A)
    r0=list(range(min0, max0+1))
    if set(A) == set(r0):
        return 1
    d0=list(set(r0) - set(A))
    if 1 not in d0:
        return 1
    return(min(d0))
