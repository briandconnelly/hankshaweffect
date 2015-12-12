# Model, Data, and Analysis Scripts for *The Evolution of Cooperation by the Hankshaw Effect*

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.17423.svg)](http://dx.doi.org/10.5281/zenodo.17423)


## Contents

These subdirectories may contain additional information

* [configuration](configuration) - Configuration files for reported simulations
* [data](data) - Result data sets
* [figures](figures) - Figures
* [model](model) - Model source code
* [scripts](scripts) - Scripts for analyzing and plotting [result data](data)


## Contents by Figure


| Figure  | Related Files  | Configuration |
|:--------|:---------------|:--------------|
| 1A      | [data](data/lsweep.csv.bz2), [analysis](scripts/figure1.R), [figure](figures/Figure1.png) | [wellmixed.cfg](configuration/wellmixed.cfg), `Population:genome_length = 0` |
| 1B      | [data](data/lsweep.csv.bz2), [analysis](scripts/figure1.R), [figure](figures/Figure1.png) | [wellmixed.cfg](configuration/wellmixed.cfg) |
| 1C      | [data](data/lsweep.csv.bz2), [analysis](scripts/figure1.R), [figure](figures/Figure1.png) | [base.cfg](configuration/base.cfg), `Population:genome_length = 0` |
| 1D      | [data](data/lsweep.csv.bz2), [analysis](scripts/figure1.R), [figure](figures/Figure1.png) | [base.cfg](configuration/base.cfg) |
| 2A      | [data](data/envchange-regular.csv.bz2), [analysis](scripts/plot-envchange-regular.R), [figure](figures/envchange-regular-rep.png) | [envchange-regular.cfg](configurations/envchange-regular.cfg) |
| 2B      | [data](data/envchange-regular.csv.bz2), [analysis](scripts/plot-envchange-regular.R), [figure](figures/envchange-regular-all.png) | [envchange-regular.cfg](configurations/envchange-regular.cfg), `EnvironmentalChange:frequency` values 250, 500, 750, 1000, 1250, 2500 |
| 3A      | [data](data/envchange-control.csv.bz2), [analysis](scripts/plot-envchange-control.R), [figure](figures/envchange-control.png) | TODO |
| 3B      | [data](data/envchange-exponential-cooppct.csv.bz2), [analysis](scripts/plot-envchange-exponential.R), [figure](figures/envchange-exponential-sample.png) | TODO |
| 3C      | [data](data/envchange-exponential-cooppct.csv.bz2), [analysis](scripts/plot-envchange-exponential.R), [figure](figures/envchange-exponential-all.png) | TODO | 
| S1A    | [data](data/lsweep.csv.bz2), [analysis](scripts/plot-genomelengthsweep.R), [figure](figures/genomelengthsweep-sample.png) | TODO |
| S1B    | [data](data/lsweep.csv.bz2), [analysis](scripts/plot-genomelengthsweep.R), [figure](figures/genomelengthsweep-integral.png) | TODO |
| S1C    | [data](data/bsweep.csv.bz2), [analysis](scripts/scripts/plot-benefitsweep.R), [figure](figures/benefitsweep-integral.png) | TODO |
| S1D    | [data](data/csweep.csv.bz2), [analysis](scripts/plot-costsweep-integral.R), [figure](figures/costsweep-integral.png) | TODO |
| S1E    | [data](data/migrationsweep.csv.bz2), [analysis](scripts/plot-migrationsweep.R), [figure](figures/migrationsweep-integral.png) | TODO |
| S1F    | [data](data/mutationsweep.csv.bz2), [analysis](scripts/plot-mutationsweep.R), [figure](figures/mutationsweep-integral.png) | TODO |
| S2A    | [data](data/mutationsweep-adaptive.csv.bz2), [analysis](scripts/plot-mutationsweep-adaptive.R), [figure](figures/mutationsweep-adaptive.png) | TODO |
| S2B    | [data](data/mutationsweep-adaptive.csv.bz2), [analysis](scripts/plot-mutationsweep-cooperation.R), [figure](figures/mutationsweep-cooperation.png) | TODO |
| S2C    | [data](data/mutationsweep-adaptive.csv.bz2), [analysis](scripts/plot-mutationsweep-cooperation.R), [figure](figures/mutationsweep-cooperation-mumax.png) | TODO |
| S3     | [data](data/nosocialmu.csv.bz2), [analysis](scripts/plot-nosocialmu.R), [figure](figures/nosocialmu.png) | TODO |
| S4 TODO | [data](data/TODO), [analysis](scripts/TODO), [figure](figures/TODO)  - TODO | TODO |
| S5     | [data](data/envchange-exponential-strength-cooppct.csv.bz2), [analysis](scripts/plot-envchange-exponential-strength.R), [figure](figures/envchange-exponential-strength-integral.png) | TODO |
| S6A    | [data](data/thinnothin.csv.bz2), [analysis](scripts/plot-thinnothin.R), [figure](figures/thinnothin.png) | TODO |
| S6B    | [data](data/thinnothin.csv.bz2), [analysis](scripts/plot-thinnothin.R), [figure](figures/thinnothin-integral.png) | TODO |
| S7     | [data](data/migration-topology.csv.bz2), [analysis](scripts/plot-migration-topology.R), [figure](figures/migration-topology.png) | TODO |
| S8     | [data](data/viability-selection.csv.bz2), [analysis](scripts/plot-viability-selection.R), [figure](figures/viability-selection.png) | TODO |
| S9A    | [data](data/benefitgamma.csv.bz2), [analysis](scripts/plot-benefitgamma.R), [figure](figures/benefitgamma-gamma.png) | TODO |
| S9B    | [data](data/benefitgamma.csv.bz2), [analysis](scripts/plot-benefitgamma.R), [figure](figures/benefitgamma-integral.png) | TODO |
| S10A   | [data](data/fitnessgamma.csv.bz2), [analysis](scripts/plot-fitnessgamma.R), [figure](figures/fitnessgamma-gamma.png) | TODO |
| S10B   | [data](data/fitnessgamma.csv.bz2), [analysis](scripts/plot-fitnessgamma.R), [figure](figures/fitnessgamma-integral.png) | TODO |
| S11 TODO   | [data](data/TODO), [analysis](scripts/TODO), [figure](figures/TODO) | TODO |
| S12A   | [data](data/spite-dilution.csv.bz2), [analysis](scripts/plot-spite-dilution.R]), [figure](figures/spite-avg-proportion.png) | TODO |
| S12B   | [data](data/spite-dilution.csv.bz2), [analysis](scripts/plot-spite-dilution.R]), [figure](figures/spite-dilution.png) | TODO |
| S12C   | [data](data/spite-envchange.csv.bz2), [analysis](scripts/plot-spite-envchange.R), [figure](figures/spite-envchange-sample.png) | TODO |


## License

This work is licensed under a [Creative Commons](http://creativecommons.org) [Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

