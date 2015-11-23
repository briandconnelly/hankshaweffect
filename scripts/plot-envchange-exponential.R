#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

d <- read.csv('../data/envchange-exponential-cooppct.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Unchanging Environment? ------------------------------------------------------



# Sample trajectory ------------------------------------------------------------

data_sample <- d %>% filter(EnvChangeFrequency == 500 & Replicate == 36)
p_sample <- ggplot(data=data_sample, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
p_sample <- rescale_golden(plot = p_sample)
ggsave_golden(filename = '../figures/envchange-exponential-sample.png',
              plot = p_sample)


# All trajectories -------------------------------------------------------------

pall <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeFrequency ~ .) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size = 17)
ggsave_golden(filename = '../figures/envchange-exponential-all.png',
              plot = pall)
