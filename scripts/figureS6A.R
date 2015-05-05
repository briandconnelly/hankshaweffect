#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

figs6adata <- read.csv('../data/figureS6a.csv') %>%
    filter(Time <= max_time)
figs6adata$Replicate <- as.factor(figs6adata$Replicate)

figs6a_integral <- figs6adata %>%
    group_by(MinProbDilution, Replicate) %>%
    summarise(Integral=1*sum(MeanProducerProportion)/(max(Time)-min(Time)))

figS6A <- ggplot(figs6a_integral, aes(x=MinProbDilution, y=Integral)) +
    #geom_point(shape=1, alpha=0.05) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    scale_x_log10(limits=c(1e-3,1), breaks=c(1e-3, 1e-2, 1e-1, 1)) +
    labs(x=label_dilute_min, y=label_spite_presence) +
    theme_hankshaw(base_size=17)
figS6A <- rescale_golden(plot=figS6A)

g <- ggplotGrob(figS6A)
g <- gtable_add_grob(g, textGrob(expression(bold("A")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS6a.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.draw(g)
dev.off()

