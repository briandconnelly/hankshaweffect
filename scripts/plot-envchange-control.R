#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('figsummary.R')
source('formatting.R')

echctrl <- read.csv('../data/envchange-control.csv.bz2')
echctrl$Replicate <- as.factor(echctrl$Replicate)

pX <- ggplot(data=echctrl, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(limits=c(0,1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
pX <- rescale_golden(plot = pX)
ggsave_golden(filename = '../figures/envchange-control.png', plot = pX)

