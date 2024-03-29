# Model for "The Evolution of Cooperation by the Hankshaw Effect"

This folder contains the source code for the model, which is maintained as a Python package named [`hankshaw`](https://pypi.python.org/pypi/hankshaw/).


## Installing the Model

`hankshaw` is maintained in the [Python Package Index](https://pypi.python.org/pypi). The most recent version of the model and its dependencies can be installed by running:

```python
pip install hankshaw
```

Specific versions of the model can be given:

```python
pip install hankshaw==2.0.0
```


### Installing in a Virtual Environment

To ensure consistency, each release of the model requires specific versions of its dependencies.
Because these versions may differ from what you have on your machine, we recommend installing the model and its dependencies into a virtual environment.

Using [virtualenv](https://virtualenv.pypa.io/en/latest/), first create the virtual environment into a folder (we'll use *virtualhankshaw*):

```sh
virtualenv --python=python2.7 virtualhankshaw
```

We can then enter that environment by running the `activate` script:

```sh
source virtualhankshaw/bin/activate
```

Finally, we'll install `hankshaw` into the virtual environment as done above:

```python
pip install hankshaw
```


## Dependiencies

* Python - 2.7.10 was used for the paper, 3.4 and above are supported
* [NumPy](http://www.numpy.org) - 1.10.1 used for the paper
* [NetworkX](https://networkx.github.io/) - 1.10 used for the paper


When installing `hankshaw` using `pip`, as described above, these dependencies are automatically installed if needed.

Otherwise, dependencies can be installed using:

```sh
pip install numpy networkx configobj
```


## Running the Model

Simulations are run using the `hankshaw` command. When no arguments are supplied, the base conditions described in the paper are used. To see what options can be provided, run `hankshaw` with the `--help` argument:

```sh
python hankshaw --help
```

```
usage: hankshaw [-h] [--config FILE] [--checkconfig] [--genconfig FILE]
                [--data_dir DIR] [--param SECTION NAME VALUE] [--seed S]
                [--quiet] [--version]

Run a simluation

optional arguments:
  -h, --help                 show this help message and exit
  --config FILE, -c FILE     Configuration file to use
  --checkconfig, -C          Check the given configuration file and quit (note: includes parameters specified with --param)
  --genconfig FILE, -G FILE  Generate a configuration file with default values and quit (note: includes parameters specified with --param)
  --data_dir DIR, -d DIR     Directory to store data (default: data)
  --param SECTION NAME VALUE, -p SECTION NAME VALUE
                             Set a parameter value
  --seed S, -s S             Set the pseudorandom number generator seed
  --quiet, -q                Suppress output messages
  --version                  show program's version number and exit
```

### Configuration

One or more parameter values can be set using the `--param` argument. For example, to run a simulation for 200 cycles in which individuals have genomes with 5 loci:

```sh
hankshaw --param Simulation cycles 200 --param Population genome_length 5
```

Otherwise, a configuration file can be specified with the `--config` option:

```sh
hankshaw --config wellmixed.cfg
```

When pairing `--config` with `--param`, parameter values specified in the configuration file are replaced by the value specified with `--param`.

To generate a configuration file that contains all parameters and their base values (we'll call it *myconfig.cfg*), use the `--genconfig` option:

```sh
hankshaw --genconfig myconfig.cfg
```


## Result Data

Output from simulations is placed in the `data` directory. This directory contains:

* `run.cfg`: A configuration file that contains all parameter values used for this simulation as well as the seed used for the random number generator. This file allows a simulation to be repeated exactly.
* `run_info.txt`: Information about the simulation and the computer on which it was run

In addition, the `data` directory may contain the following result data files depending on the configuration:

* `metapopulation.csv`: Population-level information including cooperator proportion and fitness (configured in the `MetapopulationLog` section)
* `population.csv`: Subpopulation-level information including cooperator proportion and fitness (configured in the `PopulationLog` section)
* `fitness.csv`: Fitness values for cooperators and defectors (configured in the `FitnessLog` section)
* `genotypes.csv`: Each genotype present in the population, its abundance, and whether or not individuals are cooperators (configured in the `GenotypeLog` section)
* `environmental_change.csv`: Whether or not an environmental change event occurred at that time point (configured in the `EnvChangeLog` section)
* `topology.gml`: The topology that determines migration among subpopulations in [Graph Modelling Language](https://en.wikipedia.org/wiki/Graph_Modelling_Language) format


### Compression

By default, output data are compressed with [bzip2](http://bzip.org) to reduce file size.
This can be configured for each output file via the `compress` option.

