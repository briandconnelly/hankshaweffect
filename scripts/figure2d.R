#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

# How often data were logged
data_interval <- 10

data_fig2d <- read.csv('../data/figure2d.csv')
data_fig2d$Replicate <- as.factor(data_fig2d$Replicate)

data_fig2d_integral <- data_fig2d %>%
    filter(Time <= integral_maxtime) %>%
    group_by(ProductionCost, Source, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

fig2d <- ggplot(data_fig2d_integral, aes(x=ProductionCost, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary') +
    scale_x_continuous(breaks=unique(data_fig2d_integral$ProductionCost), labels=cost_labels) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_cost, y=label_producer_presence)
fig2d <- rescale_golden(plot=fig2d)

g <- ggplotGrob(fig2d)
g <- gtable_add_grob(g, textGrob(expression(bold('D')), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2d.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()

