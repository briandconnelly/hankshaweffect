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
| [figureS2.cfg](figureS2.cfg) | Runs with periodic environmental change and no stress-induced thinning |
| [figureS3-nobottleneck.cfg](figureS3-nobottleneck.cfg) | Runs with no stress-induced thinning |
| [figureS4-128regular.cfg](figureS4-128regular.cfg) | Migration topology modeled as a 128-regular graph |
| [figureS4-16regular.cfg](figureS4-16regular.cfg) | Migration topology modeled as a 16-regular graph |
| [figureS4-complete.cfg](figureS4-complete.cfg) | Migration topology modeled as a complete graph |
| [figureS4-lattice.cfg](figureS4-lattice.cfg) | Migration topology modeled as a lattice (Moore neighborhood) |
| [figureS4-singlepop.cfg](figureS4-singlepop.cfg) | Population consists of a single subpopulation |
| [figureS5.cfg](figureS5.cfg) | Spite simulations (where `Population/dilution_prob_min` is varied) |


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
| [Figure S3A](../figures/FigureS3a.png) | Using `Population/genome_length` = 8 in [base.cfg](base.cfg) (with stress bottleneck) and [figureS3-nobottleneck.cfg](figureS3-nobottleneck.cfg) (without stress bottleneck) |
| [Figure S3B](../figures/FigureS3b.png) | Varying parameter `Population/genome_length` in [base.cfg](base.cfg) (with stress bottleneck) and [figureS3-nobottleneck.cfg](figureS3-nobottleneck.cfg) (without stress bottleneck) |

