#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Script for installing the model.

To install, run:

    python setup.py install

"""

# Modified from https://github.com/pypa/sampleproject/blob/master/setup.py

from setuptools import setup, find_packages

from codecs import open
from os import path
import sys


if sys.argv[-1] == 'setup.py':
    print("To install hankshaw, run 'python setup.py install'\n")

if sys.version_info[:2] < (2, 7):
    print("hankshaw requires Python 2.7 or later (%d.%d detected)." % sys.version_info[:2])
    sys.exit(-1)


here = path.abspath(path.dirname(__file__))

setup(
    name='hankshaw',
    version='2.0.0',
    description='Model for The Evolution of Cooperation by the Hankshaw Effect',
    long_description='Simulation model described and used in The Evolution of Cooperation by the Hankshaw Effect. In each simulation, a metapopulation of populations grow and evolve.',
    url='https://github.com/briandconnelly/hankshaweffect',
    author='Brian D. Connelly',
    author_email='bdc@bconnelly.net',
    license='BSD',

    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.4',
        'Intended Audience :: Science/Research',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Artificial Life',
        'License :: OSI Approved :: BSD License'
    ],

    # What does your project relate to?
    keywords='evolution simulation metapopulation',

    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=find_packages(exclude=['contrib', 'docs', 'tests*']),

    install_requires=['numpy==1.21.0', 'networkx==1.10', 'configobj==5.0.6'],

    extras_require={},
    package_data={},
    data_files=[],

    include_package_data=True,

    # To provide executable scripts, use entry points in preference to the
    # "scripts" keyword. Entry points provide cross-platform support and allow
    # pip to create the appropriate form of executable for the target platform.
    entry_points={
        'console_scripts': [
            'hankshaw=hankshaw.cmd_script:main',
        ],
    },
)

