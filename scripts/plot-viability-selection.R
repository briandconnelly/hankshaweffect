#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

d <- read.csv('../data/viability-selection.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

p <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    geom_line() +
    scale_y_continuous(limits=c(0,1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size = 17)
p <- rescale_golden(plot = p)
ggsave_golden('../figures/viability-selection.png')
