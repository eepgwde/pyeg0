#!/usr/bin/env python
# $Id$

from setuptools import setup

setup(
    setup_requires=['pbr>=1.9', 'setuptools>=17.1'],
    install_requires=[
          'markdown',
	  'python3-vote-core',
	  'python-graph-core>=1.8.0',
    ],
    pbr=True,
)
