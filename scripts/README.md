# Analysis Scripts

These scripts are used to analyze the [data](../data) and create the
[figures](../figures).

## Dependencies

* [R](http://www.r-project.org) (version 3.2.0 used)
* [dplyr](http://cran.r-project.org/web/packages/dplyr/) (version 0.4.1 used)
* [ggplot2](http://cran.r-project.org/web/packages/ggplot2/) (version 1.0.1 used)
* [ggplot2bdc](https://github.com/briandconnelly/ggplot2bdc/) (version 0.2.0 used)
* [gtable](http://cran.r-project.org/web/packages/gtable/) (version 0.1.2 used)
* [magrittr](http://cran.r-project.org/web/packages/magrittr/) (version 1.5 used)
* [scales](http://cran.r-project.org/web/packages/scales/) (version 0.2.4 used)

These packages can be installed in R using the following commands:

```r
install.packages(c('dplyr', 'ggplot2', 'gtable', 'magrittr', 'scales', 'devtools'))
devtools::install_github('briandconnelly/ggplot2bdc')
```

## Contents

| File               | Description                                       |
|:-------------------|:--------------------------------------------------|
| [figsummary.R](figsummary.R) | Function for calculating statistics shown in most figures |
| [figure1.R](figure1.R) | Create [Figure 1](../figures/Figure1.png)     |
| [figure2a.R](figure2a.R) | Create [Figure 2a](../figures/Figure2a.png) |
| [figure2b.R](figure2b.R) | Create [Figure 2b](../figures/Figure2b.png) |
| [figure2c.R](figure2c.R) | Create [Figure 2c](../figures/Figure2c.png) |
| [figure2d.R](figure2d.R) | Create [Figure 2d](../figures/Figure2d.png) |
| [figure2e.R](figure2e.R) | Create [Figure 2e](../figures/Figure2e.png) |
| [figure2f.R](figure2f.R) | Create [Figure 2f](../figures/Figure2f.png) |
| [figure3a.R](figure3a.R) | Create [Figure 3a](../figures/Figure3a.png) |
| [figure3b.R](figure3b.R) | Create [Figure 3b](../figures/Figure3b.png) |
| [figureS1a.R](figureS1a.R) | Create [Figure S1a](../figures/FigureS1a.png) |
| [figureS1b.R](figureS1b.R) | Create [Figure S1b](../figures/FigureS1b.png) |
| [figureS1c.R](figureS1c.R) | Create [Figure S1c](../figures/FigureS1c.png) |
| [figureS3.R](figureS3.R) | Create [Figure S3](../figures/FigureS3.png) |
| [figureS3-trajectories.R](figureS3-trajectories.R) | Plot the trajectories for data shown in [Figure S3](../figures/FigureS3.png) |
| [figureS4a.R](figureS4a.R) | Create [Figure S4a](../figures/FigureS4a.png) |
| [figureS4b.R](figureS4b.R) | Create [Figure S4b](../figures/FigureS4b.png) |
| [figureS5.R](figureS4.R) | Create [Figure S5](../figures/FigureS5.png) |
| [figureS6.R](figureS6.R) | Create [Figure S6](../figures/FigureS6.png) |
| [formatting.R](formatting.R) | Define variables for formatting figures |
| [theme_hankshaw.R](theme_hankshaw.R) | Theme for creating plots        |


