#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import datetime
import getpass
import os
import shutil
import signal
import sys
from time import time
from uuid import uuid4
from warnings import warn

from configobj import ConfigObj, ConfigObjError, flatten_errors
from validate import Validator

import networkx as nx
import numpy as np

import hankshaw

from hankshaw.Metapopulation import Metapopulation
from hankshaw.misc import write_run_information, append_run_information


def parse_arguments():
    """Parse command line arguments"""

    parser = argparse.ArgumentParser(prog='hankshaw',
                                     description='Run a simluation')
    parser.add_argument('--config', '-c', metavar='FILE', help='Configuration '\
                        'file to use', dest='configfile', default=None)
    parser.add_argument('--checkconfig', '-C', action='store_true',
                        default=False,
                        help='Check the given configuration file and quit (note: includes parameters specified with --param)')
    parser.add_argument('--genconfig', '-G', metavar='FILE',
                        help='Generate a configuration file with default values and quit (note: includes parameters specified with --param)')
    parser.add_argument('--data_dir', '-d', metavar='DIR',
                        help='Directory to store data (default: data)')
    parser.add_argument('--param', '-p', nargs=3, metavar=('SECTION', 'NAME',
                                                           'VALUE'),
                        action='append', help='Set a parameter value')
    parser.add_argument('--seed', '-s', metavar='S', help='Set the '\
                        'pseudorandom number generator seed', type=int)
    parser.add_argument('--quiet', '-q', action='store_true', default=False,
                       help='Suppress output messages')
    parser.add_argument('--version', action='version', version=hankshaw.__version__)

    args = parser.parse_args()

    return args


def main():
    start_time = time()

    cfgspec = os.path.join(hankshaw.__path__[0], 'configspec-v1.ini')

    # Get the command line arguments
    args = parse_arguments()

    if args.genconfig:
        if os.path.exists(args.genconfig):
            print("Error: File '{f}' already exists.".format(f=args.genconfig))
            sys.exit(1)

        config = ConfigObj(infile=args.genconfig, create_empty=True,
                           configspec=cfgspec)
        config.validate(Validator(), copy=True)
        config.write()
        print("Created configuration file '{f}'".format(f=args.genconfig))
        sys.exit(0)

    # Read the configuration file
    try:
        require_config = args.configfile is not None or args.checkconfig
        config = ConfigObj(infile=args.configfile,
                           configspec=cfgspec,
                           file_error=require_config)
    except (ConfigObjError, OSError, IOError) as e:
        print("Error: {e}".format(e=e))
        sys.exit(1)

    # Validate the configuration (this time, just copy in any missing values)
    validation = config.validate(Validator(), copy=True)


    # Add any parameters specified on the command line to the configuration
    if args.param:
        for p in args.param:
            config[p[0]][p[1]] = p[2]

    # Validate the modified configuration
    validation = config.validate(Validator(), copy=True)

    if validation != True:
        errors = flatten_errors(config, validation)
        print("Found {n} error(s) in configuration:".format(n=len(errors)))
        for (section_list, key, _) in errors:
            if key is not None:
                print("\t* Invalid value for '{k}' in Section '{s}'".format(k=key, s=section_list[0]))
            else:
                print("\t* Missing required section '{s}'".format(s=section_list[0]))

        sys.exit(2)

    if args.checkconfig:
        print("No errors found in configuration file '{f}'".format(f=args.configfile))
        sys.exit(0)

    # If the random number generator seed specified, add it to the config,
    # overwriting any previous value. Otherwise, if it wasn't in the
    # supplied configuration file, create one.
    if args.seed:
        config['Simulation']['seed'] = args.seed
    elif config['Simulation']['seed'] == 0:
        seed = np.random.randint(low=0, high=np.iinfo(np.uint32).max)
        config['Simulation']['seed'] = seed

    np.random.seed(seed=config['Simulation']['seed'])

    # Generate a universally unique identifier (UUID) for this run
    config['Simulation']['UUID'] = str(uuid4())


    # If the data directory is specified, add it to the config, overwriting any
    # previous value
    if args.data_dir:
        config['Simulation']['data_dir'] = args.data_dir


    # If the data_dir already exists, append the current date and time to
    # data_dir, and use that. Afterwards, create the directory.
    if os.path.exists(config['Simulation']['data_dir']):
        newname = '{o}-{d}'.format(o=config['Simulation']['data_dir'],
                                   d=datetime.datetime.now().strftime("%Y%m%d%H%M%S"))
        msg = '{d} already exists. Using {new} instead.'.format(d=config['Simulation']['data_dir'],
                                                                new=newname)
        warn(msg)
        config['Simulation']['data_dir'] = newname

    os.mkdir(config['Simulation']['data_dir'])


    # Write the configuration file
    config.filename = os.path.join(config['Simulation']['data_dir'], 'run.cfg')
    config.write()


    # Write information about the run
    infofile = os.path.join(config['Simulation']['data_dir'], 'info.txt')
    write_run_information(filename=infofile, config=config)


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
    for t in range(config['Simulation']['cycles']):
        m.cycle()

        if not args.quiet:
            msg = "[{t}] {m}".format(t=t, m=m)
            print(msg)

        if config['Simulation']['stop_when_empty'] and m.size() == 0:
            break

    m.write_logfiles()
    m.cleanup()

    rt_string = 'Run Time: {t}\n'.format(t=datetime.timedelta(seconds=time()-start_time))
    append_run_information(filename=infofile, string=rt_string)


if __name__ == "__main__":
    main()

