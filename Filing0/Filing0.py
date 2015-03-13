## @file Filing0
# @brief Processing CSV files.
# @author weaves
#
# @details
# This class uses no special API.
#
# @note
#
# @see
# 

from __future__ import print_function

import logging

import random
import numpy as np
import pandas as pd
from pandas import *

class Filing0(object):
    """Given a file handle, apply some filtering to it.

    Designed to be run within a web-server - see Django.  The
    web-server handler for the URL would support upload, ie. a PUT and
    this class would be passed a file (or stringbuffer posing as a
    file) containing a CSV file in the constructor. A Pandas DataFrame
    is constructed.

    The object supports a set of filtering calls.

    filter1: filters the columns based on the value of a field called
    "decision" when it is set (or not.)

    ranges0: calculates the min (or max) for each column given the
    dataframe after filtering.

    filter2: removes those rows where the decision is reset and the
    value in each column is outside the range for that column.

    In summary, filter1 filters when 'decision' is set. filter2
    filters using the results of ranges0 and operates on rows where
    'decision' is reset.

    """
    # Values that may be returned by next_num()

    _filename = ''
    _df = None

    # This constructor will do for testing.
    # Read directly from file.
    def __init__(self, filename0):
        if filename0 == None:
            return

        self._filename = filename0
        self._df = read_csv(self._filename)

        # TODO: RAiI: Integrity checks
        # does it have a column called decision?
        # non-empty
        # at least one row marked as decision 0, one as 1.

        return

    def dispose(self):
        pass
