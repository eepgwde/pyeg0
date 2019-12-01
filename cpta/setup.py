#!/usr/bin/env python
# $Id$

from setuptools import setup

setup(
    setup_requires=['pbr>=1.9', 'setuptools>=17.1'],
    install_requires=[
          'markdown'
    ],
    data_files=[('extra', ['cache/out', 'tests']), ('notebooks', ['*.ipynb']) ],
    pbr=True,
)
