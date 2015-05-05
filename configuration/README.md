# Configuration Files

These configuration files can be used with the [model](../model) to reproduce our simulations

## Contents

| File               | Description                                       |
|:-------------------|:--------------------------------------------------|
| [base.cfg](base.cfg) | Base parameter values                           |
| [figure1a.cfg](figure1a.cfg) | Single subpopulation runs without adaptation |
| [figure1b.cfg](figure1b.cfg) | Single subpopulation runs with adaptation |
| [figure1c.cfg](figure1c.cfg) | Lattice-structured population runs without adaptation |
| [figure3a.cfg](figure3a.cfg) | Runs where environment changes every 1000 cycles |
| [figureS1.cfg](figureS1.cfg) | Runs without mutation at the cooperation locus |
| [figureS3.cfg](figureS3.cfg) | Runs with periodic environmental change and no stress-induced thinning |
| [figureS4-nothinning.cfg](figureS4-nothinning.cfg) | Runs with no stress-induced thinning |
| [figureS5-128regular.cfg](figureS5-128regular.cfg) | Migration topology modeled as a 128-regular graph |
| [figureS5-16regular.cfg](figureS5-16regular.cfg) | Migration topology modeled as a 16-regular graph |
| [figureS5-complete.cfg](figureS5-complete.cfg) | Migration topology modeled as a complete graph |
| [figureS5-lattice.cfg](figureS5-lattice.cfg) | Migration topology modeled as a lattice (Moore neighborhood) |
| [figureS5-singlepop.cfg](figureS5-singlepop.cfg) | Population consists of a single subpopulation |
| [figureS6a.cfg](figureS6a.cfg) | Spite simulations (where `Population/dilution_prob_min` is varied) |
| [figureS6b.cfg](figureS6b.cfg) | Spite simulations with environmental change every 1000 cycles |


## Other Simulations

| Result Figure      | Description                                       |
|:-------------------|:--------------------------------------------------|
| [Figure 1D](../figures/Figure1.png) | These are the base values defined in [base.cfg](base.cfg) |
| [Figure 2A](../figures/Figure2a.png) | Varying parameter `Population/genome_length` in [base.cfg](base.cfg) |
| [Figure 2B](../figures/Figure2b.png) | Varying parameter `Population/genome_length` in [base.cfg](base.cfg) |
| [Figure 2C](../figures/Figure2c.png) | Varying parameter `Population/capacity_max` in [base.cfg](base.cfg) |
| [Figure 2D](../figures/Figure2d.png) | Varying parameter `Population/production_cost` in [base.cfg](base.cfg) |
| [Figure 2E](../figures/Figure2e.png) | Varying parameter `Metapopulation/migration_rate` in [base.cfg](base.cfg) |
| [Figure 2F](../figures/Figure2f.png) | Varying parameter `Population/mutation_rate_social` and `Population/mutation_rate_social` in [base.cfg](base.cfg) |
| [Figure 3B](../figures/Figure3b.png) | Varying parameter `Metapopulation/env_change_frequency` in [figure3a.cfg](figure3a.cfg) |
| [Figure S2A](../figures/FigureS2a.png) | Varying parameter `Population/mutation_rate_adaptation` in [base.cfg](base.cfg) |
| [Figure S2B](../figures/FigureS2b.png) | Varying parameter `Population/mutation_rate_social` in [base.cfg](base.cfg) |
| [Figure S2C](../figures/FigureS2c.png) | Varying parameter `Population/mutation_rate_social` in [base.cfg](base.cfg) |
| [Figure S4A](../figures/FigureS4a.png) | Using `Population/genome_length` = 8 in [base.cfg](base.cfg) (with stress induced thinning) and [figureS4-nothinning.cfg](figureS4-nothinning.cfg) (without stress induced thinning) |
| [Figure S4B](../figures/FigureS4b.png) | Varying parameter `Population/genome_length` in [base.cfg](base.cfg) (with stress induced thinning) and [figureS4-nothinning.cfg](figureS4-nothinning.cfg) (without stress induced thinning) |

