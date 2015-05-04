#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('formatting.R')
source('figsummary.R')

figX2data <- read.csv('../data/figureS5.csv')
figX2data$Replicate <- as.factor(figX2data$Replicate)

figX2_integral <- figX2data %>%
    filter(Time <= integral_maxtime) %>%
    group_by(MinProbDilution, Replicate) %>%
    summarise(Integral=1*sum(MeanProducerProportion)/(max(Time)-min(Time)))

figX2 <- ggplot(figX2_integral, aes(x=MinProbDilution, y=Integral)) +
    #geom_point(shape=1, alpha=0.05) +
    stat_summary(fun.data='figsummary', geom='errorbar', color='black',
                 width=0, size=0.8) +
    stat_summary(fun.y='mean', geom='point') +
    scale_y_continuous(limits=c(0, 1)) +
    scale_x_log10(limits=c(1e-3,1), breaks=c(1e-3, 1e-2, 1e-1, 1)) +
    labs(x=label_dilute_min, y=label_spite_presence)
figX2 <- rescale_golden(plot=figX2)

ggsave_golden(plot=figX2, filename='../figures/FigureS5.png', dpi=figure_dpi)

