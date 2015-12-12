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
| 1       | [data](data/lsweep.csv.bz2), [analysis](scripts/figure1.R), [figure](figures/Figure1.png) | **A:** [wellmixed.cfg](configuration/wellmixed.cfg), `Population:genome_length` = 0<br>**B:** [wellmixed.cfg](configuration/wellmixed.cfg)<br>**C:** [base.cfg](configuration/base.cfg), `Population:genome_length` = 0<br>**D:** [base.cfg](configuration/base.cfg) |
| 2A      | [data](data/envchange-regular.csv.bz2), [analysis](scripts/plot-envchange-regular.R), [figure](figures/envchange-regular-rep.png) | [envchange-regular.cfg](configurations/envchange-regular.cfg) |
| 2B      | [data](data/envchange-regular.csv.bz2), [analysis](scripts/plot-envchange-regular.R), [figure](figures/envchange-regular-all.png) | [envchange-regular.cfg](configurations/envchange-regular.cfg), `EnvironmentalChange:frequency` values 250, 500, 750, 1000, 1250, 2500 |
| 3A      | [data](data/envchange-control.csv.bz2), [analysis](scripts/plot-envchange-control.R), [figure](figures/envchange-control.png) | TODO |
| 3B      | [data](data/envchange-exponential-cooppct.csv.bz2), [analysis](scripts/plot-envchange-exponential.R), [figure](figures/envchange-exponential-sample.png) | TODO |
| 3C      | [data](data/envchange-exponential-cooppct.csv.bz2), [analysis](scripts/plot-envchange-exponential.R), [figure](figures/envchange-exponential-all.png) | TODO | 
| S1A    | [data](data/lsweep.csv.bz2), [analysis](scripts/plot-genomelengthsweep.R), [figure](figures/genomelengthsweep-sample.png) | [base.cfg](configuration/base.cfg), `Population:genome_length` = 0, 8 |
| S1B    | [data](data/lsweep.csv.bz2), [analysis](scripts/plot-genomelengthsweep.R), [figure](figures/genomelengthsweep-integral.png) | [base.cfg](configuration/base.cfg), `Population:genome_length` = 0..10 |
| S1C    | [data](data/bsweep.csv.bz2), [analysis](scripts/scripts/plot-benefitsweep.R), [figure](figures/benefitsweep-integral.png) | [base.cfg](configuration/base.cfg), `Population:capacity_max` = 800..2450 |
| S1D    | [data](data/csweep.csv.bz2), [analysis](scripts/plot-costsweep-integral.R), [figure](figures/costsweep-integral.png) | [base.cfg](configuration/base.cfg), `Population:production_cost` = 0..0.5 |
| S1E    | [data](data/migrationsweep.csv.bz2), [analysis](scripts/plot-migrationsweep.R), [figure](figures/migrationsweep-integral.png) | [base.cfg](configuration/base.cfg), `Metapopulation:migration_rate` = 5e-07, 5e-06, 5e-05, 5e-04, 5e-03, 5e-02, 5e-01 |
| S1F    | [data](data/mutationsweep.csv.bz2), [analysis](scripts/plot-mutationsweep.R), [figure](figures/mutationsweep-integral.png) | [base.cfg](configuration/base.cfg), `Population:mutation_rate_social` and `Population:mutation_rate_adaptation` = 1e-07, 1e-06, 1e-05, 1e-04, 1e-03, 1e-02, 1e-01 |
| S2A    | [data](data/mutationsweep-adaptive.csv.bz2), [analysis](scripts/plot-mutationsweep-adaptive.R), [figure](figures/mutationsweep-adaptive.png) | [base.cfg](configuration/base.cfg), `Population:mutation_rate_adaptation` = 1e-07, 1e-06, 1e-05, 1e-04, 1e-03, 1e-02, 1e-01 |
| S2B    | [data](data/mutationsweep-adaptive.csv.bz2), [analysis](scripts/plot-mutationsweep-cooperation.R), [figure](figures/mutationsweep-cooperation.png) | [base.cfg](configuration/base.cfg), `Population:mutation_rate_social` = 1e-07, 1e-06, 1e-05, 1e-04, 1e-03, 1e-02, 1e-01 |
| S2C    | [data](data/mutationsweep-adaptive.csv.bz2), [analysis](scripts/plot-mutationsweep-cooperation.R), [figure](figures/mutationsweep-cooperation-mumax.png) | [base.cfg](configuration/base.cfg), `Population:mutation_rate_adaptation` = 1e-01 |
| S3     | [data](data/nosocialmu.csv.bz2), [analysis](scripts/plot-nosocialmu.R), [figure](figures/nosocialmu.png) | **A:** [wellmixed.cfg](configuration/wellmixed.cfg), `Population:genome_length` = 0, `Population:mutation_rate_social` = 0<br>**B:** [wellmixed.cfg](configuration/wellmixed.cfg), `Population:mutation_rate_social` = 0<br>**C:** [base.cfg](configuration/base.cfg), `Population:genome_length` = 0, `Population:mutation_rate_social` = 0<br>**D:** [base.cfg](configuration/base.cfg), `Population:mutation_rate_social` = 0 |
| S4 TODO | [data](data/TODO), [analysis](scripts/TODO), [figure](figures/TODO)  - TODO | TODO |
| S5     | [data](data/envchange-exponential-strength-cooppct.csv.bz2), [analysis](scripts/plot-envchange-exponential-strength.R), [figure](figures/envchange-exponential-strength-integral.png) | [envchange-exponential.cfg](configuration/envchange-exponential.cfg), `EnvironmentalChange:affected_loci` = 1..8 |
| S6A    | [data](data/thinnothin.csv.bz2), [analysis](scripts/plot-thinnothin.R), [figure](figures/thinnothin.png) | [base.cfg](configuration/base.cfg), `Population:stress_survival_rate` = 1e-04 (With Thinning), 1.0 (Without thinning) |
| S6B    | [data](data/thinnothin.csv.bz2), [analysis](scripts/plot-thinnothin.R), [figure](figures/thinnothin-integral.png) | [base.cfg](configuration/base.cfg), `Population:stress_survival_rate` = 1e-04 (With Thinning), 1.0 (Without thinning), `Population:genome_length` = 0..10 |
| S7     | [data](data/migration-topology.csv.bz2), [analysis](scripts/plot-migration-topology.R), [figure](figures/migration-topology.png) | TODO |
| S8     | [data](data/viability-selection.csv.bz2), [analysis](scripts/plot-viability-selection.R), [figure](figures/viability-selection.png) | TODO |
| S9A    | [data](data/benefitgamma.csv.bz2), [analysis](scripts/plot-benefitgamma.R), [figure](figures/benefitgamma-gamma.png) | - |
| S9B    | [data](data/benefitgamma.csv.bz2), [analysis](scripts/plot-benefitgamma.R), [figure](figures/benefitgamma-integral.png) | [base.cfg](configuration/base.cfg), `Population:capacity_shape` = 0.25, 0.5, 1.0, 2.0, 4.0 |
| S10A   | [data](data/fitnessgamma.csv.bz2), [analysis](scripts/plot-fitnessgamma.R), [figure](figures/fitnessgamma-gamma.png) | - |
| S10B   | [data](data/fitnessgamma.csv.bz2), [analysis](scripts/plot-fitnessgamma.R), [figure](figures/fitnessgamma-integral.png) | [base.cfg](configuration/base.cfg), `Population:fitness_shape` = 0.3, 0.6, 0.9, 1.0, 1.5, 2.0 |
| S11 TODO   | [data](data/TODO), [analysis](scripts/TODO), [figure](figures/TODO) | TODO |
| S12A   | [data](data/spite-dilution.csv.bz2), [analysis](scripts/plot-spite-dilution.R]), [figure](figures/spite-avg-proportion.png) | [spite.cfg](configuration/spite.cfg) |
| S12B   | [data](data/spite-dilution.csv.bz2), [analysis](scripts/plot-spite-dilution.R]), [figure](figures/spite-dilution.png) | [spite.cfg](configuration/spite.cfg), `dilution_prob_min` = 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 0.75, 1.0 |
| S12C   | [data](data/spite-envchange.csv.bz2), [analysis](scripts/plot-spite-envchange.R), [figure](figures/spite-envchange-sample.png) | [spite-envchange-regular.cfg](configuration/spite-envchange-regular.cfg) |


## License

This work is licensed under a [Creative Commons](http://creativecommons.org) [Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

