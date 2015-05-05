#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

data_figs1 <- read.csv('../data/figureS1.csv')
data_figs1$Replicate <- as.factor(data_figs1$Replicate)

figS1 <- ggplot(data_figs1, aes(x=Time, y=MeanProducerProportion)) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion)
figS1 <- rescale_golden(plot=figS1)

png('../figures/FigureS1.png', width=6, height=3.708204, units='in', res=figure_dpi)
figS1
dev.off()
