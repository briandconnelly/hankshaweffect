# Hankshaw Effect Model

## Dependiencies

* Python 2.7
* [NumPy](http://www.numpy.org) 1.8.0 or later
* [NetworkX](https://networkx.github.io/)

These dependencies can be installed in a modern Python environment using:       
                                                                                
```sh
pip install numpy networkx
```


## Running the Model

Simulations using this model are run using the `hankshaw.py` script. To see what options can be provided to `hankshaw.py`, run it with the `--help` argument:

```sh
python hankshaw.py --help
```
```
usage: hankshaw.py [-h] [--config FILE] [--data_dir DIR]
                     [--param SECTION NAME VALUE] [--seed S] [--quiet]
                     [--version]

Run a simluation

optional arguments:
-h, --help            show this help message and exit
--config FILE, -c FILE
Configuration file to use (default: run.cfg)
--data_dir DIR, -d DIR
Directory to store data (default: data)
--param SECTION NAME VALUE, -p SECTION NAME VALUE
Set a parameter value
--seed S, -s S        Set the pseudorandom number generator seed
--quiet, -q           Suppress output messages
--version             show program's version number and exit

```

## Configuring the Model

The parameters for the model are specified in the `run.cfg` file. Alternate
configuration files can be used with the `--config` argument to
`hankshaw.py`:

```sh
python hankshaw.py --config other_config.cfg
```

Additionally, parameter values can be set from the command line with the
`--param` argument. For example, to use the configuration `run.cfg`, but
set the simulation to run for 10 cycles:

```sh
python hankshaw.py --param Simulation num_cycles 10
```

## Result Data

The model produces the following data files, which are placed in the `data` directory:

* `configuration.cfg`: A configuration file that can be used to reproduce the simulation
* `demographics.csv.bz2`: Information about the abundances of cooperators and defectors in each population
* `fitness.csv.bz2`: Information about the fitnesses of cooperators and defectors
* `genotypes.csv.bz2`: Information about the abundances of each possible genotype over time

In the [base configuration file](../configuration/base.cfg), data are written every 10 simulation cycles.


### Uncompressing the Data Files

To save space, the resulting data files are compressed. To open these files in Python:

```python
import bz2
import csv

reader = csv.reader(bz2.BZ2File('demographics.csv.bz2', 'r'))
for row in reader:
    print(row)
```

The decompression is done transparently in R:

```r
mydata <- read.csv('demographics.csv.bz2')
```

Otherwise, they can be opened by double clicking on them in Finder (Mac),
running `bunzip2 <filename>` (Mac/Linux), or opening with
[7-Zip](http://www.7-zip.org/) (Windows).

