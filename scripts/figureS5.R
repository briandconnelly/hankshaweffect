#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('formatting.R')
source('figsummary.R')

data_figs5 <- read.csv('../data/figureS5.csv') %>%
    filter(Time <= max_time)
data_figs5$Treatment <- factor(data_figs5$Treatment, levels=c('Lattice',
                                                              '16-Regular',
                                                              '128-Regular',
                                                              'Complete',
                                                              'Single Population'))

data_interval <- 10

presence <- data_figs5 %>%
    group_by(Treatment, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

figS5 <- ggplot(presence, aes(x=Treatment, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_topology, y=label_producer_presence) +
    theme_hankshaw(base_size=12)
figS5 <- rescale_golden(plot=figS5)

png('../figures/FigureS5.png', width=6, height=3.708204, units='in', res=figure_dpi)
figS5
dev.off()

