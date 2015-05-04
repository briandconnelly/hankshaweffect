#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('formatting.R')
source('figsummary.R')

data_figs4 <- read.csv('../data/figureS4.csv') %>%
    filter(Time <= max_time)
data_figs4$Treatment <- factor(data_figs4$Treatment, levels=c('Lattice',
                                                              '16-Regular',
                                                              '128-Regular',
                                                              'Complete',
                                                              'Single Population'))

data_interval <- 10

presence <- data_figs4 %>%
    group_by(Treatment, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

figS4 <- ggplot(presence, aes(x=Treatment, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_topology, y=label_producer_presence)
figS4 <- rescale_golden(plot=figS4)

png('../figures/FigureS4.png', width=6, height=3.708204, units='in', res=figure_dpi)
figS4
dev.off()

