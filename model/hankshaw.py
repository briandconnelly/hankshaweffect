#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import datetime
import getpass
import os
import shutil
import signal
import sys
import warnings

try:
    from ConfigParser import SafeConfigParser
except ImportError:
    from configparser import SafeConfigParser

import networkx as nx
import numpy as np

from Metapopulation import Metapopulation

__version__ = '1.0.5'

def parse_arguments():
    """Parse command line arguments"""

    parser = argparse.ArgumentParser(prog='hankshaw.py',
                                     description='Run a simluation')
    parser.add_argument('--config', '-c', metavar='FILE', help='Configuration '\
                        'file to use (default: run.cfg)', default='run.cfg',
                        dest='configfile', type=argparse.FileType('r'))
    parser.add_argument('--data_dir', '-d', metavar='DIR',
                        help='Directory to store data (default: data)')
    parser.add_argument('--param', '-p', nargs=3, metavar=('SECTION', 'NAME',
                                                           'VALUE'),
                        action='append', help='Set a parameter value')
    parser.add_argument('--seed', '-s', metavar='S', help='Set the '\
                        'pseudorandom number generator seed', type=int)
    parser.add_argument('--quiet', '-q', action='store_true', default=False,
                       help='Suppress output messages')
    parser.add_argument('--version', action='version', version=__version__)

    args = parser.parse_args()

    return args


def main():
    # Get the command line arguments
    args = parse_arguments()

    # Read the configuration file
    config = SafeConfigParser()
    config.readfp(args.configfile)
    args.configfile.close()

    # Add any parameters specified on the command line to the configuration
    if args.param:
        for p in args.param:
            config.set(section=p[0], option=p[1], value=p[2])

    # If the random number generator seed specified, add it to the config,
    # overwriting any previous value. Otherwise, if it wasn't in the
    # supplied configuration file, create one.
    if args.seed:
        config.set(section='Simulation', option='seed', value=str(args.seed))
    elif config.has_option(section='Simulation', option='seed') is not True:
        seed = np.random.randint(low=0, high=np.iinfo(np.uint32).max)
        config.set(section='Simulation', option='seed', value=str(seed))

    # Set the seed for the pseudorandom number generator
    if config.has_option(section='Simulation', option='seed'):
        np.random.seed(seed=config.getint(section='Simulation', option='seed'))


    # If the data directory is specified, add it to the config, overwriting any
    # previous value
    if args.data_dir:
        config.set(section='Simulation', option='data_dir', value=args.data_dir)

    if config.has_option(section='Simulation', option='data_dir'):
        data_dir = config.get(section='Simulation', option='data_dir')
    else:
        config.set(section='Simulation', option='data_dir', value='data')
        data_dir = 'data'


    # If the data_dir already exists, append the current date and time to
    # data_dir, and use that. Afterwards, create the directory.
    if os.path.exists(data_dir):
        newname = '{o}-{d}'.format(o=data_dir,
                                   d=datetime.datetime.now().strftime("%Y%m%d%H%M%S"))
        msg = '{d} already exists. Using {new} instead.'.format(d=data_dir,
                                                                new=newname)
        warnings.warn(msg)

        data_dir = newname
        config.set(section='Simulation', option='data_dir', value=data_dir)

    os.mkdir(data_dir)

    # Write the configuration file and some additional information
    cfg_out = os.path.join(data_dir, 'configuration.cfg')
    with open(cfg_out, 'w') as configfile:
        configfile.write('# Hankshaw Effect Model Configuration\n')
        configfile.write('# Generated: {when} by {who}\n'.format(when=datetime.datetime.now().isoformat(),
                                                                 who=getpass.getuser()))
        configfile.write('# hankshaw.py version: {v}\n'.format(v=__version__))
        configfile.write('# Python version: {v}\n'.format(v= ".".join(map(str, sys.version_info[:3]))))
        configfile.write('# NumPy version: {v}\n'.format(v=np.version.version))
        configfile.write('# NetworkX version: {v}\n'.format(v=nx.__version__))
        configfile.write('# Command: {cmd}\n'.format(cmd=' '.join(sys.argv)))
        configfile.write('# {line}\n\n'.format(line='-'*77))
        config.write(configfile)


    # Create and initialize the metapopulation
    m = Metapopulation(config=config)


    # Print a status message when SIGINFO (ctrl-T) is received on BSD or
    # OS X systems or when SIGUSR1 is received on POSIX systems
    def handle_siginfo(signum, frame):
        print("Cycle {c}: Size {ps}, {pc:.0%} cooperators".format(c=m.time, ps=m.size(), pc=m.prop_producers()))

    signal.signal(signal.SIGUSR1, handle_siginfo)
    if hasattr(signal, 'SIGINFO'):
        signal.signal(signal.SIGINFO, handle_siginfo)


    # Run the simulation
    for t in range(config.getint(section='Simulation', option='num_cycles')):
        m.cycle()

        if not args.quiet:
            msg = "[{t}] {m}".format(t=t, m=m)
            print(msg)

        if config.getboolean(section='Simulation', option='stop_when_empty') == True and m.size() == 0:
            break

    m.cleanup()


if __name__ == "__main__":
    main()

