#!/usr/bin/env python

from setuptools import setup

setup(
    setup_requires=['pbr>=1.9', 'setuptools>=17.1'],
    install_requires=[
          'markdown',
          'unidecode',
          'cached-property',
    ],
    pbr=True,
)
